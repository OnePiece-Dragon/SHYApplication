//
//  SHYLoginController.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/5.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseController.h"
#import "InputTextField.h"
#import "AppMacro.h"
#import "UIImage+Ext.h"

#import "TPKeyboardAvoidingScrollView.h"

@interface SHYLoginController : SHYBaseController

@property (nonatomic, strong) TPKeyboardAvoidingScrollView * backView;

@property (nonatomic, strong) UIImageView * iconImage;
@property (nonatomic, strong) InputTextField * phoneField;
@property (nonatomic, strong) InputTextField * passWordField;

@property (nonatomic, strong) UIButton * autoLogin;
@property (nonatomic, strong) UIButton * bigLogin;




@end
