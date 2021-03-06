//
//  SHYHistoryDetailController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/27.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYHistoryDetailController.h"
#import "SHYGoodsCell.h"

@interface SHYHistoryDetailController ()

{
    NSInteger _page;
}

@end

@implementation SHYHistoryDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"运单详情";
    _page = 1;
    [self setUI];
    [self showNetTips:LOADING_TIPS];
    [self historyDetailRequest];
}
- (void)loadMoreData:(id)view {
    if (_page<_allPage) {
        _page++;
        [self historyGoodsCategoryRequest];
    }else {
        [self.checkGoodsDetailView noMoreData];
    }
}
- (void)historyDetailRequest{
    [self showNetTips:LOADING_TIPS];
    [NetManager post:URL_TASK_HISTORY_DETAIL
               param:@{@"userId":USER_ID,
                       @"taskId":self.taskId,
                       @"lineId":self.lineId,
                       @"shopId":self.shopId}
             success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                 if (code) {
                     //
                     DLog(@"detail_responseObj:%@",responseObj);
                     self.historyModel = [SHYTaskHistoryModel mj_objectWithKeyValues:responseObj];
                     [self setContentView:self.tableHeaderView model:self.historyModel];
                     self.checkGoodsDetailView.tableHeaderView = self.tableHeaderView;
                     
                     [self historyGoodsCategoryRequest];
                 }else {
                     [self hideNetTips];
                     [self showToast:failMessag];
                 }
             } failure:^(NSString * _Nonnull errorStr) {
                 [self hideNetTips];
                 [self showToast:errorStr];
             }];
}
- (void)historyGoodsCategoryRequest {
    [self showNetTips:LOADING_TIPS];
    [NetManager post:URL_TASK_HISTORY_GOODS_INFO
               param:@{@"shopId":self.shopId,
                       @"taskCode":self.taskCode,
                       @"page":@(_page)}
             success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                 [self.checkGoodsDetailView endRefresh];
                 [self hideNetTips];
                 if (code) {
                     //
                     if (responseObj[@"pages"]) {
                         _allPage = [responseObj[@"pages"] integerValue];
                     }
                     [self handleData:responseObj];
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
                 [self.checkGoodsDetailView endRefresh];
                 [self hideNetTips];
                 [self showToast:errorStr];
             }];
}
- (void)handleData:(NSDictionary*)responseObj{
    DLog(@"detialResponseObj:%@",responseObj);
    if (responseObj[@"pages"]) {
        _allPage = [responseObj[@"pages"] integerValue];
    }
    for (NSDictionary * dic in responseObj[@"rows"]) {
        SHYNuclearCategoryModel * category_model = [SHYNuclearCategoryModel mj_objectWithKeyValues:dic];
        [self.dataArray addObject:category_model];
    }
    [self.checkGoodsDetailView reloadData];
}
- (void)setUI {
    kWeakSelf(self);
    [self.view addSubview:self.checkGoodsDetailView];
    [self.checkGoodsDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakself.view);
        make.bottom.equalTo(weakself.view);
    }];
}

