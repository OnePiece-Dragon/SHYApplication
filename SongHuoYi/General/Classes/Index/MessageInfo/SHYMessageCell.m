//
//  SHYMessageCell.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/19.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYMessageCell.h"

@implementation SHYMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.infoLabel.font = kFont(14);
        
        self.infoLabel.textColor = [UIColor grayColor];
        [self addSubview:self.titleLabel];
        kWeakSelf(self);
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(weakself).offset(8);
            make.right.equalTo(weakself).offset(-8);
            make.height.mas_equalTo(@26);
        }];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakself.titleLabel);
            make.bottom.equalTo(weakself).offset(-8);
            make.top.equalTo(weakself.titleLabel.mas_bottom).offset(8);
        }];
    }
    return self;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel.alloc init];
    }
    return _titleLabel;
}
- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [UILabel.alloc init];
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}
@end
