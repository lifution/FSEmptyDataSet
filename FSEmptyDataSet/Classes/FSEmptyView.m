//
//  FSEmptyView.m
//  FSEmptyDataSet
//
//  Created by Sheng on 2018/4/25.
//  Copyright © 2018 fusheng. All rights reserved.
//

#import "FSEmptyView.h"

static CGFloat const kImageBottomSpace = 20.0;
static CGFloat const kTextBottomSpace = 10.0;
static CGFloat const kDetailTextBottomSpace = 20.0;
static CGFloat const kViewHorizontalMargin = 20.0;

static inline BOOL P_NSStringIsEmpty(NSString *aString) {
    return (!aString ||
            aString == (id)kCFNull ||
            ![aString isKindOfClass:[NSString class]] ||
            aString.length == 0);
}

static inline BOOL P_NSAttributedStringIsEmpty(NSAttributedString *attributedText) {
    return (!attributedText ||
            attributedText == (id)kCFNull ||
            ![attributedText isKindOfClass:[NSAttributedString class]] ||
            attributedText.string.length == 0);
}

@interface FSEmptyView ()
{
    struct {
        unsigned contentOffset : 1;
        unsigned imageBottomSpace : 1;
        unsigned textBottomSpace : 1;
        unsigned detailTextBottomSpace : 1;
        unsigned textPreferredMaxLayoutWidth : 1;
        unsigned detailTextPreferredMaxLayoutWidth : 1;
        unsigned allowScroll : 1;
        unsigned backgroundColor : 1;
        unsigned didPressButton : 1;
    } _delegateHas;
    
    struct {
        unsigned image : 1;
        unsigned customView : 1;
        unsigned customViewSize : 1;
        unsigned text : 1;
        unsigned detailText : 1;
        unsigned attributedText : 1;
        unsigned attributedDetailText : 1;
        unsigned buttonTitleFont : 1;
        unsigned buttonTitleColorForState : 1;
        unsigned buttonTitleForState : 1;
        unsigned buttonAttributedTitleForState : 1;
        unsigned button : 1;
    } _dataSourceHas;
}

// MARK: UI
@property (nonatomic, strong) UIScrollView *scrollView; // 为适配横屏, 使用 scrollView 可以在横屏时可滑动显示所有内容.
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, strong) UIButton *actionButton;

// MARK: Data
@property (nonatomic, assign) BOOL needsReload; ///< 标记是否要重新加载内容.
@property (nonatomic, readonly) UIFont *defaultButtonTitleFont;
@property (nonatomic, readonly) UIColor *defaultButtonNormalTitleColor;
@property (nonatomic, readonly) UIColor *defaultButtonSelectedTitleColor;
@property (nonatomic, readonly) UIColor *defaultButtonHighlightedTitleColor;

@end

@implementation FSEmptyView

#pragma mark - Constructors

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self p_didInitialize];
    }
    return self;
}

#pragma mark - Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self p_reloadDataIfNeeded];
    [self p_layoutScrollView];
}

#pragma mark - Private

- (void)p_didInitialize
{
    [self p_setupSubviews];
    [self p_setNeedsReload];
}

- (void)p_setupSubviews
{
    // ScrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.scrollsToTop = NO;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11, *)) {_scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;}
    [self addSubview:_scrollView];
    
    // 内容承载区
    _contentView = [[UIView alloc] init];
    [_scrollView addSubview:_contentView];
    
    // 图片
    _imageView = [[UIImageView alloc] init];
    [_contentView addSubview:_imageView];
    
    // 文本
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont systemFontOfSize:14.0];
    _textLabel.textColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00];
    _textLabel.numberOfLines = 0;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_textLabel];
    
    // 详细文本
    _detailTextLabel = [[UILabel alloc] init];
    _detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    _detailTextLabel.textColor = [UIColor colorWithRed:0.42 green:0.44 blue:0.47 alpha:1.00];
    _detailTextLabel.numberOfLines = 0;
    _detailTextLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_detailTextLabel];
}

