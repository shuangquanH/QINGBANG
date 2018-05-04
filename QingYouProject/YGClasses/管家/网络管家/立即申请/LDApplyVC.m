//
//  LDApplyVC.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/9/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDApplyVC.h"//申请信息:第一个是联系人
#import "LDTextView.h"
#import <WebKit/WebKit.h>
#import "AreaSelectViewController.h"

@interface LDApplyVC ()<WKNavigationDelegate>
/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** 左侧iamgeView  */
@property (nonatomic,strong) UIImageView * leftImageView;
/** 头部产品名称  */
@property (nonatomic,strong) UILabel * topLabel;
/** 联系人姓名  */
@property (nonatomic,strong) UITextField * applyName;
/** 联系电话  */
@property (nonatomic,strong) UITextField * applyPhone;
/** 企业/个人名称  */
@property (nonatomic,strong) LDTextView * applyComName;
/** 企业地址  */
@property (nonatomic,strong) LDTextView * applyPlace;
/** 底部产品介绍详细名字  */
@property (nonatomic,strong) UILabel * bottomDetailLabel;
/** 底部产品介绍名称  */
@property (nonatomic,strong) UILabel * bottomTitleLabel;
/** 底部Button  */
@property (nonatomic,strong) UIButton * bottomButton;
/** 底部企业地址 分割线  */
@property (nonatomic,strong) UIView * lineFour;
/** 企业/个人名 分割线  */
@property (nonatomic,strong) UIView * lineThree;

@property (nonatomic,strong) UITextField * addressField;

@property (nonatomic,strong) WKWebView * footerWebView;
@end

@implementation LDApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    self.naviTitle = @"立即申请";
    //设置UI视图
    [self setupUI];
    
    //网络请求
    [self sendRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(immediatelyApply:) name:@"immediatelyApply" object:nil];

}
- (void)immediatelyApply:(NSNotification *)notifit {
    NSString * addressStr =[notifit object];
    self.addressField.text = addressStr;
}

