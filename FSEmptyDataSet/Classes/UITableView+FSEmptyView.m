//
//  UITableView+FSEmptyView.m
//  FSEmptyDataSet
//
//  Created by Sheng on 2018/4/25.
//  Copyright © 2018 fusheng. All rights reserved.
//

#import "UITableView+FSEmptyView.h"
#import "FSEmptyViewDefines.h"
#import <objc/runtime.h>

@implementation UITableView (FSEmptyView)

#pragma mark - Override

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL selectors[] = {
            @selector(reloadData),
            @selector(insertSections:withRowAnimation:),
            @selector(deleteSections:withRowAnimation:),
            @selector(reloadSections:withRowAnimation:),
            @selector(moveSection:toSection:),
            @selector(insertRowsAtIndexPaths:withRowAnimation:),
            @selector(deleteRowsAtIndexPaths:withRowAnimation:),
            @selector(reloadRowsAtIndexPaths:withRowAnimation:),
            @selector(moveRowAtIndexPath:toIndexPath:)
        };
        
        for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"fsempty_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            FSEmptyReplaceMethod(self, originalSelector, swizzledSelector);
        }
    });
}

#pragma mark - Runtime

- (FSEmptyView *)fsempty_emptyView
{
    FSEmptyView *emptyView = objc_getAssociatedObject(self, @selector(fsempty_addEmptyViewIfNeeded));
    return emptyView;
}

- (void)fsempty_addEmptyViewIfNeeded
{
    FSEmptyView *emptyView = [self fsempty_emptyView];
    if (!emptyView) {
        emptyView = [[FSEmptyView alloc] init];
        [self addSubview:emptyView];
        objc_setAssociatedObject(self, _cmd, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        // Constraints
        emptyView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:emptyView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:emptyView
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:emptyView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1.0
                                                          constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:emptyView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1.0
                                                          constant:0.0]];
        [self fsempty_refreshEmptyViewState];
    }
}

#pragma mark - Swizzled Methos

- (void)fsempty_reloadData
{
    [self fsempty_reloadData];
    [self fsempty_refreshEmptyViewState];
}

- (void)fsempty_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self fsempty_reloadSections:sections withRowAnimation:animation];
    [self fsempty_refreshEmptyViewState];
}

- (void)fsempty_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self fsempty_insertSections:sections withRowAnimation:animation];
    [self fsempty_refreshEmptyViewState];
}

- (void)fsempty_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self fsempty_deleteSections:sections withRowAnimation:animation];
    [self fsempty_refreshEmptyViewState];
}

- (void)fsempty_moveSection:(NSInteger)section toSection:(NSInteger)newSection
{
    [self fsempty_moveSection:section toSection:newSection];
    [self fsempty_refreshEmptyViewState];
}

- (void)fsempty_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self fsempty_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self fsempty_refreshEmptyViewState];
}

- (void)fsempty_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self fsempty_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self fsempty_refreshEmptyViewState];
}

- (void)fsempty_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self fsempty_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self fsempty_refreshEmptyViewState];
}

- (void)fsempty_moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath
{
    [self fsempty_moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    [self fsempty_refreshEmptyViewState];
}

#pragma mark - Private

- (void)fsempty_refreshEmptyViewState
{
    FSEmptyView *emptyView = [self fsempty_emptyView];
    if (!emptyView) {
        return;
    }
    emptyView.hidden = YES;
    
    if (!self.dataSource) {
        emptyView.hidden = NO;
        return;
    }
    
    NSInteger sections = self.numberOfSections;
    if (sections == 0) {
        emptyView.hidden = NO;
        return;
    }
    BOOL emptyViewShouldHide = NO;
    for (NSInteger i = 0; i < sections; i ++) {
        NSInteger rowsInSection = [self numberOfRowsInSection:i];
        if (rowsInSection > 0) {
            emptyViewShouldHide = YES;
            break;
        }
    }
    emptyView.hidden = emptyViewShouldHide;
}

#pragma mark - Setter

- (void)setFs_emptyDelegate:(id<FSEmptyViewDelegate>)fs_emptyDelegate
{
    if (![self fsempty_emptyView]) {
        [self fsempty_addEmptyViewIfNeeded];
    }
    [self fsempty_emptyView].delegate = fs_emptyDelegate;
}

- (void)setFs_emptyDataSource:(id<FSEmptyViewDataSource>)fs_emptyDataSource
{
    if (![self fsempty_emptyView]) {
        [self fsempty_addEmptyViewIfNeeded];
    }
    [self fsempty_emptyView].dataSource = fs_emptyDataSource;
}

#pragma mark - Getter

- (id<FSEmptyViewDelegate>)fs_emptyDelegate
{
    return [self fsempty_emptyView].delegate;
}

- (id<FSEmptyViewDataSource>)fs_emptyDataSource
{
    return [self fsempty_emptyView].dataSource;
}

@end
