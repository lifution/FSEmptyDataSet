//
//  UICollectionView+FSEmptyView.h
//  FSEmptyDataSet
//
//  Created by Sheng on 2018/4/25.
//  Copyright © 2018 fusheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSEmptyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (FSEmptyView)

/*
    使用者无需手动添加 FSEmptyView, 只需要设置对应的 fs_emptyDelegate / fs_emptyDataSource 即可,
    内部会自动创建 FSEmptyView 并添加布局约束,
    调用者只需要实现 FSEmptyView 的代理和数据源方法即可, 其它任何的都不用管了.
 */
@property (nullable, nonatomic, weak) id<FSEmptyViewDelegate> fs_emptyDelegate;
@property (nullable, nonatomic, weak) id<FSEmptyViewDataSource> fs_emptyDataSource;

@end

NS_ASSUME_NONNULL_END
