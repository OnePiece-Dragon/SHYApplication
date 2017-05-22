//
//  SHYLoginViewModel.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/18.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYLoginViewModel.h"

@interface SHYLoginViewModel()

@property (nonatomic, strong, nonnull) RACSignal *usernameSignal;
@property (nonatomic, strong, nonnull) RACSignal *passwordSignal;

@end

@implementation SHYLoginViewModel

- (instancetype)init {
    if ([super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.username = self.model.userPhone;
    self.password = self.model.userPassword;
    self.isAutoLogin = self.model.isAutoLogin;
    
    //
    self.usernameSignal = [RACObserve(self, self.username) map:^id _Nullable(id  _Nullable value) {
        return @([(NSString*)value length]);
    }];
    self.passwordSignal = [RACObserve(self, self.password) map:^id _Nullable(id  _Nullable value) {
        return @([(NSString*)value length]);
    }];
    self.validSignal = [RACSignal combineLatest:@[self.usernameSignal,self.passwordSignal] reduce:^id (NSNumber*userNum,NSNumber*passwordNum){
        return @(userNum.integerValue>10 && passwordNum.integerValue>5);
    }];
    
}

- (void)fetchResponse {
    [self.requestBody requestWithMethod:URL_Login
                                  param:@{@"mobile":self.username,
                                          @"password":self.password,
                                          @"clientId":UserDefaultObjectForKey(DeviceToken)}
                               observer:self];
}

- (void)fetchResponse:(id)responseObj code:(BOOL)code fail:(NSString *)fail {
    [super fetchResponse:responseObj code:code fail:fail];
    if (code) {
        [self saveAccount];
        [self.responseSignal sendNext:@YES];
    }else {
        [self.responseSignal sendNext:@NO];
    }
    //[self.responseSignal sendCompleted];
}

- (void)saveAccount {
    UserDefaultSetObjectForKey(self.username, USER_PHONE);
    UserDefaultSetObjectForKey(self.password, USER_PASSWORD);
    if (self.isAutoLogin) {
        UserDefaultSetObjectForKey(@1, USER_ISAUTO_LOGIN);
    }else {
        UserDefaultSetObjectForKey(@0, USER_ISAUTO_LOGIN);
    }
    
    //UserDefaultSetObjectForKey(@1, USER_LOGIN_STATUS);
    
    //NSString *plistPath = PLIST_Name(@"userMessage");
    //NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    SHYUserModel * userModel = [SHYUserModel shareUserMsg];
    [userModel mj_setKeyValues:self.successResult];
    NSData * userData = ArchivedDataWithObject(userModel);
    UserDefaultSetObjectForKey(userData, USER_MESSAGE);
}


- (SHYLoginModel *)model {
    if (!_model) {
        SHYLoginModel * loginModel = [SHYLoginModel.alloc init];
        
        loginModel.userPhone = UserDefaultObjectForKey(USER_PHONE);
        loginModel.userPassword = UserDefaultObjectForKey(USER_PASSWORD);
        //loginModel.clientId = UserDefaultObjectForKey(DeviceToken);
        loginModel.isAutoLogin = [UserDefaultObjectForKey(USER_ISAUTO_LOGIN) integerValue] == 1 ? YES : NO;
        _model = loginModel;
    }
    return _model;
}

@end
