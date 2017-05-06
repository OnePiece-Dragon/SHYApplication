//
//  SHYSectionModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/5/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseModel.h"
#import "SHYNuclearCategoryModel.h"

@interface SHYSectionModel : SHYBaseModel

@property (nonatomic, strong) SHYNuclearCategoryModel * categoryModel;
@property (nonatomic, assign) BOOL isExpanded;

@property (nonatomic, strong) NSString * sectionTitle;
@property (nonatomic, strong) UIImage * iconImage;


@end
