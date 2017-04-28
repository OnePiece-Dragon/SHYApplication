//
//  SHYLoginViewModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/18.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseViewModel.h"
#import "SHYLoginModel.h"

@interface SHYLoginViewModel : SHYBaseViewModel

@property (nonatomic, strong) SHYLoginModel * model;

@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, assign) BOOL isAutoLogin;

@property (nonatomic, strong) RACSignal * validSignal;

@property (nonatomic, strong) RACSubject * responseSignal;

- (void)saveAccount;

@end
