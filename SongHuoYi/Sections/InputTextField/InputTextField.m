//
//  InputTextField.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/5.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "InputTextField.h"

@implementation InputTextField

- (instancetype)initWithFrame:(CGRect)frame
                  placeHolder:(NSString *)placeHolder
                     leftIcon:(NSString *)leftIcon
                    rightIcon:(NSString *)rightIcon {
    if ([super initWithFrame:frame]) {
        [self addSubview:self.inputTextField];
        
        if (leftIcon) {
            self.leftIcon.image = [UIImage imageNamed:leftIcon];
        }
        if (rightIcon) {
            self.rightIcon.image = [UIImage imageNamed:rightIcon];
        }
        
        self.inputTextField.leftView = self.leftIcon;
        self.inputTextField.rightView = self.rightIcon;
        if (placeHolder) {
            self.inputTextField.placeholder = placeHolder;
        }
        
        self.inputTextField.leftViewMode = UITextFieldViewModeNever;
        self.inputTextField.rightViewMode = UITextFieldViewModeNever;
        
        __weak typeof(self) weakSelf = self;
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(weakSelf);
        }];
    }
    return self;
}

- (void)setIconSize:(CGSize)size direction:(Direction)direction {
    switch (direction) {
        case Left:
        {
            self.leftIcon.size = size;
        }
        break;
        case Right:
        {
            self.rightIcon.size = size;
        }
        break;
        default:
            break;
    }
}

- (void)setFieldMode:(UITextFieldViewMode)mode direction:(Direction)direction {
    switch (direction) {
        case Left:
        {
            self.inputTextField.leftViewMode = mode;
        }
        break;
        case Right:
        {
            self.inputTextField.rightViewMode = mode;
        }
        break;
        default:
            break;
    }
}


- (CustomTextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [CustomTextField.alloc initWithFrame:self.bounds];
        //_inputTextField.backgroundColor = [UIColor yellowColor];
    }
    return _inputTextField;
}

- (UIImageView *)leftIcon {
    if (!_leftIcon) {
        _leftIcon = [UIImageView.alloc initWithFrame:CGRectMake(0, 0, 32, 32)];
    }
    return _leftIcon;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [UIImageView.alloc initWithFrame:CGRectMake(0, 0, 32, 32)];
    }
    return _rightIcon;
}

@end
