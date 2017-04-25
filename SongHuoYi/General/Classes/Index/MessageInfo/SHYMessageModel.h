//
//  SHYMessageModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/19.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseModel.h"

@interface SHYMessageModel : SHYBaseModel

@property (nonatomic, strong) NSNumber * messId;
@property (nonatomic, strong) NSString * messTitle;
@property (nonatomic, strong) NSString * messInfo;
@property (nonatomic, strong) NSNumber * gmt_create;

@end
