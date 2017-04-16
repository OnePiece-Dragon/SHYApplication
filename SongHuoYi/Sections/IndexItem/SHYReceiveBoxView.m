//
//  SHYReceiveBoxView.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYReceiveBoxView.h"

@implementation SHYReceiveBoxView
- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.leftLabel];
        [self addSubview:self.leftTextField];
        [self addSubview:self.midLabel];
        [self addSubview:self.midBtn];
        [self addSubview:self.rightLabel];
        
        __weak typeof(self) weakSelf = self;
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(8);
            make.centerY.equalTo(weakSelf);
            make.width.mas_lessThanOrEqualTo(@55);
            make.height.mas_equalTo(@36);
        }];
        [self.leftTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.leftLabel.mas_right);
            make.centerY.equalTo(weakSelf);
            make.right.equalTo(weakSelf.midLabel.mas_left);
            make.height.mas_equalTo(weakSelf.leftLabel);
        }];
        [self.midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.leftTextField.mas_right).offset(8);
            make.centerY.equalTo(weakSelf);
            make.height.mas_equalTo(weakSelf.leftTextField);
            make.width.mas_equalTo(@40);
        }];
        [self.midBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.midLabel.mas_right).offset(10);
            make.centerY.equalTo(weakSelf);
            make.height.mas_equalTo(weakSelf.leftLabel);
            make.width.mas_equalTo(@60);
        }];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.midBtn.mas_right).offset(10);
            make.centerY.equalTo(weakSelf);
            make.right.equalTo(weakSelf).offset(-8);
            make.height.mas_equalTo(weakSelf.leftLabel);
        }];
    }
    return self;
}

- (void)midBtnClick {
    //NSLog(@"蒂娜我");
    if (self.midBtnClickBlock) {
        self.midBtnClickBlock();
    }
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel.alloc init];
    }
    return _leftLabel;
}
- (UITextField *)leftTextField {
    if (!_leftTextField) {
        _leftTextField = [UITextField.alloc init];
    }
    return _leftTextField;
}
- (UILabel *)midLabel {
    if (!_midLabel) {
        _midLabel = [UILabel.alloc init];
    }
    return _midLabel;
}
- (UIButton *)midBtn {
    if (!_midBtn) {
        _midBtn = [Factory createBtn:CGRectZero title:@"" type:UIButtonTypeCustom target:self action:@selector(midBtnClick)];
    }
    return _midBtn;
}
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [UILabel.alloc init];
    }
    return _rightLabel;
}
@end
