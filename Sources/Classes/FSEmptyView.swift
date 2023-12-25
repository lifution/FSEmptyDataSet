//
//  FSEmptyView.swift
//  FSEmptyDataSet
//
//  Created by Sheng on 2023/12/25.
//  Copyright © 2023 Sheng. All rights reserved.
//

/*
 FSEmptyView 的布局规则:
 
       ----------------
       | UIImageView  |
       |      or      |
       |  CustomView  |
       ----------------
               |
            (space)
               |
       ------------------
       | UILabel (Text) |
       ------------------
               |
            (space)
               |
    ------------------------
    | UILabel (DetailText) |
    ------------------------
               |
            (space)
               |
       ----------------
       |   UIButton   |
       |      or      |
       | CustomButton |
       ----------------
*/

import UIKit

open class FSEmptyView: UIView {
    
    // MARK: Properties/Public
    
    /// - Note: 设置该属性，无论是否有效，都会清空已设置的 content 属性。
    public weak var delegate: FSEmptyViewDelegate? {
        get { return _p_delegate }
        set {
            _content = nil
            _delegate = newValue
            _p_delegate = newValue
            p_setNeedsReload()
        }
    }
    
    /// - Note: 设置该属性，无论是否有效，都会清空已设置的 content 属性。
    public weak var dataSource: FSEmptyViewDataSource? {
        get { return _p_dataSource }
        set {
            _content = nil
            _dataSource = newValue
            _p_dataSource = newValue
            p_setNeedsReload()
        }
    }
    
    /// empty 内容。
    ///
    /// - Important:
    ///   - 设置 content 会覆盖已设置的 delegate 和 dataSource，
    ///     这三者没有先后优先级，默认为后者覆盖前者。
    ///
    public var content: FSEmptyContent? {
        get { return _content }
        set {
            _content = newValue
            _delegate = _content
            _dataSource = _content
            _p_delegate = nil
            _p_dataSource = nil
            p_setNeedsReload()
        }
    }
    
    /// 该属性表示的是 FSEmptyView 中内容的 size，和整体的 FSEmptyView 没有必然的联系，
    /// 外部如有需要约束 FSEmptyView 只有内容大小，可在设置 _delegate/_dataSource/content
    /// 后调用 `emptyView.layoutIfNeeded()`，然后访问该属性即可拿到内容的 size。
    public private(set) var contentSize: CGSize = .zero
    
    // MARK: Properties/Private
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.scrollsToTop = false
        scroll.alwaysBounceVertical = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            scroll.contentInsetAdjustmentBehavior = .never
        }
        return scroll
    }()
    
    private var containerView = UIView()
    
    private var imageView = UIImageView()
    
    private var customView: UIView?
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var detailTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor(red: 0.42, green: 0.44, blue: 0.47, alpha: 1.00)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var actionButton: UIButton?
    
    private var needsReload = false
    private var needsLayoutScrollView = false
    
    private var _content: FSEmptyContent?
    private weak var _p_delegate: FSEmptyViewDelegate?
    private weak var _p_dataSource: FSEmptyViewDataSource?
    private weak var _delegate: FSEmptyViewDelegate?
    private weak var _dataSource: FSEmptyViewDataSource?
    
    private var viewSize: CGSize = .zero
    
    // MARK: Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        p_didInitialize()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Override

extension FSEmptyView {
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if viewSize != bounds.size {
            viewSize = bounds.size
            needsLayoutScrollView = true
        }
        p_reloadIfNeeded()
        p_layoutScrollViewIfNeeded()
    }
    
    open override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return contentSize
    }
    
    open override func sizeToFit() {
        frame.size = sizeThatFits(.init(width: 100000.0, height: 100000.0))
    }
}

// MARK: - Private

private extension FSEmptyView {
    
    func p_didInitialize() {
        defer {
            p_setNeedsReload()
        }
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(textLabel)
        containerView.addSubview(detailTextLabel)
    }
    
    func p_setNeedsReload() {
        needsReload = true
        needsLayoutScrollView = true
        setNeedsLayout()
    }
    
    func p_reloadIfNeeded() {
        if needsReload {
            p_reload()
        }
    }
    
