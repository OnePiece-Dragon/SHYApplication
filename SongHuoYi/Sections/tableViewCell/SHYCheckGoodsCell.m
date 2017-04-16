//
//  SHYCheckGoodsCell.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/8.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYCheckGoodsCell.h"

@implementation SHYCheckGoodsCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    direction:(Goods_Direction)direction {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = COLOR_WHITE;
        [self addSubview:self.backView];
        [self.backView addSubview:self.labelView];
        
        _labelView.rightLabel.textAlignment = NSTextAlignmentRight;
        
        __weak typeof(self) wSelf = self;
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf).offset(8);
            make.right.equalTo(wSelf).offset(-8);
            make.top.bottom.equalTo(wSelf);
        }];
        [self.labelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(wSelf.backView);
        }];
        //_backView.backgroundColor =[UIColor greenColor];
        switch (direction) {
            case None:
            {
                [Factory boraderLayer:self.backView rect:CGRectMake(0, 0, SCREEN_WIDTH - 16, 60) roundCorner:0];
            }
            break;
            case Top:
            {
                [Factory boraderLayer:self.backView rect:CGRectMake(0, 0, SCREEN_WIDTH - 16, 60) roundCorner:UIRectCornerTopLeft|UIRectCornerTopRight];
            }
            break;
            case Bottom:
            {
                [Factory boraderLayer:self.backView rect:CGRectMake(0, 0, SCREEN_WIDTH - 16, 60) roundCorner:UIRectCornerBottomLeft|UIRectCornerBottomRight];
            }
            break;
            default:
                break;
        }
        
    }
    return self;
}
- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView.alloc init];
    }
    return _backView;
}
- (SHYLeftRightLabel *)labelView {
    if (!_labelView) {
        _labelView = [SHYLeftRightLabel.alloc initWithFrame:CGRectZero];
    }
    return _labelView;
}

@end
