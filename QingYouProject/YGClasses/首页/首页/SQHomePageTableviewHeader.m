//
//  SQHomePageTableviewHeader.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/11.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQHomePageTableviewHeader.h"

#import "SMKCycleScrollView.h"



@implementation SQHomePageTableviewHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTopBannerView];
        [self addHomeTopProjectsIconsView];
        [self addTodayNewsView];
        [self addsubProjectsIconViews];
        self.frame = CGRectMake(0, 0, YGScreenWidth, self.subProjectsIcon.sqbottom+10);
    }
    return self;
}


- (void)addTopBannerView {
    self.homeBannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth/2) delegate:self placeholderImage:YGDefaultImgTwo_One];
    self.homeBannerView.autoScroll = YES;
    self.homeBannerView.infiniteLoop = YES;
    [self addSubview:self.homeBannerView];
}

- (void)addHomeTopProjectsIconsView {
    //功能按钮底部
    self.homeTopProjectsIcon = [[UIView alloc]initWithFrame:CGRectMake(0, _homeBannerView.y + _homeBannerView.height, YGScreenWidth, 0)];
    self.homeTopProjectsIcon.backgroundColor = colorWithYGWhite;
    [self addSubview:self.homeTopProjectsIcon];
    
    NSArray *imageNameArray = @[@{@"title":@"抢购",@"image":@"home_rushpurchase"},
                                @{@"title":@"一起玩",@"image":@"home_havefun"},
                                @{@"title":@"预约看房",@"image":@"home_ordertable"},
                                @{@"title":@"二手置换",@"image":@"home_secondhand"}];
    for (int i = 0; i<imageNameArray.count; i++) {
        UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(YGScreenWidth/4*i, 0, YGScreenWidth/4, 0)];
        [self.homeTopProjectsIcon addSubview:baseView];
        
        //小图
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageNameArray[i][@"image"]]];
        [imageView sizeToFit];
        imageView.y = 20;
        imageView.centerx = baseView.width/2;
        [baseView addSubview:imageView];
        
        //小文字
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        label.textColor = colorWithBlack;
        label.text = imageNameArray[i][@"title"];
        [label sizeToFitHorizontal];
        label.centerx = imageView.centerx;
        label.y = imageView.y + imageView.height + 10;
        [baseView addSubview:label];
        
        baseView.height = label.y + label.height + 20;
        
        //大button
        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, baseView.width, baseView.height)];
        coverButton.tag = 100 + i;
        [coverButton addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:coverButton];
        
        if (i == 0) {
            self.homeTopProjectsIcon.height = baseView.height;
            UIImageView *fireImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_hot.png"]];
            [fireImageView sizeToFit];
            fireImageView.centery = label.centery;
            fireImageView.x = label.x + label.width;
            [baseView addSubview:fireImageView];
        }
    }
}

- (void)addTodayNewsView {
    //热门推荐view
    self.todayNews = [[UIView alloc] initWithFrame:CGRectMake(0, self.homeTopProjectsIcon.sqbottom+10, YGScreenWidth, 60)];
    self.todayNews.backgroundColor = colorWithYGWhite;
    [self addSubview:self.todayNews];
    
    //今日头条icon
    UIImageView *todaysTopNewsImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_today_green"]];
    todaysTopNewsImageView.frame = CGRectMake(10, 10, 2, 20);
    [todaysTopNewsImageView sizeToFit];
    [self.todayNews addSubview:todaysTopNewsImageView];
    todaysTopNewsImageView.frame = CGRectMake(10, 30-todaysTopNewsImageView.height/2, todaysTopNewsImageView.width, todaysTopNewsImageView.height);
    
    //中间分割线
    UIImageView *leftLineImageView = [[UIImageView alloc]init];
    leftLineImageView.frame = CGRectMake(todaysTopNewsImageView.width+todaysTopNewsImageView.x+10, 5, 1, todaysTopNewsImageView.height-5);
    leftLineImageView.backgroundColor = colorWithLightGray;
    [self.todayNews addSubview:leftLineImageView];
    leftLineImageView.centery = todaysTopNewsImageView.centery;
    
    SMKCycleScrollView  * newsScrollView = [[SMKCycleScrollView alloc] init];
    newsScrollView.frame = CGRectMake(leftLineImageView.x+leftLineImageView.width+10, 0, YGScreenWidth-leftLineImageView.x-20, 35);
    newsScrollView.titleColor = colorWithLightGray;
    newsScrollView.titleFont = [UIFont systemFontOfSize:YGFontSizeNormal];
    [self.todayNews addSubview:newsScrollView];
    newsScrollView.centery = todaysTopNewsImageView.centery;
    newsScrollView.backColor = [UIColor whiteColor];
    /** 实现点击轮播广告的回调  */
    [newsScrollView setSelectedBlock:^(NSInteger index, NSString *title) {
        
    }];
}

- (void)addsubProjectsIconViews {
    self.subProjectsIcon = [[UIView alloc] initWithFrame:CGRectMake(0, self.todayNews.sqbottom, YGScreenWidth, 120)];
    self.subProjectsIcon.backgroundColor = kWhiteColor;
    [self addSubview:self.subProjectsIcon];
    CGFloat imageWidth = (YGScreenWidth-20)/3.0;
    for (int i = 0; i<3; i++) {
        UIButton    *projectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        projectButton.backgroundColor = [UIColor lightGrayColor];
        projectButton.frame = CGRectMake(5+(imageWidth+5)*i, 5, imageWidth, 100);
        [self.subProjectsIcon addSubview:projectButton];
        projectButton.tag = 1000+i;
        [projectButton addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}


/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"%ld", index);
}
/** 点击项目回调  */
- (void)coverButtonClick:(UIButton  *)sender {
    NSLog(@"%ld", sender.tag);
}

@end