    func p_reload() {
        
        needsReload = false
        
        do {
            scrollView.isScrollEnabled = _delegate?.emptyViewShouldAllowScroll(self) ?? true
            
            if let color = _delegate?.backgroundColor(for: self) {
                backgroundColor = color
            } else {
                backgroundColor = .clear
            }
        }
        
        // 优先判断是否有自定义 view。
        var isCustomViewInvalid = true // 标记自定义 view 是否有效，以便 UIImageView 的设置。
        do {
            if let customView = _dataSource?.customView(for: self) {
                imageView.isHidden = true
                isCustomViewInvalid = false
                if let old = self.customView {
                    if old !== customView {
                        old.removeFromSuperview()
                        self.customView = customView
                        containerView.addSubview(customView)
                    }
                } else {
                    self.customView = customView
                    containerView.addSubview(customView)
                }
            }
        }
        
        // 图片
        do {
            if isCustomViewInvalid {
                if let old = customView {
                    old.removeFromSuperview()
                    customView = nil
                }
                imageView.isHidden = true
                if let image = _dataSource?.image(for: self), image.size != .zero {
                    imageView.image = image
                    imageView.isHidden = false
                }
            }
        }
        
        // 文本
        do {
            textLabel.isHidden = true
            if let text = _dataSource?.attributedText(for: self), !text.string.isEmpty {
                textLabel.isHidden = false
                textLabel.attributedText = text
            } else {
                if let text = _dataSource?.text(for: self), !text.isEmpty {
                    textLabel.text = text
                    textLabel.isHidden = false
                }
            }
        }
        
        // 详细文本
        do {
            detailTextLabel.isHidden = true
            if let text = _dataSource?.attributedDetailText(for: self), !text.string.isEmpty {
                detailTextLabel.isHidden = false
                detailTextLabel.attributedText = text
            } else {
                if let text = _dataSource?.detailText(for: self), !text.isEmpty {
                    detailTextLabel.text = text
                    detailTextLabel.isHidden = false
                }
            }
        }
        
        // 按钮
        do {
            if let old = actionButton {
                old.removeFromSuperview()
                actionButton = nil
            }
            // 优先检测是否含有自定义button。
            if let button = _dataSource?.customButton(for: self) {
                actionButton = button
            } else {
                // 当没有自定义 button 的时候判断是否使用默认 button。
                let title = _dataSource?.emptyView(self, buttonTitleFor: .normal)
                let title_rich = _dataSource?.emptyView(self, buttonAttributedTitleFor: .normal)
                if title != nil || title_rich != nil {
                    let button = p_generateDefaultActionButton()
                    if let font = _dataSource?.buttonTitleFont(for: self) {
                        button.titleLabel?.font = font
                    }
                    let states: [UIControl.State] = [.normal, .highlighted, .disabled, .selected]
                    if let text = title_rich, !text.string.isEmpty {
                        button.setAttributedTitle(text, for: .normal)
                        for state in states {
                            if state == .normal { continue }
                            let text_ = _dataSource?.emptyView(self, buttonAttributedTitleFor: state)
                            button.setAttributedTitle(text_, for: state)
                        }
                    } else {
                        if let text = title, !text.isEmpty {
                            button.setTitle(text, for: .normal)
                            for state in states {
                                if state != .normal {
                                    let text_ = _dataSource?.emptyView(self, buttonTitleFor: state)
                                    button.setTitle(text_, for: state)
                                }
                                let color = _dataSource?.emptyView(self, buttonTitleColorFor: state)
                                button.setTitleColor(color, for: state)
                            }
                        }
                    }
                    actionButton = button
                }
            }
            if let button = actionButton {
                containerView.addSubview(button)
            }
        }
    }
    
    func p_layoutScrollViewIfNeeded() {
        if needsLayoutScrollView {
            p_layoutScrollView()
        }
    }
    
