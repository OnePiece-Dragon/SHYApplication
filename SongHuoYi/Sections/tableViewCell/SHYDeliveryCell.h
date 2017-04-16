//
//  SHYDeliveryCell.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/8.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseCell.h"

@interface SHYDeliveryCell : SHYBaseCell

@property (nonatomic, strong) NSMutableArray * rowArray;
@property (nonatomic, strong) UIButton * seeDetailBtn;
@property (nonatomic, strong) UIButton * endDeliveryBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    lineCount:(NSInteger)count;

@end
