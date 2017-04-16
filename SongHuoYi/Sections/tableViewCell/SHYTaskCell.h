//
//  SHYTaskCell.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseCell.h"
#import "SHYIconLabel.h"
#import "SHYTaskModel.h"

@interface SHYTaskCell : SHYBaseCell

@property (nonatomic, strong) SHYTaskModel *model;

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIImageView * rightIconView;


@property (nonatomic, strong) NSMutableArray * labelArray;
@property (nonatomic, strong) UIButton * enterBtn;//进入核货
@property (nonatomic, strong) UIButton * startBtn;

@property (nonatomic, copy) void(^startBtnClickBlock) (id);
@property (nonatomic, copy) void(^enterBtnClickBlock) (id);

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                   labelCount:(NSInteger)count;
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                   labelCount:(NSInteger)count
                enterBtnIndex:(NSInteger)enterBtnIndex;
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                   labelCount:(NSInteger)count
                enterBtnIndex:(NSInteger)enterBtnIndex
                    bottomBtn:(BOOL)hidenBottomBtn;

- (instancetype)initWithFrame:(CGRect)frame labelCount:(NSInteger)count;
- (instancetype)initWithFrame:(CGRect)frame labelCount:(NSInteger)count enterBtnIndex:(NSInteger)enterBtnIndex;

- (void)setCellModel:(SHYBaseModel *)model;

@end
