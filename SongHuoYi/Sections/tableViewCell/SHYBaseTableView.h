//
//  SHYBaseTableView.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHYBaseCell.h"
#import "UIScrollView+EmptyDataSet.h"

#define cellID @"baseCell"

@protocol EmptyRequestDelegate <NSObject>

-(void)emptyRequestAgainWithState:(nonnull NSString*)state;

@end

@interface SHYBaseTableView : UITableView<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,EmptyRequestDelegate>

@property (nonatomic, strong, nonnull) NSString * emptyBtnString;

@property (nonatomic, copy, nonnull) void (^emptyRequestAgainBlock)();

- (_Nonnull instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style target:(_Nonnull id)target;

- (void)addRefreshHeader:(_Nonnull id)target action:(_Nonnull SEL)action;
- (void)addRefreshFooter:(_Nonnull id)target action:(_Nonnull SEL)action;
- (void)addRefreshHeader:( void(^ _Nonnull )())block;
- (void)addRefreshFooter:( void(^ _Nonnull )())block;

- (void)endRefresh;
- (void)noMoreData;

@end
