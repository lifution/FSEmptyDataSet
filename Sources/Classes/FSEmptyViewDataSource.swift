//
//  FSEmptyViewDataSource.swift
//  FSEmptyDataSet
//
//  Created by Sheng on 2023/12/25.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit
import Foundation

public protocol FSEmptyViewDataSource: AnyObject {
    
    /// - Note: 如果没有实现所需的数据源方法则会默认隐藏对应的控件。
    
    // MARK: ImageView
    
    /// 图片, 只需要返回 UIImage 实例即可, FSEmptyView 会根据图片的 size 自动调整 UIImageView 的 size。
    /// 如果实现了 `customView(for emptyView:)` 方法的话则会忽略该方法，不管是否返回有效的 UIImage 对象，
    /// 但如果 `customView(for emptyView:)` 方法返回 nil 且该方法返回有效 UIImage 对象的话则当前方法有效。
    /// - Note: 如果不实现该方法或返回 nil 则隐藏 UIImageView。
    func image(for emptyView: FSEmptyView) -> UIImage?
    
    // MARK: CustomView
    
    /// 自定义 view 替代 UIImageView 所在位置，比如设置一个 loading 控件。
    /// 自定义 view 底部的空隙用的是 `imageBottomSpace(for emptyView:)` 方法的返回值(如果没有实现该方法则使用默认值)。
    /// - Note: 此 customView 只是替代顶部的 UIImage 所在控件，并非指替代整个 EmptyView 的内容，
    ///         不过，你可以只设置 customView 而忽略其它所有控件，这样就达到了替代整个 EmptyView 内容的效果。
    func customView(for emptyView: FSEmptyView) -> UIView?
    
    /// 配置自定义 view 的 size，
    /// 如果不实现该方法则会先判断 customView 的 frame.size 是否有效，如果有效则使用 frame.size，
    /// 否则使用 customView 的 `sizeThatFits(_:)` 来确定 customView 的 size。
    func customViewSize(for emptyView: FSEmptyView) -> CGSize
    
    // MARK: TextLabel
    
    /// 文本，使用默认的字体和文本颜色。
    /// - Note: 如果返回 nil 则隐藏 textLabel。
    func text(for emptyView: FSEmptyView) -> String?
    
    /// 文本的富文本，如果实现了该方法这会自动忽略 `text(for emptyView:)` 方法。
    /// - Note: 如果该方法返回 nil 则会去使用 `text(for emptyView:)` 方法配置 textLabel。
    func attributedText(for emptyView: FSEmptyView) -> NSAttributedString?
    
    // MARK: DetailTextLabel
    
    /// 详细文本，使用默认的字体和文本颜色。
    /// - Note: 如果返回 nil 则隐藏 detailTextLabel。
    func detailText(for emptyView: FSEmptyView) -> String?
    
    /// 详细文本的富文本，如果实现了该方法这会自动忽略 `detailText(for emptyView:)` 方法。
    /// - Note: 如果该方法返回 nil 则会去使用 `detailText(for emptyView:)` 方法配置 detailTextLabel。
    func attributedDetailText(for emptyView: FSEmptyView) -> NSAttributedString?
    
    // MARK: Button
    
    /// 默认按钮的标题字体。
    /// - Note: 如果返回 nil 则使用默认的字体。
    func buttonTitleFont(for emptyView: FSEmptyView) -> UIFont?
    
    /// 指定状态下的按钮标题文本颜色。
    /// - Note: 如果返回 nil 则使用默认的颜色。
    func emptyView(_ emptyView: FSEmptyView, buttonTitleColorFor state: UIControl.State) -> UIColor?
    
    /// 指定状态下的按钮标题文本标题。
    /// - Note: 如果 UIControl.State.normal 状态下返回 nil 则默认会隐藏 UIButton。
    func emptyView(_ emptyView: FSEmptyView, buttonTitleFor state: UIControl.State) -> String?
    
    /// 指定状态下的富文本按钮标题。
    /// - Important: 如果实现了该方法则会忽略 `buttonTitleFont(for emptyView:)` 和 `emptyView(_ emptyView:, buttonTitleFor state:)` 以及 `emptyView(_ emptyView:, buttonTitleColorFor state:)` 方法.
    /// - Note: 如果 UIControl.State.normal 状态下返回 nil 则默认会继续使用上述三个被忽略的方法去配置 button。
    func emptyView(_ emptyView: FSEmptyView, buttonAttributedTitleFor state: UIControl.State) -> NSAttributedString?
    
    /// 自定义按钮。
    /// 如果实现了该方法则会忽略与按钮相关的其它任何数据源方法,
    /// 而且不会回调代理方法 `emptyView(_ emptyView:, didPressButton:)`, 需由开发者自己指定 target-action，
    /// 使用者需给这个自定义的 button 设置一个 bounds, 否则 FSEmpetyView 内部会使用 UIView 默认的 sizeToFit 方法配置 button 的 size.
    func customButton(for emptyView: FSEmptyView) -> UIButton?
}

// optional
public extension FSEmptyViewDataSource {
    func image(for emptyView: FSEmptyView) -> UIImage? { return nil }
    func customView(for emptyView: FSEmptyView) -> UIView? { return nil }
    func customViewSize(for emptyView: FSEmptyView) -> CGSize { return .zero }
    func text(for emptyView: FSEmptyView) -> String? { return nil }
    func attributedText(for emptyView: FSEmptyView) -> NSAttributedString? { return nil }
    func detailText(for emptyView: FSEmptyView) -> String? { return nil }
    func attributedDetailText(for emptyView: FSEmptyView) -> NSAttributedString? { return nil }
    func buttonTitleFont(for emptyView: FSEmptyView) -> UIFont? { return nil }
    func emptyView(_ emptyView: FSEmptyView, buttonTitleColorFor state: UIControl.State) -> UIColor? { return nil }
    func emptyView(_ emptyView: FSEmptyView, buttonTitleFor state: UIControl.State) -> String? { return nil }
    func emptyView(_ emptyView: FSEmptyView, buttonAttributedTitleFor state: UIControl.State) -> NSAttributedString? { return nil }
    func customButton(for emptyView: FSEmptyView) -> UIButton? { return nil }
}
