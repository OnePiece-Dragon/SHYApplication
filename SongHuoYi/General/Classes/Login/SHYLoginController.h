//
//  SHYLoginController.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/5.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseController.h"
#import "InputTextField.h"
#import <Masonry.h>
#import "AppMacro.h"
#import "Factory.h"
#import "UIImage+Ext.h"
#import "NetManager.h"
#import "SHYLoginModel.h"
#import "SHYUserModel.h"

@interface SHYLoginController : SHYBaseController

@property (nonatomic, strong) UIView * backView;

@property (nonatomic, strong) UIImageView * iconImage;
@property (nonatomic, strong) InputTextField * phoneField;
@property (nonatomic, strong) InputTextField * passWordField;

@property (nonatomic, strong) UIButton * autoLogin;

@property (nonatomic, strong) UIButton * bigLogin;

@property (nonatomic, strong) SHYLoginModel * model;

@property (nonatomic, copy) void (^loginFailBlock)(NSString*);
- (void)setLoginModel:(SHYLoginModel*)model;

- (void)endEditing;

@end
