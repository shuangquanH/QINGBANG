//
//  HomePageLegalServiceLDPayViewController.m
//  QingYouProject
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "HomePageLegalServiceLDPayViewController.h"
#import "LDVipImageView.h"//头部视图
#import "LDPayItemView.h"//支付View
#import "ResultViewController.h"//支付成功页
#import <Pingpp.h>

@interface HomePageLegalServiceLDPayViewController ()<LDPayItemViewDelegate>
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
/** 商品价格  */
@property (nonatomic,strong) NSString * priceString;
/** 确认支付 sureButton  */
@property (nonatomic,strong) UIButton * sureButton;

@property (nonatomic, strong)  LDVipImageView * vipImageView;
@property (nonatomic,strong) NSString * pointPrice;

@property (nonatomic,strong) NSString * selectPayWay;
@property (nonatomic,strong) NSString * isCheck;//是否使用青币
@property (nonatomic,strong) NSString * getPoint;//获得青币

@property (nonatomic, strong)  UIButton * rightButton;
@end

@implementation HomePageLegalServiceLDPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectPayWay = @"alipay";
    //网络请求
    [self sendRequest];
    //设置导航栏
    self.naviTitle = @"立即支付";
    self.getPoint = @"0";
    //网络请求
    [self setupUI];
    //接收支付结果的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushViewController:) name:@"paySuccess" object:nil];
    
}
#pragma mark - 网络请求数据
- (void)sendRequest{
    
    NSDictionary * dict = @{
                            @"userID":YGSingletonMarco.user.userId,
                            @"isVIP":self.isVIP,
                            @"cardID":self.parameters[@"cardID"]
                            };
    
    [YGNetService YGPOST:@"LawVIPView" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        
        [self.vipImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"img"]] placeholderImage:YGDefaultImgFour_Three];
        
        self.exchangeLable.attributedText = [[NSString stringWithFormat:@"可用%@青币抵¥%@",responseObject[@"point"],responseObject[@"pointPrice"]] ld_attributedStringFromNSString:[NSString stringWithFormat:@"可用%@青币抵¥%@",responseObject[@"point"],responseObject[@"pointPrice"]] startLocation:[NSString stringWithFormat:@"可用%@",responseObject[@"point"]].length forwardFont:[UIFont systemFontOfSize:YGFontSizeSmallOne] backFont:[UIFont systemFontOfSize:YGFontSizeSmallOne] forwardColor:LD9ATextColor backColor:kRedColor];
        
        self.priceString = responseObject[@"price"];
        self.pointPrice = responseObject[@"pointPrice"];
        
        self.isCheck = @"1";
        
        NSString * priceString = [NSString stringWithFormat:@"￥%.2f",([self.priceString  floatValue ]- [self.pointPrice floatValue])];
        self.otherPayRightLable.attributedText = [priceString ld_attributedStringFromNSString:priceString startLocation:1 forwardFont:[UIFont systemFontOfSize:12] backFont:[UIFont systemFontOfSize:17] forwardColor:colorWithOrangeColor backColor:colorWithOrangeColor];
        
    } failure:^(NSError *error) {
        
        LDLog(@"%@",error);
    }];
}


