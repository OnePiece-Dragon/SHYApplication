//
//  SHYReceiveBoxController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYReceiveBoxController.h"
#import "SHYCheckGoodsCell.h"

@interface SHYReceiveBoxController ()

@property (nonatomic, strong) SHYReceiveBoxView * topBoxView;
@property (nonatomic, strong) SHYBaseTableView * checkGoodsListView;
@property (nonatomic, strong) UIView * footerTopView;
@property (nonatomic, strong) UIButton * receiveDoneBtn;

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation SHYReceiveBoxController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"收箱";
    self.view.backgroundColor = LINE_COLOR;
    // Do any additional setup after loading the view from its nib.
    [self setUI];
    [self requestData];
}


/**
 提交
 */
- (void)submitBtnClick {
    DLog(@"提交");
}

/**
 收箱完成
 */
- (void)receiveBoxDone {
    DLog(@"收箱完成");
}

/**
 每行的核货
 */
- (void)checkRowGoods:(NSDictionary*)dic {
    DLog(@"row核货:%@",dic);
}

- (void)requestData {
    self.dataArray = (NSMutableArray*)@[@{@"goodsName":@"ASD123123",@"status":@"已核货"},
                                        @{@"goodsName":@"BBS123123",@"status":@"未核货"},
                                        @{@"goodsName":@"RAG123123",@"status":@"已核货"}];
    [self.checkGoodsListView reloadData];
}

- (void)setUI {
    kWeakSelf(self);
    [self.view addSubview:self.topBoxView];
    [self.topBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakself.view);
        make.height.mas_equalTo(@56);
    }];
    
    
    [self.view addSubview:self.checkGoodsListView];
    [self.checkGoodsListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakself.view);
        make.top.equalTo(weakself.topBoxView.mas_bottom).offset(8);
        make.bottom.equalTo(weakself.view);
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
    }
    
    kWeakSelf(self);
    cell.tapActionBlock = ^(id model){
        [weakself checkRowGoods:weakself.dataArray[indexPath.row]];
    };
    
    NSDictionary * cellDic = self.dataArray[indexPath.row];
    
    cell.labelView.leftLabel.text = cellDic[@"goodsName"];
    cell.labelView.rightLabel.text = cellDic[@"status"];
    
    return cell;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [UIView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    view.backgroundColor = COLOR_WHITE;
    return view;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view = [UIView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    view.backgroundColor = LINE_COLOR;
    _footerTopView = [UIView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    _footerTopView.backgroundColor = COLOR_WHITE;
    [view addSubview:_footerTopView];
    [view addSubview:self.receiveDoneBtn];
    
    return view;
}

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
        _receiveDoneBtn = [Factory createBtn:CGRectMake(20, 60, SCREEN_WIDTH - 40, 44) title:@"收箱完成" type:UIButtonTypeCustom target:self action:@selector(receiveBoxDone)];
        [_receiveDoneBtn setBackgroundImage:[UIImage imageWithColor:BUTTON_COLOR] forState:UIControlStateNormal];
        _receiveDoneBtn.layer.cornerRadius = 8.f;
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
