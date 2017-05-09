//
//  SHYBaseTableView.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseTableView.h"


@implementation SHYBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style target:(id)target {
    if ([super initWithFrame:frame style:style]) {
        self.emptyBtnString = NET_EMPTY_MSG;
        
        self.backgroundColor = BACKGROUND_COLOR;
        
        self.delegate = target;
        self.dataSource = target;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        
        
    }
    return self;
}
- (void)addRefreshHeader:(id)target action:(SEL)action {
    MJRefreshHeader * header = [self createRefreshHeader];
    [header setRefreshingTarget:target refreshingAction:action];
    self.mj_header = header;
}
- (void)addRefreshHeader:(void (^)())block {
    MJRefreshHeader * header = [self createRefreshHeader];
    [header setRefreshingBlock:block];
    self.mj_header = header;
}
- (void)addRefreshFooter:(id)target action:(SEL)action {
    MJRefreshFooter * footer = [self createRefreshFooter];
    [footer setRefreshingTarget:target refreshingAction:action];
    self.mj_footer = footer;
}
- (void)addRefreshFooter:(void (^)())block {
    MJRefreshFooter * footer = [self createRefreshFooter];
    [footer setRefreshingBlock:block];
    self.mj_footer = footer;
}
- (MJRefreshHeader*)createRefreshHeader{
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader.alloc init];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    [header setTitle:@"即将刷新" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"松开以刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    return header;
}
- (MJRefreshFooter*)createRefreshFooter{
    MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter.alloc init];
    
    [footer setTitle:@"没有更多的数据了" forState:MJRefreshStateNoMoreData];
    return footer;
}



- (void)endRefresh {
    if ([self.mj_header isRefreshing]) {
        [self.mj_header endRefreshing];
    }
    if ([self.mj_footer isRefreshing]) {
        [self.mj_footer endRefreshing];
    }
}
- (void)noMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
}


- (void)emptyRequestAgainWithState:(NSString *)state{
    self.emptyBtnString = state;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"kongzhuangtai"];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]};
    
    return [[NSAttributedString alloc] initWithString:self.emptyBtnString attributes:attributes];
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if (self.emptyRequestAgainBlock) {
        self.emptyRequestAgainBlock();
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    // Do something
    if (self.emptyRequestAgainBlock) {
        self.emptyRequestAgainBlock();
    }
}

@end
