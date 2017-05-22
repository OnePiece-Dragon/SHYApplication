//
//  SHYCheckGoodsDetailController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYCheckGoodsDetailController.h"
#import "SHYReceiveBoxController.h"

@interface SHYCheckGoodsDetailController ()

{
    NSInteger _page;
    
    BOOL _haveChanged;
}
@property (nonatomic, strong) UIButton * startSendGoods;
@property (nonatomic, strong) UIPasteboard * pasteBoard;

@property (nonatomic, strong, nonnull) UIView * goodsHeaderView;

@end

@implementation SHYCheckGoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    _haveChanged = NO;
    kWeakSelf(self);
    self.naviTitle = @"核货详情";
    NOTICENTER_Register(self,@selector(checkBoxChangeDone), Noti_CheckBox);
    [self setRightItem:@"daohang" rightBlock:^{
        [weakself mapGuide];
    }];
    self.leftBar=^(){
        [weakself leftBarAction];
    };
    
    //核货详情类别
    [self setUI];
    //核货详情
    [self showNetTips:LOADING_TIPS];
    [self requestNuclearDetailData];
}

- (void)leftBarAction {
    if (_haveChanged) {
        if (self.backBlock) {
            self.backBlock();
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mapGuide {
    if (!self.goodsDetailModel.longitude) {
        return;
    }
    
    SHYMapNaviController * VC = [SHYMapNaviController.alloc init];
    VC.model = self.goodsDetailModel;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)goodsList:(BOOL)isAll model:(SHYNuclearCategoryModel*)model {
//    if (!_canCheckBtnClick) {
//        return;
//    }
    
    SHYReceiveBoxController * VC = [SHYReceiveBoxController.alloc init];
    VC.taskId = self.taskId;
    VC.lineId = self.lineId;
    VC.senderId = self.goodsDetailModel.senderId;
    VC.nuclearModel = model;
    
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)checkBoxChangeDone {
    _haveChanged = YES;
    
    _page = 1;
    [self.dataArray removeAllObjects];
    [self requestNuclearCategoryData];
}

- (void)sendGoodsBtnClick {
    DLog(@"一键核货");
    [self showAlertVCWithTitle:nil info:CHECK_BOX_ONCE_TIP CancelTitle:@"取消" okTitle:@"确定" cancelBlock:nil okBlock:^{
        [self onceAllGoodsCheck];
    }];
}

- (void)loadMoreData:(id)view {
    [super loadMoreData:view];
    if (_page<_allPage) {
        _page++;
        [self requestNuclearCategoryData];
    }else {
        [self.checkGoodsDetailView noMoreData];
    }
}

- (void)onceAllGoodsCheck {
    [self showNetTips:LOADING_DISPOSE];
    [NetManager post:URL_TASK_ONCENUCLEAR_UPDATE
               param:@{@"userId":USER_ID,
                       @"taskId":self.taskId,
                       @"lineId":self.lineId,
                       @"categoryId":@""}
             success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                 if (code) {
                     [self hideNetTips];
                     DLog(@"responseObj核对:%@",responseObj);
                     
                     [self showToast:@"核货成功"];
                     
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         _haveChanged = YES;
                         [self leftBarAction];
                     });
                     
                 }else {
                     [self showToast:failMessag];
                 }
             } failure:^(NSString * _Nonnull errorStr) {
                 [self hideNetTips];
                 [self showToast:errorStr];
             }];
}

- (void)requestNuclearDetailData {
    [NetManager post:URL_TASK_NUCLEAR_LIST
               param:@{@"userId":USER_ID,
                       @"taskId":self.taskId,
                       @"lineId":self.lineId}
             success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                 if (code == YES) {
                     [self handleResponseObj:responseObj nulClearDetail:YES];
                     //请求分类
                     [self requestNuclearCategoryData];
                     
                 }else {
                     [self hideNetTips];
                     [self showToast:failMessag];
                 }
             } failure:^(NSString * _Nonnull errorStr) {
                 [self hideNetTips];
                 [self showToast:errorStr];
             }];
}

