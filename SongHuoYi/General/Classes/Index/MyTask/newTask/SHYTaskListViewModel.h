//
//  SHYTaskListViewModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/5/2.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYTaskViewModel.h"

@interface SHYTaskListViewModel : SHYTaskViewModel<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SHYBaseTableView * taskListView;
@property (nonatomic, strong) NSMutableArray * taskListArray;


@property (nonatomic, assign) NSInteger page;

- (void)fetchResponse;
- (void)resetDataWithRequest;

@end
