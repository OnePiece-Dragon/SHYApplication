//
//  SHYIconLabel.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYIconLabel.h"

@implementation SHYIconLabel

- (instancetype)initWithFrame:(CGRect)frame icon:(NSString *)icon {
    if ([super initWithFrame:frame]) {
        [self addSubview:self.iconImage];
        [self addSubview:self.titleLabel];
        
        _iconImage.image = [UIImage imageNamed:icon];
        
        __weak typeof(self) weakSelf = self;
        if (icon) {
            //有图
            [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf).offset(LINE_VER_SPACE/2.f);
                make.left.equalTo(weakSelf).offset(8);
                make.size.mas_equalTo(CGSizeMake(32, 32));
            }];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf);
                make.left.equalTo(weakSelf.iconImage.mas_right).offset(5);
                make.right.equalTo(weakSelf).offset(-8);
                make.centerY.equalTo(weakSelf);
            }];
        }else {
            [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf).offset(LINE_VER_SPACE/2.f);
                make.left.equalTo(weakSelf).offset(8);
                make.size.mas_equalTo(CGSizeZero);
            }];
            //没图
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf).offset(LINE_VER_SPACE);
                make.left.equalTo(weakSelf).offset(8);
                make.right.equalTo(weakSelf).offset(-8);
                make.bottom.equalTo(weakSelf).offset(-LINE_VER_SPACE);
            }];
        }
    }
    return self;
}

- (void)setIcon:(NSString *)iconString size:(CGSize)size {
    __weak typeof(self) weakSelf = self;
    if (iconString) {
        //有图片的情况
        _iconImage.image = [UIImage imageNamed:iconString];
        [self.iconImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
        }];
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(size.width + 16);
        }];
    }
}

-(UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [UIImageView.alloc init];
        
        _iconImage.userInteractionEnabled = YES;
    }
    return _iconImage;
}
-(CustomLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [CustomLabel.alloc init];
        
        _titleLabel.userInteractionEnabled = YES;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
@end
