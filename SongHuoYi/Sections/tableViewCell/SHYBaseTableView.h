//
//  SHYBaseTableView.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHYBaseCell.h"

#define cellID @"baseCell"

@interface SHYBaseTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style target:(nullable id)target;

@end
