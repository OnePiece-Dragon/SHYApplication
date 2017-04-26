//
//  SHYLeftRightLabel.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/8.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYLeftRightLabel.h"

@implementation SHYLeftRightLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        
        _leftLabel.userInteractionEnabled = YES;
        _rightLabel.userInteractionEnabled = YES;
        
        __weak typeof(self) weakSelf = self;
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(weakSelf);
            make.left.equalTo(weakSelf).offset(8);
            make.right.equalTo(weakSelf.rightLabel.mas_left);
        }];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(weakSelf);
            make.right.equalTo(weakSelf).offset(-8);
            make.width.mas_greaterThanOrEqualTo(@80);
        }];
    }
    return self;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel.alloc init];
    }
    return _leftLabel;
}
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [UILabel.alloc init];
    }
    return _rightLabel;
}

@end
