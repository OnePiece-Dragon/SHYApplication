//
//  SHYTwoSideLabel.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYTwoSideLabel.h"

@interface SHYTwoSideLabel()

@end

@implementation SHYTwoSideLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self addSubview:self.rightTipsLabel];
        [self addSubview:self.rightIcon];
        [self addSubview:self.topLine];
        [self addSubview:self.bottomLine];
        
        _leftLabel.userInteractionEnabled = YES;
        _rightLabel.userInteractionEnabled = YES;
        _rightIcon.userInteractionEnabled = YES;
        
        _leftLabel.font = kFont(14);
        _rightLabel.font = kFont(14);
        _rightTipsLabel.font = kFont(14);
        
        kWeakSelf(self);
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself).offset(8);
            make.top.equalTo(weakself).offset(4);
            make.bottom.equalTo(weakself).offset(-4);
            make.right.lessThanOrEqualTo(weakself).offset(-SCREEN_WIDTH/3);
        }];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself).offset(-8);
            make.top.equalTo(weakself).offset(4);
            make.bottom.equalTo(weakself).offset(-4);
            make.left.lessThanOrEqualTo(weakself).offset(SCREEN_WIDTH*2/3);
        }];
        [self.rightTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakself).offset(4);
            make.bottom.equalTo(weakself).offset(-4);
            make.right.equalTo(weakself).offset(-8);
            make.width.equalTo(@0);
        }];
        [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakself);
            make.right.equalTo(weakself).offset(-8);
            make.size.mas_equalTo(CGSizeZero);
        }];
        
        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself).offset(8);
            make.right.equalTo(weakself).offset(-8);
            make.top.equalTo(weakself);
            make.height.mas_equalTo(@1);
        }];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself).offset(8);
            make.right.equalTo(weakself).offset(-8);
            make.bottom.equalTo(weakself);
            make.height.mas_equalTo(@1);
        }];
        
        [self setTopLineHiden:YES bottomHiden:NO];
    }
    return self;
}

- (void)setLeftStr:(NSString *)leftString
          rightStr:(NSString *)rightString
         rightIcon:(NSString *)icon {
    kWeakSelf(self);
    if (leftString && rightString) {
        //两个都有left 2/3  right 1/3
        self.leftLabel.text = leftString;
        self.rightLabel.text = rightString;
        
    }else if(leftString && !rightString){
        //只有left 1 space=8
        self.leftLabel.text = leftString;
        self.rightLabel.hidden = YES;
    }else if (!leftString && rightString) {
        //只有right space=8
        self.rightLabel.text = rightString;
//        [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(weakself).offset(8);
//        }];
        self.leftLabel.hidden = YES;
    }
    
    if (icon) {
        self.rightIcon.image = [UIImage imageNamed:icon];
        [self.rightIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakself);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
    }
    
}
- (void)setTopLineHiden:(BOOL)topHiden
            bottomHiden:(BOOL)bottomHiden {
    self.topLine.hidden = topHiden;
    self.bottomLine.hidden = bottomHiden;
}

- (void)updateRightTipsLabel {
    kWeakSelf(self);
    _rightLabel.numberOfLines = 1;
    [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself).offset(-60);
        
    }];
    [self.rightTipsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
    }];
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
        
        _rightLabel.numberOfLines = 0;
    }
    return _rightLabel;
}
- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [UIImageView.alloc init];
    }
    return _rightIcon;
}
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [UIView.alloc init];
        _topLine.hidden = YES;
        _topLine.backgroundColor = LINE_COLOR;
    }
    return _topLine;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView.alloc init];
        _bottomLine.hidden = YES;
        _bottomLine.backgroundColor = LINE_COLOR;
    }
    return _bottomLine;
}
- (UILabel *)rightTipsLabel {
    if (!_rightTipsLabel) {
        _rightTipsLabel = [UILabel.alloc init];
    }
    return _rightTipsLabel;
}
@end
