//
//  SHYTaskListViewModel.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/5/2.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYTaskListViewModel.h"

#define taskCellReuseId @"taskListViewCell"

@interface SHYTaskListViewModel()

{
    NSInteger _allPage;
}

@end

@implementation SHYTaskListViewModel

- (void)initialize {
    [super initialize];
    _allPage    = 1;
    _page       = 1;
    
}

- (void)fetchResponse {
    if (_page>_allPage) {
        _page--;
        return;
    }
    [self.requestBody requestWithMethod:URL_TASK_LIST
                                  param:@{@"userId":USER_ID,@"page":@(_page)} observer:self];
}
- (void)resetDataWithRequest {
    _page = 1;
    [self.taskListArray removeAllObjects];
    [self fetchResponse];
}
- (void)fetchResponse:(id)responseObj code:(BOOL)code fail:(NSString *)fail {
    [super fetchResponse:responseObj code:code fail:fail];
    if (code) {
        //success
        if (responseObj[@"pages"]) {
            _allPage = [responseObj[@"pages"] integerValue];
        }
        [self handleResponseMessage:self.successResult];
        [self.responseSignal sendNext:@YES];
    }else {
        [self.responseSignal sendNext:@NO];
    }
}
- (void)handleResponseMessage:(NSDictionary*)responseObject {
    DLog(@"responseObject:%@",responseObject);
    
    for (NSDictionary * dic in responseObject[@"rows"]) {
        SHYTaskModel * model = [SHYTaskModel mj_objectWithKeyValues:dic];
        [self.taskListArray addObject:model];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskListArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHYTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:taskCellReuseId];
    if (!cell) {
        cell = [SHYTaskCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:taskCellReuseId labelCount:6];
    }
    SHYTaskModel * taskModel = [self.taskListArray objectAtIndex:indexPath.row];
    [self setContentView:cell model:taskModel];
    
    kWeakSelf(self);
    cell.startBtnClickBlock = ^(SHYTaskModel*model){
        [weakself.startBtnSignal sendNext:model];
    };
    cell.enterBtnClickBlock = ^(SHYTaskModel*model){
        [weakself.enterBtnSignal sendNext:model];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 270.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 4.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [UIView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 4)];
    view.backgroundColor = BACKGROUND_COLOR;
    return view;
}



- (SHYBaseTableView *)taskListView {
    if (!_taskListView) {
        _taskListView = [SHYBaseTableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped target:self];
        _taskListView.backgroundColor = BACKGROUND_COLOR;
        //[_taskListView registerClass:[SHYTaskCell class] forCellReuseIdentifier:taskCellReuseId];
        _taskListView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self.target refreshingAction:@selector(loadMoreData:)];
        _taskListView.emptyRequestAgainBlock = ^(){
            
        };
    }
    return _taskListView;
}

@end
