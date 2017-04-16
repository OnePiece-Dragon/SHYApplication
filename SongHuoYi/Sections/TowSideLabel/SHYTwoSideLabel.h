//
//  SHYTwoSideLabel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseView.h"

@interface SHYTwoSideLabel : SHYBaseView

@property (nonatomic, strong) UIView * topLine;
@property (nonatomic, strong) UIView * bottomLine;

@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * rightLabel;
@property (nonatomic, strong) UIImageView * rightIcon;



- (void)setLeftStr:(NSString*)leftString
          rightStr:(NSString*)rightString
         rightIcon:(NSString*)icon;

- (void)setTopLineHiden:(BOOL)topHiden
            bottomHiden:(BOOL)bottomHiden;

@end