- (void)setContentView:(SHYTaskCell*)view model:(SHYTaskHistoryModel*)model {
    [view setCellModel:model];
    view.enterBtn.hidden = YES;
    [view.startBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@0);
    }];
    
    SHYIconLabel*label1 = view.labelArray[0];
    SHYIconLabel*label2 = view.labelArray[1];
    SHYIconLabel*label3 = view.labelArray[2];
    SHYIconLabel*label4 = view.labelArray[3];
    SHYIconLabel*label5 = view.labelArray[4];
    SHYIconLabel*label6 = view.labelArray[5];
    
    [label2 setIcon:@"renwudan" size:CGSizeMake(24, 24)];
    [label3 setIcon:@"daishoukuan" size:CGSizeMake(24, 24)];
    [label4 setIcon:@"xingming" size:CGSizeMake(24, 24)];
    [label5 setIcon:@"calldianhua" size:CGSizeMake(24, 24)];
    [label6 setIcon:@"dizhi" size:CGSizeMake(24, 28)];
    
    
    label1.titleLabel.text = model.lineName;
    label2.titleLabel.text = [NSString stringWithFormat:@"任务单号：%@",model.taskId];
    label3.titleLabel.text = [NSString stringWithFormat:@"代收款：%.2f元",model.collectMoney.floatValue];
    label4.titleLabel.text = [NSString stringWithFormat:@"姓名：%@",model.senderName];
    label5.titleLabel.text = [NSString stringWithFormat:@"手机：%@",model.senderPhone];
    label6.titleLabel.text = [NSString stringWithFormat:@"地址：%@",model.senderAddr];
    
    [label3.titleLabel setAttributedText:[Factory setText:label3.titleLabel.text
                                                attribute:@{NSForegroundColorAttributeName:COLOR_PRICE}
                                                    range:NSMakeRange(3, label3.titleLabel.text.length - 3)]];
}
#pragma mark -tableViewDataSource-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
#pragma mark -tableViewDelegate-
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self goodsCategoryAndAll:NO tableView:tableView indexPath:indexPath];
}
- (UITableViewCell*)goodsCategoryAndAll:(BOOL)isAll
                              tableView:(UITableView*)tableView
                              indexPath:(NSIndexPath *)indexPath {
    if (isAll) {
        return nil;
    }else {
        SHYNuclearCategoryModel * model = self.dataArray[indexPath.row];
        NSInteger goodsCount = model.goods.count+1;
        //货物种类
        SHYGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"SHYGoodsCell_CAT:%ld",goodsCount]];
        if (!cell) {
            cell = [SHYGoodsCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"SHYGoodsCell_CAT:%ld",goodsCount] isAll:NO lineCount:goodsCount];
        }
        [cell addTopView];
        
        
        int i = 0;
        for (SHYTwoSideLabel * label in cell.rowArray) {
            label.rightLabel.textAlignment = NSTextAlignmentRight;
            if (i == 0) {
                [label setLeftStr:[NSString stringWithFormat:@"%@（%@）",model.categoryName,model.goodsTotal]
                         rightStr:nil rightIcon:nil];
            }else {
                [label setLeftStr:[(SHYGoodsModel*)model.goods[i-1] goodsName]
                         rightStr:[NSString stringWithFormat:@"%@：",
                                   [(SHYGoodsModel*)model.goods[i-1] unit]] rightIcon:nil];
                [label updateRightTipsLabel];
                SHYGoodsModel * itemModel = (SHYGoodsModel*)model.goods[i-1];
                label.rightTipsLabel.text = [NSString stringWithFormat:@"%@/%@",itemModel.actualNum,itemModel.buyNum];
            }
            if (i++ == cell.rowArray.count - 1) {
                [label setTopLineHiden:YES bottomHiden:YES];
            }
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHYNuclearCategoryModel * model = self.dataArray[indexPath.row];
    return (model.goods.count+1)*50;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 270.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}
- (SHYBaseTableView *)checkGoodsDetailView {
    if (!_checkGoodsDetailView) {
        _checkGoodsDetailView = [SHYBaseTableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped target:self];
        _checkGoodsDetailView.backgroundColor = BACKGROUND_COLOR;
        [_checkGoodsDetailView addRefreshFooter:self action:@selector(loadMoreData:)];
    }
    return _checkGoodsDetailView;
}
- (SHYTaskCell *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [SHYTaskCell.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270) labelCount:6 enterBtnIndex:0 bottomBtn:YES];
        [_tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(SCREEN_WIDTH));
            make.height.mas_greaterThanOrEqualTo(@100);
        }];
        
        [_tableHeaderView.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_tableHeaderView);
        }];
    }
    return _tableHeaderView;
}
//- (SHYTaskHistoryModel *)historyModel{
//    if (!_historyModel) {
//        _historyModel = [SHYTaskHistoryModel.alloc init];
//    }
//    return _historyModel;
//}
- (NSMutableArray<SHYNuclearCategoryModel *> *)dataArray {
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
