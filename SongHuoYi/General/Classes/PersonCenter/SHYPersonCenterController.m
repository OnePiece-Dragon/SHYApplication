//
//  SHYPersonCenterController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYPersonCenterController.h"
#import "SHYPersonCenterCell.h"

#import "SHYChangePasswordController.h"
#import "SHYFeedBackController.h"

#define SERVE_PHONE     @"0571-8888888"

@interface SHYPersonCenterController ()

@property (nonatomic, strong) SHYBaseTableView * personTableView;
@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, strong) UIButton * logoutBtn;

@end

@implementation SHYPersonCenterController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = NO;;
    [self cancelBackItem];
    self.naviTitle = @"个人中心";
    
    [self.view addSubview:self.personTableView];
}

- (void)tapAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            //一键反馈
            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SHYFeedBackController * VC = [mainSB instantiateViewControllerWithIdentifier:@"FeedBackVC"];
            //SHYFeedBackController * VC = [SHYFeedBackController.alloc init];
            [self.navigationController pushViewController:VC animated:YES];
        }
        break;
        case 1:
        {
            //修改密码
            SHYChangePasswordController * VC = [SHYChangePasswordController.alloc init];
            [self.navigationController pushViewController:VC animated:YES];
        }
        break;
        case 2:
        {
            //联系客服
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:String_Combine(@"tel:", SERVE_PHONE)]]];
            [self.view addSubview:callWebview];
        }
        break;
        case 3:
        {
            //帮助中心
        }
        break;
        case 4:
        {
            //个人信息
        }
            break;
        default:
            break;
    }
}

- (void)callNumAction {
    DLog(@"打电话");
}
- (void)logOutBtnClick {
    kWeakSelf(self);
    [self showAlertVCWithTitle:nil info:@"确认退出当前账户？" CancelTitle:@"取消" okTitle:@"确定" cancelBlock:nil okBlock:^{
        [weakself logOutToLogin];
    }];
}

- (void)logOutToLogin {
    AppDelegate*app = APP_DELEGATE;
    [app.loginVC setLoginModel:app.loginModel];
    [app window].rootViewController = app.loginVC;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHYPersonCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:@"personCell"];
    if (!cell) {
        cell = [SHYPersonCenterCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personCell"];
        [cell.contentLabel.rightIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentLabel).offset(-8);
            make.centerY.equalTo(cell.contentLabel);
        }];
    }
    
    __weak typeof(SHYTwoSideLabel*)weakView = cell.contentLabel;
    if (indexPath.row == 2) {
        //联系客服
        [cell.contentLabel setLeftStr:self.dataArray[indexPath.row]
                             rightStr:SERVE_PHONE
                            rightIcon:nil];
        cell.contentLabel.rightLabel.textAlignment = NSTextAlignmentRight;
        UIImageView * callImageView = [UIImageView.alloc initWithImage:ImageNamed(@"dianhua")];
        [cell.contentLabel addSubview:callImageView];
        
        [callImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakView);
            make.right.equalTo(weakView.mas_left).offset(SCREEN_WIDTH*2/3);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
        
    }else if(indexPath.row == self.dataArray.count - 1){
        [cell.contentLabel setLeftStr:self.dataArray[indexPath.row]
                             rightStr:nil
                            rightIcon:nil];
        [cell.contentLabel addSubview:self.logoutBtn];
        [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakView);
            make.right.equalTo(weakView).offset(-20);
            make.size.mas_equalTo(CGSizeMake(56, 32));
        }];
        
    }else {
        [cell.contentLabel setLeftStr:self.dataArray[indexPath.row]
                             rightStr:nil
                            rightIcon:@"youjinru"];
        [cell.contentLabel.rightIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 16));
        }];
    }
    if (indexPath.row == self.dataArray.count - 1) {
        cell.contentLabel.rightIcon.hidden = YES;
    }else {
        cell.contentLabel.rightIcon.hidden = NO;
    }
    
    kWeakSelf(self);
    cell.contentLabel.clickBlock = ^(){
        [weakself tapAtIndex:indexPath.row];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (SHYBaseTableView *)personTableView {
    if (!_personTableView) {
        _personTableView = [SHYBaseTableView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarH - kNavigationBarH - kTabBarH) style:UITableViewStyleGrouped target:self];
    }
    return _personTableView;
}
- (NSArray *)dataArray {
    return @[@"意见反馈",@"修改密码",@"联系客服",@"帮助中心",
             [NSString stringWithFormat:@"当前账户：%@",UserDefaultObjectForKey(USER_PHONE)]];
}
- (UIButton *)logoutBtn {
    if (!_logoutBtn) {
        _logoutBtn = [Factory createBtn:CGRectZero title:@"退出" type:UIButtonTypeCustom target:self action:@selector(logOutBtnClick)];
        [_logoutBtn setBackgroundImage:[UIImage imageWithColor:BUTTON_COLOR] forState:UIControlStateNormal];
        _logoutBtn.titleLabel.font = kFont(14);
        _logoutBtn.layer.cornerRadius = 8.f;
        _logoutBtn.clipsToBounds = YES;
    }
    return _logoutBtn;
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
