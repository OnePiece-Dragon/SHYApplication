//
//  SHYTransportDetailController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/8.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYTransportDetailController.h"
#import "SHYMapNaviController.h"

@interface SHYTransportDetailController ()

@property (nonatomic, strong) UIPasteboard * pasteBoard;
@property (nonatomic, strong) UIView * goodsHeaderView;

@end

@implementation SHYTransportDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    kWeakSelf(self);
    
    self.naviTitle = @"配送详情";
    [self setRightItem:@"daohang" rightBlock:^{
        [weakself mapGuide];
    }];
    [self requestData];
    [self setUI];
}

- (void)mapGuide {
    SHYMapNaviController * VC = [SHYMapNaviController.alloc init];
    VC.deliverModel = self.deliveryDetailModel;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)sendGoodsBtnClick {
    DLog(@"开始配送");
}

- (void)requestData {
    for (SHYGoodsModel * goodsModel in _deliveryDetailModel.goods) {
        [self.dataArray addObject:goodsModel];
    }
    [self.deliveryDetailView reloadData];
}

- (void)setUI {
    kWeakSelf(self);
    [self.view addSubview:self.deliveryDetailView];
    [self.deliveryDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakself.view);
    }];
}

- (void)setContentView:(SHYTaskCell*)view model:(SHYDeliveryModel*)model {
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
    [label5 setIcon:@"dianhua" size:CGSizeMake(24, 24)];
    [label6 setIcon:@"dizhi" size:CGSizeMake(24, 28)];
    
    label1.titleLabel.text = model.shopName;
    label2.titleLabel.text = [NSString stringWithFormat:@"订单号：%@",model.orderId];
    label3.titleLabel.text = [NSString stringWithFormat:@"代收：%.2f元",model.collectMoney.floatValue/100.0];
    label4.titleLabel.text = [NSString stringWithFormat:@"收货方：%@",model.shopName];
    label5.titleLabel.text = [NSString stringWithFormat:@"电话：%@",model.shopPhone];
    label6.titleLabel.text = [NSString stringWithFormat:@"地址：%@",model.targetAddr];
    if ([model.collectMoney floatValue] == 0) {
        //
        [label6 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view.backView.mas_bottom);
        }];
    }
    
    //字体颜色
    [label3.titleLabel setAttributedText:[Factory setText:label3.titleLabel.text
                                                attribute:@{NSForegroundColorAttributeName:COLOR_PRICE}
                                                    range:NSMakeRange(3, label3.titleLabel.text.length - 3)]];
    [label5.titleLabel setAttributedText:[Factory setText:label5.titleLabel.text
                                                attribute:@{NSForegroundColorAttributeName:COLOR_ADRESS}
                                                    range:NSMakeRange(3, label5.titleLabel.text.length - 3)]];
    [label6.titleLabel setAttributedText:[Factory setText:label6.titleLabel.text
                                                attribute:@{NSForegroundColorAttributeName:COLOR_ADRESS}
                                                    range:NSMakeRange(3, label6.titleLabel.text.length - 3)]];
    
    
    [label6.titleLabel attachTapGesture];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        SHYTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [SHYTaskCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID labelCount:6];
        }
        [cell.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(cell);
        }];
        
        if (_deliveryDetailModel) {
            [self setContentView:cell model:_deliveryDetailModel];
        }
        return cell;
    }else if(indexPath.section == 1){
        SHYGoodsDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SHYGoodsDetailCell"];
        if (!cell) {
            cell = [SHYGoodsDetailCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHYGoodsDetailCell"];
        }
        
        if (indexPath.row == 0) {
            [cell setTopLineHiden:NO bottomLineHiden:NO];
        }
        SHYGoodsModel * model = self.dataArray[indexPath.row];
        [cell setLeftTopStr:model.goodsName
              leftBottomStr:[NSString stringWithFormat:@"单价：%.2f元",model.price.floatValue/100.f]
                rightTopStr:[NSString stringWithFormat:@"实际配送:%@(%@)",model.actualNum,model.unit]
             rightBottomStr:[NSString stringWithFormat:@"总价：%.2f元",model.price.floatValue*model.actualNum.floatValue/100.f]];
        
        return cell;
    }
    return nil;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.goodsHeaderView;
    }
    return nil;
}
/*
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView * footerView = [UIView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
        UIButton * startSendGoods = [Factory createBtn:CGRectMake(40, 20, SCREEN_WIDTH - 80, 44) title:@"开始配送" type:UIButtonTypeCustom target:self action:@selector(sendGoodsBtnClick)];
        startSendGoods.layer.cornerRadius = 8.f;
        startSendGoods.backgroundColor = BUTTON_COLOR;
        [footerView addSubview:startSendGoods];
        return footerView;
    }
    return nil;
}*/

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 300;
    }
    return 160.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    }
    return 56.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 120;
    }
    return 8.f;
}

- (SHYBaseTableView *)deliveryDetailView {
    if (!_deliveryDetailView) {
        _deliveryDetailView = [SHYBaseTableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped target:self];
    }
    return _deliveryDetailView;
}
- (SHYTaskCell *)headerDetailView {
    if (!_headerDetailView) {
        _headerDetailView = [SHYTaskCell.alloc initWithFrame:CGRectZero labelCount:7];
    }
    return _headerDetailView;
}
- (UIView *)goodsHeaderView {
    if (!_goodsHeaderView) {
        _goodsHeaderView=[UIView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 52)];
        _goodsHeaderView.backgroundColor = COLOR_WHITE;
        UILabel * titleLabel = [UILabel.alloc initWithFrame:CGRectMake(8, 8, 100, 36)];
        titleLabel.text = @"商品信息";
        [_goodsHeaderView addSubview:titleLabel];
        
        /*
        UIImageView * icon = [UIImageView.alloc initWithFrame:CGRectZero];
        icon.userInteractionEnabled = YES;
        icon.image = ImageNamed(@"xialazhanshi");
        [_goodsHeaderView addSubview:icon];
        
        kWeakSelf(self);
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.goodsHeaderView).offset(-8);
            make.centerY.equalTo(weakself.goodsHeaderView);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];*/
    }
    return _goodsHeaderView;
}

- (NSMutableArray<SHYGoodsModel *> *)dataArray {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
