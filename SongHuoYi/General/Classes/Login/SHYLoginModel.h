//
//  SHYLoginModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/5.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseModel.h"

@interface SHYLoginModel : SHYBaseModel

@property (nonatomic, strong) NSString * userPhone;
@property (nonatomic, strong) NSString * userPassword;

@property (nonatomic, assign) BOOL isAutoLogin;


@end
