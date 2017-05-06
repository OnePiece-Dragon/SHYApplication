//
//  SHYHeaderView.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/5/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYHeaderView.h"

@interface SHYHeaderView()

@property(nonatomic, strong) UILabel * titleLabel;
@property(nonatomic, strong) UIImageView *iconImage;

@end

@implementation SHYHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.iconImage];
        kWeakSelf(self);
        
        _titleLabel.userInteractionEnabled = YES;
        _iconImage.userInteractionEnabled = YES;
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(weakself).offset(8);
            make.right.equalTo(weakself).offset(-80);
            make.bottom.equalTo(weakself).offset(-8);
        }];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself).offset(-8);
            make.centerY.equalTo(weakself.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
        [self addGestureRecognizer:[UITapGestureRecognizer.alloc initWithTarget:self action:@selector(tapActionExpend)]];
    }
    return self;
}

- (void)setSectionModel:(SHYSectionModel *)sectionModel {
    _sectionModel = sectionModel;
    
    self.titleLabel.text = sectionModel.sectionTitle;
    self.iconImage.image = sectionModel.iconImage;
}

- (void)tapActionExpend{
    DLog(@"tapHeaderView");
    self.sectionModel.isExpanded = !self.sectionModel.isExpanded;
    if (self.expandCallback) {
        self.expandCallback(self.sectionModel.isExpanded);
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}
- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [UIImageView new];
    }
    return _iconImage;
}

@end
