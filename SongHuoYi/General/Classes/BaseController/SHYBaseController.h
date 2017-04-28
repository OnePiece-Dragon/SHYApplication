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
#import "UIView+Toast.h"

@interface SHYBaseController : UIViewController<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger _allPage;
}

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


- (void)showAlertVCWithTitle:(NSString *)titleStr
                        info:(NSString *)infoStr
                 CancelTitle:(NSString *)cancelStr
                     okTitle:(NSString *)okStr
                 cancelBlock:(void (^)())cancelBlock
                     okBlock:(void (^)())okBlock;


- (void)showToast:(NSString*)toast;
- (void)showNetTips:(NSString*)tips;
- (void)hideNetTips;


- (void)loadRefreshData:(id)view;
- (void)loadMoreData:(id)view;

@end