- (UIButton *)p_defaultActionButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = self.defaultButtonTitleFont;
    [button setTitleColor:self.defaultButtonNormalTitleColor forState:UIControlStateNormal];
    [button setTitleColor:self.defaultButtonSelectedTitleColor forState:UIControlStateSelected];
    [button setTitleColor:self.defaultButtonHighlightedTitleColor forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(p_didPressButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)p_setNeedsReload
{
    _needsReload = YES;
    [self setNeedsLayout];
}

- (void)p_reloadDataIfNeeded
{
    if (_needsReload) {
        [self reloadData];
    }
}

- (void)p_layoutScrollView
{
    const CGRect bounds = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    const CGSize boundsSize = bounds.size;
    _scrollView.frame = bounds;
    CGSize contentSize = [self p_contentSizeToFit];
    _scrollView.contentSize = contentSize;
    CGFloat contentX = (boundsSize.width - contentSize.width) * 0.5;
    CGFloat contentY = (boundsSize.height - contentSize.height) * 0.5;
    if (_delegateHas.contentOffset) {
        CGPoint contentOffset = [_delegate contentOffsetForEmptyView:self];
        contentX -= contentOffset.x;
        contentY -= contentOffset.y;
    }
    _contentView.frame = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
}

- (CGSize)p_contentSizeToFit
{
    CGFloat contentWidth = 0.0;
    CGFloat contentHeight = 0.0;
    CGFloat imageBottomSpace = kImageBottomSpace;
    CGFloat textBottomSpace = kTextBottomSpace;
    CGFloat detailTextBottomSpace = kDetailTextBottomSpace;
    
    if (_delegateHas.imageBottomSpace) { imageBottomSpace = [_delegate imageBottomSpaceForEmptyView:self]; }
    if (_delegateHas.textBottomSpace) { textBottomSpace = [_delegate textBottomSpaceForEmptyView:self]; }
    if (_delegateHas.detailTextBottomSpace) { detailTextBottomSpace = [_delegate detailTextBottomSpaceForEmptyView:self]; }
    
    UIView *topView = nil;
    if (_customView) {
        topView = _customView;
        CGSize customViewSize = CGSizeZero;
        if (_dataSourceHas.customViewSize) {
            customViewSize = [_dataSource customViewSizeForEmptyView:self];
        }
        else {
            if (CGSizeEqualToSize(_customView.frame.size, CGSizeZero)) {
                customViewSize = [_customView sizeThatFits:CGSizeMake(INT16_MAX, INT16_MAX)];
            }
            else {
                customViewSize = _customView.frame.size;
            }
        }
        _customView.bounds = (CGRect){{0.0, 0.0}, customViewSize};
    }
    else {
        if (!_imageView.isHidden) {
            topView = _imageView;
            [_imageView sizeToFit];
        }
    }
    
    if (topView) {
        contentWidth = CGRectGetWidth(topView.bounds);
        contentHeight = CGRectGetHeight(topView.bounds);
    }
    else {
        // 顶部控件不存在则不需要间隙了。
        imageBottomSpace = 0.0;
    }
    
    // 文本
    if (!_textLabel.isHidden) {
        CGFloat textMaxWidth = 0.0;
        if (_delegateHas.textPreferredMaxLayoutWidth) {
            textMaxWidth = [_delegate textPreferredMaxLayoutWidthForEmptyView:self];
        }
        else {
            textMaxWidth = CGRectGetWidth(self.bounds) - kViewHorizontalMargin * 2;
        }
        CGSize textSize = [_textLabel sizeThatFits:CGSizeMake(textMaxWidth, INT16_MAX)];
        _textLabel.bounds = (CGRect){CGPointZero, textSize};
        contentWidth = fmax(contentWidth, textSize.width);
        contentHeight += imageBottomSpace;
        contentHeight += textSize.height;
    }
    else {
        // 同样的, 文本不存在则不需要间隙了.
        textBottomSpace = 0.0;
    }
    
    // 详细文本
    if (!_detailTextLabel.isHidden) {
        CGFloat detailTextMaxWidth = 0.0;
        if (_delegateHas.detailTextPreferredMaxLayoutWidth) {
            detailTextMaxWidth = [_delegate detailTextPreferredMaxLayoutWidthForEmptyView:self];
        }
        else {
            detailTextMaxWidth = CGRectGetWidth(self.bounds) - kViewHorizontalMargin * 2;
        }
        CGSize detailTextSize = [_detailTextLabel sizeThatFits:CGSizeMake(detailTextMaxWidth, INT16_MAX)];
        _detailTextLabel.bounds = (CGRect){CGPointZero, detailTextSize};
        contentWidth = fmax(contentWidth, detailTextSize.width);
        if (!_textLabel.isHidden) {
            contentHeight += textBottomSpace;
        }
        else {
            contentHeight += imageBottomSpace;
        }
        contentHeight += detailTextSize.height;
    }
    else {
        // 同样的, 详细文本不存在则不需要间隙了.
        detailTextBottomSpace = 0.0;
    }
    
    // 按钮
    if (_actionButton) {
        CGRect buttonBounds = _actionButton.bounds;
        if (CGSizeEqualToSize(buttonBounds.size, CGSizeZero)) {
            [_actionButton sizeToFit];
            buttonBounds = _actionButton.bounds;
        }
        contentWidth = fmax(contentWidth, CGRectGetWidth(buttonBounds));
        if (!_detailTextLabel.isHidden) {
            contentHeight += detailTextBottomSpace;
        }
        else {
            if (!_textLabel.isHidden) {
                contentHeight += textBottomSpace;
            }
            else {
                contentHeight += imageBottomSpace;
            }
        }
        contentHeight += CGRectGetHeight(buttonBounds);
    }
    
    // 布局
    CGFloat maxY = 0.0;
    if (topView) {
        CGSize topViewSize = topView.bounds.size;
        CGFloat topViewX = (contentWidth - topViewSize.width) * 0.5;
        CGFloat topViewY = 0.0;
        topView.frame = CGRectMake(topViewX, topViewY, topViewSize.width, topViewSize.height);
        maxY = CGRectGetMaxY(topView.frame);
    }
    if (!_textLabel.isHidden) {
        CGSize textSize = _textLabel.bounds.size;
        CGFloat textX = (contentWidth - textSize.width) * 0.5;
        CGFloat textY = (maxY == 0.0) ? 0.0 : (maxY + imageBottomSpace);
        _textLabel.frame = CGRectMake(textX, textY, textSize.width, textSize.height);
        maxY = CGRectGetMaxY(_textLabel.frame);
    }
    if (!_detailTextLabel.isHidden) {
        CGSize detailTextSize = _detailTextLabel.bounds.size;
        CGFloat detailTextX = (contentWidth - detailTextSize.width) * 0.5;
        CGFloat detailTextY;
        {
            if (!_textLabel.isHidden) {
                detailTextY = (maxY == 0.0) ? 0.0 : (maxY + textBottomSpace);
            }
            else {
                detailTextY = (maxY == 0.0) ? 0.0 : (maxY + imageBottomSpace);
            }
        }
        _detailTextLabel.frame = CGRectMake(detailTextX, detailTextY, detailTextSize.width, detailTextSize.height);
        maxY = CGRectGetMaxY(_detailTextLabel.frame);
    }
    if (_actionButton) {
        CGSize buttonSize = _actionButton.bounds.size;
        CGFloat buttonX = (contentWidth - buttonSize.width) * 0.5;
        CGFloat buttonY;
        {
            if (!_detailTextLabel.isHidden) {
                buttonY = (maxY == 0.0) ? 0.0 : (maxY + detailTextBottomSpace);
            }
            else {
                if (!_textLabel.isHidden) {
                    buttonY = (maxY == 0.0) ? 0.0 : (maxY + textBottomSpace);
                }
                else {
                    buttonY = (maxY == 0.0) ? 0.0 : (maxY + imageBottomSpace);
                }
            }
        }
        _actionButton.frame = CGRectMake(buttonX, buttonY, buttonSize.width, buttonSize.height);
    }
    
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
    return contentSize;
}

#pragma mark - Action

- (void)p_didPressButton:(id)sender
{
    if (_delegateHas.didPressButton) {
        [_delegate emptyView:self didPressButton:sender];
    }
}

#pragma mark - Public

- (void)reloadData
{
    _needsReload = NO;
    
    if (_delegateHas.allowScroll) {
        _scrollView.scrollEnabled = [_delegate emptyViewShouldAllowScroll:self];
    }
    
    if (_delegateHas.backgroundColor) {
        self.backgroundColor = [_delegate backgroundColorForEmptyView:self];
    }
    
    // 优先判断时候有自定义 view。
    BOOL customViewInvalid = YES; // 标记自定义 view 是否有效，以便 UIImageView 的设置。
    if (_dataSourceHas.customView) {
        _imageView.hidden = YES;
        UIView *customView = [_dataSource customViewForEmptyView:self];
        if (customView && [customView isKindOfClass:UIView.class]) {
            customViewInvalid = NO;
            if (_customView) {
                if (_customView != customView) {
                    [_customView removeFromSuperview];
                    _customView = customView;
                    [_contentView addSubview:_customView];
                }
            }
            else {
                _customView = customView;
                [_contentView addSubview:_customView];
            }
        }
    }
    
    // 如果自定义 view 无效则开始设置 UIImageView。
    if (customViewInvalid) {
        if (_customView) {
            [_customView removeFromSuperview];
            _customView = nil;
        }
        _imageView.hidden = YES;
        if (_dataSourceHas.image) {
            UIImage *image = [_dataSource imageForEmptyView:self];
            if (image && !CGSizeEqualToSize(image.size, CGSizeZero)) {
                _imageView.hidden = NO;
                _imageView.image = image;
            }
        }
    }
    
    // 文本
    _textLabel.hidden = YES;
    if (_dataSourceHas.text || _dataSourceHas.attributedText) {
        // attributedString first
        if (_dataSourceHas.attributedText) {
            NSAttributedString *attributedText = [_dataSource attributedTextForEmptyView:self];
            if (!P_NSAttributedStringIsEmpty(attributedText)) {
                _textLabel.hidden = NO;
                _textLabel.attributedText = attributedText;
            }
        } else {
            NSString *text = [_dataSource textForEmptyView:self];
            if (!P_NSStringIsEmpty(text)) {
                _textLabel.hidden = NO;
                _textLabel.text = text;
            }
        }
    }
    
    // 详细文本
    _detailTextLabel.hidden = YES;
    if (_dataSourceHas.detailText || _dataSourceHas.attributedDetailText) {
        // attributedString first
        if (_dataSourceHas.attributedDetailText) {
            NSAttributedString *attributedText = [_dataSource attributedDetailTextForEmptyView:self];
            if (!P_NSAttributedStringIsEmpty(attributedText)) {
                _detailTextLabel.hidden = NO;
                _detailTextLabel.attributedText = attributedText;
            }
        } else {
            NSString *text = [_dataSource detailTextForEmptyView:self];
            if (!P_NSStringIsEmpty(text)) {
                _detailTextLabel.hidden = NO;
                _detailTextLabel.text = text;
            }
        }
    }
    
    // 按钮
    if (_actionButton) {
        [_actionButton removeFromSuperview];
        _actionButton = nil;
    }
    if (_dataSourceHas.button) { // 优先检测是否含有自定义button.
        UIButton *button = [_dataSource buttonForEmptyView:self];
        if (button) {
            _actionButton = button;
        }
    } else {
        if (_dataSourceHas.buttonTitleForState || _dataSourceHas.buttonAttributedTitleForState) {
            
            static NSArray *states;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                states = @[@(UIControlStateNormal),
                           @(UIControlStateHighlighted),
                           @(UIControlStateDisabled),
                           @(UIControlStateSelected)];
            });
            
            // attributedString first
            if (_dataSourceHas.buttonAttributedTitleForState) {
                NSAttributedString *normalAttributedTitle = [_dataSource emptyView:self
                                                     buttonAttributedTitleForState:UIControlStateNormal];
                if (!P_NSAttributedStringIsEmpty(normalAttributedTitle)) {
                    _actionButton = [self p_defaultActionButton];
                    [_actionButton setAttributedTitle:normalAttributedTitle forState:UIControlStateNormal];
                    for (NSNumber *stateNumber in states) {
                        UIControlState state = [stateNumber unsignedIntegerValue];
                        if (state != UIControlStateNormal) {
                            NSAttributedString *attributedTitle = [_dataSource emptyView:self
                                                           buttonAttributedTitleForState:state];
                            [_actionButton setAttributedTitle:attributedTitle forState:state];
                        }
                    }
                }
            } else {
                NSString *normalTitle = [_dataSource emptyView:self buttonTitleForState:UIControlStateNormal];
                if (!P_NSStringIsEmpty(normalTitle)) {
                    _actionButton = [self p_defaultActionButton];
                    [_actionButton setTitle:normalTitle forState:UIControlStateNormal];
                    for (NSNumber *stateNumber in states) {
                        UIControlState state = [stateNumber unsignedIntegerValue];
                        
                        // title
                        if (state != UIControlStateNormal) {
                            NSString *title = [_dataSource emptyView:self buttonTitleForState:state];
                            [_actionButton setTitle:title forState:state];
                        }
                        
                        // title color
                        if (_dataSourceHas.buttonTitleColorForState) {
                            UIColor *titleColor = [_dataSource emptyView:self buttonTitleColorForState:state];
                            if (titleColor) {
                                [_actionButton setTitleColor:titleColor forState:state];
                            }
                        }
                    }
                }
            }
            
            if (_actionButton) {
                if (_dataSourceHas.buttonTitleFont) {
                    UIFont *font = [_dataSource buttonTitleFontForEmptyView:self];
                    if (font) {
                        _actionButton.titleLabel.font = font;
                    }
                }
            }
        }
    }
    if (_actionButton) {
        [_contentView addSubview:_actionButton];
    }
    
    [self setNeedsLayout];
}

