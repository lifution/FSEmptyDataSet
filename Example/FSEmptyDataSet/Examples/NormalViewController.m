//
//  NormalViewController.m
//  FSEmptyDataSet_Example
//
//  Created by Sheng on 2018/4/25.
//  Copyright © 2018 lifusheng. All rights reserved.
//

#import "NormalViewController.h"
#import <FSEmptyDataSet/FSEmptyDataSet.h>

@interface NormalViewController () <FSEmptyViewDelegate, FSEmptyViewDataSource>

@end

@implementation NormalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

#pragma mark - <FSEmptyViewDelegate>

- (CGFloat)detailTextPreferredMaxLayoutWidthForEmptyView:(FSEmptyView *)emptyView
{
    return CGRectGetWidth(self.view.bounds) - 80.0 * 2;
}

- (UIColor *)backgroundColorForEmptyView:(FSEmptyView *)emptyView
{
    return [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
}

#pragma mark - <FSEmptyViewDataSource>

- (UIImage * _Nullable)imageForEmptyView:(FSEmptyView *)emptyView
{
    return [UIImage imageNamed:@"placeholder_whatsapp"];
}

- (NSString * _Nullable)textForEmptyView:(FSEmptyView *)emptyView
{
    return @"No Media";
}

- (NSString * _Nullable)detailTextForEmptyView:(FSEmptyView *)emptyView
{
    return @"You can exchange media with Ignacio by tapping on the Arrow Up icon in the conversation screen.";
}

@end
