//
//  SHYIndexItemModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseModel.h"

@interface SHYIndexItemModel : SHYBaseModel

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger isClick;

@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) NSString * highlightImageName;
@property (nonatomic, strong) NSString * titleName;

@property (nonatomic, strong) NSString * descName;

@end