#pragma mark - Setter

- (void)setDelegate:(id<FSEmptyViewDelegate>)delegate
{
    _delegate = delegate;
    
    _delegateHas.contentOffset = [_delegate respondsToSelector:@selector(contentOffsetForEmptyView:)];
    _delegateHas.imageBottomSpace = [_delegate respondsToSelector:@selector(imageBottomSpaceForEmptyView:)];
    _delegateHas.textBottomSpace = [_delegate respondsToSelector:@selector(textBottomSpaceForEmptyView:)];
    _delegateHas.detailTextBottomSpace = [_delegate respondsToSelector:@selector(detailTextBottomSpaceForEmptyView:)];
    _delegateHas.textPreferredMaxLayoutWidth = [_delegate respondsToSelector:@selector(textPreferredMaxLayoutWidthForEmptyView:)];
    _delegateHas.detailTextPreferredMaxLayoutWidth = [_delegate respondsToSelector:@selector(detailTextPreferredMaxLayoutWidthForEmptyView:)];
    _delegateHas.allowScroll = [_delegate respondsToSelector:@selector(emptyViewShouldAllowScroll:)];
    _delegateHas.backgroundColor = [_delegate respondsToSelector:@selector(backgroundColorForEmptyView:)];
    _delegateHas.didPressButton = [_delegate respondsToSelector:@selector(emptyView:didPressButton:)];
    
    [self p_setNeedsReload];
}

