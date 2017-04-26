//
//  SHYHelpCenterCell.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/26.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYHelpCenterCell.h"

@implementation SHYHelpCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.titleLabel];
        kWeakSelf(self);
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(weakself).offset(8);
            make.right.bottom.equalTo(weakself).offset(-8);
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

@end
