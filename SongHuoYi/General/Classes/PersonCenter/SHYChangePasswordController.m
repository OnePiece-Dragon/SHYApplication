//
//  SHYChangePasswordController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/10.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYChangePasswordController.h"

@interface SHYChangePasswordController ()

@end

@implementation SHYChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviTitle = @"修改密码";
    self.view.backgroundColor = COLOR_WHITE;
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.originalPasswordView];
    [self.backView addSubview:self.nPasswordView];
    [self.backView addSubview:self.confirmPasswordView];
    [self.backView addSubview:self.submitBtn];
    
    UIView * line1 = [UIView new];
    UIView * line2 = [UIView new];
    UIView * line3 = [UIView new];
    line1.backgroundColor = LINE_COLOR;
    line2.backgroundColor = LINE_COLOR;
    line3.backgroundColor = LINE_COLOR;
    [self.backView addSubview:line1];
    [self.backView addSubview:line2];
    [self.backView addSubview:line3];
    [_originalPasswordView setFieldMode:UITextFieldViewModeAlways direction:Left];
    _originalPasswordView.backgroundColor = COLOR_WHITE;
//    _originalPasswordView.layer.borderColor = BUTTON_COLOR.CGColor;
//    _originalPasswordView.layer.borderWidth = 1.f;
//    _originalPasswordView.layer.cornerRadius = 8.f;
    
    [_nPasswordView setFieldMode:UITextFieldViewModeAlways direction:Left];
    _nPasswordView.backgroundColor = COLOR_WHITE;
//    _nPasswordView.layer.borderColor = BUTTON_COLOR.CGColor;
//    _nPasswordView.layer.borderWidth = 1.f;
//    _nPasswordView.layer.cornerRadius = 8.f;
    
    
    [_confirmPasswordView setFieldMode:UITextFieldViewModeAlways direction:Left];
    _confirmPasswordView.backgroundColor = COLOR_WHITE;
//    _confirmPasswordView.layer.borderColor = BUTTON_COLOR.CGColor;
//    _confirmPasswordView.layer.borderWidth = 1.f;
//    _confirmPasswordView.layer.cornerRadius = 8.f;
    
    [_originalPasswordView setIconSize:CGSizeMake(24, 24) direction:Left];
    [_nPasswordView setIconSize:CGSizeMake(24, 32) direction:Left];
    [_confirmPasswordView setIconSize:CGSizeMake(24, 32) direction:Left];
    
    _originalPasswordView.inputTextField.secureTextEntry = YES;
    _nPasswordView.inputTextField.secureTextEntry = YES;
    _confirmPasswordView.inputTextField.secureTextEntry = YES;
    
    kWeakSelf(self);
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(weakself.view);
    }];
    
    [self.originalPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.backView).offset(20);
        make.centerX.equalTo(weakself.backView);
        make.top.equalTo(weakself.backView).offset(80);
        make.height.mas_offset(49);
    }];
    [self.nPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.backView).offset(20);
        make.centerX.equalTo(weakself.backView);
        make.top.equalTo(weakself.originalPasswordView.mas_bottom).offset(8);
        make.height.mas_offset(49);
    }];
    [self.confirmPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.backView).offset(20);
        make.centerX.equalTo(weakself.backView);
        make.top.equalTo(weakself.nPasswordView.mas_bottom).offset(8);
        make.height.mas_offset(49);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.backView).offset(20);
        make.centerX.equalTo(weakself.backView);
        make.top.equalTo(weakself.confirmPasswordView.mas_bottom).offset(8);
        make.height.mas_offset(49);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.backView).offset(20);
        make.centerX.equalTo(weakself.backView);
        make.bottom.equalTo(weakself.originalPasswordView.mas_bottom);
        make.height.mas_offset(@1);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.backView).offset(20);
        make.centerX.equalTo(weakself.backView);
        make.bottom.equalTo(weakself.nPasswordView.mas_bottom);
        make.height.mas_offset(@1);
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.backView).offset(20);
        make.centerX.equalTo(weakself.backView);
        make.bottom.equalTo(weakself.confirmPasswordView.mas_bottom);
        make.height.mas_offset(@1);
    }];
}

- (void)submitBtnAction {
    DLog(@"提交");
    NSString * originalPassword = _originalPasswordView.inputTextField.text;
    NSString * newPassword      = _nPasswordView.inputTextField.text;
    NSString * confirmPassword  = _confirmPasswordView.inputTextField.text;
    
    if (!originalPassword.length || !newPassword.length || !confirmPassword.length) {
        [self showToast:@"请填写完整"];
        return;
    }
    if (![newPassword isEqualToString:confirmPassword]) {
        [self showToast:@"您两次填写密码不一致"];
        return;
    }
    
    [self showAlertVCWithTitle:nil info:@"确定修改密码？" CancelTitle:@"取消" okTitle:@"确定" cancelBlock:nil okBlock:^{
        [self passWordChangeRequest:originalPassword newPassword:newPassword];
    }];
}

- (void)passWordChangeRequest:(NSString*)originalPassword
                  newPassword:(NSString*)newPassword{
    
    [self showNetTips:LOADING_DISPOSE];
    [NetManager post:URL_UPDATE_PASSWORD
               param:@{@"userId":USER_ID,
                       @"password":originalPassword,
                       @"newPassword":newPassword}
             success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                 [self hideNetTips];
                 if (code) {
                     [self showToast:@"修改成功"];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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

- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView.alloc init];
    }
    return _backView;
}
- (InputTextField *)originalPasswordView {
    if (!_originalPasswordView) {
        _originalPasswordView = [InputTextField.alloc initWithFrame:CGRectZero
                                                        placeHolder:@"请输入您的原密码"
                                                           leftIcon:@"yuanmima"
                                                          rightIcon:nil];
    }
    return _originalPasswordView;
}
- (InputTextField *)nPasswordView {
    if (!_nPasswordView) {
        _nPasswordView = [InputTextField.alloc initWithFrame:CGRectZero
                                                        placeHolder:@"请输入您的新密码"
                                                           leftIcon:@"xinmima"
                                                          rightIcon:nil];
    }
    return _nPasswordView;
}
- (InputTextField *)confirmPasswordView {
    if (!_confirmPasswordView) {
        _confirmPasswordView = [InputTextField.alloc initWithFrame:CGRectZero
                                                        placeHolder:@"请确认您的新密码"
                                                           leftIcon:@"xinmima"
                                                          rightIcon:nil];
    }
    return _confirmPasswordView;
}
- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [Factory createBtn:CGRectZero title:@"提交" type:UIButtonTypeCustom target:self action:@selector(submitBtnAction)];
        [_submitBtn setBackgroundImage:[UIImage imageWithColor:BUTTON_COLOR] forState:UIControlStateNormal];
        [_submitBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        _submitBtn.layer.cornerRadius = 8.f;
        _submitBtn.clipsToBounds = YES;
    }
    return _submitBtn;
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
