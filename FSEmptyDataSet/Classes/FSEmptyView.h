//
//  FSEmptyView.h
//  FSEmptyDataSet
//
//  Created by Sheng on 2018/4/25.
//  Copyright © 2018 fusheng. All rights reserved.
//

/*
 FSEmptyView 默认布局:
 
    ----------------
    | UIImageView  |
    |      or      |
    |  CustomView  |
    ----------------
            |
         (space)
            |
    -----------------
    | UILabel (Text)|
    -----------------
            |
         (space)
            |
 -----------------------
 | UILabel (DetailText)|
 -----------------------
            |
         (space)
            |
    ----------------
    |   UIButton   |
    ----------------
 */

#import <UIKit/UIKit.h>

@protocol FSEmptyViewDelegate;
@protocol FSEmptyViewDataSource;

NS_ASSUME_NONNULL_BEGIN

@interface FSEmptyView : UIView

@property (nullable, nonatomic, weak) id<FSEmptyViewDelegate> delegate;
@property (nullable, nonatomic, weak) id<FSEmptyViewDataSource> dataSource;

/**
 刷新 FSEmptyView 所有的数据.
 
 @note 调用该方法会重新走一遍 delegate 和 dataSource 协议方法.
 */
- (void)reloadData;

@end


@protocol FSEmptyViewDelegate <NSObject>

@optional

/**
 内容偏移量, 默认为 CGPointZero.
 */
- (CGPoint)contentOffsetForEmptyView:(FSEmptyView *)emptyView;

/**
 图片底部空隙, 如果不实现该方法则使用默认的空隙.
 */
- (CGFloat)imageBottomSpaceForEmptyView:(FSEmptyView *)emptyView;

/**
 文本底部空隙, 如果不实现该方法则使用默认的空隙.
 */
- (CGFloat)textBottomSpaceForEmptyView:(FSEmptyView *)emptyView;

/**
 详细文本底部空隙, 如果不实现该方法则使用默认的空隙.
 */
- (CGFloat)detailTextBottomSpaceForEmptyView:(FSEmptyView *)emptyView;

/**
 文本最大布局宽度, 如果不实现该方法这默认使用 FSEmptyView 的宽度.
 */
- (CGFloat)textPreferredMaxLayoutWidthForEmptyView:(FSEmptyView *)emptyView;

/**
 详细文本最大布局宽度, 如果不实现该方法这默认使用 FSEmptyView 的宽度.
 */
- (CGFloat)detailTextPreferredMaxLayoutWidthForEmptyView:(FSEmptyView *)emptyView;

/**
 是否允许滑动, 默认是 YES.
 */
- (BOOL)emptyViewShouldAllowScroll:(FSEmptyView *)emptyView;

/**
 自定义 FSEmptyView 背景颜色, 默认为 nil.
 */
- (UIColor * _Nullable)backgroundColorForEmptyView:(FSEmptyView *)emptyView;

/**
 点击了 FSEmptyView 上的按钮.
 */
- (void)emptyView:(FSEmptyView *)emptyView didPressButton:(UIButton *)button;

@end


/*
 
 如果没有实现所需的数据源方法则会默认隐藏对应的控件,
 比如没有实现 `emptyView: buttonTitleForState:` & `emptyView: buttonAttributedTitleForState:` & `buttonForEmptyView:`
 这三个方法至少一个, 则隐藏按钮, 其它控件类似.
 
 */
@protocol FSEmptyViewDataSource <NSObject>

@optional

#pragma mark - ImageView

/**
 图片, 只需要返回 UIImage 实例即可, FSEmptyView 会根据图片的 size 自动调整 UIImageView 的 size。
 如果实现了 `customViewForEmptyView:` 方法的话则会忽略该方法，不管是否返回有效的 UIImage 对象。
 
 @note 如果不实现该方法或返回 nil 则隐藏 UIImageView.
 */
- (UIImage * _Nullable)imageForEmptyView:(FSEmptyView *)emptyView;

#pragma mark - CustomView

