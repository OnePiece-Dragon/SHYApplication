//
//  SHYCheckGoodsDetailController.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseController.h"
#import "SHYTaskCell.h"
#import "SHYGoodsCell.h"
#import "SHYCheckGoodsDetailModel.h"
#import "SHYNuclearCategoryModel.h"


#import "SHYMapNaviController.h"
/**
 核货详情
 */
@interface SHYCheckGoodsDetailController : SHYBaseController

/**
 任务编号
 */
@property (nonatomic, strong) NSNumber * taskId;
/**
 线路编号
 */
@property (nonatomic, strong) NSNumber * lineId;

@property (nonatomic, strong) SHYTaskCell * headerDetailView;
@property (nonatomic, strong) SHYCheckGoodsDetailModel * goodsDetailModel;

@property (nonatomic, strong) SHYBaseTableView * checkGoodsDetailView;
@property (nonatomic, strong) NSMutableArray<SHYNuclearCategoryModel*> * dataArray;

@property (nonatomic, copy) void (^backBlock)();

@end