- (void)requestNuclearCategoryData {
    [NetManager post:URL_TASK_NUCLEAR_CATEGORY
               param:@{@"userId":USER_ID,
                       @"taskId":self.taskId,
                       @"lineId":self.lineId,
                       @"page":@(_page)}
             success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                 [self.checkGoodsDetailView endRefresh];
                 [self hideNetTips];
                 if (code) {
                     if (responseObj[@"pages"]) {
                         _allPage = [responseObj[@"pages"] integerValue];
                     }
                     [self handleResponseObj:responseObj nulClearDetail:NO];
                     [self.checkGoodsDetailView reloadData];
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

- (void)handleResponseObj:(NSDictionary*)responseObj nulClearDetail:(BOOL)detail{
    if (detail) {
        DLog(@"responseObj_detail:%@",responseObj);
        //NSString *plistPath = PLIST_Name(@"nuclear");
        //NSDictionary * result = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        SHYCheckGoodsDetailModel * model = [SHYCheckGoodsDetailModel mj_objectWithKeyValues:responseObj];
        _goodsDetailModel = model;
    }else {
        DLog(@"responseObj_category:%@",responseObj);
        self.startSendGoods.hidden = NO;
        //nuclear_category
        //NSString *category_plistPath = PLIST_Name(@"nuclear_category");
        //NSDictionary * category_result = [NSDictionary dictionaryWithContentsOfFile:category_plistPath];
        for (NSDictionary * dic in responseObj[@"rows"]) {
            SHYNuclearCategoryModel * category_model = [SHYNuclearCategoryModel mj_objectWithKeyValues:dic];
            [self.dataArray addObject:category_model];
        }
    }
}

- (void)setUI {
    kWeakSelf(self);
    [self.view addSubview:self.checkGoodsDetailView];
    [self.view addSubview:self.startSendGoods];
    [self.checkGoodsDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakself.view);
        make.bottom.equalTo(weakself.view).offset(-(52+20));
    }];
    
    self.startSendGoods.hidden = YES;
    if (_canCheckBtnClick == YES) {
        self.startSendGoods.enabled = YES;
        [self.startSendGoods setTitle:@"一键核货" forState:UIControlStateNormal];
    }else {
        self.startSendGoods.enabled = NO;
        [self.startSendGoods setTitle:@"已核货" forState:UIControlStateDisabled];
    }
}

- (void)setContentView:(SHYTaskCell*)view model:(SHYCheckGoodsDetailModel*)model {
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
    
    //字体颜色
    [label3.titleLabel setAttributedText:[Factory setText:label3.titleLabel.text
                                                attribute:@{NSForegroundColorAttributeName:COLOR_PRICE}
                                                    range:NSMakeRange(4, label3.titleLabel.text.length - 4)]];
    [label5.titleLabel setAttributedText:[Factory setText:label5.titleLabel.text
                                                attribute:@{NSForegroundColorAttributeName:COLOR_ADRESS}
                                                    range:NSMakeRange(3, label5.titleLabel.text.length - 3)]];
    [label6.titleLabel setAttributedText:[Factory setText:label6.titleLabel.text
                                                attribute:@{NSForegroundColorAttributeName:COLOR_ADRESS}
                                                    range:NSMakeRange(3, label6.titleLabel.text.length - 3)]];
    
    
    [label6.titleLabel attachTapGesture];
}

#pragma mark -tableViewDataSource-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger section = 0;
    if (self.goodsDetailModel) {
        section ++;
    }
    if (self.dataArray.count) {
        section ++;
    }
    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.goodsDetailModel) {
        if (section == 1) {
            return self.dataArray.count;
        }
        return 1;
    }
    return self.dataArray.count;
}

#pragma mark -tableViewDelegate-
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.goodsDetailModel) {
        if (indexPath.section == 0) {
            SHYTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [SHYTaskCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID labelCount:6 enterBtnIndex:0 bottomBtn:YES];
            }
            [cell.backView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(cell);
            }];
            
            [self setContentView:cell model:_goodsDetailModel];
            
            return cell;
        }else {
            return [self goodsCategoryAndAll:NO tableView:tableView indexPath:indexPath];
        }
    }else {
        return [self goodsCategoryAndAll:NO tableView:tableView indexPath:indexPath];
    }
}

