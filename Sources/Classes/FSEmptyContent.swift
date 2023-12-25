//
//  FSEmptyContent.swift
//  FSEmptyDataSet
//
//  Created by Sheng on 2023/12/25.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

/// FSEmptyDataSet 提供的默认空白占位内容类型。
public enum FSEmptyContentType {
    /// 不显示 empty
    case none
    /// 自定义
    case custom
    /// 重新加载
    case reload(title: String? = "Reload", tintColor: UIColor? = .gray)
    /// 无内容
    case noContent(title: String? = "No Content", titleColor: UIColor? = .black, detail: String? = nil, detailColor: UIColor? = .gray)
    /// 加载中...
    case loading(title: String? = "Loading...", tintColor: UIColor? = .gray)
}

/// 这是 FSEmptyDataSet 提供的默认 FSEmptyView 的内容容器，外部无法修改该类的内容，
/// 外部如有需要自定义 empty 内容，请自己实现 FSEmptyViewDelegate & FSEmptyViewDataSource。
public final class FSEmptyContent: FSEmptyViewDelegate, FSEmptyViewDataSource {
    
    public let type: FSEmptyContentType
    
    public var onDidPressButton: ((_ button: UIButton) -> Void)? {
        get {
            return contentProxy.onDidPressButton
        }
        set {
            contentProxy.onDidPressButton = newValue
        }
    }
    
    private var contentProxy: FSEmptyContentProxy!
    
    // MARK: Initialization
    
    public init(content: FSEmptyContentProxy) {
        self.type = .custom
        contentProxy = content
    }
    
    public init(type: FSEmptyContentType) {
        self.type = type
        switch type {
        case .none:
            contentProxy = FSEmptyContentNone()
        case .custom:
            #if DEBUG
            fatalError("Use `init(content:)` initializer if you want to cutom content.")
            #else
            contentProxy = FSEmptyContentTemplate()
            #endif
        case let .reload(title, tintColor):
            contentProxy = FSEmptyContentReload(title: title, tintColor: tintColor)
        case let .noContent(title, titleColor, detail, detailColor):
            contentProxy = FSEmptyContentNoContent(title: title, titleColor: titleColor, detail: detail, detailColor: detailColor)
        case let .loading(title, tintColor):
            contentProxy = FSEmptyContentLoading(title: title, tintColor: tintColor)
        }
    }
    
    // MARK: <FSEmptyViewDelegate>
    
    public func contentOffset(for emptyView: FSEmptyView) -> CGPoint {
        return contentProxy.contentOffset
    }
    
    public func imageBottomSpace(for emptyView: FSEmptyView) -> CGFloat {
        return contentProxy.imageBottomSpace
    }
    
    public func textBottomSpace(for emptyView: FSEmptyView) -> CGFloat {
        return contentProxy.textBottomSpace
    }
    
    public func detailTextBottomSpace(for emptyView: FSEmptyView) -> CGFloat {
        return contentProxy.detailTextBottomSpace
    }
    
    public func emptyViewShouldAllowScroll(_ emptyView: FSEmptyView) -> Bool {
        return contentProxy.isScrollEnabled
    }
    
    public func backgroundColor(for emptyView: FSEmptyView) -> UIColor? {
        if let color = contentProxy.backgroundColor {
            return color
        }
        return .clear
    }
    
    public func emptyView(_ emptyView: FSEmptyView, didPress button: UIButton) {
        contentProxy.onDidPressButton?(button)
    }
    
    // MARK: <FSEmptyViewDataSource>
    
    public func image(for emptyView: FSEmptyView) -> UIImage? {
        return contentProxy.image
    }
    
    public func customView(for emptyView: FSEmptyView) -> UIView? {
        return contentProxy.customView
    }
    
    public func text(for emptyView: FSEmptyView) -> String? {
        return contentProxy.title
    }
    
    public func attributedText(for emptyView: FSEmptyView) -> NSAttributedString? {
        return contentProxy.richTitle
    }
    
    public func detailText(for emptyView: FSEmptyView) -> String? {
        return contentProxy.detail
    }
    
    public func attributedDetailText(for emptyView: FSEmptyView) -> NSAttributedString? {
        return contentProxy.richDetail
    }
    
    public func emptyView(_ emptyView: FSEmptyView, buttonTitleFor state: UIControl.State) -> String? {
        if state == .normal {
            return contentProxy.buttonTitle
        } else {
            return nil
        }
    }
    
    public func buttonTitleFont(for emptyView: FSEmptyView) -> UIFont? {
        return contentProxy.buttonTitleFont
    }
    
    public func emptyView(_ emptyView: FSEmptyView, buttonTitleColorFor state: UIControl.State) -> UIColor? {
        if state == .highlighted, let color = contentProxy.buttonTitleColor {
            return color.withAlphaComponent(0.65)
        }
        return contentProxy.buttonTitleColor
    }
    
