//
//  SHYHistoryNoteController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYHistoryNoteController.h"
#import "DatePickerView.h"
#import "SHYTaskHistoryModel.h"
#import "SHYTaskCell.h"

@interface SHYHistoryNoteController ()<DatePickerViewDelegate>

{
    NSInteger _allPage;
    NSInteger _page;
    NSTimeInterval _currentTime;
}

@property (nonatomic, strong) UIButton * frontBtn;
@property (nonatomic, strong) UILabel * dateLabel;
@property (nonatomic, strong) UIButton * behindBtn;
@property (nonatomic, strong) UIView * topView;

@property (nonatomic, strong) SHYBaseTableView * historyNoteView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation SHYHistoryNoteController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = NO;
    [self cancelBackItem];
    self.naviTitle = @"历史运单";
    _page = 1;
    [self setTopTimeUI];
    [self.view addSubview:self.historyNoteView];
    
    [self requestData];
}
- (void)loadRefreshData:(id)view {
    _page = 1;
    [self.dataArray removeAllObjects];
    [self requestData];
}
- (void)loadMoreData:(id)view {
    if (_page < _allPage) {
        _page ++;
        [self requestData];
    }else {
        [self.historyNoteView noMoreData];
    }
}
- (void)dateChangeRequest {
    _page = 1;
    _allPage = 1;
    [self.dataArray removeAllObjects];
    [self requestData];
}
- (void)endRefresh{
    [self.historyNoteView.mj_header endRefreshing];
    [self.historyNoteView.mj_footer endRefreshing];
}
- (void)requestData {
    //SHYTaskHistoryModel
    [self showNetTips:LOADING_TIPS];
    [NetManager post:URL_TASK_HISTORY
               param:@{@"userId":USER_ID,
                       @"qryTime":self.dateLabel.text,
                       @"page":@(_page)} success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                           [self hideNetTips];
                           [self.historyNoteView endRefresh];
                           if (code) {
                               DLog(@"responseObj:%@",responseObj);
                               if (responseObj[@"pages"]) {
                                   _allPage = [responseObj[@"pages"] integerValue];
                               }
                               
                               for (NSDictionary *dic in responseObj[@"rows"]) {
                                   SHYTaskHistoryModel * model = [SHYTaskHistoryModel mj_objectWithKeyValues:dic];
                                   [self.dataArray addObject:model];
                               }
                               
                               [self.historyNoteView reloadData];
                           }else {
                               [self showToast:failMessag];
                           }
                           
                           [self endRefresh];
                       } failure:^(NSString * _Nonnull errorStr) {
                           [self hideNetTips];
                           [self showToast:errorStr];
                           
                           [self endRefresh];
                       }];
    /*
    NSDictionary * result=[NSDictionary.alloc initWithContentsOfFile:PLIST_Name(@"history_task")];
    for (NSDictionary *dic in result[@"data"][@"rows"]) {
        SHYTaskHistoryModel * model = [SHYTaskHistoryModel mj_objectWithKeyValues:dic];
        [self.dataArray addObject:model];
    }
    
    [self.historyNoteView reloadData];*/
}

- (void)setContentView:(SHYTaskCell*)view model:(SHYTaskHistoryModel*)taskModel {
    [view setCellModel:taskModel];
    SHYIconLabel*label1 = view.labelArray[0];
    SHYIconLabel*label2 = view.labelArray[1];
    SHYIconLabel*label3 = view.labelArray[2];
    SHYIconLabel*label4 = view.labelArray[3];
    SHYIconLabel*label5 = view.labelArray[4];
    SHYIconLabel*label6 = view.labelArray[5];
    
    [label2 setIcon:@"renwudan" size:CGSizeMake(24, 24)];
    [label3 setIcon:@"dizhi" size:CGSizeMake(24, 28)];
    
    label1.titleLabel.text = taskModel.lineName;
    label2.titleLabel.text = [NSString stringWithFormat:@"任务单号：%@",taskModel.taskId];
    label3.titleLabel.text = [NSString stringWithFormat:@"地址：%@",taskModel.startAddr];
    label4.titleLabel.text = [NSString stringWithFormat:@"订单数：%@",taskModel.orderNum];
    label5.titleLabel.text = [NSString stringWithFormat:@"供应商数：%@",taskModel.merchantNum];
    label6.titleLabel.text = [NSString stringWithFormat:@"共计：%@",taskModel.taskDetail];
}

