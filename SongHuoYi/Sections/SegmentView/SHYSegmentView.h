//
//  SHYSegmentView.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/8.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseView.h"

@interface SHYSegmentView : SHYBaseView

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) NSArray * viewArray;

@property (nonatomic, copy) void (^scrollPageBlock)(NSInteger);

- (void)setPageIndex:(NSInteger)index;

@end