    public func emptyView(_ emptyView: FSEmptyView, buttonAttributedTitleFor state: UIControl.State) -> NSAttributedString? {
        if state == .normal {
            return contentProxy.richButtonTitle
        } else {
            return nil
        }
    }
    
    public func customButton(for emptyView: FSEmptyView) -> UIButton? {
        return contentProxy.customButton
    }
}

// MARK: - Strategies

/// 这是完全遵守 FSEmptyContentProxy 协议的 FSEmptyContent 模板。
/// 该类默认没有实现任何的内容，外部可使用该类做自定义。
public struct FSEmptyContentTemplate: FSEmptyContentProxy {
    
    public var contentOffset: CGPoint          = .zero
    public var imageBottomSpace: CGFloat       = 10.0
    public var textBottomSpace: CGFloat        = 10.0
    public var detailTextBottomSpace: CGFloat  = 10.0
    public var isScrollEnabled: Bool           = true
    public var image: UIImage?
    public var customView: UIView?
    public var title: String?
    public var richTitle: NSAttributedString?
    public var detail: String?
    public var richDetail: NSAttributedString?
    public var buttonTitleFont: UIFont?
    public var buttonTitleColor: UIColor?
    public var buttonTitle: String?
    public var richButtonTitle: NSAttributedString?
    public var onDidPressButton: ((_ button: UIButton) -> Void)?
    public var customButton: UIButton?
    public var backgroundColor: UIColor?
    
    // MARK: Initialization
    
    public init() {}
}


public struct FSEmptyContentNone: FSEmptyContentProxy {
    public init() {}
}


public class FSEmptyContentReload: FSEmptyContentProxy {
    
    public var customButton: UIButton?
    public var onDidPressButton: ((_ button: UIButton) -> Void)?
    
    public init(title: String? = "Reload", tintColor: UIColor? = nil) {
        let color = tintColor ?? .gray
        customButton = {
            let button = UIButton()
            button.titleLabel?.font = .systemFont(ofSize: 16.0)
            button.setTitle(title, for: .normal)
            button.setTitleColor(color, for: .normal)
            button.layer.borderColor = color.cgColor
            button.layer.borderWidth = 1.0
            button.layer.cornerRadius = 6.0
            let size = button.sizeThatFits(.init(width: 10000.0, height: 10000.0))
            button.frame.size.width = floor(size.width) + 26.0
            button.frame.size.height = floor(size.height) + 6.0
            button.addTarget(self, action: #selector(p_didPress(_:)), for: .touchUpInside)
            return button
        }()
    }
    
    @objc
    private func p_didPress(_ sender: UIButton) {
        onDidPressButton?(sender)
    }
}


public struct FSEmptyContentNoContent: FSEmptyContentProxy {
    
    public var richTitle: NSAttributedString?
    public var richDetail: NSAttributedString?
    
    public init(title: String? = "No Content", titleColor: UIColor? = .gray, detail: String? = nil, detailColor: UIColor? = .lightGray) {
        if let title = title, !title.isEmpty {
            let color = titleColor ?? .gray
            richTitle = {
                let attributes: [NSAttributedString.Key : Any] = [
                    .font : UIFont.systemFont(ofSize: 16.0),
                    .foregroundColor : color
                ]
                return NSAttributedString(string: title, attributes: attributes)
            }()
        }
        if let detail = detail, !detail.isEmpty {
            let color = detailColor ?? .lightGray
            richDetail = {
                let attributes: [NSAttributedString.Key : Any] = [
                    .font : UIFont.systemFont(ofSize: 14.0),
                    .foregroundColor : color
                ]
                return NSAttributedString(string: detail, attributes: attributes)
            }()
        }
    }
}


public struct FSEmptyContentLoading: FSEmptyContentProxy {
    
    public var customView: UIView?
    public var richTitle: NSAttributedString?
    
    public init(title: String? = "Loading...", tintColor: UIColor? = nil) {
        let color = tintColor ?? .gray
        customView = {
            let loadingView = UIActivityIndicatorView()
            loadingView.color = color
            loadingView.startAnimating()
            if #available(iOS 13.0, *) {
                loadingView.style = .large
            }
            return loadingView
        }()
        if let title = title, !title.isEmpty {
            richTitle = {
                let fontSize: CGFloat = { if #available(iOS 13.0, *) { return 18.0 } else { return 16.0 } }()
                let attributes: [NSAttributedString.Key : Any] = [
                    .font : UIFont.systemFont(ofSize: fontSize),
                    .foregroundColor : color
                ]
                return NSAttributedString(string: title, attributes: attributes)
            }()
        }
    }
}
