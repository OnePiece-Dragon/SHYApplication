//
//  SHYHeaderView.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/5/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SHYSectionModel.h"

typedef void(^HeadViewExpandCallback)(BOOL isExpanded);

@interface SHYHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) SHYSectionModel * sectionModel;
@property (nonatomic, copy) HeadViewExpandCallback expandCallback;

@end
