//
//  HomePageLegalServiceManagerApplyViewController.m
//  QingYouProject
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "HomePageLegalServiceManagerApplyViewController.h"
#import "LDTextView.h"//换行TextView
#import "HXTagsView.h"//TagView
#import "HomePageLegalServiceLDPayViewController.h"//立即支付,顶部月卡
#import <WebKit/WebKit.h>
#import "AreaSelectViewController.h"

@interface HomePageLegalServiceManagerApplyViewController ()<WKNavigationDelegate>
/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** 头部iamgeView  */
@property (nonatomic,strong) UIImageView * topImageView;

/** 所在园区  */
@property (nonatomic,strong) UITextField * parkLabelName;
/** 服务类型  */
@property (nonatomic,strong) UITextField * serviceName;
/** 联系人  */
@property (nonatomic,strong) UITextField * contactName;
/** 联系电话  */
@property (nonatomic,strong) UITextField * contactPhone;
/** 企业/个人名称  */
@property (nonatomic,strong) LDTextView * personalNameTextView;
/** 企业地址  */
@property (nonatomic,strong) LDTextView * companyAddressTextView;
/** 底部产品介绍详情  */
@property (nonatomic,strong) UILabel * bottomDetailLabel;
/** 底部产品介绍名称  */
@property (nonatomic,strong) UILabel * bottomTitleLabel;
/** 底部Button  */
@property (nonatomic,strong) UIButton * bottomButton;
/** 底部Button  */
@property (nonatomic,strong) UIView * hiddenAppearView;
/** 服务类型 : VIP包月选项  */
@property (nonatomic,strong) HXTagsView * tagsView;

@property (nonatomic,strong) WKWebView * footerWebView;
@property (nonatomic,strong) NSMutableArray * cardIDArry;

@property (nonatomic,strong) NSString * cardID;

//@property (nonatomic,assign) float  webViewHeight;

@property (nonatomic,strong) UIView * footView;

@end

@implementation HomePageLegalServiceManagerApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    self.naviTitle = @"VIP包年法律服务快捷通道";
    //设置UI视图
    [self setupUI];
    //网络请求
    [self sendRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VIPApply:) name:@"VIPApply" object:nil];
    
}
- (void)VIPApply:(NSNotification *)notifit {
    NSString * addressStr =[notifit object];
    self.parkLabelName.text = addressStr;
    
}
#pragma mark - 立即支付,顶部月卡
- (void)bottomButtonClick:(UIButton *)bottomButton{
    
    //所在地
    if(!self.parkLabelName.text.length)
    {
        [YGAppTool showToastWithText:@"请选择所在地"];
        return;
    }
    
    if(!self.contactName.text.length)
    {
        [YGAppTool showToastWithText:@"请输入联系人姓名"];
        return;
    }
    
    if (!self.contactPhone.text.length) {
        [YGAppTool showToastWithText:@"请输入联系电话"];
        return;
    }
    
    if ([YGAppTool isNotPhoneNumber:self.contactPhone.text])
        return;
    
    
    if (!self.personalNameTextView.text.length) {
        [YGAppTool showToastWithText:@"请选择输入企业名称"];
        return;
    }
    if (!self.companyAddressTextView.text.length) {
        [YGAppTool showToastWithText:@"请输入企业地址"];
        return;
    }
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:YGSingletonMarco.user.userId forKey:@"userID"];
    [parameters setValue:self.parkLabelName.text forKey:@"location"];
    [parameters setValue:self.contactName.text forKey:@"name"];
    [parameters setValue:self.contactPhone.text forKey:@"phone"];
    [parameters setValue:self.personalNameTextView.text forKey:@"companyName"];
    [parameters setValue:self.companyAddressTextView.text forKey:@"companyAddress"];
    [parameters setValue:self.cardID forKey:@"cardID"];
    
    
    HomePageLegalServiceLDPayViewController * VC= [[HomePageLegalServiceLDPayViewController alloc] init];
    VC.parameters = parameters;
    VC.isVIP =self.isVIP;
    [self.navigationController pushViewController:VC animated:YES];
    
}
#pragma mark - 网络请求数据
- (void)sendRequest{
    
    [YGNetService YGPOST:@"LawVIPApply" parameters:@{@"isVIP":self.isVIP} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        NSDictionary *  VIPDetail =responseObject[@"VIPDetail"] ;
        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:VIPDetail[@"img"]] placeholderImage:YGDefaultImgFour_Three];
        
        self.cardIDArry  =[NSMutableArray array];
        self.tagsView.tags =[NSMutableArray array];
        NSArray *  cardArry = responseObject[@"card"];
        for(int i=0;i<cardArry.count; i++ )
        {
            NSDictionary * dict = cardArry[i];
            NSString * titleStr = [NSString stringWithFormat:@"%@%@",dict[@"name"],dict[@"price"]] ;
            if([self.isVIP isEqualToString:@"1"])
                titleStr = [NSString stringWithFormat:@"续费%@%@",dict[@"name"],dict[@"price"]] ;
            [self.tagsView.tags addObject:titleStr];
            [self.cardIDArry addObject:dict[@"cardID"]];
        }
        self.tagsView.selectedTags = [NSMutableArray arrayWithObject:self.tagsView.tags.firstObject];
        self.tagsView.selectedIndexs = [NSMutableArray arrayWithObject:@(0)];
        [_tagsView reloadData];
        
        //更新高度
        CGFloat hiddenAppearViewH = 0;
        if (self.tagsView.tags.count > 0) {
            
            hiddenAppearViewH = [HXTagsView getHeightWithTags:self.tagsView.tags layout:self.tagsView.layout tagAttribute:self.tagsView.tagAttribute width:kScreenW];
            
            
        }
        
        //更新约束
        [self.hiddenAppearView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(hiddenAppearViewH);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self.view layoutIfNeeded];
            
        }];
        
        
        self.cardID = [NSString stringWithFormat:@"%@",[self.cardIDArry objectAtIndex:0]];
        
        [self.footerWebView loadHTMLString: [NSString stringWithFormat:
                                             @"<html> \n"
                                             "<head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\">\n"
                                             "<style type=\"text/css\"> \n"
                                             "max-width:100%%"
                                             "</style> \n"
                                             "</head> \n"
                                             "<body>%@</body> \n"
                                             "</html>",responseObject[@"VIPDetail"][@"detail"]
                                             ] baseURL:nil];
        
    } failure:^(NSError *error) {
        
        LDLog(@"%@",error);
    }];
}

