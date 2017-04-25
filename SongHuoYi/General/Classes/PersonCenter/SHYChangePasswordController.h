//
//  SHYChangePasswordController.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/10.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseController.h"
#import "InputTextField.h"

@interface SHYChangePasswordController : SHYBaseController

@property (nonatomic, strong) UIScrollView * backView;

@property (nonatomic, strong) InputTextField * originalPasswordView;
@property (nonatomic, strong) InputTextField * nPasswordView;
@property (nonatomic, strong) InputTextField * confirmPasswordView;

@property (nonatomic, strong) UIButton * submitBtn;

@end
