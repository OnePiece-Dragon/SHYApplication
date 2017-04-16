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

@interface SHYPersonCenterController ()

@property (nonatomic, strong) SHYBaseTableView * personTableView;
@property (nonatomic, strong) NSArray * dataArray;

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
            
        }
        break;
        case 1:
        {
            SHYChangePasswordController * VC = [SHYChangePasswordController.alloc init];
            [self.navigationController pushViewController:VC animated:YES];
        }
        break;
        case 2:
        {
            
        }
        break;
        case 3:
        {
            
        }
        break;
            
        default:
            break;
    }
}

- (void)callNumAction {
    DLog(@"打电话");
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
    /*
    if (indexPath.row == 2) {
        [cell.contentLabel setLeftStr:self.dataArray[indexPath.row]
                             rightStr:nil
                            rightIcon:nil];
        UIButton * rightBtn = [Factory createBtn:CGRectMake(SCREEN_WIDTH/2.f, 0, SCREEN_WIDTH/2.f-8, 64) title:@"0571-8888888" type:UIButtonTypeCustom target:self action:@selector(callNumAction)];
        [rightBtn setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
        [cell addSubview:rightBtn];
    }else {
        [cell.contentLabel setLeftStr:self.dataArray[indexPath.row]
                             rightStr:nil
                            rightIcon:@"xialazhanshi"];
    }*/
    [cell.contentLabel setLeftStr:self.dataArray[indexPath.row]
                         rightStr:nil
                        rightIcon:@"xialazhanshi"];
    
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
    return @[@"意见反馈",@"修改密码",@"帮助中心",@"消息设置"];
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
