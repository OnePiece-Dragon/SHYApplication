//
//  SHYIndexItemView.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/5.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYIndexItemView.h"

@implementation SHYIndexItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if ([super init]) {
        [self addSubview:self.backgroundImage];
        [self.backgroundImage addSubview:self.titleLabel];
        [self.backgroundImage addSubview:self.descLabel];
        
        __weak typeof(self) weakSelf = self;
        [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(weakSelf);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.backgroundImage.mas_top).offset(10);
            make.right.equalTo(weakSelf.backgroundImage.mas_right).offset(-8);
            make.left.equalTo(weakSelf.backgroundImage.mas_left).offset(8);
            make.height.mas_equalTo(36);
        }];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(5);
            make.left.right.equalTo(weakSelf.titleLabel);
            make.height.mas_offset(44);
        }];
    }
    return self;
}

- (UIImageView *)backgroundImage {
    if (!_backgroundImage) {
        _backgroundImage = [UIImageView.alloc init];
        
        _backgroundImage.userInteractionEnabled = YES;
    }
    return _backgroundImage;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel.alloc init];
        
        _titleLabel.userInteractionEnabled = YES;
    }
    return _titleLabel;
}
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [UILabel.alloc init];
        
        _descLabel.userInteractionEnabled = YES;
    }
    return _descLabel;
}
@end
