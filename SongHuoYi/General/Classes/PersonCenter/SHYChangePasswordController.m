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
    self.view.backgroundColor = COLOR_WHITE;
    self.naviTitle = @"修改密码";
    
    [self.view addSubview:self.originalPasswordView];
    [self.view addSubview:self.nPasswordView];
    [self.view addSubview:self.confirmPasswordView];
    [self.view addSubview:self.submitBtn];
    
    [_originalPasswordView setFieldMode:UITextFieldViewModeAlways direction:Left];
    _originalPasswordView.backgroundColor = COLOR_WHITE;
    _originalPasswordView.layer.borderColor = BUTTON_COLOR.CGColor;
    _originalPasswordView.layer.borderWidth = 1.f;
    _originalPasswordView.layer.cornerRadius = 8.f;
    
    [_nPasswordView setFieldMode:UITextFieldViewModeAlways direction:Left];
    _nPasswordView.backgroundColor = COLOR_WHITE;
    _nPasswordView.layer.borderColor = BUTTON_COLOR.CGColor;
    _nPasswordView.layer.borderWidth = 1.f;
    _nPasswordView.layer.cornerRadius = 8.f;
    
    
    [_confirmPasswordView setFieldMode:UITextFieldViewModeAlways direction:Left];
    _confirmPasswordView.backgroundColor = COLOR_WHITE;
    _confirmPasswordView.layer.borderColor = BUTTON_COLOR.CGColor;
    _confirmPasswordView.layer.borderWidth = 1.f;
    _confirmPasswordView.layer.cornerRadius = 8.f;
    
    
    [_nPasswordView setIconSize:CGSizeMake(24, 32) direction:Left];
    [_confirmPasswordView setIconSize:CGSizeMake(24, 32) direction:Left];
    
    kWeakSelf(self);
    [self.originalPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.view).offset(20);
        make.centerX.equalTo(weakself.view);
        make.top.equalTo(weakself.view).offset(80);
        make.height.mas_offset(49);
    }];
    [self.nPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.view).offset(20);
        make.centerX.equalTo(weakself.view);
        make.top.equalTo(weakself.originalPasswordView.mas_bottom).offset(8);
        make.height.mas_offset(49);
    }];
    [self.confirmPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.view).offset(20);
        make.centerX.equalTo(weakself.view);
        make.top.equalTo(weakself.nPasswordView.mas_bottom).offset(8);
        make.height.mas_offset(49);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.view).offset(20);
        make.centerX.equalTo(weakself.view);
        make.top.equalTo(weakself.confirmPasswordView.mas_bottom).offset(8);
        make.height.mas_offset(49);
    }];
}

- (void)submitBtnAction {
    DLog(@"提交");
    //NSString * originalPassword = _originalPasswordView.inputTextField.text;
    
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
