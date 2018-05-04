//
//  YGScollTitleView.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/5.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "YGScollTitleView.h"

@interface YGScollTitleView()


@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *titleButtons;

@property (nonatomic, strong) UILabel *selectionIndicator;

@property (nonatomic, assign) BOOL  setDefult;

@end

@implementation YGScollTitleView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self initData];
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self setupUI];
    }
    return self;
}

- (void)initData{
    self.selectedIndex = 0;
    self.normalColor = [UIColor blackColor];
    self.selectedColor = self.selectedColor;
    self.titleWidth = 85.f;
    self.indicatorHeight = 2.f;
    self.titleFont = [UIFont systemFontOfSize:14.f];
    self.titleButtons = [[NSMutableArray alloc] init];
}

- (void)setupUI{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.selectionIndicator = [[UILabel alloc] initWithFrame:self.frame];
    self.selectionIndicator.textColor  = colorWithMainColor;
    self.selectionIndicator.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    self.selectionIndicator.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.selectionIndicator];
    
    self.setDefult = NO;
}

- (void)reloadViewWithTitles:(NSArray *)titles{
    
    for (UIButton *btn in self.titleButtons) {
        [btn removeFromSuperview];
    }
    NSInteger i = 0;
    for (NSString *title in titles) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == self.selectedIndex && self.setDefult == NO) {
            btn.selected = YES;
        }
        btn.tag = 100 + i++;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = self.titleFont;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectedColor forState:UIControlStateSelected];
        btn.titleLabel.numberOfLines = 0;
        [self.scrollView addSubview:btn];
        btn.contentMode = UIViewContentModeCenter;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleButtons addObject:btn];
    }
    [self layoutSubviews];
}

- (void)btnClick:(UIButton *)btn{
    NSInteger btnIndex = btn.tag - 100;
    if (btnIndex == self.selectedIndex) {
        return;
    }
    self.selectedIndex = btnIndex;
    if (self.selectedBlock) {
        self.selectedBlock(btnIndex);
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    
    self.scrollView.contentSize = CGSizeMake(self.titleButtons.count * self.titleWidth+15, self.frame.size.height);
    CGFloat width = 0.0f;
    //    NSInteger i = 0;
    for (UIButton *btn in self.titleButtons) {
        [btn sizeToFit];
        btn.frame = CGRectMake(width, 0, btn.width+20, self.frame.size.height);
        width += btn.width;
    }
    self.scrollView.contentSize = CGSizeMake(width, self.frame.size.height);
    [self setSelectedIndicator:NO];
    [self.scrollView bringSubviewToFront:self.selectionIndicator];
}

- (void)setSelectedIndicator:(BOOL)animated {
    [UIView animateWithDuration:(animated? 0.02 : 0) delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (_selectedIndex >0) {
            self.selectionIndicator.frame = CGRectMake(((UIButton *)self.titleButtons[_selectedIndex-1]).x+((UIButton *)self.titleButtons[_selectedIndex-1]).width, self.frame.size.height - self.indicatorHeight, ((UIButton *)self.titleButtons[_selectedIndex]).width, self.indicatorHeight);
            
        }else
        {
            self.selectionIndicator.frame = CGRectMake(0, self.frame.size.height - self.indicatorHeight, ((UIButton *)self.titleButtons[_selectedIndex]).width, self.indicatorHeight);
            
        }
    } completion:^(BOOL finished) {
        [self scrollRectToVisibleCenteredOn:self.selectionIndicator.frame animated:YES];
    }];
}

- (void)scrollRectToVisibleCenteredOn:(CGRect)visibleRect animated:(BOOL)animated {
    CGRect centeredRect = CGRectMake(visibleRect.origin.x + visibleRect.size.width / 2.0 - self.scrollView.frame.size.width / 2.0,
                                     visibleRect.origin.y + visibleRect.size.height / 2.0 - self.scrollView.frame.size.height / 2.0,
                                     self.scrollView.frame.size.width,
                                     self.scrollView.frame.size.height);
    [self.scrollView scrollRectToVisible:centeredRect animated:animated];
}

#pragma mark - setter

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (_selectedIndex == selectedIndex) {
        return;
    }
    UIButton *btn = [self.scrollView viewWithTag:_selectedIndex + 100];
    btn.selected = NO;
    _selectedIndex = selectedIndex;
    UIButton *selectedBtn = [self.scrollView viewWithTag:_selectedIndex + 100];
    selectedBtn.selected = YES;
    [self setSelectedIndicator:YES];
}

- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
}

- (void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor = selectedColor;
}

- (void)setTitleWidth:(CGFloat)titleWidth{
    _titleWidth = titleWidth;
    [self setNeedsLayout];
}

- (void)setIndicatorHeight:(CGFloat)indicatorHeight{
    _indicatorHeight = indicatorHeight;
    [self setNeedsLayout];
}

- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
}

- (void)selectDefult
{
    self.setDefult = YES;
    for (int i = 0;i< self.titleButtons.count;i++) {
        UIButton *btn = [self.scrollView viewWithTag:100+i];
        btn.selected = NO;
    }
    _selectedIndex = 100;
}
@end
