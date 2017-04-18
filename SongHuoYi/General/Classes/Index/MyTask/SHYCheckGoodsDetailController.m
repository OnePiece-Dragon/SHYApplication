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
}

@property (nonatomic, strong) UIPasteboard * pasteBoard;

@end

@implementation SHYCheckGoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    kWeakSelf(self);
    self.naviTitle = @"核货详情";
    [self setRightItem:@"daohang" rightBlock:^{
        [weakself mapGuide];
    }];
    //核货详情
    [self requestNuclearDetailData];
    //核货详情类别
    [self requestNuclearCategoryData];
    [self setUI];
}

- (void)mapGuide {
    if (!self.goodsDetailModel.longitude) {
        return;
    }
    
    SHYMapNaviController * VC = [SHYMapNaviController.alloc init];
    VC.model = self.goodsDetailModel;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)goodsList {
    SHYReceiveBoxController * VC = [SHYReceiveBoxController.alloc init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)sendGoodsBtnClick {
    DLog(@"一键核货");
}

- (void)requestNuclearDetailData {
    [self showNetTips:nil];
    [NetManager post:URL_TASK_NUCLEAR_LIST
               param:@{@"userId":USER_ID,
                       @"taskCode":self.taskCode,
                       @"lineCode":self.lineCode}
            progress:^(NSProgress * _Nonnull progress) {}
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 [self hideNetTips];
                 [self handleResponseObj:responseObject nulClearDetail:YES];
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [self hideNetTips];
                 [self showToast:NET_ERROR_TIP];
                 
                 [self handleResponseObj:nil nulClearDetail:YES];
             }];
}

- (void)requestNuclearCategoryData {
    [self showNetTips:nil];
    [NetManager post:URL_TASK_NUCLEAR_CATEGORY
               param:@{@"userId":USER_ID,
                       @"taskCode":self.taskCode,
                       @"lineCode":self.lineCode,
                       @"page":@(_page)}
            progress:^(NSProgress * _Nonnull progress) {}
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 [self hideNetTips];
                 [self handleResponseObj:responseObject nulClearDetail:NO];
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [self hideNetTips];
                 [self showToast:NET_ERROR_TIP];
                 
                 
                 [self handleResponseObj:nil nulClearDetail:NO];
             }];
}

- (void)handleResponseObj:(NSDictionary*)responseObj nulClearDetail:(BOOL)detail{
    if (detail) {
        NSString *plistPath = PLIST_Name(@"nuclear");
        NSDictionary * result = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        SHYCheckGoodsDetailModel * model = [SHYCheckGoodsDetailModel mj_objectWithKeyValues:result[@"data"]];
        _goodsDetailModel = model;
    }else {
        //nuclear_category
        NSString *category_plistPath = PLIST_Name(@"nuclear_category");
        NSDictionary * category_result = [NSDictionary dictionaryWithContentsOfFile:category_plistPath];
        for (NSDictionary * dic in category_result[@"data"][@"rows"]) {
            SHYNuclearCategoryModel * category_model = [SHYNuclearCategoryModel mj_objectWithKeyValues:dic];
            [self.dataArray addObject:category_model];
        }
    }
    [self.checkGoodsDetailView reloadData];
}

- (void)setUI {
    kWeakSelf(self);
    [self.view addSubview:self.checkGoodsDetailView];
    [self.checkGoodsDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakself.view);
    }];
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
    SHYIconLabel*label7 = view.labelArray[6];
    
    [label2 setIcon:@"renwudan" size:CGSizeMake(24, 24)];
    [label3 setIcon:@"dizhi" size:CGSizeMake(24, 28)];
    
    label1.titleLabel.text = model.lineName;
    label2.titleLabel.text = [NSString stringWithFormat:@"任务单号：%@",model.tasksId];
    label3.titleLabel.text = [NSString stringWithFormat:@"地址：%@",model.startAddr];
    label4.titleLabel.text = [NSString stringWithFormat:@"姓名：%@",model.senderName];
    label5.titleLabel.text = [NSString stringWithFormat:@"电话：%@",model.senderPhone];
    label6.titleLabel.text = [NSString stringWithFormat:@"地址：%@",model.senderAddr];
    if ([model.collectMoney floatValue] == 0) {
        //
        [label6 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view.backView.mas_bottom);
        }];
    }else {
        label7.titleLabel.text = [NSString stringWithFormat:@"代收款：%@",model.collectMoney];
        [label7 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view.backView.mas_bottom);
        }];
    }
    
    //字体颜色
    [label5.titleLabel setAttributedText:[Factory setText:label5.titleLabel.text
                                                attribute:@{NSForegroundColorAttributeName:[UIColor greenColor]}
                                                    range:NSMakeRange(3, label5.titleLabel.text.length - 3)]];
    [label6.titleLabel setAttributedText:[Factory setText:label6.titleLabel.text
                                                attribute:@{NSForegroundColorAttributeName:[UIColor greenColor]}
                                                    range:NSMakeRange(3, label6.titleLabel.text.length - 3)]];
    [label7.titleLabel setAttributedText:[Factory setText:label7.titleLabel.text
                                                attribute:@{NSForegroundColorAttributeName:[UIColor orangeColor]}
                                                    range:NSMakeRange(4, label7.titleLabel.text.length - 4)]];
    
    [label6.titleLabel attachTapGesture];
}

