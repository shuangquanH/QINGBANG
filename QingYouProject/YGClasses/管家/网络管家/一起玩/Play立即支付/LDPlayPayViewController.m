//
//  LDPlayPayViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/12.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDPlayPayViewController.h"
#import "LDVipImageView.h"//头部视图
#import "LDPayItemView.h"//支付View
#import "ResultViewController.h"//支付成功页
@interface LDPlayPayViewController ()<LDPayItemViewDelegate>
/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** 青币购支付 右侧Button  */
@property (nonatomic,strong) UIButton * scoreViewRightButton;
/** 青币购支付 coverButton  */
@property (nonatomic,strong) UIButton * coverButton;
/** 抵扣青币  */
@property (nonatomic,strong) UILabel * exchangeLable;
/** 还需支付的价格  */
@property (nonatomic,strong) UILabel * otherPayRightLable;
/** 定金价格  */
@property (nonatomic,strong) UILabel * orderPayRightLable;
/** 商品价格  */
@property (nonatomic,strong) NSString * priceString;
/** 确认支付 sureButton  */
@property (nonatomic,strong) UIButton * sureButton;
/** goodsView 商品信息View  */
@property (nonatomic,strong) UIView * goodsView;
/** 商品图片  */
@property (nonatomic,strong) UIImageView * goodsImageView;
/** 商品名称 */
@property (nonatomic,strong) UILabel * goodsName;
/** 商品时间  */
@property (nonatomic,strong) UILabel * goodsTimeLabel;
/** 商品地点  */
@property (nonatomic,strong) UILabel * goodsPlaceLabel;

@end

@implementation LDPlayPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.priceString = @"275.00";
    
    //网络请求
    [self sendRequest];
    //设置导航栏
    self.navigationItem.title = @"立即支付";
    //网络请求
    [self setupUI];
}
#pragma mark - 刷新数据
- (void)reloadData{
    //报名人信息
    self.otherPayRightLable.text = @"路黑(13554554555)";
    //商品图片
    self.goodsImageView.image = LDImage(@"1");
    //商品图片
    self.goodsName.text = @"做简历求职记";
    self.goodsName.font = LD14Font;

    //商品时间
    self.goodsTimeLabel.text = @"2017-08-28 09:00 至 2017-08-29 17:00";
    self.goodsTimeLabel.font = LD13Font;

    //商品地点
    self.goodsPlaceLabel.text = @"安徽艺术剧场";
    self.goodsPlaceLabel.font = LD13Font;
    
    //定金
    self.orderPayRightLable.attributedText = [@"￥275.00" ld_attributedStringFromNSString:@"￥275.00" startLocation:1 forwardFont:[UIFont systemFontOfSize:12] backFont:LD15Font forwardColor:kRedColor backColor:kRedColor];
    
}
#pragma mark - UI设置
- (void)setupUI{
    //头部背景视图高度
    CGFloat headerBackViewH = 100;
    //青币购支付背景视图高度
    CGFloat  scoreViewH = 50;
    //添加背景backScrollowView
    [self.view addSubview:self.backScrollowView];
    
    //添加确认支付按钮
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:@"确认支付" selectedTitle:@"" normalTitleColor:kWhiteColor selectedTitleColor:nil backGroundColor:LDMainColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:16];
    [self.sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat Y = kScreenH - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight - YGBottomMargin;
    
    self.sureButton.frame = CGRectMake(0, Y, kScreenW, YGNaviBarHeight + YGBottomMargin);
    
    if (iphoneX) {
        
        [self.sureButton setTitleEdgeInsets:UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0 )];
        
        if (@available(iOS 11.0, *)) {
            
            self.backScrollowView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            [self.sureButton setTitleEdgeInsets:UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0 )];
     
        } else {
            // Fallback on earlier versions
        }

    }
    
    
    [self.view addSubview:self.sureButton];
    
    //添加backScrollowView 容器视图
    UIView * container = [[UIView alloc] init];
    [self.backScrollowView addSubview:container];
    container.backgroundColor = kWhiteColor;
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(_backScrollowView).offset(0);
        make.width.offset(kScreenW);
    }];
    
    ///报名人信息
    UIView * otherPayLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    otherPayLineView.backgroundColor = LDEEPaddingColor;
    [container addSubview:otherPayLineView];

    UIView * otherPayView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, kScreenW, scoreViewH)];
    otherPayView.backgroundColor = kWhiteColor;
    [container addSubview:otherPayView];
    CGFloat otherPayW = [UILabel calculateWidthWithString:@"报名人信息" textFont:leftFont numerOfLines:1].width;
    UILabel * otherPayLable = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding, 0, otherPayW, scoreViewH)];
    otherPayLable.font = leftFont;
    otherPayLable.text = @"报名人信息";
    [otherPayView addSubview:otherPayLable];
    UILabel * otherPayRightLable = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding + otherPayW, 1, kScreenW - 2 * LDHPadding - otherPayW, scoreViewH)];
    self.otherPayRightLable = otherPayRightLable;
    self.otherPayRightLable.font = leftFont;
    otherPayRightLable.textAlignment = NSTextAlignmentRight;
    [otherPayView addSubview:otherPayRightLable];
    
 

    
    ///定金
    UIView * orderPayView = [[UIView alloc] initWithFrame:CGRectMake(0, 151, kScreenW, scoreViewH)];
    
    orderPayView.backgroundColor = kWhiteColor;
    [container addSubview:orderPayView];
    CGFloat orderPayW = [UILabel calculateWidthWithString:@"报名费" textFont:leftFont numerOfLines:1].width;
    UILabel * orderPayLable = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding, 0, orderPayW, scoreViewH)];
    orderPayLable.font = leftFont;
    orderPayLable.text = @"报名费";
    [orderPayView addSubview:orderPayLable];
    
    UILabel * orderPayRightLable = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding + orderPayW, 1, kScreenW - 2 * LDHPadding - orderPayW, scoreViewH)];
    orderPayRightLable.backgroundColor = kWhiteColor;
    self.orderPayRightLable = orderPayRightLable;
    self.orderPayRightLable.font = leftFont;
    orderPayRightLable.textAlignment = NSTextAlignmentRight;
    [orderPayView addSubview:orderPayRightLable];
    
    //商品信息
    [otherPayView addSubview:self.goodsView];
    //底部支付视图
    LDPayItemView * patView = [[LDPayItemView alloc] init];
    [patView showPayItemViewWithY:headerBackViewH + 2 * scoreViewH];
    [container addSubview:patView];
    patView.delegate = self;
    
    //container容器试视图,底部约束
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(patView.mas_bottom);
    }];
}
#pragma mark - 确认支付点击事件
- (void)sureButtonClick:(UIButton *)sureButton{
    
    ResultViewController * VC = [[ResultViewController alloc] init];
    
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - LDPayItemViewDelegate
- (void)payItemViewDidSelectedWitchItem:(NSInteger)itemNumber{
    switch (itemNumber) {
            
        case 0:
        {
            [YGAppTool showToastWithText:@"支付宝"];
        }
            break;
            
        case 1:
        {
            [YGAppTool showToastWithText:@"微信"];
        }
            break;
        case 2:
        {
            [YGAppTool showToastWithText:@"银行卡"];
            
        }
            break;
    }
    
}
#pragma mark - 青币购支付点击事件
- (void)coverButtonClick:(UIButton *)coverButton{
    
    self.coverButton.selected = !self.coverButton.selected;
    self.scoreViewRightButton.selected = !self.scoreViewRightButton.selected;
    
    CGFloat priceFloat = [self.priceString floatValue];
    
    NSString * price = @"";
    
    if (!self.coverButton.selected) {
        
        price = [NSString stringWithFormat:@"￥%.2f",priceFloat];
        
    }else{
        
        priceFloat = priceFloat - 25;
        
        price = [NSString stringWithFormat:@"￥%.2f",priceFloat];
        
        
    }
    
    self.otherPayRightLable.attributedText = [price ld_attributedStringFromNSString:price startLocation:1 forwardFont:[UIFont systemFontOfSize:12] backFont:[UIFont systemFontOfSize:17] forwardColor:LD9ATextColor backColor:kRedColor];
}
#pragma mark - 网络请求数据
- (void)sendRequest{
    
    [YGNetService showLoadingViewWithSuperView:self.view];
    
    //获取全局并发队列
    dispatch_queue_t globleQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //异步任务执行时间
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC));
    
    dispatch_after(delayTime, globleQueue, ^{
        
        //异步返回主线程，根据获取的数据，更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self reloadData];
            [YGNetService dissmissLoadingView];
        });
        
    });
    
}
- (UIScrollView *)backScrollowView{
    if (!_backScrollowView) {
        CGRect rect = CGRectMake(0, 0, kScreenW, kScreenH - YGNaviBarHeight - YGStatusBarHeight);
        _backScrollowView.alwaysBounceVertical = YES;
        _backScrollowView = [[UIScrollView alloc] initWithFrame:rect];
        _backScrollowView.backgroundColor = kWhiteColor;
    }
    return _backScrollowView;
}

