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
