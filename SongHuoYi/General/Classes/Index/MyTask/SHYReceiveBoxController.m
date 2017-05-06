//
//  SHYReceiveBoxController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYReceiveBoxController.h"
#import "SHYCheckGoodsCell.h"

@interface SHYReceiveBoxController ()<UITextFieldDelegate>

{
    BOOL _canBtnClick;
    
    BOOL _checkBoxChange;
}

@property (nonatomic, strong) SHYReceiveBoxView * topBoxView;
@property (nonatomic, strong) SHYBaseTableView * checkGoodsListView;
@property (nonatomic, strong) UIView * footerTopView;
@property (nonatomic, strong) UIButton * receiveDoneBtn;

@property (nonatomic, strong) NSMutableArray<SHYGoodsModel*> * dataArray;

@end

@implementation SHYReceiveBoxController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"核货";
    // Do any additional setup after loading the view from its nib.
    [self setUI];
    [self requestData];
    
    _canBtnClick = NO;
    _checkBoxChange = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_checkBoxChange) {
        NOTICENTER_Post(Noti_CheckBox, nil);
    }
}

/**
 提交
 */
- (void)submitBtnClick {
    DLog(@"提交");
}

/**
 一键核货
 */
- (void)receiveBoxDone {
    DLog(@"一键核货");
    [self showAlertVCWithTitle:nil info:CHECK_BOX_ONCE_TIP CancelTitle:@"取消" okTitle:@"确定" cancelBlock:nil okBlock:^{
        [self checkBoxOnceTime];
    }];
}

- (void)checkBoxOnceTime {
    [self showNetTips:@"处理中..."];
    [NetManager post:URL_TASK_ONCENUCLEAR_UPDATE
               param:@{@"userId":USER_ID,
                       @"taskId":self.taskId,
                       @"lineId":self.lineId,
                       @"categoryId":self.nuclearModel.categoryId.stringValue}
             success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                 [self hideNetTips];
                 if (code) {
                     DLog(@"responseObj:%@",responseObj);
                     [self showToast:@"操作成功"];
                     _checkBoxChange = YES;
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [self.navigationController popViewControllerAnimated:YES];
                     });
                 }else {
                     [self showToast:failMessag];
                 }
             } failure:^(NSString * _Nonnull errorStr) {
                 [self hideNetTips];
                 [self showToast:errorStr];
             }];
}

- (void)receiveBoxGoodsItem:(NSInteger)countNum goodsModel:(SHYGoodsModel*)goodsModel{
    [self showNetTips:LOADING_DISPOSE];
    [NetManager post:URL_TASK_NUCLEAR_CGTUPDATE
               param:@{@"userId":USER_ID,
                       @"taskId":self.taskId,
                       @"senderId":self.senderId,
                       @"categoryId":self.nuclearModel.categoryId,
                       @"receivedNum":@(countNum),
                       @"orderItemId":goodsModel.orderItemId}
             success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                 [self hideNetTips];
                 if (code) {
                     DLog(@"responseObj:%@",responseObj);
                     goodsModel.nuclearStatus = @1;
                     goodsModel.actualNum = @(countNum);
                     _canBtnClick = NO;
                     _checkBoxChange = YES;
                     [self.checkGoodsListView reloadData];
                     
                 }else {
                     [self showToast:failMessag];
                 }
             } failure:^(NSString * _Nonnull errorStr) {
                 [self hideNetTips];
                 [self showToast:errorStr];
             }];
}

//暂时废弃
- (void)receiveBoxWithIssue:(NSInteger)countNum goodsModel:(SHYGoodsModel*)goodsModel {
    [NetManager post:URL_TASK_CREATEPRO
               param:@{@"userId":USER_ID,
                       @"taskId":self.taskId,
                       @"senderId":self.senderId,
                       @"categoryId":self.nuclearModel.categoryId,
                       @"receivedNum":@(countNum),
                       @"orderItemId":goodsModel.orderItemId}
             success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                 if (code) {
                     DLog(@"responseObj:%@",responseObj);
                     goodsModel.nuclearStatus = @1;
                     goodsModel.actualNum = @(countNum);
                     _canBtnClick = NO;
                     _checkBoxChange = YES;
                     [self.checkGoodsListView reloadData];
                     
                 }else {
                     [self showToast:failMessag];
                 }
             } failure:^(NSString * _Nonnull errorStr) {
                 [self hideNetTips];
                 [self showToast:errorStr];
             }];
}

/**
 每行的核货
 */
- (void)checkRowGoods:(SHYGoodsModel*)goodsModel cell:(SHYCheckGoodsCell*)cell {
    if (_canBtnClick == NO) {
        return;
    }
    if (goodsModel.nuclearStatus.integerValue == 1) {
        return;
    }
    
    kWeakSelf(self);
    DLog(@"row:%@",goodsModel.mj_keyValues);
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:goodsModel.goodsName message:[NSString stringWithFormat:@"最大收箱数：%@",goodsModel.buyNum] preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(UIAlertController*) weakAlert = alertController;
    __weak typeof(SHYGoodsModel*) weakModel = goodsModel;
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself inputRowTextModel:weakModel action:action alertController:weakAlert cell:cell];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = [NSString stringWithFormat:@"最大收箱数：%@",goodsModel.buyNum];
        textField.delegate = weakself;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)inputRowTextModel:(SHYGoodsModel*)model action:(UIAlertAction*)action alertController:(UIAlertController*)alertController cell:(SHYCheckGoodsCell*)cell{
    UITextField *userNameTextField = alertController.textFields.firstObject;
    //cell.labelView.rightLabel.text= @"已核货";
    //[self.checkGoodsListView reloadData];
    //NSInteger maxNum    = model.buyNum.integerValue;
    NSInteger inputNum  = userNameTextField.text.integerValue;
    if (inputNum>=0) {
        [self receiveBoxGoodsItem:userNameTextField.text.integerValue
                       goodsModel:model];
    }else{
        [self showToast:@"您的输入有误，请重新输入"];
    }
}