- (void)setDataSource:(id<FSEmptyViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    _dataSourceHas.image = [_dataSource respondsToSelector:@selector(imageForEmptyView:)];
    _dataSourceHas.customView = [_dataSource respondsToSelector:@selector(customViewForEmptyView:)];
    _dataSourceHas.customViewSize = [_dataSource respondsToSelector:@selector(customViewSizeForEmptyView:)];
    _dataSourceHas.text = [_dataSource respondsToSelector:@selector(textForEmptyView:)];
    _dataSourceHas.detailText = [_dataSource respondsToSelector:@selector(detailTextForEmptyView:)];
    _dataSourceHas.attributedText = [_dataSource respondsToSelector:@selector(attributedTextForEmptyView:)];
    _dataSourceHas.attributedDetailText = [_dataSource respondsToSelector:@selector(attributedDetailTextForEmptyView:)];
    _dataSourceHas.buttonTitleFont = [_dataSource respondsToSelector:@selector(buttonTitleFontForEmptyView:)];
    _dataSourceHas.buttonTitleColorForState = [_dataSource respondsToSelector:@selector(emptyView:buttonTitleColorForState:)];
    _dataSourceHas.buttonTitleForState = [_dataSource respondsToSelector:@selector(emptyView:buttonTitleForState:)];
    _dataSourceHas.buttonAttributedTitleForState = [_dataSource respondsToSelector:@selector(emptyView:buttonAttributedTitleForState:)];
    _dataSourceHas.button = [_dataSource respondsToSelector:@selector(buttonForEmptyView:)];
    
    [self p_setNeedsReload];
}

#pragma mark - Getter

- (UIFont *)defaultButtonTitleFont
{
    return [UIFont systemFontOfSize:14.0];
}

- (UIColor *)defaultButtonNormalTitleColor
{
    return [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00];
}

- (UIColor *)defaultButtonSelectedTitleColor
{
    // Same as default highlighted color.
    return self.defaultButtonHighlightedTitleColor;
}

- (UIColor *)defaultButtonHighlightedTitleColor
{
    return [UIColor grayColor];
}

@end