#pragma mark - 刷新数据
- (void)reloadData{
    
    CGFloat priceFloat = [self.priceString floatValue];
    
    priceFloat = priceFloat - [self.pointPrice floatValue];
    
    NSString * priceString = [NSString stringWithFormat:@"￥%.2f",priceFloat];
    
    self.otherPayRightLable.attributedText = [priceString ld_attributedStringFromNSString:priceString startLocation:1 forwardFont:[UIFont systemFontOfSize:12] backFont:[UIFont systemFontOfSize:17] forwardColor:colorWithOrangeColor backColor:colorWithOrangeColor];
    
}
#pragma mark - UI设置
- (void)setupUI{
    //头部背景视图高度
    CGFloat headerBackViewH = 100;
    //青币购支付背景视图高度
    CGFloat  scoreViewH = 60;
    
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
    container.backgroundColor = kBlueColor;
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(_backScrollowView).offset(0);
        make.width.offset(kScreenW);
    }];
    
    //添加头部背景试图
    UIView * headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, headerBackViewH)];
    headerBackView.backgroundColor = LDEFPaddingColor;
    [container addSubview:headerBackView];
    
    //头部图片子视图
    self.vipImageView = [[LDVipImageView alloc]initWithFrame:CGRectMake(LDHPadding, LDVPadding, kScreenW - 2 * LDHPadding, headerBackViewH - LDVPadding)];
    
    //    LDVipImageView * vipImageView = [LDVipImageView vipImageViewWithCardType:@"月卡" andPrice:@"￥300" frame:CGRectMake(LDHPadding, LDVPadding, kScreenW - 2 * LDHPadding, headerBackViewH - LDVPadding)];
    //    vipImageView.backgroundColor = kRedColor;
    [headerBackView addSubview:self.vipImageView];
    
    ///青币购支付
    UIView * scoreView = [[UIView alloc] initWithFrame:CGRectMake(0, headerBackViewH, kScreenW, scoreViewH)];
    scoreView.backgroundColor = kWhiteColor;
    [container addSubview:scoreView];
    
    CGFloat payTypelableW = [UILabel calculateWidthWithString:@"青币购支付" textFont:[UIFont systemFontOfSize:YGFontSizeBigOne] numerOfLines:1].width;
    UILabel * payTypelable = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding, 0, payTypelableW, scoreViewH)];
    payTypelable.text = @"青币购支付";
    payTypelable.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [scoreView addSubview:payTypelable];
    
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:@"" selectedTitle:@"" normalTitleColor:nil selectedTitleColor:nil backGroundColor:nil normalBackGroundImageStr:@"nochoice_btn_gray" selectedBackGroundImageStr:@"choice_btn_green" titleFont:0];
    
    self.scoreViewRightButton = self.rightButton;
    self.rightButton.frame = CGRectMake(kScreenW - LDHPadding - 2 * LDVPadding, (scoreViewH - 2 * LDVPadding) / 2, 2 * LDVPadding, 2 * LDVPadding);
    [scoreView addSubview:self.rightButton];
    
    ///青币兑换
    self.exchangeLable = [UILabel new];
    [scoreView addSubview:self.exchangeLable];
    [self.exchangeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(1.5);
        make.left.equalTo(payTypelable.mas_right).offset(LDHPadding);
        make.right.equalTo(self.rightButton.mas_left).offset(-LDHPadding);
    }];
    
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(LDHPadding, scoreViewH - 1, kScreenW - LDHPadding, 1)];
    bottomLine.backgroundColor = LDEEPaddingColor;
    [scoreView addSubview:bottomLine];
    
    UIButton * coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    coverButton.frame = CGRectMake(0, 0, kScreenW, scoreViewH);
    self.coverButton = coverButton;
    [coverButton addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [scoreView addSubview:coverButton];
    self.coverButton.selected = YES;
    self.scoreViewRightButton.selected = YES;
    
    ///还需支付
    UIView * otherPayView = [[UIView alloc] initWithFrame:CGRectMake(0, headerBackViewH + scoreViewH, kScreenW, scoreViewH)];
    otherPayView.backgroundColor = kWhiteColor;
    [container addSubview:otherPayView];
    
    CGFloat otherPayW = [UILabel calculateWidthWithString:@"还需支付" textFont:[UIFont systemFontOfSize:YGFontSizeBigOne] numerOfLines:1].width;
    UILabel * otherPayLable = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding, 0, otherPayW, scoreViewH)];
    otherPayLable.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    
    otherPayLable.text = @"还需支付";
    [otherPayView addSubview:otherPayLable];
    
    UILabel * otherPayRightLable = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding + otherPayW, 0, kScreenW - 2 * LDHPadding - otherPayW, scoreViewH)];
    self.otherPayRightLable = otherPayRightLable;
    otherPayRightLable.textAlignment = NSTextAlignmentRight;
    [otherPayView addSubview:otherPayRightLable];
    
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
    
    if(self.selectPayWay.length >0)
    {
        [self.parameters setObject:self.selectPayWay forKey:@"channel"];
        [self.parameters setObject:self.isCheck forKey:@"isCheck"];
        
        __weak typeof(self)Weakself = self;
        
        [YGNetService YGPOST:@"LawPayOrder" parameters:self.parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
            
            NSString * charge = responseObject[@"charge"];
            if(!charge.length)
            {
                //支付宝
                ResultViewController *controller = [[ResultViewController alloc] init];
                controller.pageType =  ResultPageTypeSubmitPlayTogether;
                [self.navigationController pushViewController:controller animated:YES];
                return ;
            }
            
            self.getPoint = responseObject[@"getPoint"];
            
            [Pingpp createPayment:responseObject[@"charge"] viewController:Weakself appURLScheme:@"qingyouhui" withCompletion:^(NSString *result, PingppError *error){
                
                if ([result isEqualToString:@"success"])
                {
                    if([self.selectPayWay isEqualToString:@"alipay"])
                    {
                        //支付宝
                        ResultViewController *controller = [[ResultViewController alloc] init];
                        controller.pageType =  ResultPageTypeNetVIPPayResult;
                        controller.earnPoints = [self.getPoint intValue];
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                    //                    NSLog(@"success");
                } else {
                    if (error.code == PingppErrWxNotInstalled) {
                        [YGAppTool showToastWithText:@"请安装微信客户端"];
                    }
                    NSLog(@"PingppError: code=%lu msg=%@", error.code, [error getMsg]);
                }
            }];
            
        } failure:^(NSError *error) {
            
            
        }];
    }else
    {
        [YGNetService YGPOST:@"LawOfflineOrder" parameters:self.parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
            [YGAppTool showToastWithText:@"线下支付成功"];
            ResultViewController *controller = [[ResultViewController alloc] init];
            controller.pageType =  ResultPageTypeNetVIPOfflinePayResult;
            [self.navigationController pushViewController:controller animated:YES];
        } failure:^(NSError *error) {
            
        }];
    }
}
#pragma mark - LDPayItemViewDelegate
- (void)payItemViewDidSelectedWitchItem:(NSInteger)itemNumber{
    self.coverButton.userInteractionEnabled = YES;
    
    switch (itemNumber) {
            
        case 0:
        {
            self.selectPayWay = @"alipay";
        }
            break;
            
        case 1:
        {
            self.selectPayWay = @"wx";
        }
            break;
        case 2:
        {
            self.selectPayWay = @"";
            
            NSString * price = [NSString stringWithFormat:@"￥%.2f",[self.priceString floatValue]];
            self.isCheck = @"0";
            
            self.otherPayRightLable.attributedText = [price ld_attributedStringFromNSString:price startLocation:1 forwardFont:[UIFont systemFontOfSize:12] backFont:[UIFont systemFontOfSize:17] forwardColor:colorWithOrangeColor backColor:colorWithOrangeColor];
            self.rightButton.selected = NO;
            self.coverButton.selected = NO;
            self.coverButton.userInteractionEnabled = NO;
            [YGAlertView showAlertWithTitle:@"线下支付不支持青币购支付" buttonTitlesArray:@[@"确定"] buttonColorsArray:@[colorWithBlack] handler:^(NSInteger buttonIndex) {
                
            }];
            
        }
            break;
    }
    
}

