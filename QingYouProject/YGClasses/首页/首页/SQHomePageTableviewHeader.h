//
//  SQHomePageTableviewHeader.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/11.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  首页tableview的headerview，包含顶部轮播图，轮播图下面四个icon，今日头条轮播，今日头条下面三个子项目

#import <UIKit/UIKit.h>


@protocol SQHomeTableViewHeaderDelegate

- (void)clickedBannerWithModel:(NSString    *)model;

- (void)clickedProjectsIconWithModel:(NSString  *)model;

- (void)clickedTodyNewsWithModel:(NSString  *)model;

@end



@interface SQHomePageTableviewHeader : UIView

@property (nonatomic, weak) SQHomePageTableviewHeader       *delegate;

@property (nonatomic, strong) SDCycleScrollView     *homeBannerView;
@property (nonatomic, strong) UIView                *homeTopProjectsIcon;
@property (nonatomic, strong) UIView                *todayNews;
@property (nonatomic, strong) UIView                *subProjectsIcon;

@end
