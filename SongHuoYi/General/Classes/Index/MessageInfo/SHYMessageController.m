//
//  SHYMessageController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYMessageController.h"
#import "SHYMessageModel.h"
#import "SHYMessageCell.h"

@interface SHYMessageController ()

{
    NSInteger _page;
    NSInteger _allPages;
}

@property (nonatomic, strong) SHYBaseTableView *messageView;
@property (nonatomic, strong) NSMutableArray * messageList;

@end

@implementation SHYMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"消息中心";
    _page = 1;
    _allPages = 1;
    [self.view addSubview:self.messageView];
    
    [self messageListRequest];
}

- (void)messageListRequest {
    [NetManager post:URL_MESSAGE_INFO
               param:@{@"userId":USER_ID,
                       @"page":@(_page)}
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary* result = responseObject[@"data"];
                 _allPages = [result[@"pages"] integerValue];
                 NSArray * dataArray = [SHYMessageModel mj_objectArrayWithKeyValuesArray:result[@"rows"]];
                 [self.messageList addObjectsFromArray:dataArray];
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [self showToast:NET_ERROR_TIP];
             }];
}

#pragma mark -tableViewDelegate-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageList.count;
}
#pragma mark -tableViewDataSource-
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId=@"messageCell";
    SHYMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [SHYMessageCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    SHYMessageModel * model = self.messageList[indexPath.row];
    cell.titleLabel.text = model.messTitle;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

#pragma mark -Lazing-
- (SHYBaseTableView *)messageView {
    if (!_messageView) {
        _messageView = [SHYBaseTableView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarH - kStatusBarH) style:UITableViewStyleGrouped target:self];
    }
    return _messageView;
}
- (NSMutableArray *)messageList {
    if (!_messageList) {
        _messageList = [NSMutableArray array];
    }
    return _messageList;
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
