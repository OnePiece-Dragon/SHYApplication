//
//  SHYUserModel.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/5.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYUserModel.h"

@implementation SHYUserModel

+ (instancetype)shareUserMsg {
    static SHYUserModel * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [SHYUserModel.alloc init];
    });
    return _instance;
}
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"operators":@"operator"};
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.clientId forKey:@"clientId"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.lastLoginTime forKey:@"lastLoginTime"];
    [aCoder encodeObject:self.messNum forKey:@"messNum"];
    [aCoder encodeObject:self.taskNum forKey:@"taskNum"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.workTime forKey:@"workTime"];
    [aCoder encodeObject:self.offDutyTime forKey:@"offDutyTime"];
    [aCoder encodeObject:self.addressId forKey:@"addressId"];
    [aCoder encodeObject:self.categoryId forKey:@"categoryId"];
    [aCoder encodeObject:self.loginTimes forKey:@"loginTimes"];
    
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.operators forKey:@"operators"];
    [aCoder encodeObject:self.position forKey:@"position"];
    [aCoder encodeObject:self.qrcode forKey:@"qrcode"];
    [aCoder encodeObject:self.qrcodeShow forKey:@"qrcodeShow"];
    [aCoder encodeObject:self.updateTime forKey:@"updateTime"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super init]) {
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.clientId = [aDecoder decodeObjectForKey:@"clientId"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.lastLoginTime = [aDecoder decodeObjectForKey:@"lastLoginTime"];
        self.messNum = [aDecoder decodeObjectForKey:@"messNum"];
        self.taskNum = [aDecoder decodeObjectForKey:@"taskNum"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.workTime = [aDecoder decodeObjectForKey:@"workTime"];
        self.offDutyTime = [aDecoder decodeObjectForKey:@"offDutyTime"];
        self.addressId = [aDecoder decodeObjectForKey:@"addressId"];
        self.categoryId = [aDecoder decodeObjectForKey:@"categoryId"];
        self.loginTimes = [aDecoder decodeObjectForKey:@"loginTimes"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.operators = [aDecoder decodeObjectForKey:@"operators"];
        self.position = [aDecoder decodeObjectForKey:@"position"];
        self.qrcode = [aDecoder decodeObjectForKey:@"qrcode"];
        self.qrcodeShow = [aDecoder decodeObjectForKey:@"qrcodeShow"];
        self.updateTime = [aDecoder decodeObjectForKey:@"updateTime"];
    }
    return self;
}
@end