- (void)enterToDetail:(SHYTaskHistoryModel*)model {
    SHYHistoryDetailController * VC = [SHYHistoryDetailController.alloc init];
    VC.taskId = model.taskId;
    VC.lineId = model.lineId;
    
    VC.shopId = model.shopId;
    VC.taskCode = model.taskCode;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark -tableViewDelegate-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count) {
        return 1;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHYTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [SHYTaskCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID labelCount:6 enterBtnIndex:4 bottomBtn:YES];
        cell.backgroundColor = COLOR_WHITE;
        cell.enterBtn.hidden = YES;
    }
    SHYTaskHistoryModel * taskModel = [self.dataArray objectAtIndex:indexPath.section];
    [self setContentView:cell model:taskModel];
    kWeakSelf(self);
    for (SHYIconLabel *label in cell.labelArray) {
        label.clickBlock = ^(){
            [weakself enterToDetail:taskModel];
        };
    }
    
    
    return cell;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel * label = [UILabel.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = [TimeManager timeWithTimeIntervalString:[(SHYTaskHistoryModel*)self.dataArray[section] gmtModifly] format:@"HH:mm:ss"];
    
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.f;
}


#pragma mark -datePickerView-
- (void)showPickViewerAction
{
    DatePickerView *pickerView = [[DatePickerView alloc] initDatePickerWithDefaultDate:nil
                                                                     andDatePickerMode:UIDatePickerModeDate];
    
    pickerView.delegate = self;
    [pickerView show];
}

- (void)pickerView:(DatePickerView *)pickerView didSelectDateString:(NSString *)dateString
{
    _dateLabel.text = dateString;
    //格式: 2017-01-23
    _currentTime = [TimeManager timeSwitchTimeString:dateString format:@"yyyy-MM-dd"] + 86400;
    [self dateChangeRequest];
}

- (void)setTopTimeUI {
    [self.topView addSubview:self.frontBtn];
    [self.topView addSubview:self.behindBtn];
    [self.topView addSubview:self.dateLabel];
    [self.view addSubview:self.topView];
    [_frontBtn setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    [_behindBtn setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    [_frontBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_behindBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_frontBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_behindBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    
    [self setCurrentTime];
}

- (void)frontBtnAction {
    _currentTime -= 86400;
    [self setDateLabelText];
    
    [self dateChangeRequest];
}
- (void)behindBtnAction {
    _currentTime += 86400;
    [self setDateLabelText];
    
    [self dateChangeRequest];
}

- (void)setCurrentTime {
    _currentTime = [NSDate.date timeIntervalSince1970];
    [self setDateLabelText];
}

- (void)setDateLabelText {
    NSString * dateString = [TimeManager timeWithTimeIntervalString:[NSString stringWithFormat:@"%lf",_currentTime] format:@"YYY-MM-dd"];
    _page = 1;
    _dateLabel.text = dateString;
}


#pragma mark -Lazing-
- (UIButton *)frontBtn {
    if (!_frontBtn) {
        _frontBtn = [Factory createBtn:CGRectMake(0, 0, 80, 49) title:@"前一天" type:UIButtonTypeCustom target:self action:@selector(frontBtnAction)];
        _frontBtn.titleLabel.font = kFont(14);
    }
    return _frontBtn;
}
- (UIButton *)behindBtn {
    if (!_behindBtn) {
        _behindBtn = [Factory createBtn:CGRectMake(SCREEN_WIDTH - 80, 0, 80, 49) title:@"后一天" type:UIButtonTypeCustom target:self action:@selector(behindBtnAction)];
        _behindBtn.titleLabel.font = kFont(14);
    }
    return _behindBtn;
}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel.alloc initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH - 160, 49)];
        _dateLabel.font = kFont(14);
        _dateLabel.userInteractionEnabled = YES;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [_dateLabel addGestureRecognizer:[UITapGestureRecognizer.alloc initWithTarget:self action:@selector(showPickViewerAction)]];
    }
    return _dateLabel;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
        
        _topView.backgroundColor = COLOR_WHITE;
    }
    return _topView;
}

- (SHYBaseTableView *)historyNoteView {
    if (!_historyNoteView) {
        _historyNoteView = [SHYBaseTableView.alloc initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, SCREEN_HEIGHT -kStatusBarH - 44 - 49 - 49) style:UITableViewStyleGrouped target:self];
        [_historyNoteView addRefreshHeader:self action:@selector(loadRefreshData:)];
        [_historyNoteView addRefreshFooter:self action:@selector(loadMoreData:)];
        kWeakSelf(self);
        _historyNoteView.emptyRequestAgainBlock = ^(){
            [weakself loadRefreshData:nil];
        };
    }
    return _historyNoteView;
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
