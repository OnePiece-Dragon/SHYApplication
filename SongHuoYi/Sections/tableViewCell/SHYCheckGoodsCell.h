//
//  SHYCheckGoodsCell.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/8.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseCell.h"
#import "SHYLeftRightLabel.h"

typedef NS_ENUM(NSInteger,Goods_Direction) {
    None = 0,
    Top,
    Bottom
};

@interface SHYCheckGoodsCell : SHYBaseCell

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) SHYLeftRightLabel * labelView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    direction:(Goods_Direction)direction;

@end
