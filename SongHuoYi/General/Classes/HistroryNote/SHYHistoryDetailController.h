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

@property (nonatomic, strong) SHYTaskHistoryModel * historyModel;

@property (nonatomic, strong) SHYBaseTableView * checkGoodsDetailView;
@property (nonatomic, strong) NSMutableArray<SHYNuclearCategoryModel*> * dataArray;

@end