    func p_layoutScrollView() {
        needsLayoutScrollView = false
        p_contentSizeToFit()
        scrollView.frame = .init(origin: .zero, size: viewSize)
        var scrollContentSize = contentSize
        do {
            var contentX = abs(viewSize.width - contentSize.width) / 2.0
            var contentY = abs(viewSize.height - contentSize.height) / 2.0
            if let offset = _delegate?.contentOffset(for: self) {
                contentX -= offset.x
                contentY -= offset.y
            }
            containerView.frame = .init(x: contentX, y: contentY, width: scrollContentSize.width, height: scrollContentSize.height)
        }
        do {
            scrollContentSize.width += (abs(containerView.frame.minX) * 2.0)
            scrollContentSize.height += (abs(containerView.frame.minY) * 2.0)
            scrollView.contentSize = scrollContentSize
        }
    }
    
    func p_contentSizeToFit() {
        
        var contentWidth: CGFloat = 0.0
        var contentHeight: CGFloat = 0.0
        
        var imageBottomSpace = Consts.imageBottomSpace
        var textBottomSpace = Consts.textBottomSpace
        var detailTextBottomSpace = Consts.detailTextBottomSpace
        do {
            if let space = _delegate?.imageBottomSpace(for: self) {
                imageBottomSpace = space
            }
            if let space = _delegate?.textBottomSpace(for: self) {
                textBottomSpace = space
            }
            if let space = _delegate?.detailTextBottomSpace(for: self) {
                detailTextBottomSpace = space
            }
        }
        
        var topView: UIView?
        do {
            if let customView = customView {
                topView = customView
                
                var customViewSize = CGSize.zero
                if let size = _dataSource?.customViewSize(for: self), size != .zero {
                    customViewSize = size
                } else {
                    if customView.frame.size == .zero {
                        customViewSize = customView.sizeThatFits(CGSize(width: CGFloat(INT16_MAX), height: CGFloat(INT16_MAX)))
                    } else {
                        customViewSize = customView.frame.size
                    }
                }
                customView.bounds = .init(x: 0.0, y: 0.0, width: customViewSize.width, height: customViewSize.height)
            } else {
                if !imageView.isHidden {
                    topView = imageView
                    imageView.sizeToFit()
                }
            }
            
            if let topView = topView {
                contentWidth = topView.bounds.width
                contentHeight = topView.bounds.height
            } else {
                // 顶部控件不存在则不需要间隙了。
                imageBottomSpace = 0.0
            }
        }
        
        // 文本
        do {
            if !textLabel.isHidden {
                var textMaxWidth: CGFloat = 0.0
                if let width = _delegate?.textPreferredMaxLayoutWidth(for: self), width > 0.1 {
                    textMaxWidth = width
                } else {
                    if bounds.width > 0.0 {
                        let textSize = textLabel.sizeThatFits(CGSize(width: CGFloat(Int16.max), height: CGFloat(Int16.max)))
                        if (bounds.width - textSize.width) < Consts.viewHorizontalMargin * 2.0 {
                            textMaxWidth = bounds.width
                        } else {
                            textMaxWidth = bounds.width - Consts.viewHorizontalMargin * 2.0
                        }
                    } else {
                        textMaxWidth = CGFloat(Int16.max)
                    }
                }
                let textSize = textLabel.sizeThatFits(CGSize(width: textMaxWidth, height: CGFloat(Int16.max)))
                textLabel.bounds = .init(x: 0.0, y: 0.0, width: textSize.width, height: textSize.height)
                contentWidth = max(contentWidth, textSize.width)
                contentHeight += imageBottomSpace
                contentHeight += textSize.height
            } else {
                // 同样的，文本不存在则不需要间隙了。
                textBottomSpace = 0.0
            }
        }
        
        // 详细文本
        do {
            if !detailTextLabel.isHidden {
                var textMaxWidth: CGFloat = 0.0
                if let width = _delegate?.detailTextPreferredMaxLayoutWidth(for: self), width > 0.1 {
                    textMaxWidth = width
                } else {
                    if bounds.width > 0.0 {
                        let textSize = detailTextLabel.sizeThatFits(CGSize(width: CGFloat(Int16.max), height: CGFloat(Int16.max)))
                        if (bounds.width - textSize.width) < Consts.viewHorizontalMargin * 2.0 {
                            textMaxWidth = bounds.width
                        } else {
                            textMaxWidth = bounds.width - Consts.viewHorizontalMargin * 2.0
                        }
                    } else {
                        textMaxWidth = CGFloat(Int16.max)
                    }
                }
                let textSize = detailTextLabel.sizeThatFits(CGSize(width: textMaxWidth, height: CGFloat(Int16.max)))
                detailTextLabel.bounds = .init(x: 0.0, y: 0.0, width: textSize.width, height: textSize.height)
                contentWidth = max(contentWidth, textSize.width)
                if !textLabel.isHidden {
                    contentHeight += textBottomSpace
                } else {
                    contentHeight += imageBottomSpace
                }
                contentHeight += textSize.height
            }
            else {
                // 同样的，详细文本不存在则不需要间隙了。
                detailTextBottomSpace = 0.0
            }
        }
        
        // 按钮
        do {
            if let button = actionButton {
                var buttonBounds = button.bounds
                if buttonBounds == .zero {
                    button.sizeToFit()
                    buttonBounds = button.bounds
                }
                contentWidth = max(contentWidth, buttonBounds.width)
                if !detailTextLabel.isHidden {
                    contentHeight += detailTextBottomSpace
                } else {
                    if !textLabel.isHidden {
                        contentHeight += textBottomSpace
                    } else {
                        contentHeight += imageBottomSpace
                    }
                }
                contentHeight += buttonBounds.height
            }
        }
        
        // 开始布局
        do {
            var maxY: CGFloat = 0.0
            if let view = topView {
                let size = view.bounds.size
                let x = (contentWidth - size.width) / 2.0
                view.frame = .init(x: x, y: 0.0, width: size.width, height: size.height)
                maxY = view.frame.maxY
            }
            if !textLabel.isHidden {
                let size = textLabel.bounds.size
                let x = (contentWidth - size.width) / 2.0
                let y = (maxY == 0.0) ? 0.0 : (maxY + imageBottomSpace)
                textLabel.frame = .init(x: x, y: y, width: size.width, height: size.height)
                maxY = textLabel.frame.maxY
            }
            if !detailTextLabel.isHidden {
                let size = detailTextLabel.bounds.size
                let x = (contentWidth - size.width) / 2.0
                let y: CGFloat = {
                    return (maxY == 0.0) ? 0.0 : (maxY + (textLabel.isHidden ? imageBottomSpace : textBottomSpace))
                }()
                detailTextLabel.frame = .init(x: x, y: y, width: size.width, height: size.height)
                maxY = detailTextLabel.frame.maxY
            }
            if let button = actionButton {
                let size = button.bounds.size
                let x = (contentWidth - size.width) / 2.0
                let y: CGFloat = {
                    return (maxY == 0.0) ? 0.0 : (maxY + (detailTextLabel.isHidden ? (textLabel.isHidden ? imageBottomSpace : textBottomSpace) : detailTextBottomSpace))
                }()
                button.frame = .init(x: x, y: y, width: size.width, height: size.height)
            }
        }
        
        contentWidth = ceil(contentWidth)
        contentHeight = ceil(contentHeight)
        contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        setNeedsUpdateConstraints()
        invalidateIntrinsicContentSize()
    }
    
    func p_generateDefaultActionButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.setTitleColor(UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00), for: .normal)
        button.setTitleColor(.gray, for: .selected)
        button.setTitleColor(.gray, for: .highlighted)
        button.addTarget(self, action: #selector(p_didPressButton(_:)), for: .touchUpInside)
        return button
    }
}

// MARK: - Actions

private extension FSEmptyView {
    
    @objc func p_didPressButton(_ sender: UIButton) {
        _delegate?.emptyView(self, didPress: sender)
    }
}

// MARK: - Public

public extension FSEmptyView {
    
    func reloadData() {
        p_reload()
    }
}

// MARK: - Consts

private struct Consts {
    static let imageBottomSpace: CGFloat = 20.0
    static let textBottomSpace: CGFloat  = 10.0
    static let detailTextBottomSpace: CGFloat = 20.0
    static let viewHorizontalMargin: CGFloat  = 20.0
}