#pragma mark - 网络请求数据
- (void)sendRequest{
    
    [YGNetService YGPOST:@"NetServiceIntroduce" parameters:@{@"serviceID":self.serviceID} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        [self.footerWebView loadHTMLString: [NSString stringWithFormat:
                                             @"<html> \n"
                                             "<head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\">\n"
                                             "<style type=\"text/css\"> \n"
                                             "max-width:100%%"
                                             "</style> \n"
                                             "</head> \n"
                                             "<body>%@</body> \n"
                                             "</html>",
                                             responseObject[@"serviceIntroduce"]] baseURL:nil];

    } failure:^(NSError *error) {
        
        LDLog(@"%@",error);
    }];
}
#pragma mark - 导航栏右侧按钮点击
- (void)rightBarButtonClick:(UIButton *)rightBarButton{
    
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
    UIView * headerView = [UIView new];
    [container addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.offset(0);
        make.left.offset(0);
        make.height.offset(88);
    }];
    
    //头部视图子视图
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LDHPadding, LDHPadding, 62, 62)];
    [headerView addSubview:self.leftImageView];
    //文字
    self.topLabel = [UILabel new];
    [container addSubview:self.topLabel];
 

    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImageView.mas_top).offset(5);
        make.right.offset(-LDHPadding);
        make.left.equalTo(self.leftImageView.mas_right).offset(5);
    }];
    
    //申请信息
    UIView * applyView = [UIView new];
    [container addSubview:applyView];
    [applyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(headerView.mas_bottom);
        //make.height.offset(253);
    }];
    

    //顶部分割线
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, LDVPadding)];
    [applyView addSubview:topLine];
    UILabel * applyInfo = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding, LDVPadding * 2, kScreenW - 2 * LDHPadding, LDVPadding * 2)];
    [applyView addSubview:applyInfo];
    
    //所在地
    UILabel * addressLabel = [UILabel new];
    CGFloat addressLabelW = [UILabel calculateWidthWithString:@"所在地" textFont:leftFont numerOfLines:1].width;
    addressLabel.font = LD14Font;
    
    [applyView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(addressLabelW);
        
        make.left.offset(LDHPadding);
        make.top.equalTo(applyInfo.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
 
    self.addressField = [UITextField new];
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 17, 17)];
    UIImageView * image = [[UIImageView alloc] initWithFrame:rightView.frame];
    [rightView addSubview:image];
    image.image = LDImage(@"go_gray");
    self.addressField.rightView = rightView;
    self.addressField.rightViewMode = UITextFieldViewModeAlways;
    self.addressField.userInteractionEnabled = YES;
    self.addressField.enabled = NO;
    
    self.addressField.textAlignment = NSTextAlignmentRight;
    [applyView addSubview:self.addressField];
    [self.addressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLabel.mas_right).offset(5);
        make.top.bottom.equalTo(addressLabel);
        make.right.offset(-LDHPadding);
    }];
    
    //所在地点击事件
    UIButton * addressCoverButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:nil selectedTitle:nil normalTitleColor:nil selectedTitleColor:nil backGroundColor:kClearColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:0];
    
    addressCoverButton.frame = CGRectMake(addressLabelW + 5 + LDHPadding, addressLabel.ld_y + 50, kScreenW - (CGRectGetMaxX(addressLabel.frame) + 5 + LDHPadding), 40);
    [applyView addSubview:addressCoverButton];
    [addressCoverButton addTarget:self action:@selector(addressCoverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * lineZero = [UIView new];
    [applyView addSubview:lineZero];
    [lineZero mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(addressLabel.mas_bottom);
    }];
    
    //联系人
    UILabel * contactLabel = [UILabel new];
    CGFloat contactLabelW = [UILabel calculateWidthWithString:@"联系人" textFont:leftFont numerOfLines:1].width;
    contactLabel.font = LD14Font;

    [applyView addSubview:contactLabel];
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(contactLabelW);

        make.left.offset(LDHPadding);
        make.top.equalTo(lineZero.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
    self.applyName = [UITextField new];
    self.applyName.textAlignment = NSTextAlignmentRight;
    [applyView addSubview:self.applyName];
    [self.applyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactLabel.mas_right).offset(5);
        make.top.bottom.equalTo(contactLabel);
        make.right.offset(-LDHPadding);
    }];
    UIView * lineOne = [UIView new];
    [applyView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(contactLabel.mas_bottom);
    }];

    //联系电话
    UILabel * phoneLabel = [UILabel new];
    [applyView addSubview:phoneLabel];
    CGFloat phoneLabelW = [UILabel calculateWidthWithString:@"联系电话" textFont:leftFont numerOfLines:1].width;
    phoneLabel.font = leftFont;
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(phoneLabelW);

        make.left.offset(LDHPadding);
        make.top.equalTo(lineOne.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
    
    self.applyPhone = [UITextField new];
    self.applyPhone.textAlignment = NSTextAlignmentRight;
    [applyView addSubview:self.applyPhone];
    [self.applyPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel.mas_right).offset(5);
        make.top.bottom.equalTo(phoneLabel);
        make.right.offset(-LDHPadding);
    }];
    UIView * lineTwo = [UIView new];
    [applyView addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(phoneLabel.mas_bottom);
    }];
    
    //企业/个人名称
    UILabel * comLabel = [UILabel new];
    [applyView addSubview:comLabel];
    CGFloat comLabelW = [UILabel calculateWidthWithString:@"企业/个人名称" textFont:leftFont numerOfLines:1].width;
    comLabel.font = leftFont;

    [comLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(comLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineTwo.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
    
    //企业个人
    self.applyComName = [[LDTextView alloc] initWithFrame:CGRectMake(comLabelW + LDHPadding + 5, 142 + 7, kScreenW - (comLabelW + 2 * LDHPadding + 5), 50)];
    self.applyComName.textAlignment = NSTextAlignmentRight;
    self.applyComName.maxNumberOfLines = 4;
    [applyView addSubview:self.applyComName];
    [self.applyComName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.applyComName.ld_width);
        make.right.offset(-LDHPadding);
        make.top.equalTo(comLabel.mas_top).offset(7);
        make.height.offset(self.applyComName.ld_height);
    }];
    
    __weak typeof(self) weakSelf = self;
    [self.applyComName textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        
        CGRect frame = weakSelf.applyComName.frame;
        frame.size.height = textHeight;
        
        [weakSelf.applyComName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(textHeight);
        }];
        
        [weakSelf.view layoutIfNeeded];
        

    }];
    
    UIView * lineThree = [UIView new];
    [applyView addSubview:lineThree];
    [lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(self.applyComName.mas_bottom);
    }];
    
    //企业地址
    UILabel * placeLabel = [UILabel new];
    [applyView addSubview:placeLabel];
    CGFloat placeLabelW = [UILabel calculateWidthWithString:@"请填写详细地址" textFont:leftFont numerOfLines:1].width;
    placeLabel.font = leftFont;
    
    [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(placeLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineThree.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
    
    //详细地址
    CGFloat maxY = CGRectGetMaxY(self.applyComName.frame);
    self.applyPlace = [[LDTextView alloc] initWithFrame:CGRectMake(comLabelW + LDHPadding + 5, maxY + 1 + 7, kScreenW - (comLabelW + 2 * LDHPadding + 5), 50)];
    self.applyPlace.maxNumberOfLines = 4;
    [applyView addSubview:self.applyPlace];
    
    self.applyPlace.textAlignment = NSTextAlignmentRight;
    
    [self.applyPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.applyPlace.ld_width);
        make.right.offset(-LDHPadding);
        make.top.equalTo(placeLabel.mas_top).offset(7);
        make.height.offset(self.applyPlace.ld_height);
    }];
    
    [self.applyPlace textValueDidChanged:^(NSString *text, CGFloat textHeight) {

        CGRect frame = weakSelf.applyPlace.frame;
        frame.size.height = textHeight;
        [weakSelf.applyPlace mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(textHeight);
        }];
        
        [weakSelf.view layoutIfNeeded];

        
    }];
   
    

    UIView * lineFour = [UIView new];
    [applyView addSubview:lineFour];
    self.lineFour = lineFour;
    [lineFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(10);
        make.top.equalTo(self.applyPlace.mas_bottom);
        make.bottom.equalTo(applyView.mas_bottom);
    }];
    
 
    //底部试图
    UILabel * bottomTitleLabel = [UILabel new];
    [container addSubview:bottomTitleLabel];
    self.bottomTitleLabel = bottomTitleLabel;
    [bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.top.equalTo(lineFour.mas_bottom).offset(2 * LDVPadding);
        make.right.offset(-LDHPadding);
    }];
    
    self.footerWebView = [[WKWebView alloc] init];
    self.footerWebView.scrollView.scrollEnabled = NO;
    [container addSubview:self.footerWebView];
    self.footerWebView.navigationDelegate = self;
    [self.footerWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(bottomTitleLabel.mas_bottom).offset(LDVPadding);
        make.bottom.equalTo(container.mas_bottom).offset(- 2* LDVPadding);
    }];
    
