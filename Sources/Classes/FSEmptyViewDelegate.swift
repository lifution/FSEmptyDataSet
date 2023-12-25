//
//  FSEmptyViewDelegate.swift
//  FSEmptyDataSet
//
//  Created by Sheng on 2023/12/25.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit
import Foundation

public protocol FSEmptyViewDelegate: AnyObject {
    
    /// 内容偏移量，默认为 CGPointZero。
    func contentOffset(for emptyView: FSEmptyView) -> CGPoint
    
    /// 图片底部空隙，如果不实现该方法则使用默认的空隙。
    func imageBottomSpace(for emptyView: FSEmptyView) -> CGFloat
    
    /// 文本底部空隙，如果不实现该方法则使用默认的空隙。
    func textBottomSpace(for emptyView: FSEmptyView) -> CGFloat
    
    /// 详细文本底部空隙，如果不实现该方法则使用默认的空隙。
    func detailTextBottomSpace(for emptyView: FSEmptyView) -> CGFloat
    
    /// 文本最大布局宽度，如果不实现该方法这默认使用 FSEmptyView 的宽度。
    func textPreferredMaxLayoutWidth(for emptyView: FSEmptyView) -> CGFloat
    
    /// 详细文本最大布局宽度，如果不实现该方法这默认使用 FSEmptyView 的宽度。
    func detailTextPreferredMaxLayoutWidth(for emptyView: FSEmptyView) -> CGFloat
    
    /// 是否允许滑动，默认是 true。
    func emptyViewShouldAllowScroll(_ emptyView: FSEmptyView) -> Bool
    
    /// 自定义 FSEmptyView 背景颜色，默认为 nil。
    func backgroundColor(for emptyView: FSEmptyView) -> UIColor?
    
    /// 点击了 FSEmptyView 上的默认按钮。
    /// - Note: 自定义按钮不会回调该方法。
    func emptyView(_ emptyView: FSEmptyView, didPress button: UIButton)
}

// optional
public extension FSEmptyViewDelegate {
    func contentOffset(for emptyView: FSEmptyView) -> CGPoint { return .zero }
    func imageBottomSpace(for emptyView: FSEmptyView) -> CGFloat { return 10.0 }
    func textBottomSpace(for emptyView: FSEmptyView) -> CGFloat { return 10.0 }
    func detailTextBottomSpace(for emptyView: FSEmptyView) -> CGFloat { return 10.0 }
    func textPreferredMaxLayoutWidth(for emptyView: FSEmptyView) -> CGFloat { return 0.0 }
    func detailTextPreferredMaxLayoutWidth(for emptyView: FSEmptyView) -> CGFloat { return 0.0 }
    func emptyViewShouldAllowScroll(_ emptyView: FSEmptyView) -> Bool { return true }
    func backgroundColor(for emptyView: FSEmptyView) -> UIColor? { return nil }
    func emptyView(_ emptyView: FSEmptyView, didPress button: UIButton) {}
}
