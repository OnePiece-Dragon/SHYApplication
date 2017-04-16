//
//  SHYBaseController.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"
#import "SHYBaseTableView.h"

@interface SHYBaseController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) NSString * naviTitle;

@property (nonatomic, copy) void (^leftBar)();
@property (nonatomic, copy) void (^rightBar)();
@property (nonatomic, copy) void (^rightBarClick)(id);

- (void)setBackItem:(NSString*)backImage;
- (void)cancelBackItem;
- (void)setRightItem:(NSString*)imageName;
- (void)setRightItem:(NSString*)imageName rightBlock:(void(^)())rightBlock;
- (void)setRightItem:(NSString *)imageName
       selectedImage:(NSString*)selectedImage
           rightBlock:(void (^)(id))rightBlock;

- (void)showToast:(NSString*)toast;

@end