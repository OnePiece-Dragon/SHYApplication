//
//  SHYSegmentView.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/8.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYSegmentView.h"

@interface SHYSegmentView()<UIScrollViewDelegate>

{
    CGFloat _width;
    CGFloat _height;
    
    NSInteger _lastSelected;
}

@end

@implementation SHYSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)setViewArray:(NSArray *)viewArray {
    _viewArray = viewArray;
    
    UIView * view = (UIView*)viewArray.firstObject;
    self.scrollView.frame = view.bounds;
    _width = view.width;
    _height = view.height;
    int i = 0;
    for (UIView * view in viewArray) {
        view.x = _width*(i++);
        [self.scrollView addSubview:view];
        [self.scrollView setContentSize:CGSizeMake(CGRectGetMaxX(view.frame), _height)];
    }
}

- (void)setPageIndex:(NSInteger)index {
    if (index < _viewArray.count) {
        [self.scrollView setContentOffset:CGPointMake(_width*index, 0) animated:YES];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSInteger page = (scrollView.contentOffset.x + _width/2.f) / _width;
    //NSLog(@"s_page:%ld",page);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //NSInteger page = scrollView.contentOffset.x / _width;
    //_lastSelected = page;
    //NSLog(@"scrollViewWillBeginDragging");
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger page = (scrollView.contentOffset.x + _width/2.f) / _width;
    if (self.scrollPageBlock) {
        self.scrollPageBlock(page);
    }
    NSLog(@"scrollViewDidEndDragging");
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView.alloc init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

@end
