//
//  YGStartPageView.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/7/27.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGStartPageView.h"

@implementation YGStartPageView
{
    UIPageControl *_pageControl;
}
- (instancetype)initWithLocalPhotoNamesArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        _localPhotoNamesArray = array;
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    self.frame = [UIScreen mainScreen].bounds;
    
    //scrollview
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight)];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(YGScreenWidth *(_localPhotoNamesArray.count + 1), scrollView.height);
    scrollView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    //page
    UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, YGScreenHeight -  40, YGScreenWidth, 10)];
    page.currentPage = 0;
    page.currentPageIndicatorTintColor = colorWithLightGray;
    page.pageIndicatorTintColor = colorWithTable;
    page.numberOfPages = _localPhotoNamesArray.count;
    [self addSubview:page];
    _pageControl = page;
    
    
    for (int i = 0; i<_localPhotoNamesArray.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        imageView.x = i * YGScreenWidth;
        imageView.image = [UIImage imageNamed:_localPhotoNamesArray[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview:imageView];
        if (i == _localPhotoNamesArray.count-1) {
            UIButton *noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            noticeBtn.frame = CGRectMake(YGScreenWidth/2-100, YGScreenHeight-100, 200, 45);
            noticeBtn.titleLabel.font = KFONT(32);
            [noticeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
            [noticeBtn setTitle:@"马上体验" forState:UIControlStateNormal];
            [noticeBtn setBackgroundImage:[UIImage imageNamed:@"guide_btn"] forState:UIControlStateNormal];
            [noticeBtn addTarget:self action:@selector(didLaunched) forControlEvents:UIControlEventTouchUpInside];
            [noticeBtn.imageView sizeToFit];
            noticeBtn.centerx = self.centerx;
            [imageView addSubview:noticeBtn];
        }
    }
}

+(void)showWithLocalPhotoNamesArray:(NSArray *)array
{
    [[[self alloc]initWithLocalPhotoNamesArray:array] showView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x/YGScreenWidth;
    //如果不是最后一页，正常变page
    if (index != _localPhotoNamesArray.count)
    {
        _pageControl.currentPage = index;
    }
    //如果是最后一页,把自己干掉
    else
    {
        [self didLaunched];
    }
}

-(void)showView
{
    [YGAppDelegate.window addSubview:self];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float index = scrollView.contentOffset.x/YGScreenWidth;
    
    if (index>_localPhotoNamesArray.count - 1)
    {
        float offsetX = scrollView.contentOffset.x - YGScreenWidth *(_localPhotoNamesArray.count - 1);
        float alpha = 1.0/YGScreenWidth * offsetX;
        scrollView.alpha = 1 - alpha;
    }
    else
    {
        scrollView.alpha = 1;
    }
    
}

/** 引导页执行完毕  */
- (void)didLaunched {
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTI_LASTLAUNCHPAGE object:nil];
    [YGUserDefaults setObject:@"1" forKey:USERDEF_FIRSTOPENAPP];
    [self removeFromSuperview];
}
@end