- (void)requestData {
    self.dataArray = self.nuclearModel.goods;
    [self.checkGoodsListView reloadData];
}

- (void)setUI {
    kWeakSelf(self);
//    [self.view addSubview:self.topBoxView];
//    [self.topBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(weakself.view);
//        make.height.mas_equalTo(@56);
//    }];
    [self.view addSubview:self.receiveDoneBtn];
    [self.view addSubview:self.checkGoodsListView];
    [self.checkGoodsListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakself.view);
        make.top.equalTo(weakself.view).offset(8);
        make.bottom.equalTo(weakself.view).offset(-(52+20));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * reuseId = nil;
    Goods_Direction direction = 0;
    if (indexPath.row == 0) {
        //first
        reuseId = @"receiveBoxCell_first";
        direction = Top;
    }else if (indexPath.row == self.dataArray.count - 1) {
        //last
        reuseId = @"receiveBoxCell_last";
        direction = Bottom;
    }else {
        reuseId = @"receiveBoxCell";
        direction = None;
    }
    SHYCheckGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [SHYCheckGoodsCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId direction:direction];
        cell.backView.backgroundColor = BACKGROUND_COLOR;
        cell.labelView.backgroundColor=COLOR_WHITE;
    }
    
    kWeakSelf(self);
    __weak typeof(SHYCheckGoodsCell*)weakCell = cell;
    cell.labelView.clickBlock = ^(){
        [weakself checkRowGoods:weakself.dataArray[indexPath.row] cell:weakCell];
    };
    
    SHYGoodsModel * model = self.dataArray[indexPath.row];
    
    if ([model.nuclearStatus integerValue] == 0) {
        _canBtnClick = YES;
    }
    if (_canBtnClick == YES) {
        self.receiveDoneBtn.enabled = YES;
    }else {
        self.receiveDoneBtn.enabled = NO;
    }
    
    cell.labelView.leftLabel.text = model.goodsName;
    
    if ([model.nuclearStatus integerValue] == 1) {
        //已核货
        NSString * string = @"";
        if (model.actualNum.integerValue == model.buyNum.integerValue) {
            string = @"已核货";
        }else if (model.actualNum.integerValue < model.buyNum.integerValue &&
                  model.actualNum.integerValue>=0) {
            string = [NSString stringWithFormat:@"%@/%@（%@）",model.actualNum,model.buyNum,model.unit];
        }
        cell.labelView.rightLabel.text = string;
        cell.labelView.rightLabel.textColor = BUTTON_COLOR;
        [self.receiveDoneBtn setTitle:@"已核货" forState:UIControlStateDisabled];
    }else {
        cell.labelView.rightLabel.text = @"未核货";
        cell.labelView.rightLabel.textColor = COLOR_PRICE;
        [self.receiveDoneBtn setTitle:@"一键核货" forState:UIControlStateNormal];
    }
    
    return cell;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [UIView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    view.backgroundColor = COLOR_WHITE;
    return view;
}
/*
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view = [UIView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    view.backgroundColor = BACKGROUND_COLOR;
    _footerTopView = [UIView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    _footerTopView.backgroundColor = COLOR_WHITE;
    [view addSubview:_footerTopView];
    [view addSubview:self.receiveDoneBtn];
    
    return view;
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 110.f;
}

- (SHYReceiveBoxView *)topBoxView {
    if (!_topBoxView) {
        _topBoxView = [SHYReceiveBoxView.alloc init];
        
        _topBoxView.leftTextField.layer.borderWidth = 1.f;
        _topBoxView.leftTextField.layer.borderColor = LINE_COLOR.CGColor;
        
        _topBoxView.midBtn.layer.borderWidth = 1.f;
        _topBoxView.midBtn.layer.borderColor = BUTTON_COLOR.CGColor;
        
        kWeakSelf(self);
        _topBoxView.midBtnClickBlock=^(){
            [weakself submitBtnClick];
        };
        
        _topBoxView.leftLabel.text = @"数量：";
        _topBoxView.midLabel.text = @"箱";
        [_topBoxView.midBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_topBoxView.midBtn setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
        _topBoxView.rightLabel.text = @"应收：15箱";
    }
    return _topBoxView;
}

- (SHYBaseTableView *)checkGoodsListView {
    if (!_checkGoodsListView) {
        _checkGoodsListView = [SHYBaseTableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped target:self];
    }
    return _checkGoodsListView;
}
- (UIButton *)receiveDoneBtn {
    if (!_receiveDoneBtn) {
        _receiveDoneBtn = [Factory createBtn:CGRectMake(40, SCREEN_HEIGHT -kStatusBarH - kNavigationBarH- 48 - 20, SCREEN_WIDTH - 80, 44) title:@"一键核货" type:UIButtonTypeCustom target:self action:@selector(receiveBoxDone)];
        [_receiveDoneBtn setTitle:@"已核货" forState:UIControlStateDisabled];
        [_receiveDoneBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        [_receiveDoneBtn setBackgroundImage:[UIImage imageWithColor:BUTTON_COLOR] forState:UIControlStateNormal];
        _receiveDoneBtn.layer.cornerRadius = 8.f;
        _receiveDoneBtn.clipsToBounds = YES;
        _receiveDoneBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        _receiveDoneBtn.layer.shadowOffset = CGSizeMake(2,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _receiveDoneBtn.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        _receiveDoneBtn.layer.shadowRadius = 4;//阴影半径，默认3
    }
    return _receiveDoneBtn;
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