- (void)pushViewController:(NSNotification *)notif
{
    NSString *state = notif.userInfo[@"successOrNot"];
    
    if ([state isEqualToString:@"1"])
    {
        if([self.selectPayWay isEqualToString:@"alipay"])
        {
            //支付宝
            ResultViewController *controller = [[ResultViewController alloc] init];
            controller.pageType =  ResultPageTypeNetVIPPayResult;
            controller.earnPoints = [self.getPoint intValue];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if([self.selectPayWay isEqualToString:@"wx"])
        {
            //微信
            ResultViewController *controller = [[ResultViewController alloc] init];
            controller.pageType =  ResultPageTypeNetVIPPayResult;
            controller.earnPoints = [self.getPoint intValue];
            [self.navigationController pushViewController:controller animated:YES];
        }
        
        [YGAppTool showToastWithText:@"购买成功"];
    }
    else
    {
        [YGAppTool showToastWithText:@"购买失败"];
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
        self.isCheck = @"0";
        
    }else{
        
        priceFloat = priceFloat - [self.pointPrice floatValue];
        
        price = [NSString stringWithFormat:@"￥%.2f",priceFloat];
        self.isCheck = @"1";
    }
    
    self.otherPayRightLable.attributedText = [price ld_attributedStringFromNSString:price startLocation:1 forwardFont:[UIFont systemFontOfSize:12] backFont:[UIFont systemFontOfSize:17] forwardColor:colorWithOrangeColor backColor:colorWithOrangeColor];
}
#pragma mark - 网络请求数据
- (void)sendRequest00{
    
    [YGNetService showLoadingViewWithSuperView:self.view];
    
    //获取全局并发队列
    dispatch_queue_t globleQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //异步任务执行时间
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
    
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
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    LDLogFunc
}
@end

