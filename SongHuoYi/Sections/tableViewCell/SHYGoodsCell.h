//
//  SHYGoodsCell.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseCell.h"
#import "SHYTwoSideLabel.h"


@interface SHYGoodsCell : SHYBaseCell

@property (nonatomic, strong) UIView * topView;

@property (nonatomic, strong) NSMutableArray * rowArray;
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        isAll:(BOOL)isAll
                    lineCount:(NSInteger)count;

- (void)addTopView;

@end
