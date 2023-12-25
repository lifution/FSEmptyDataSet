//
//  FSEmptyContentProxy.swift
//  FSEmptyDataSet
//
//  Created by Sheng on 2023/12/25.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

public protocol FSEmptyContentProxy {
    
    var contentOffset: CGPoint { get set }
    
    var imageBottomSpace: CGFloat { get set }
    
    var textBottomSpace: CGFloat { get set }
    
    var detailTextBottomSpace: CGFloat { get set }
    
    var isScrollEnabled: Bool { get set }
    
    var image: UIImage? { get set }
    
    var customView: UIView? { get set }
    
    var title: String? { get set }
    
    var richTitle: NSAttributedString? { get set }
    
    var detail: String? { get set }
    
    var richDetail: NSAttributedString? { get set }
    
    var buttonTitleFont: UIFont? { get set }
    
    var buttonTitleColor: UIColor? { get set }
    
    var buttonTitle: String? { get set }
    
    var richButtonTitle: NSAttributedString? { get set }
    
    var onDidPressButton: ((_ button: UIButton) -> Void)? { get set }
    
    var customButton: UIButton? { get set }
    
    var backgroundColor: UIColor? { get set }
}

// optional
public extension FSEmptyContentProxy {
    var contentOffset: CGPoint { get { return .zero } set {} }
    var imageBottomSpace: CGFloat { get { return 10.0 } set {} }
    var textBottomSpace: CGFloat { get { return 10.0 } set {} }
    var detailTextBottomSpace: CGFloat { get { return 10.0 } set {} }
    var isScrollEnabled: Bool { get { return true } set {} }
    var image: UIImage? { get { return nil } set {} }
    var customView: UIView? { get { return nil } set {} }
    var title: String? { get { return nil } set {} }
    var richTitle: NSAttributedString? { get { return nil } set {} }
    var detail: String? { get { return nil } set {} }
    var richDetail: NSAttributedString? { get { return nil } set {} }
    var buttonTitleFont: UIFont? { get { return nil } set {} }
    var buttonTitleColor: UIColor? { get { return nil } set {} }
    var buttonTitle: String? { get { return nil } set {} }
    var richButtonTitle: NSAttributedString? { get { return nil } set {} }
    var onDidPressButton: ((_ button: UIButton) -> Void)? { get { return nil } set {} }
    var customButton: UIButton? { get { return nil } set {} }
    var backgroundColor: UIColor? { get { return nil } set {} }
}