- (UIView *)goodsView{
    if (!_goodsView) {
        CGFloat goodsViewY = 50;
        CGFloat goodsViewH = 100;

        _goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, goodsViewY, kScreenW, LDVPadding)];
        _goodsView.backgroundColor = kYellowColor;
        //分割线
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, LDVPadding)];
        lineView.backgroundColor = LDEFPaddingColor;
        [_goodsView addSubview:lineView];
        //商品View
        UIView * detaileView = [[UIView alloc] initWithFrame:CGRectMake(0, LDVPadding, kScreenW, goodsViewH)];
        detaileView.backgroundColor = kWhiteColor;
        [_goodsView addSubview:detaileView];
        
        //商品View子试图 = 图片
        UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LDHPadding, LDVPadding, 2 * (goodsViewH - 3 * LDVPadding), goodsViewH - 3 * LDVPadding)];
        self.goodsImageView = leftImageView;
        [detaileView addSubview:leftImageView];
        
        //商品View子试图 = 名称
        self.goodsName = [UILabel new];
        [detaileView addSubview:self.goodsName];
        [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(LDHPadding);
            make.right.offset(-LDHPadding);
            make.top.equalTo(self.goodsImageView.mas_top).offset(0);
        }];
        
        //商品View子试图 = 时间
        self.goodsTimeLabel = [UILabel new];
        [detaileView addSubview:self.goodsTimeLabel];

        [self.goodsTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(LDHPadding);
            make.right.offset(-LDHPadding);
        make.centerY.equalTo(self.goodsImageView.mas_centerY);
            
        }];
        //商品View子试图 = 地点
        self.goodsPlaceLabel = [UILabel new];
        [detaileView addSubview:self.goodsPlaceLabel];

        [self.goodsPlaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsImageView.mas_right).offset(LDHPadding);
            make.right.offset(-LDHPadding);
            make.bottom.equalTo(self.goodsImageView.mas_bottom);
            
        }];
        
        UIView * otherPayViewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 99, kScreenW, 1)];
        otherPayViewLine.backgroundColor = LDEFPaddingColor;
        [_goodsView addSubview:otherPayViewLine];
    }
    return _goodsView;
    
    
}


















@end
