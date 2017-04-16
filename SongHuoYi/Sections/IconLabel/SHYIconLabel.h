//
//  SHYIconLabel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseView.h"

@interface SHYIconLabel : SHYBaseView

@property (nonatomic, strong) UIImageView * iconImage;
@property (nonatomic, strong) CustomLabel * titleLabel;

- (instancetype)initWithFrame:(CGRect)frame icon:(NSString*)icon;

- (void)setIcon:(NSString*)iconString
           size:(CGSize)size;


@end
