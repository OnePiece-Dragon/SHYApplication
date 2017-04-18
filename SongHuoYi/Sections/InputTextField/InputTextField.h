//
//  InputTextField.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/5.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "CustomTextField.h"
#import "UIView+Ext.h"

typedef NS_ENUM(NSInteger,Direction) {
    Left = 0,
    Right
};

@interface InputTextField : UIView

@property (nonatomic, strong) CustomTextField * inputTextField;
@property (nonatomic, strong) UIImageView * leftIcon;
@property (nonatomic, strong) UIImageView * rightIcon;

@property (nonatomic, copy) NSString * placeHolder;

- (instancetype)initWithFrame:(CGRect)frame
                  placeHolder:(NSString*)placeHolder
                     leftIcon:(NSString*)leftIcon
                    rightIcon:(NSString*)rightIcon;

- (void)setIconSize:(CGSize)size direction:(Direction)direction;

- (void)setFieldMode:(UITextFieldViewMode)mode direction:(Direction)direction;

@end