- (UITableViewCell*)goodsCategoryAndAll:(BOOL)isAll
                              tableView:(UITableView*)tableView
                              indexPath:(NSIndexPath *)indexPath {
    kWeakSelf(self);
    if (isAll) {
        //货物清单  SHYGoodsCell
        SHYGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SHYGoodsCell"];
        if (!cell) {
            cell = [SHYGoodsCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHYGoodsCell" isAll:YES lineCount:3];
        }
        
        SHYTwoSideLabel * label1 = cell.rowArray[0];
        SHYTwoSideLabel * label2 = cell.rowArray[1];
        SHYTwoSideLabel * label3 = cell.rowArray[2];
        
        [label1 setLeftStr:@"货物清单" rightStr:nil rightIcon:nil];
        [label2 setLeftStr:[NSString stringWithFormat:@"箱数：（%@）",self.goodsDetailModel.taskDetail] rightStr:nil rightIcon:@"xialazhanshi"];
        [label3 setLeftStr:@"" rightStr:@"箱数：" rightIcon:nil];
        [label3 setTopLineHiden:YES bottomHiden:YES];
        
        [label2 addBaseTapClickAction];
        label2.clickBlock = ^(){
            [weakself goodsList:YES model:nil];
        };
        
        return cell;
    }else {
        SHYNuclearCategoryModel * model = self.dataArray[indexPath.row];
        NSInteger goodsCount = 3;
        if (model.goods.count<2) {
            goodsCount = 2;
        }
        //货物种类
        SHYGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"SHYGoodsCell_CAT:%ld",(long)goodsCount]];
        if (!cell) {
            cell = [SHYGoodsCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"SHYGoodsCell_CAT:%ld",(long)goodsCount] isAll:NO lineCount:goodsCount];
        }
        
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
            
            label.clickBlock = ^(){
                [weakself goodsList:NO model:model];
            };
        }
        return cell;
    }
}

//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (section == 1) {
//        UIView * footerView = [UIView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
//        [footerView addSubview:self.startSendGoods];
//        return footerView;
//    }
//    return nil;
//}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        
        return self.goodsHeaderView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 270;
    }
    SHYNuclearCategoryModel * model = self.dataArray[indexPath.row];
    if (model.goods.count<2) {
        return 2*50;
    }
    return 3*50;
    //return (model.goods.count+1)*50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 46.f;
    }
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

- (SHYBaseTableView *)checkGoodsDetailView {
    if (!_checkGoodsDetailView) {
        _checkGoodsDetailView = [SHYBaseTableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped target:self];
        [_checkGoodsDetailView addRefreshFooter:self action:@selector(loadMoreData:)];
        _checkGoodsDetailView.backgroundColor = BACKGROUND_COLOR;
    }
    return _checkGoodsDetailView;
}
- (SHYTaskCell *)headerDetailView {
    if (!_headerDetailView) {
        _headerDetailView = [SHYTaskCell.alloc initWithFrame:CGRectZero labelCount:7];
    }
    return _headerDetailView;
}
-(UIView *)goodsHeaderView{
    if (!_goodsHeaderView) {
        UIView * view = [UIView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46)];
        UIView * bottomLine = [UIView.alloc initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 1)];
        UILabel * label = [UILabel.alloc initWithFrame:view.bounds];
        label.x = 8;
        label.text = @"货物清单";
        label.backgroundColor = COLOR_WHITE;
        view.backgroundColor = COLOR_WHITE;
        bottomLine.backgroundColor = LINE_COLOR;
        label.font = [UIFont boldSystemFontOfSize:16];
        [view addSubview:label];
        [view addSubview:bottomLine];
        _goodsHeaderView = view;
    }
    return _goodsHeaderView;
}
- (UIButton *)startSendGoods {
    if (!_startSendGoods) {
        UIButton * startSendGoods = [Factory createBtn:CGRectMake(40, SCREEN_HEIGHT -kStatusBarH - kNavigationBarH- 48 - 20, SCREEN_WIDTH - 80, 44) title:@"一键核货" type:UIButtonTypeCustom target:self action:@selector(sendGoodsBtnClick)];
        startSendGoods.layer.cornerRadius = 8.f;
        startSendGoods.clipsToBounds = YES;
        [startSendGoods setTitle:@"已核货" forState:UIControlStateDisabled];
        [startSendGoods setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        [startSendGoods setBackgroundImage:[UIImage imageWithColor:BUTTON_COLOR] forState:UIControlStateNormal];
        _startSendGoods = startSendGoods;
    }
    return _startSendGoods;
}
- (NSMutableArray<SHYNuclearCategoryModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UIPasteboard *)pasteBoard {
    if (!_pasteBoard) {
        _pasteBoard = [UIPasteboard generalPasteboard];
    }
    return _pasteBoard;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    NOTICENTER_Remove(self, Noti_CheckBox);
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
