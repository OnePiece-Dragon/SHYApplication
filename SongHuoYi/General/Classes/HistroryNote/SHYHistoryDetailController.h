//
//  SHYHistoryDetailController.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/27.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseController.h"
#import "SHYTaskHistoryModel.h"
#import "SHYNuclearCategoryModel.h"

@interface SHYHistoryDetailController : SHYBaseController

@property (nonatomic, strong) NSNumber * taskId;
@property (nonatomic, strong) NSNumber * lineId;

@property (nonatomic, strong) NSNumber * shopId;
@property (nonatomic, strong) NSString * taskCode;


@property (nonatomic, strong) SHYBaseTableView * checkGoodsDetailView;


@property (nonatomic, strong) SHYTaskHistoryModel * historyModel;
@property (nonatomic, strong) NSMutableArray<SHYNuclearCategoryModel*> * dataArray;


@end
