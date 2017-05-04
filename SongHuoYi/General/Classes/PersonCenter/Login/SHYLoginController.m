//
//  SHYLoginController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/5.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYLoginController.h"

#import "SHYLoginViewModel.h"

@interface SHYLoginController ()


@end

@implementation SHYLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self cancelBackItem];
    // Do any additional setup after loading the view.
    NSString *path = [[NSBundle mainBundle]pathForResource:@"beijing"ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    self.backView.layer.contents = (id)image.CGImage;
    
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.iconImage];
    [self.backView addSubview:self.phoneField];
    [self.backView addSubview:self.passWordField];
    [self.backView addSubview:self.autoLogin];
    [self.backView addSubview:self.bigLogin];
    
    _phoneField.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneField.inputTextField.layer.borderWidth = 1.f;
    _phoneField.inputTextField.layer.borderColor = COLOR_RGB(255, 255, 255).CGColor;
    _phoneField.inputTextField.layer.cornerRadius = 8.f;
    _passWordField.inputTextField.layer.borderWidth = 1.f;
    _passWordField.inputTextField.layer.borderColor = COLOR_RGB(255, 255, 255).CGColor;
    _passWordField.inputTextField.layer.cornerRadius = 8.f;
    
    _iconImage.image = ImageNamed(@"logo");
    [_autoLogin setTitle:@"自动登录" forState:UIControlStateNormal];
    [_autoLogin setImage:ImageNamed(@"buxuanze") forState:UIControlStateNormal];
    [_autoLogin setImage:ImageNamed(@"xuanze") forState:UIControlStateSelected];
    
    _bigLogin.layer.cornerRadius = 8.f;
    _bigLogin.clipsToBounds = YES;
    [_bigLogin setTitleColor:COLOR_RGB(2, 166, 255) forState:UIControlStateNormal];
    [_bigLogin setBackgroundImage:[UIImage imageWithColor:COLOR_WHITE] forState:UIControlStateNormal];
    
    
    NSString * phone_holderText = _phoneField.inputTextField.placeholder;
    NSMutableAttributedString *phone_placeholder = [[NSMutableAttributedString alloc]initWithString:phone_holderText];
    [phone_placeholder addAttribute:NSForegroundColorAttributeName value:COLOR_WHITE range:NSMakeRange(0, phone_holderText.length)];
    _phoneField.inputTextField.attributedPlaceholder = phone_placeholder;
    NSString * password_holderText = _phoneField.inputTextField.placeholder;
    NSMutableAttributedString *password_placeholder = [[NSMutableAttributedString alloc]initWithString:password_holderText];
    [password_placeholder addAttribute:NSForegroundColorAttributeName value:COLOR_WHITE range:NSMakeRange(0, password_holderText.length)];
    _passWordField.inputTextField.attributedPlaceholder = password_placeholder;
    
    
    _phoneField.inputTextField.textColor = COLOR_WHITE;
    _passWordField.inputTextField.textColor = COLOR_WHITE;
    _passWordField.inputTextField.secureTextEntry = YES;
    
    [self setContain];
    
    [self bindData];
}

- (void)bindData {
    SHYLoginViewModel * viewModel = [SHYLoginViewModel.alloc init];
    self.phoneField.inputTextField.text = viewModel.username;
    self.passWordField.inputTextField.text = viewModel.password;
    
    RAC(viewModel,username) = self.phoneField.inputTextField.rac_textSignal;
    RAC(viewModel,password) = self.passWordField.inputTextField.rac_textSignal;
    
    RAC(self.bigLogin,enabled) = viewModel.validSignal;
    
    self.autoLogin.selected = viewModel.isAutoLogin;
    [[self.autoLogin rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
        x.selected = !x.selected;
        viewModel.isAutoLogin = x.selected;
    }];
    [[self.bigLogin rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        [self showNetTips:LOADING_WAIT];
        [viewModel fetchResponse];
        [self endEdit];
    }];
    [viewModel.responseSignal subscribeNext:^(id  _Nullable x) {
        [self hideNetTips];
        if (x) {
            [APP_DELEGATE switchToHome];
        }else {
            [self showToast:viewModel.failResult[@"error"]];
        }
    }];
}

- (void)setContain {
    __weak typeof(self) wSelf = self;
    __weak typeof(UIView*) weakView = self.view;
    __weak typeof(UIView*) weakSelf = self.backView;
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakView);
    }];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(100);
        make.centerX.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(77*SCREEN_POINT, 77*SCREEN_POINT));
    }];
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.iconImage.mas_bottom).offset(28);
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(20);
        make.height.mas_equalTo(52);
    }];
    
    [self.passWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.phoneField.mas_bottom).offset(15);
        make.left.equalTo(wSelf.phoneField.mas_left);
        make.right.equalTo(wSelf.phoneField.mas_right);
        make.height.mas_equalTo(wSelf.phoneField.mas_height);
    }];
    [self.autoLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.passWordField.mas_bottom).offset(20);
        make.left.equalTo(wSelf.view).offset(8);
        make.size.mas_equalTo(CGSizeMake(120, 44));
    }];
    [self.bigLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.autoLogin.mas_bottom).offset(20);
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(20);
        make.height.mas_equalTo(52);
    }];
}

- (void)endEdit {
    [self.phoneField.inputTextField endEditing:YES];
    [self.passWordField.inputTextField endEditing:YES];
}

#pragma mark -lazing-
- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [UIImageView.alloc init];
        _iconImage.userInteractionEnabled = YES;
    }
    return _iconImage;
}

- (InputTextField *)phoneField {
    if (!_phoneField) {
        _phoneField = [InputTextField.alloc initWithFrame:CGRectZero
                                              placeHolder:@"请输入您的手机号"
                                                 leftIcon:@"shoujihaoma"
                                                rightIcon:nil];
        [_phoneField setIconSize:CGSizeMake(24, 32) direction:Left];
        [_phoneField setFieldMode:UITextFieldViewModeAlways direction:Left];
    }
    return _phoneField;
}

- (InputTextField *)passWordField {
    if (!_passWordField) {
        _passWordField = [InputTextField.alloc initWithFrame:CGRectZero
                                                 placeHolder:@"请输入您的密码"
                                                    leftIcon:@"mima"
                                                   rightIcon:@"zhengyan"];
        [_passWordField setIconSize:CGSizeMake(24, 32) direction:Left];
        [_passWordField setIconSize:CGSizeMake(28, 15) direction:Right];
        [_passWordField setFieldMode:UITextFieldViewModeAlways direction:Left];
        [_passWordField setFieldMode:UITextFieldViewModeAlways direction:Right];
    }
    return _passWordField;
}
- (UIButton *)autoLogin {
    if (!_autoLogin) {
        _autoLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _autoLogin;
}
- (UIButton *)bigLogin {
    if (!_bigLogin) {
        _bigLogin = [Factory createBtn:CGRectZero title:@"登录" type:UIButtonTypeCustom target:nil action:nil];
    }
    return _bigLogin;
}

- (TPKeyboardAvoidingScrollView *)backView {
    if (!_backView) {
        _backView = [TPKeyboardAvoidingScrollView.alloc init];
    }
    return _backView;
}



- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
