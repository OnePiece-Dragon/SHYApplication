//
//  SHYLoginController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/5.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYLoginController.h"

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
    
    /*
    _iconImage.backgroundColor = [UIColor orangeColor];
    _phoneField.backgroundColor = [UIColor orangeColor];
    _passWordField.backgroundColor = [UIColor orangeColor];
    _autoLogin.backgroundColor = [UIColor orangeColor];
    _bigLogin.backgroundColor = [UIColor orangeColor];
    */
    
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
    
    //赋值
    if (_model.userPhone) {
        _phoneField.inputTextField.text = _model.userPhone;
    }
    if (_model.userPassword) {
        _passWordField.inputTextField.text = _model.userPassword;
    }
    if (_model.isAutoLogin == YES) {
        _autoLogin.selected = YES;
    }else {
        _autoLogin.selected = NO;
    }
}

- (void)failBlock:(NSString*)msg {
    [self showToast:msg];
    if (self.loginFailBlock) {
        self.loginFailBlock(msg);
    }
}

- (void)setLoginModel:(SHYLoginModel *)model {
    _model = model;
    [self endEditing];
    
    if (model.userPhone) {
        _phoneField.inputTextField.text = model.userPhone;
    }
    if (model.userPassword) {
        _passWordField.inputTextField.text = model.userPassword;
    }
    if (model.isAutoLogin == YES) {
        _autoLogin.selected = YES;
    }else {
        _autoLogin.selected = NO;
    }
}


- (void)loginAction {
    [self endEditing];
    DLog(@"loginAction");
    
    self.model.userPhone = _phoneField.inputTextField.text;
    self.model.userPassword = _passWordField.inputTextField.text;
    self.model.isAutoLogin = _autoLogin.isSelected;
    
    _model.clientId = UserDefaultObjectForKey(DeviceToken);
    
    if (!_model.clientId) {
        _model.clientId = @"";
    }
    if (!_model.userPassword.length || !_model.userPhone.length) {
        [self failBlock:@"请填写完整信息!"];
        return;
    }
    
    
    //loginRequest
    NSDictionary * paramDic = @{
                                @"mobile":_model.userPhone,
                                @"password":_model.userPassword,
                                @"clientId":_model.clientId
                                };
    [self showNetTips:@"登录中..."];
    [NetManager post:URL_Login param:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideNetTips];
        [self handleWithObj:responseObject];
        /*
        if ([responseObject[@"errcode"] integerValue] == 0) {
            [self handleWithObj:responseObject];
        }else if ([responseObject[@"errcode"] integerValue] == 1) {
            [self failBlock:responseObject[@"errmsg"]];
        }else {
            [self failBlock:NET_FAIL_TIP];
        }*/
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideNetTips];
        [self failBlock:NET_ERROR_TIP];
    }];
}

- (void)handleWithObj:(NSDictionary*)responseObject{
    DLog(@"loginRequest:%@",responseObject);
    UserDefaultSetObjectForKey(_model.userPhone, USER_PHONE);
    UserDefaultSetObjectForKey(_model.userPassword, USER_PASSWORD);
    if (_model.isAutoLogin == YES) {
        UserDefaultSetObjectForKey(@1, USER_ISAUTO_LOGIN);
    }else {
        UserDefaultSetObjectForKey(@0, USER_ISAUTO_LOGIN);
    }
    
    UserDefaultSetObjectForKey(@1, USER_LOGIN_STATUS);
    
    NSString *plistPath = PLIST_Name(@"userMessage");
    NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    SHYUserModel * userModel = [SHYUserModel shareUserMsg];
    [userModel mj_setKeyValues:dic[@"data"]];
    NSData * userData = ArchivedDataWithObject(userModel);
    UserDefaultSetObjectForKey(userData, USER_MESSAGE);
    
    [APP_DELEGATE window].rootViewController = [APP_DELEGATE tabBarVC];
}


- (void)autoLoginAction:(id)sender {
    [self endEditing];
    UIButton * button = (UIButton*)sender;
    button.selected = !button.selected;
    
    self.model.isAutoLogin = button.isSelected;
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


- (void)endEditing {
    [_phoneField.inputTextField endEditing:YES];
    [_passWordField.inputTextField endEditing:YES];
}


#pragma mark -touch delegate-
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self endEditing];
}


#pragma mark -lazing-
- (SHYLoginModel *)model {
    if (!_model) {
        _model = [SHYLoginModel.alloc init];
        _model.clientId = UserDefaultObjectForKey(DeviceToken);
    }
    return _model;
}
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
        [_autoLogin addTarget:self action:@selector(autoLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _autoLogin;
}
- (UIButton *)bigLogin {
    if (!_bigLogin) {
        _bigLogin = [Factory createBtn:CGRectZero title:@"登录" type:UIButtonTypeCustom target:self action:@selector(loginAction)];
    }
    return _bigLogin;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView.alloc init];
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
