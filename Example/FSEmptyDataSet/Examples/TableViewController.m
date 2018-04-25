//
//  TableViewController.m
//  FSEmptyDataSet_Example
//
//  Created by Sheng on 2018/4/25.
//  Copyright © 2018 lifusheng. All rights reserved.
//

#import "TableViewController.h"
#import <FSEmptyDataSet/FSEmptyDataSet.h>

@interface TableViewController () <FSEmptyViewDelegate, FSEmptyViewDataSource> {
    BOOL _shouldShowRows;
}

@end

@implementation TableViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (void)p_didInitialize
{
    _shouldShowRows = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = UIView.new;
    
    self.tableView.fs_emptyDelegate = self;
    self.tableView.fs_emptyDataSource = self;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _shouldShowRows ? 10 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const kCellReuseId = @"kCellReuseId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellReuseId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Row %d", (int)indexPath.row];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _shouldShowRows = !_shouldShowRows;
    [tableView reloadData];
}

#pragma mark - <FSEmptyViewDelegate>

- (CGPoint)contentOffsetForEmptyView:(FSEmptyView *)emptyView
{
    return CGPointMake(0.0, CGRectGetMaxY(self.navigationController.navigationBar.frame));
}

- (CGFloat)textBottomSpaceForEmptyView:(FSEmptyView *)emptyView
{
    return 30.0;
}

- (UIColor *)backgroundColorForEmptyView:(FSEmptyView *)emptyView
{
    return [UIColor colorWithRed:0.93 green:0.93 blue:0.97 alpha:1.00];
}

- (void)emptyView:(FSEmptyView *)emptyView didPressButton:(UIButton *)button
{
    _shouldShowRows = !_shouldShowRows;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - <FSEmptyViewDataSource>

- (UIImage * _Nullable)imageForEmptyView:(FSEmptyView *)emptyView
{
    return [UIImage imageNamed:@"placeholder_facebook"];
}

- (NSAttributedString *)attributedTextForEmptyView:(FSEmptyView *)emptyView
{
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = [UIColor whiteColor];
    shadow.shadowOffset = CGSizeMake(0.0, 1.0);
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:22.0],
                                 NSForegroundColorAttributeName : [UIColor colorWithRed:0.67 green:0.69 blue:0.74 alpha:1.00],
                                 NSShadowAttributeName : shadow
                                 };
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:@"No friends to show."
                                                                         attributes:attributes];
    return attributedText;
}

- (NSString *)emptyView:(FSEmptyView *)emptyView buttonTitleForState:(UIControlState)state
{
    return @"Reload";
}

@end