#pragma mark - 设置UI视图
- (void)setupUI{
    
    //背景scrollowView
    UIScrollView * backScrollowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - YGNaviBarHeight - YGStatusBarHeight)];
    [self.view addSubview:backScrollowView];
    self.backScrollowView = backScrollowView;
    
    //容器视图
    UIView * container = [[UIView alloc] init];
    [self.backScrollowView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
        make.width.equalTo(backScrollowView);
    }];
    
    //头部视图
    self.topImageView = [UIImageView new];
    [container addSubview:self.topImageView];
    CGFloat scale_W_H = 75 / 22.0;
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.offset(0);
        make.left.offset(0);
        make.height.mas_equalTo(self.topImageView.mas_width).multipliedBy(1 / scale_W_H);
    }];
    
    //申请信息
    UIView * applyView = [UIView new];
    [container addSubview:applyView];
    [applyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.topImageView.mas_bottom);
        
    }];
    
    
    //顶部分割线
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, LDVPadding)];
    [applyView addSubview:topLine];
    
    UILabel * applyInfo = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding, LDVPadding * 2, kScreenW - 2 * LDHPadding, LDVPadding * 3)];
    [applyView addSubview:applyInfo];
    
    //所在园区
    UILabel * parkLabel = [UILabel new];
    [applyView addSubview:parkLabel];
    CGFloat parkLabelW = [UILabel calculateWidthWithString:@"所在地" textFont:leftFont numerOfLines:1].width;
    parkLabel.font = leftFont;
    [parkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(parkLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(applyInfo.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
    
    self.parkLabelName = [UITextField new];
    
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 15, 15)];
    UIImageView * image = [[UIImageView alloc] initWithFrame:rightView.frame];
    [rightView addSubview:image];
    image.image = LDImage(@"unfold_btn_gray");
    self.parkLabelName.rightView = rightView;
    self.parkLabelName.rightViewMode = UITextFieldViewModeAlways;
    self.parkLabelName.userInteractionEnabled = NO;
    self.parkLabelName.textAlignment = NSTextAlignmentRight;
    [applyView addSubview:self.parkLabelName];
    [self.parkLabelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parkLabel.mas_right).offset(5);
        make.top.bottom.equalTo(parkLabel);
        make.right.offset(-LDHPadding);
    }];
    
    //所在园区点击事件
    UIButton * parkLabelNameCoverButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:nil selectedTitle:nil normalTitleColor:nil selectedTitleColor:nil backGroundColor:kClearColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:0];
    
    parkLabelNameCoverButton.frame = CGRectMake(parkLabelW + 5 + LDHPadding, parkLabel.ld_y + 40, kScreenW - (CGRectGetMaxX(parkLabel.frame) + 5 + LDHPadding), 50);
    [applyView addSubview:parkLabelNameCoverButton];
    [parkLabelNameCoverButton addTarget:self action:@selector(parkLabelNameCoverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * lineOne = [UIView new];
    [applyView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(parkLabel.mas_bottom);
        
    }];
    
    //服务类型
    UILabel * serviceLabel = [UILabel new];
    [applyView addSubview:serviceLabel];
    CGFloat serviceLabelW = [UILabel calculateWidthWithString:@"服务类型" textFont:leftFont numerOfLines:1].width;
    serviceLabel.font = leftFont;
    [serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(serviceLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineOne.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
    
    self.serviceName = [UITextField new];
    self.serviceName.textAlignment = NSTextAlignmentRight;
    //    UIView * serviceNameRightView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 17, 17)];
    
    //    UIImageView * serviceNameImage = [[UIImageView alloc] initWithFrame:serviceNameRightView.frame];
    //    [serviceNameRightView addSubview:serviceNameImage];
    //    serviceNameImage.image = LDImage(@"go_gray");
    //    self.serviceName.rightView = serviceNameRightView;
    //    self.serviceName.rightViewMode = UITextFieldViewModeAlways;
    self.serviceName.userInteractionEnabled = NO;
    
    [applyView addSubview:self.serviceName];
    [self.serviceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(serviceLabel.mas_right).offset(5);
        make.top.bottom.equalTo(serviceLabel);
        make.right.offset(-LDHPadding);
    }];
    //服务类型点击事件
    UIButton * serviceNameCoverButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:nil selectedTitle:nil normalTitleColor:nil selectedTitleColor:nil backGroundColor:kClearColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:0];
    serviceNameCoverButton.selected = YES;
    serviceNameCoverButton.frame = CGRectMake(serviceLabelW + 5 + LDHPadding, CGRectGetMaxY(parkLabelNameCoverButton.frame), kScreenW - (CGRectGetMaxX(serviceLabel.frame) + 5 + LDHPadding), 50);
    [applyView addSubview:serviceNameCoverButton];
    //    [serviceNameCoverButton addTarget:self action:@selector(serviceNameCoverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [applyView addSubview:self.hiddenAppearView];
    [self.hiddenAppearView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.serviceName.mas_bottom).offset(0);
        make.height.offset([HXTagsView getHeightWithTags:self.tagsView.tags layout:self.tagsView.layout tagAttribute:self.tagsView.tagAttribute width:kScreenW]);
    }];
    
    
    UIView * lineTwo = [UIView new];
    [applyView addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.mas_equalTo(lineOne);
        make.top.equalTo(self.hiddenAppearView.mas_bottom);
    }];
    
    //联系人
    UILabel * contactLabel = [UILabel new];
    [applyView addSubview:contactLabel];
    CGFloat contactLabelW = [UILabel calculateWidthWithString:@"联系人" textFont:leftFont numerOfLines:1].width;
    contactLabel.font = leftFont;
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(contactLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineTwo.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
    
    self.contactName = [UITextField new];
    self.contactName.textAlignment = NSTextAlignmentRight;
    [applyView addSubview:self.contactName];
    [self.contactName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactLabel.mas_right).offset(5);
        make.top.bottom.equalTo(contactLabel);
        make.right.offset(-LDHPadding);
    }];
    UIView * lineThree = [UIView new];
    [applyView addSubview:lineThree];
    [lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.mas_equalTo(lineOne);
        make.top.equalTo(contactLabel.mas_bottom);
    }];
    
    //联系电话
    UILabel * contactPhoneLabel = [UILabel new];
    [applyView addSubview:contactPhoneLabel];
    CGFloat contactPhoneLabelW = [UILabel calculateWidthWithString:@"联系电话" textFont:leftFont numerOfLines:1].width;
    contactPhoneLabel.font = leftFont;
    [contactPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(contactPhoneLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineThree.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
    
    self.contactPhone = [UITextField new];
    self.contactPhone.textAlignment = NSTextAlignmentRight;
    [applyView addSubview:self.contactPhone];
    [self.contactPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactLabel.mas_right).offset(5);
        make.top.bottom.equalTo(contactPhoneLabel);
        make.right.offset(-LDHPadding);
    }];
    
    UIView * lineFour = [UIView new];
    [applyView addSubview:lineFour];
    [lineFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.mas_equalTo(lineOne);
        make.top.equalTo(contactPhoneLabel.mas_bottom);
    }];
    
    //企业/个人名称
    UILabel * comLabel = [UILabel new];
    [applyView addSubview:comLabel];
    CGFloat comLabelW = [UILabel calculateWidthWithString:@"企业/个人名称" textFont:leftFont numerOfLines:1].width;
    comLabel.font = leftFont;
    
    [comLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(comLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineFour.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
    
    self.personalNameTextView = [[LDTextView alloc] initWithFrame:CGRectMake(comLabelW + LDHPadding + 5, 244 + 7, kScreenW - (comLabelW + 2 * LDHPadding + 5), 30)];
    self.personalNameTextView.maxNumberOfLines = 40;
    
    self.personalNameTextView.textAlignment = NSTextAlignmentRight;
    [applyView addSubview:self.personalNameTextView];
    
    
    [self.personalNameTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.personalNameTextView.ld_width);
        make.right.offset(-LDHPadding);
        make.top.equalTo(lineFour.mas_bottom).offset(LDHPadding);
        make.height.offset(5 * LDVPadding - 20);
    }];
    
    __weak typeof(self) weakSelf = self;
    
    [self.personalNameTextView textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        
        CGRect frame = weakSelf.personalNameTextView.frame;
        frame.size.height = textHeight;
        
        [weakSelf.personalNameTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(textHeight);
            
        }];
        
        [weakSelf.view layoutIfNeeded];
    }];
    
    
    
    UIView * lineFive = [UIView new];
    [applyView addSubview:lineFive];
    [lineFive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.mas_equalTo(lineOne);
        make.top.equalTo(self.personalNameTextView.mas_bottom).offset(LDHPadding);
    }];
    
    //企业地址
    UILabel * companyAddressTextViewLabel = [UILabel new];
    [container addSubview:companyAddressTextViewLabel];
    CGFloat companyAddressTextViewLabelW = [UILabel calculateWidthWithString:@"企业地址" textFont:leftFont numerOfLines:1].width;
    companyAddressTextViewLabel.font = leftFont;
    
    [companyAddressTextViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(companyAddressTextViewLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineFive.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
    
    self.companyAddressTextView = [[LDTextView alloc] initWithFrame:CGRectMake(comLabelW + LDHPadding + 5, 295 + 12, kScreenW - (comLabelW + 2 * LDHPadding + 5), 30)];
    self.companyAddressTextView.textAlignment = NSTextAlignmentRight;
    self.companyAddressTextView.maxNumberOfLines = 4;
    [applyView addSubview:self.companyAddressTextView];
    
    [self.companyAddressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineFive.mas_bottom).offset(LDHPadding);
        make.right.width.mas_equalTo(self.personalNameTextView);
        make.height.offset(5 * LDVPadding - 20);
    }];
    
    
    [self.companyAddressTextView textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        
        CGRect frame = weakSelf.companyAddressTextView.frame;
        frame.size.height = textHeight;
        [weakSelf.companyAddressTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(textHeight);
            
        }];
        
        [weakSelf.view layoutIfNeeded];
    }];
    
    
    
    UIView * lineSix = [UIView new];
    [applyView addSubview:lineSix];
    [lineSix mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(LDHPadding);
        make.top.equalTo(self.companyAddressTextView.mas_bottom).offset(LDHPadding);
        make.bottom.equalTo(applyView.mas_bottom);
    }];
    
    
    //    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
    //    [container addSubview:self.footView];
    //
    //    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.offset(LDHPadding);
    //        make.top.equalTo(applyView.mas_bottom).offset(2 * LDVPadding);
    //        make.right.offset(-LDHPadding);
    //    }];
    
    //底部试图
    UILabel * bottomTitleLabel = [UILabel new];
    [container addSubview:bottomTitleLabel];
    self.bottomTitleLabel = bottomTitleLabel;
    [bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.top.equalTo(applyView.mas_bottom).offset(LDVPadding);
        make.right.offset(-LDHPadding);
        make.height.offset(3 * LDVPadding);
    }];
    
    self.footerWebView = [[WKWebView alloc] init];
    self.footerWebView.scrollView.scrollEnabled = NO;
    [container addSubview:self.footerWebView];
    self.footerWebView.navigationDelegate = self;
    [self.footerWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(bottomTitleLabel.mas_bottom).offset(LDVPadding);
        make.height.mas_equalTo(10);
        make.bottom.equalTo(container.mas_bottom).offset(10);
    }];
    
    
    //悬浮视图
    CGFloat Y = kScreenH - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight - YGBottomMargin;
    UIButton * bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame = CGRectMake(0, Y, kScreenW, YGNaviBarHeight + YGBottomMargin);
    self.bottomButton = bottomButton;
    
    [self.bottomButton setTitle:@"立即支付" forState:UIControlStateNormal];
    self.bottomButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    
    backScrollowView.contentInset = UIEdgeInsetsMake(0, 0, bottomButton.ld_height + LDVPadding, 0);
    if (iphoneX) {
        
        [self.bottomButton setTitleEdgeInsets:UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0 )];
        
        if (@available(iOS 11.0, *)) {
            
            backScrollowView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            [self.bottomButton setTitleEdgeInsets:UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0 )];
            
            
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    
    [bottomButton addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    bottomButton.backgroundColor = LDMainColor;
    [self.view addSubview:bottomButton];
    [bottomButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    lineThree.backgroundColor = LDEEPaddingColor;
    lineFour.backgroundColor = LDEEPaddingColor;
    lineTwo.backgroundColor = LDEEPaddingColor;
    lineOne.backgroundColor = LDEEPaddingColor;
    lineFive.backgroundColor = LDEEPaddingColor;
    lineSix.backgroundColor = colorWithLine;
    
    self.companyAddressTextView.font = leftFont;
    self.personalNameTextView.font = leftFont;
    //    self.personalNameTextView.placeholderColor = LD9ATextColor;
    //    self.companyAddressTextView.placeholderColor = LD9ATextColor;
    
    applyInfo.text = @"申请信息";
    parkLabel.text = @"所在地";
    serviceLabel.text = @"服务类型";
    contactLabel.text = @"联系人";
    contactPhoneLabel.text = @"联系电话";
    comLabel.text = @"企业/个人名称";
    companyAddressTextViewLabel.text = @"企业地址";
    
    self.bottomDetailLabel.textColor = LD9ATextColor;
    applyInfo.textColor = LD16TextColor;
    topLine.backgroundColor = LDEEPaddingColor;
    //applyView.backgroundColor = kRedColor;
    backScrollowView.backgroundColor = kWhiteColor;
    container.backgroundColor = kWhiteColor;
    //    self.topImageView.backgroundColor = [UIColor cyanColor];
    //    headerView.backgroundColor = kWhiteColor;
    
    applyInfo.font = LDBoldFont(15) ;
    
    self.bottomDetailLabel.font = leftFont;
    self.parkLabelName.font = leftFont;
    self.serviceName.font = leftFont;
    self.contactName.font = leftFont;
    self.contactPhone.font = leftFont;
    self.bottomTitleLabel.font = LDBoldFont(15) ;
    
    self.parkLabelName.placeholder = @"请选择";
    //    self.serviceName.placeholder = @"请选择";
    self.contactName.placeholder = @"请输入名字";
    self.contactPhone.placeholder = @"请填写真实电话";
    self.personalNameTextView.placeholder = @"请填写企业/个人名称";
    //    self.personalNameTextView.placeholderColor =  colorWithPlaceholder;
    self.companyAddressTextView.placeholder = @"请填写详细地址";
    self.bottomTitleLabel.text = @"VIP卡申请注意事项";
    
    //    self.applyPlace.backgroundColor = kBlueColor;
    //    self.applyComName.backgroundColor = kBlueColor;
    //    self.applyPhone.backgroundColor = kBlueColor;
    //    self.applyName.backgroundColor = kBlueColor;
    //假数据
    //    headerView.backgroundColor = LDRandomColor;
    //    headerView.backgroundColor = [UIColor yellowColor];
    
    if([self.isVIP isEqualToString:@"1"])
        self.serviceName.text =@"VIP续费";
    else
        self.serviceName.text =@"VIP包月";
    
}
#pragma mark - 所在园区点击事件
- (void)parkLabelNameCoverButtonClick:(UIButton *)parkLabelNameCoverButton{
    
    AreaSelectViewController * areaView =[[AreaSelectViewController alloc]init];
    areaView.tag = 1;//申请VIP
    [self.navigationController pushViewController:areaView animated:YES];
}
#pragma mark - 服务类型点击事件
- (void)serviceNameCoverButtonClick:(UIButton *)serviceNameCoverButton{
    serviceNameCoverButton.selected = !serviceNameCoverButton.selected;
    //点击按钮 切换 数据源
    if (serviceNameCoverButton.selected) {//默认选中包月
        self.serviceName.text = @"VIP包月";
        
        //        self.tagsView.tags = [NSMutableArray arrayWithArray:@[@"月卡300元",@"季卡900元",@"年卡3600元"]];
        
    }else{
        
        self.serviceName.text = @"VIP续费";
        
        //        self.tagsView.tags = [NSMutableArray arrayWithArray:@[@"续费月卡300元",@"续费季卡900元",@"续费年卡3600元"]];
        
    }
    //
    self.tagsView.selectedTags = [NSMutableArray arrayWithObject:self.tagsView.tags.firstObject];
    
    //刷新数据
    [self.tagsView reloadData];
    
    //更新高度
    CGFloat hiddenAppearViewH = 0;
    if (self.tagsView.tags.count > 0) {
        
        hiddenAppearViewH = [HXTagsView getHeightWithTags:self.tagsView.tags layout:self.tagsView.layout tagAttribute:self.tagsView.tagAttribute width:kScreenW];
        
        
    }else{
        
        hiddenAppearViewH = !serviceNameCoverButton.selected ? 5 * LDVPadding : 0;
        
    }
    
    
    
    //更新约束
    [self.hiddenAppearView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(hiddenAppearViewH);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)hiddenAppearView{
    if (!_hiddenAppearView) {
        _hiddenAppearView = [UIView new];
        _hiddenAppearView.backgroundColor = kWhiteColor;
        
        self.tagsView = [[HXTagsView alloc] init];
        [_hiddenAppearView addSubview:_tagsView];
        HXTagCollectionViewFlowLayout * layOut = [[HXTagCollectionViewFlowLayout alloc] init];
        layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        layOut.itemSize = CGSizeMake(110.0f, 25.0f);
        layOut.minimumInteritemSpacing = 10.0f;
        layOut.minimumLineSpacing = 10.0f;
        layOut.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        _tagsView.layout = layOut;
        _tagsView.isMultiSelect = NO;
        _tagsView.tagAttribute.isCircle = YES;
        _tagsView.tagAttribute.tagSpace = 20;
        _tagsView.tagAttribute.titleSize = 15;
        _tagsView.tagAttribute.borderWidth = 1;
        
        _tagsView.tagAttribute.selectedBorderColor = LDMainColor;
        _tagsView.tagAttribute.borderColor = LDEFPaddingColor;
        
        _tagsView.tagAttribute.normalTextColor = LD9ATextColor;
        _tagsView.tagAttribute.selectedTextColor = LDMainColor;
        
        _tagsView.tagAttribute.normalBackgroundColor = kWhiteColor;
        _tagsView.tagAttribute.selectedBackgroundColor = kWhiteColor;
        
        _tagsView.userInteractionEnabled = YES;
        [_tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        
        __weak typeof(self) weakSelf = self;
        
        _tagsView.completion = ^(NSArray *selectTags,NSArray *selectIndexs,NSInteger currentIndex) {
            __weak typeof(self) strongSelf = weakSelf;
            
            strongSelf.cardID = [NSString stringWithFormat:@"%@",[strongSelf.cardIDArry objectAtIndex:currentIndex]];
            
            LDLog(@"selectTags = %@",selectTags.firstObject)
            LDLog(@"selectIndexs = %@",selectIndexs.firstObject)
            LDLog(@"currentIndex = 点击了%ld", currentIndex);
            
        };
        
    }
    return _hiddenAppearView;
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self.footerWebView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        float webViewHeight = [result doubleValue];
        
        [_footerWebView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(webViewHeight + 10);
        }];
        
    }];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    LDLogFunc
}


@end

