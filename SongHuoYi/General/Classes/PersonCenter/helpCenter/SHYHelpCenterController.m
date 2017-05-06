//
//  SHYHelpCenterController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/26.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYHelpCenterController.h"

#import "SHYHelpCenterModel.h"
#import "SHYHelpCenterCell.h"

#define cellReuseId @"helpCenterCell"

@interface SHYHelpCenterController ()

{
    NSInteger _page;
}

@property (nonatomic, strong) SHYBaseTableView * tableView;
@property (nonatomic, strong) NSMutableArray   * dataArray;

@end

@implementation SHYHelpCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"帮助中心";
    _page = 1;
    kWeakSelf(self);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(weakself.view);
    }];
    [self requestData];
}

- (void)loadRefreshData:(id)view{
    [super loadRefreshData:view];
    _page = 1;
    [self requestData];
}
- (void)loadMoreData:(id)view{
    [super loadMoreData:view];
    if (_page<_allPage) {
        _page ++;
        [self requestData];
    }else{
        [self.tableView noMoreData];
    }
}

- (void)requestData {
    [self showNetTips:LOADING_TIPS];
    [NetManager post:URL_HELPER_CENTER
               param:@{@"userId":USER_ID,
                       @"page":@(_page)}
             success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                 [self hideNetTips];
                 if (code) {
                     if (responseObj[@"pages"]) {
                         _allPage = [responseObj[@"pages"] integerValue];
                     }
                     
                     if (!self.loadMore) {
                         [self.dataArray removeAllObjects];
                     }
                     NSArray * sourceArray = [SHYHelpCenterModel mj_objectArrayWithKeyValuesArray:responseObj[@"rows"]];
                     [self.dataArray addObjectsFromArray:sourceArray];
                     [self.tableView reloadData];
                 }else {
                     if (_page>1) {
                         _page--;
                     }
                     [self showToast:failMessag];
                 }
             } failure:^(NSString * _Nonnull errorStr) {
                 if (_page>1) {
                     _page--;
                 }
                 [self hideNetTips];
                 [self showToast:errorStr];
             }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHYHelpCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
    
    SHYHelpCenterModel * model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.proTitle;
    cell.infoLabel.text = model.proInfo;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (SHYBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [SHYBaseTableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped target:self];
        [_tableView registerClass:[SHYHelpCenterCell class] forCellReuseIdentifier:cellReuseId];
        [_tableView addRefreshHeader:self action:@selector(loadRefreshData:)];
        [_tableView addRefreshFooter:self action:@selector(loadMoreData:)];
    }
    return _tableView;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