//    UILabel * bottomDetailLabel = [UILabel new];
//    bottomDetailLabel.numberOfLines = 0;
//    self.bottomDetailLabel = bottomDetailLabel;
//    [container addSubview:bottomDetailLabel];
//    [bottomDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(LDHPadding);
//        make.top.equalTo(bottomTitleLabel.mas_bottom).offset(2 * LDVPadding);
//        make.right.offset(-LDHPadding);
//        make.bottom.equalTo(container.mas_bottom).offset(0);
//    }];
    
    
    //悬浮视图
    CGFloat Y = kScreenH - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight - YGBottomMargin;
    UIButton * bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame = CGRectMake(0, Y, kScreenW, YGNaviBarHeight + YGBottomMargin);
    self.bottomButton = bottomButton;
    
    [self.bottomButton setTitle:@"立即申请" forState:UIControlStateNormal];
    
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
    
    lineZero.backgroundColor = LDEEPaddingColor;
    lineThree.backgroundColor = LDEEPaddingColor;
    lineFour.backgroundColor = LDEEPaddingColor;
    lineTwo.backgroundColor = LDEEPaddingColor;
    lineOne.backgroundColor = LDEEPaddingColor;
    
    addressLabel.text = @"所在地";
    placeLabel.text = @"企业地址";
    applyInfo.text = @"申请信息";
    phoneLabel.text = @"联系电话";
    comLabel.text = @"企业/个人名称";
    contactLabel.text = @"联系人";
    
    self.bottomDetailLabel.textColor = LD9ATextColor;
    applyInfo.textColor = LD16TextColor;
    topLine.backgroundColor = LDEEPaddingColor;
    //applyView.backgroundColor = kRedColor;
    backScrollowView.backgroundColor = kWhiteColor;
    container.backgroundColor = kWhiteColor;
    headerView.backgroundColor = kWhiteColor;
    self.topLabel.numberOfLines = 0;
    
   //多行占位文字 颜色 和字体
    applyInfo.font = LD15Font;
    //底部文字
    self.bottomTitleLabel.font = LD15Font;
    self.bottomDetailLabel.font = leftFont;
    self.applyPlace.font = leftFont;
    self.applyComName.font = leftFont;
    self.topLabel.font = leftFont;
