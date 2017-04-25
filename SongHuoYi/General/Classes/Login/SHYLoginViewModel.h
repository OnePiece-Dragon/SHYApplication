//
//  SHYLoginViewModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/18.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseViewModel.h"


@interface SHYLoginViewModel : SHYBaseViewModel

@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, assign) BOOL isAutoLogin;


@property (nonatomic, strong) RACSignal * usernameSignal;
@property (nonatomic, strong) RACSignal * passwordSignal;
@property (nonatomic, strong) RACSignal * valueSignal;

@property (nonatomic, strong) RACSignal * loginBtnSignal;

@end
