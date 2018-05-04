//
//  CooperationCaseViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CooperationCaseViewController.h"

@interface CooperationCaseViewController ()<SDCycleScrollViewDelegate>
/** 顶部居中title文字label  */
@property (nonatomic,strong) UILabel * topCenterLabel;
/** 顶部描述文字label  */
@property (nonatomic,strong) UILabel * topLabel;
/** 底部文字标题文字  */
@property (nonatomic,strong) UILabel * bottomTitleLabel;
/** 底部详细描述文字  */
@property (nonatomic,strong) UILabel * bottomDetailLabel;
/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** 轮播图  */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end

@implementation CooperationCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //网络请求
    [self sendRequest];
    
    //设置导航栏
    self.navigationItem.title = @"合作案例";
    
    //设置UI视图
    [self setupUI];
    
}

#pragma mark - 设置UI视图
- (void)setupUI{
    
    //背景scrollowView
    UIScrollView * backScrollowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - YGNaviBarHeight - YGStatusBarHeight)];
    backScrollowView.backgroundColor = kWhiteColor;
    [self.view addSubview:backScrollowView];
    self.backScrollowView = backScrollowView;
    
    UIView * container = [[UIView alloc] init];
    container.backgroundColor = kWhiteColor;
    [self.backScrollowView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.left.right.offset(0);
        make.width.equalTo(backScrollowView);
        
    }];
    
    
    //顶部title视图
    self.topCenterLabel = [UILabel new];
    self.topCenterLabel.numberOfLines = 0;
    [container addSubview:self.topCenterLabel];
    [self.topCenterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(-LDHPadding);
        make.top.offset(2 * LDVPadding);
    }];
    
    //顶部描述文字试图
    self.topLabel = [UILabel new];
    self.topLabel.numberOfLines = 0;
    [container addSubview:self.topLabel];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(-LDHPadding);
        make.top.equalTo(self.topCenterLabel.mas_bottom).offset(2 * LDVPadding);
        
    }];
 
    //中部图片视图
    UIView * headerView = [UIView new];
    [container addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLabel.mas_bottom).offset(2 * LDVPadding);
        make.right.offset(-LDHPadding);
        make.left.offset(LDHPadding);
        make.height.offset((LDVPadding, kScreenW - 2 * LDHPadding) / (35 / 17));
    }];
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW - 2 * LDHPadding, (LDVPadding, kScreenW - 2 * LDHPadding) / (35 / 17)) delegate:self placeholderImage:YGDefaultImgFour_Three];
    _cycleScrollView.autoScrollTimeInterval = 3;
    [headerView addSubview:self.cycleScrollView];
    
    //底部试图
    self.bottomTitleLabel = [UILabel new];
    self.bottomTitleLabel.numberOfLines = 0;
    [container addSubview:self.bottomTitleLabel];
    [self.bottomDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(-LDHPadding);
        make.top.equalTo(headerView.mas_bottom).offset(2 * LDVPadding);
        make.bottom.equalTo(container.mas_bottom).offset(-20);
    }];
    
    self.bottomTitleLabel = [UILabel new];
    self.bottomTitleLabel.numberOfLines = 0;
    [container addSubview:self.bottomTitleLabel];
    [self.bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(-LDHPadding);
        make.top.equalTo(headerView.mas_bottom).offset(2 * LDVPadding);
        
    }];
    
    
    
    UILabel * bottomDetailLabel = [UILabel new];
    bottomDetailLabel.numberOfLines = 0;
    self.bottomDetailLabel = bottomDetailLabel;
    [container addSubview:self.bottomDetailLabel];
    [self.bottomDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(-LDHPadding);
        make.top.equalTo(self.bottomTitleLabel.mas_bottom).offset(2 * LDVPadding);
        make.bottom.equalTo(container.mas_bottom).offset(-20);
        
    }];
    
    //假数据
    //顶部标题
    self.topCenterLabel.font= LDFont(18);
    self.topCenterLabel.textAlignment = NSTextAlignmentCenter;
    //顶部描述文字
    self.topLabel.font= LDFont(14);
    //底部标题
    self.bottomTitleLabel.font = LDFont(15);
    //底部详细描述
    self.bottomDetailLabel.font = LDFont(14);
    self.topLabel.textColor = LD16TextColor;
    headerView.backgroundColor = kWhiteColor;
    _cycleScrollView.backgroundColor = kClearColor;
    self.bottomDetailLabel.textColor = LD9ATextColor;
    
    //NSString * textStr = @"轻轻的我走了,正如我轻轻的来,我轻轻的招手,作别西天的云彩,那河畔的金柳, 是夕阳中的新娘,波光里的艳影,在我的心头荡漾,软泥上的青荇,油油的在水底招摇,在康河的柔波里,我甘心做一条水草,那榆荫下的一潭,不是清泉袁是天上虹,揉碎在浮藻间,沉淀着彩虹似的梦,寻梦撑一支长篙,向青草更青处漫溯,满载一船星辉,在星辉斑斓里放歌,但我不能放歌,悄悄是别离的笙箫,夏虫也为我沉默,沉默是今晚的康桥!悄悄的我走了,正如我悄悄的来,我挥一挥衣袖,不带走一片云彩.";
    
    //    self.bottomLabel.attributedText = [textStr ld_getAttributedStringWithString:textStr lineSpace:LDVPadding];
    
    //self.topLabel.attributedText = [textStr ld_getAttributedStringWithString:textStr lineSpace:LDVPadding];
    
}
#pragma mark - 网络请求
- (void)sendRequest{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //设置数据
        self.cycleScrollView.imageURLStringsGroup = @[@"2",@"5",@"7"];
        NSString * textStr = @"轻轻的我走了,正如我轻轻的来,我轻轻的招手,作别西天的云彩,那河畔的金柳, 是夕阳中的新娘,波光里的艳影,在我的心头荡漾,软泥上的青荇,油油的在水底招摇,在康河的柔波里,我甘心做一条水草,那榆荫下的一潭,不是清泉袁是天上虹,揉碎在浮藻间,沉淀着彩虹似的梦,寻梦撑一支长篙,向青草更青处漫溯,满载一船星辉,在星辉斑斓里放歌,但我不能放歌,悄悄是别离的笙箫,夏虫也为我沉默,沉默是今晚的康桥!悄悄的我走了,正如我悄悄的来,我挥一挥衣袖,不带走一片云彩.";
        
        self.bottomDetailLabel.attributedText = [textStr ld_getAttributedStringWithString:textStr lineSpace:LDVPadding];
        
        self.topLabel.attributedText = [textStr ld_getAttributedStringWithString:textStr lineSpace:LDVPadding];
        self.topCenterLabel.text = @"青网科技合作案例";
        self.bottomTitleLabel.text = @"向青草更青处漫溯";
        LDLog(@"22222");

    });
    
    LDLog(@"线程被部署");
    
}
#pragma mark - 轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [YGAppTool showToastWithText:[NSString stringWithFormat:@"点击了第%ld张图片",index]];
    
}


@end
