//
//  CollectionViewController.m
//  FSEmptyDataSet_Example
//
//  Created by Sheng on 2018/4/25.
//  Copyright © 2018 lifusheng. All rights reserved.
//

#import "CollectionViewController.h"
#import "UICollectionView+FSEmptyView.h"

static NSString *const kCellReuseId = @"kCellReuseId";

@interface CollectionViewController () <FSEmptyViewDataSource> {
    BOOL _shouldShowRows;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CollectionViewController

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
    
    self.title = @"CollectionView";
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellReuseId];
    
    self.collectionView.fs_emptyDataSource = self;
}

#pragma mark - Event Actions

- (void)p_didPressButton:(id)sender
{
    NSLog(@"点击了自定义按钮");
    
    _shouldShowRows = !_shouldShowRows;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _shouldShowRows ? 50 : 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseId
                                                                           forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor orangeColor];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    _shouldShowRows = !_shouldShowRows;
    [collectionView reloadData];
}

#pragma mark - <FSEmptyViewDataSource>

- (UIImage * _Nullable)imageForEmptyView:(FSEmptyView *)emptyView
{
    return [UIImage imageNamed:@"placeholder_slack"];
}

- (NSAttributedString *)attributedTextForEmptyView:(FSEmptyView *)emptyView
{
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:16.0],
                                 NSForegroundColorAttributeName : [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.00]
                                 };
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:@"You don't have any recent mentions"
                                                                         attributes:attributes];
    return attributedText;
}

- (UIButton *)buttonForEmptyView:(FSEmptyView *)emptyView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.bounds = CGRectMake(0.0, 0.0, 100.0, 34.0);
    button.clipsToBounds = YES;
    button.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor orangeColor].CGColor;
    button.layer.cornerRadius = 17.0;
    [button setTitle:@"Refresh" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(p_didPressButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
