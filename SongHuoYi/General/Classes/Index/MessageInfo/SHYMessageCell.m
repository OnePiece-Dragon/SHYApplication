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
        [self addSubview:self.titleLabel];
        __weak typeof(self) weakSelf = self;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(weakSelf).offset(8);
            make.right.bottom.equalTo(weakSelf).offset(-8);
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
