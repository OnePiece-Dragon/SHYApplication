//
//  SHYHistoryDetailController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/27.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYHistoryDetailController.h"
#import "SHYTaskCell.h"
#import "SHYGoodsCell.h"

@interface SHYHistoryDetailController ()

@end

@implementation SHYHistoryDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"运单详情";
    [self handleData];
    //[self setUI];
}
- (void)handleData{
    for (NSDictionary * dic in self.historyModel.category) {
        SHYNuclearCategoryModel * category_model = [SHYNuclearCategoryModel mj_objectWithKeyValues:dic];
        [self.dataArray addObject:category_model];
    }
    [self setUI];
    //[self.checkGoodsDetailView reloadData];
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
    [label3 setIcon:@"dizhi" size:CGSizeMake(24, 28)];
    
    label1.titleLabel.text = model.lineName;
    label2.titleLabel.text = [NSString stringWithFormat:@"任务单号：%@",model.taskId];
    label3.titleLabel.text = [NSString stringWithFormat:@"地址：%@",model.targetAddr];
    label4.titleLabel.text = [NSString stringWithFormat:@"取件任务数：%@",@"15个"];
    label5.titleLabel.text = [NSString stringWithFormat:@"商户数量：%@",@"15个"];
    label6.titleLabel.text = [NSString stringWithFormat:@"共计：%@",@"12312312421wdawdwadw"];
}
#pragma mark -tableViewDataSource-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}
#pragma mark -tableViewDelegate-
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SHYTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [SHYTaskCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID labelCount:7 enterBtnIndex:0 bottomBtn:YES];
        }
        [cell.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(cell);
        }];
        
        [self setContentView:cell model:self.historyModel];
        
        return cell;
    }else {
        return [self goodsCategoryAndAll:NO tableView:tableView indexPath:indexPath];
    }
}
- (UITableViewCell*)goodsCategoryAndAll:(BOOL)isAll
                              tableView:(UITableView*)tableView
                              indexPath:(NSIndexPath *)indexPath {
    if (isAll) {
        return nil;
    }else {
        SHYNuclearCategoryModel * model = self.dataArray[indexPath.row];
        NSInteger goodsCount = model.goods.count;
        //货物种类
        SHYGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"SHYGoodsCell_CAT:%ld",goodsCount]];
        if (!cell) {
            cell = [SHYGoodsCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHYGoodsCell_CAT" isAll:NO lineCount:goodsCount];
        }
        [cell addTopView];
        
        
        int i = 0;
        for (SHYTwoSideLabel * label in cell.rowArray) {
            label.rightLabel.textAlignment = NSTextAlignmentRight;
            if (i == 0) {
                [label setLeftStr:[NSString stringWithFormat:@"%@（%@）",model.categoryName,model.goodsTotal]
                         rightStr:nil rightIcon:@"xialazhanshi"];
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
    if (indexPath.section == 0) {
        return 270;
    }
    SHYNuclearCategoryModel * model = self.dataArray[indexPath.row];
    return (model.goods.count+1)*50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 120;
    }
    return 0.1f;
}
- (SHYBaseTableView *)checkGoodsDetailView {
    if (!_checkGoodsDetailView) {
        _checkGoodsDetailView = [SHYBaseTableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped target:self];
        _checkGoodsDetailView.backgroundColor = BACKGROUND_COLOR;
    }
    return _checkGoodsDetailView;
}
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
