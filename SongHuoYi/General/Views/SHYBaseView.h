//
//  SHYBaseView.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SHYBaseView : UIView

@property (nonatomic, copy) void (^clickBlock)();

- (void)addBaseTapClickAction;

@end