/**
 自定义 view 替代 UIImageView 所在位置，比如设置一个 loading 控件。
 自定义 view 底部的空隙用的是 `imageBottomSpaceForEmptyView:` 方法的返回值(如果没有实现该方法则使用默认值)。

 @note 此 customView 只是替代顶部的 UIImage 所在控件，并非指替代整个 EmptyView 的内容，
       不过，你可以只设置 customView 而忽略其它所有控件，这样就达到了替代整个 EmptyView 内容的效果。
 @return 自定义的 view，如果返回 nil 或者非 UIView 类型则会忽略。
 */
- (UIView * _Nullable)customViewForEmptyView:(FSEmptyView *)emptyView;

/**
 配置自定义 view 的 size，
 如果不实现该方法则会先判断 customView 的 frame.size 是否有效，如果有效则使用 frame.size，
 否则使用 customView 的 `sizeThatFits:` 来确定 customView 的 size。
 */
- (CGSize)customViewSizeForEmptyView:(FSEmptyView *)emptyView;

#pragma mark - TextLabel

/**
 文本, 使用默认的字体和文本颜色.
 
 @note 如果返回 nil 则隐藏 textLabel.
 */
- (NSString * _Nullable)textForEmptyView:(FSEmptyView *)emptyView;

/**
 文本富文本,
 如果实现了该方法则会忽略 `textForEmptyView:` 方法.
 
 @note 如果返回 nil 则隐藏 textLabel.
 */
- (NSAttributedString * _Nullable)attributedTextForEmptyView:(FSEmptyView *)emptyView;

#pragma mark - DetailTextLabel

/**
 详细文本, 使用默认的字体和文本颜色.
 
 @note 如果返回 nil 则隐藏 detailTextLabel.
 */
- (NSString * _Nullable)detailTextForEmptyView:(FSEmptyView *)emptyView;

/**
 详细文本富文本,
 如果实现了该方法则会忽略 `detailTextForEmptyView:` 方法.
 
 @note 如果返回 nil 则隐藏 detailTextLabel.
 */
- (NSAttributedString * _Nullable)attributedDetailTextForEmptyView:(FSEmptyView *)emptyView;

#pragma mark - Button

/**
 按钮标题字体.
 
 @note 如果返回 nil 则使用默认的字体.
 */
- (UIFont * _Nullable)buttonTitleFontForEmptyView:(FSEmptyView *)emptyView;

/**
 指定状态下的按钮标题文本颜色.
 
 @note 如果返回 nil 则使用默认的文本颜色.
 */
- (UIColor * _Nullable)emptyView:(FSEmptyView *)emptyView buttonTitleColorForState:(UIControlState)state;

/**
 指定状态下的按钮标题.
 
 @note 如果 UIControlStateNormal 状态下返回 nil 则隐藏 UIButton.
 */
- (NSString * _Nullable)emptyView:(FSEmptyView *)emptyView buttonTitleForState:(UIControlState)state;

/**
 指定状态下的富文本按钮标题,
 如果实现了该方法则会忽略 `buttonTitleFontForEmptyView` 和 `emptyView: buttonTitleForState:` 以及
 `emptyView: buttonTitleColorForState:` 方法.
 
 @note 如果 UIControlStateNormal 状态下返回 nil 则隐藏 UIButton.
 */
- (NSAttributedString * _Nullable)emptyView:(FSEmptyView *)emptyView buttonAttributedTitleForState:(UIControlState)state;

/**
 自定义button,
 如果实现了该方法则会忽略与按钮相关的其它任何数据源方法,
 而且不会回调代理方法 `emptyView: didPressButton:`, 需由调用者自己指定 target-action,
 使用者需给自定义的button设置一个bounds, 否则内部会使用 UIView 默认的 sizeToFit 方法适应 button 的 size.
 
 @note 如果返回 nil 则隐藏 UIButton.
 */
- (UIButton * _Nullable)buttonForEmptyView:(FSEmptyView *)emptyView;

@end

NS_ASSUME_NONNULL_END

