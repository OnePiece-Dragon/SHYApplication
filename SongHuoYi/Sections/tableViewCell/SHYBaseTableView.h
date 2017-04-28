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

@interface SHYBaseTableView : UITableView<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong, nonnull) NSString * emptyBtnString;

@property (nonatomic, copy, nonnull) void (^emptyRequestAgainBlock)();

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style target:(nullable id)target;

@end
