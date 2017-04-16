//
//  SHYBaseCell.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"
#import "SHYBaseModel.h"

@interface SHYBaseCell : UITableViewCell

@property (nonatomic, strong) SHYBaseModel *model;

@property (nonatomic, copy) void (^tapActionBlock)(id);

- (void)setCellModel:(SHYBaseModel*)model;
- (void)tapAction;

@end
