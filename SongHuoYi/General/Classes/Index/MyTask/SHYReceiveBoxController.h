//
//  SHYReceiveBoxController.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseController.h"
#import "SHYReceiveBoxView.h"
#import "SHYNuclearCategoryModel.h"
/**
 收箱
 */
@interface SHYReceiveBoxController : SHYBaseController

@property (nonatomic, strong) NSNumber * taskId;
@property (nonatomic, strong) NSNumber * lineId;
@property (nonatomic, strong) NSNumber * senderId;

@property (nonatomic, strong) SHYNuclearCategoryModel * nuclearModel;

@property (nonatomic, copy) void (^responseBlock)();

@end