#pragma mark -tableViewDataSource-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger section = 0;
    if (self.goodsDetailModel) {
        section +=2;
    }
    if (self.dataArray.count) {
        section ++;
    }
    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.goodsDetailModel) {
        if (section == 2) {
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
                cell = [SHYTaskCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID labelCount:7];
            }
            [cell.backView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(cell);
            }];
            
            [self setContentView:cell model:_goodsDetailModel];
            
            return cell;
        }else if (indexPath.section == 1) {
            return [self goodsCategoryAndAll:YES tableView:tableView indexPath:indexPath];
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
        [label3 setLeftStr:@"" rightStr:@"箱数：0/15" rightIcon:nil];
        [label3 setTopLineHiden:YES bottomHiden:YES];
        
        [label2 addBaseTapClickAction];
        label2.clickBlock = ^(){
            [weakself goodsList];
        };
        
        return cell;
    }else {
        SHYNuclearCategoryModel * model = self.dataArray[indexPath.row];
        //货物种类
        SHYGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"SHYGoodsCell_CAT:%ld",model.goods.count+1]];
        if (!cell) {
            cell = [SHYGoodsCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHYGoodsCell_CAT" isAll:NO lineCount:model.goods.count+1];
        }
        [cell addTopView];
        
        int i = 0;
        for (SHYTwoSideLabel * label in cell.rowArray) {
            if (i == 0) {
                [label setLeftStr:[NSString stringWithFormat:@"%@（%@）",model.wayCategoryName,model.goodsTotal]
                         rightStr:nil rightIcon:@"xialazhanshi"];
            }else {
                [label setLeftStr:[(SHYGoodsModel*)model.goods[i-1] goodsName]
                         rightStr:[NSString stringWithFormat:@"箱数：0/%@",[(SHYGoodsModel*)model.goods[i-1] goodsNum]] rightIcon:nil];
            }
            if (i++ == cell.rowArray.count - 1) {
                [label setTopLineHiden:YES bottomHiden:YES];
            }
        }
        return cell;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView * footerView = [UIView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
        UIButton * startSendGoods = [Factory createBtn:CGRectMake(40, 20, SCREEN_WIDTH - 80, 44) title:@"一键核货" type:UIButtonTypeCustom target:self action:@selector(sendGoodsBtnClick)];
        startSendGoods.layer.cornerRadius = 8.f;
        startSendGoods.backgroundColor = BUTTON_COLOR;
        [footerView addSubview:startSendGoods];
        return footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 270;
    }else if(indexPath.section == 1){
        return 150.f;
    }
    return 160.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 0.1f;
    }
    return 8.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 120;
    }
    return 0.1f;
}

- (SHYBaseTableView *)checkGoodsDetailView {
    if (!_checkGoodsDetailView) {
        _checkGoodsDetailView = [SHYBaseTableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped target:self];
        _checkGoodsDetailView.backgroundColor = LINE_COLOR;
    }
    return _checkGoodsDetailView;
}
- (SHYTaskCell *)headerDetailView {
    if (!_headerDetailView) {
        _headerDetailView = [SHYTaskCell.alloc initWithFrame:CGRectZero labelCount:7];
    }
    return _headerDetailView;
}
- (NSMutableArray<SHYNuclearCategoryModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSString *)taskCode {
    if (!_taskCode) {
        _taskCode = @"";
    }
    return _taskCode;
}
- (NSString *)lineCode {
    if (!_lineCode) {
        _lineCode = @"";
    }
    return _lineCode;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
