//
//  CustomViewViewController.m
//  FSEmptyDataSet_Example
//
//  Created by Sheng on 2018/11/4.
//  Copyright © 2018年 lifusheng. All rights reserved.
//

#import "CustomViewViewController.h"
#import "LoadingView.h"

#import <FSEmptyDataSet/FSEmptyDataSet.h>

@interface CustomViewViewController () <FSEmptyViewDelegate, FSEmptyViewDataSource>
{
    LoadingView *_loadingView;
}

@end

@implementation CustomViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"CustomView";
    
    {
        _loadingView = [[LoadingView alloc] init];
    }
    
    FSEmptyView *emptyView = [[FSEmptyView alloc] init];
    emptyView.delegate = self;
    emptyView.dataSource = self;
    emptyView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:emptyView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[emptyView]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(emptyView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[emptyView]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(emptyView)]];
}

#pragma mark - <FSEmptyViewDataSource>

- (UIView *)customViewForEmptyView:(FSEmptyView *)emptyView
{
    return _loadingView;
}

- (NSString * _Nullable)textForEmptyView:(FSEmptyView *)emptyView
{
    return @"加载中, 请稍候...";
}

#pragma mark - <FSEmptyViewDelegate>

- (UIColor *)backgroundColorForEmptyView:(FSEmptyView *)emptyView
{
    return [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
}

@end
