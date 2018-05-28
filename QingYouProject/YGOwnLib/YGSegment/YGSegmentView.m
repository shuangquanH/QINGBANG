//
//  YGSegmentView.m
//  FindingSomething
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YGSegmentView.h"

#define lineViewHeight 2

@interface YGSegmentView ()
@property (nonatomic, strong) NSArray * titlesArray;
@property (nonatomic, strong) UIColor * lineColor;
@end

@implementation YGSegmentView {
    UIView *_lineView;
    UIScrollView *_topScrollView;
}
- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titlesArray lineColor:(UIColor *)lineColor delegate:(id)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame=frame;
        self.titlesArray= titlesArray;
        self.lineColor = lineColor;
        self.delegate = delegate;
        [self configUI];
    }
    return self;
}

-(void)configUI {
    _topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.alwaysBounceHorizontal = YES;
    [self addSubview:_topScrollView];
    int baseViewWidth = self.width/_titlesArray.count;
    
    //线
    _lineView=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-lineViewHeight, self.width/_titlesArray.count, lineViewHeight)];
    _lineView.backgroundColor = _lineColor;
    [_topScrollView addSubview:_lineView];
    
    for (int i=0; i<_titlesArray.count; i++) {
        UIButton *segmentButton=[UIButton buttonWithType:UIButtonTypeCustom];
        segmentButton.tag=100+i;
        [segmentButton setTitle:_titlesArray[i] forState:UIControlStateNormal];
        [segmentButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
        [segmentButton setTitleColor:_lineColor forState:UIControlStateSelected];
        [segmentButton addTarget:self action:@selector(segmentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        segmentButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        segmentButton.frame=CGRectMake(baseViewWidth * i, 0, baseViewWidth,self.height-lineViewHeight);
        [_topScrollView addSubview:segmentButton];
        segmentButton.backgroundColor = kWhiteColor;
        if (i==0) {
            _lineView.width = [UILabel calculateWidthWithString:_titlesArray[i] textFont:segmentButton.titleLabel.font numerOfLines:1].width + 8;
            _lineView.centerx=segmentButton.centerx;
            segmentButton.selected=YES;
        }
        
        if (i == _titlesArray.count - 1) {
            _topScrollView.contentSize = CGSizeMake(self.width,self.height);
        }
    }
}

-(void)segmentButtonClick:(UIButton*)segBtn {
    [self selectButtonWithIndex:(int)segBtn.tag-100];
    [_delegate segmentButtonClickWithIndex:(int)segBtn.tag-100];
}

-(void)selectButtonWithIndex:(int)buttonIndex {
    [self disSelectAllButton];
    UIButton *segBtn=[self viewWithTag:100+buttonIndex];
    segBtn.selected=!segBtn.selected;
    _lineView.width = [UILabel calculateWidthWithString:_titlesArray[buttonIndex] textFont:segBtn.titleLabel.font numerOfLines:1].width + 8;
    [UIView animateWithDuration:0.25 animations:^{
        _lineView.centerx = segBtn.centerx;
    }];
    [segBtn showQAnimate];

}

-(void)disSelectAllButton {
    for (int i =0; i<_titlesArray.count; i++) {
        UIButton *segBtn = [self viewWithTag:100+i];
        segBtn.selected = NO;
    }
}



/** 隐藏下划线  */
- (void)hiddenBottomLine {
    [_lineView removeFromSuperview];
}
/** 设置标题font  */
- (void)setTitleFont:(UIFont    *)font {
    for (UIView *view in _topScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            ((UIButton   *)view).titleLabel.font = font;
        }
    }
}

@end
