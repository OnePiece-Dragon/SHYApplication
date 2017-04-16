//
//  SHYGoodsDetailCell.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/8.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseCell.h"

@interface SHYGoodsDetailCell : SHYBaseCell

@property (nonatomic, strong) UIView * topLine;
@property (nonatomic, strong) UIView * bottomLine;

@property (nonatomic, strong) UILabel * leftTopLabel;
@property (nonatomic, strong) UILabel * leftBottomLabel;
@property (nonatomic, strong) UILabel * rightTopLabel;
@property (nonatomic, strong) UILabel * rightBottomLabel;

- (void)setLeftTopStr:(NSString*)leftTopStr
        leftBottomStr:(NSString*)leftBottomStr
          rightTopStr:(NSString*)rightTopStr
       rightBottomStr:(NSString*)rightBottomStr;

- (void)setTopLineHiden:(BOOL)topLine
        bottomLineHiden:(BOOL)bottomLine;

@end