//    self.applyPlace.placeholderColor = LD9ATextColor;
//    self.applyComName.placeholderColor = LD9ATextColor;

    self.applyComName.placeholder = @"请填写企业/个人名称";
    self.applyPhone.placeholder = @"请填写真实电话";
    self.applyName.placeholder = @"请输入姓名";
    self.applyPlace.placeholder = @"请填写详细地址";
    self.addressField.placeholder =@"请选择";
    bottomTitleLabel.text =@"注意事项";
    self.addressField.font = leftFont;
    self.applyName.font = leftFont;
    self.applyPhone.font = leftFont;
    self.applyComName.font = leftFont;
    self.applyPlace.font = leftFont;

    
     NSArray * imageArry =  _serviceDetail[@"serviceImg"];
    NSString * imageStr  =@"";
    if([imageArry count])
        imageStr =[NSString stringWithFormat:@"%@",imageArry[0]] ;
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:YGDefaultImgSquare];
    self.topLabel.text = [NSString stringWithFormat:@"%@-%@",_serviceDetail[@"serviceName"],_serviceDetail[@"serviceIntroduction"]];
}


#pragma mark - 立即申请
- (void)bottomButtonClick:(UIButton *)bottomButton{
    
    if(!self.addressField.text.length)
    {
        [YGAppTool showToastWithText:@"请选择所在地"];
        return;
    }
    
    if(!self.applyName.text.length)
    {
        [YGAppTool showToastWithText:@"请输入姓名"];
        return;
    }
    
    if (!self.applyPhone.text.length) {
        [YGAppTool showToastWithText:@"请输入真实电话"];
        return;
    }
    
    if ([YGAppTool isNotPhoneNumber:self.applyPhone.text])
        return;
    
    if (!self.applyComName.text.length) {
        [YGAppTool showToastWithText:@"请选择输入企业名称"];
        return;
    }
    if (!self.applyPlace.text.length) {
        [YGAppTool showToastWithText:@"请输入企业地址"];
        return;
    }
    NSDictionary * parameters = @{
                                  @"userID":YGSingletonMarco.user.userId,
                                  @"serviceID":self.serviceID,
                                  @"location":self.addressField.text,
                                  @"name":self.applyName.text,
                                  @"phone":self.applyPhone.text,
                                  @"companyName":self.applyComName.text,
                                  @"companyAddress":self.applyPlace.text,
                                  @"serviceName":self.serviceDetail[@"serviceName"],
                                  };
    
    [YGNetService YGPOST:@"NetCreateOrder" parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        [YGAppTool showToastWithText:@"您的申请已成功提交"];
        
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0/*延迟执行时间*/ * NSEC_PER_SEC));
//        
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
//        });
        
        
    } failure:^(NSError *error) {
        LDLog(@"%@",error);
    }];
    
}
-(void)addressCoverButtonClick:(UIButton *)btn
{
    AreaSelectViewController * areaView =[[AreaSelectViewController alloc]init];
    areaView.tag = 0;//申请维护
    [self.navigationController pushViewController:areaView animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self.footerWebView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        float webViewHeight = [result doubleValue];
//        CGRect frame = webView.frame;
//        frame.size.height = webViewHeight;
//        webView.frame = frame;
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
