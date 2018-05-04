//
//  RealNameCertifyViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RealNameCertifyViewController.h"
#import "CertifyViewController.h"
#import "MyFundSupportViewController.h"
#import "CertifyBaseProfileViewController.h"

#import "TobeLeaderOfAllianceViewController.h"
#import "SeccondCertifyProfileViewController.h"

@interface RealNameCertifyViewController ()

@end

@implementation RealNameCertifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnDataToServer:) name:@"alipayCertifySuccess" object:nil];
}

- (void)returnDataToServer:(NSNotification *)notif
{
    
    NSMutableDictionary *dict = (NSMutableDictionary *)notif.userInfo;
    [dict setValue:YGSingletonMarco.user.userId forKey:@"userId"];
    [YGNetService YGPOST:REQUEST_zhiMaXinYongHuiDiao parameters:dict showLoadingView:NO scrollView:nil success:^(id responseObject) {
        if ([responseObject[@"bl"] isEqualToString:@"1"])
        {
            RealNameCertifyViewController *vc = [[RealNameCertifyViewController alloc] init];
            vc.createFieldsType = self.pageType;
            vc.pageType = self.pageType;
            vc.confimDone = @"done";
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            [YGAppTool showToastWithText:@"认证失败"];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)configAttribute
{
    self.naviTitle = @"实名认证";
}

- (void)configUI
{
    UIImageView *certifyImageView = [[UIImageView alloc] init];
    certifyImageView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth*2/3);
    certifyImageView.image = [UIImage imageNamed:@"mine_realnameauthentication"];
    [certifyImageView sizeToFit];
    certifyImageView.frame = CGRectMake(YGScreenWidth/2-certifyImageView.width/2,40, certifyImageView.width, certifyImageView.height);
    [self.view addSubview:certifyImageView];
    certifyImageView.centerx = self.view.centerx;
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, certifyImageView.height+certifyImageView.y+20, YGScreenWidth-20, 40)];
    noticeLabel.text = @"根据相关法规，您需要通过实名认证绑定账户，\n通过实名认证可获得更好的体验哦！";
    noticeLabel.textColor = colorWithBlack;
    noticeLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.numberOfLines = 0;
    [self.view addSubview:noticeLabel];
    
    UIButton *confirmToCertifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmToCertifyButton.frame = CGRectMake(30, noticeLabel.y+noticeLabel.height+30, YGScreenWidth-60, 45);
    confirmToCertifyButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [confirmToCertifyButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [confirmToCertifyButton setTitle:@"支付宝一键认证" forState:UIControlStateNormal];
    confirmToCertifyButton.layer.cornerRadius = 22;
    confirmToCertifyButton.clipsToBounds = YES;
    confirmToCertifyButton.backgroundColor = colorWithMainColor;
    [self.view addSubview:confirmToCertifyButton];
    [confirmToCertifyButton addTarget:self action:@selector(confirmToCertifyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.confimDone isEqualToString:@"done"]) {
        certifyImageView.image = [UIImage imageNamed:@"mine_underreview"];
        noticeLabel.text = @"您的申请已进入审核，\n我们会在第一时间为您处理，并以短信方式通知您！";
        [confirmToCertifyButton setTitle:@"完成" forState:UIControlStateNormal];

    }
    
    
}

-(void)back
{

    if ([self.confimDone isEqualToString:@"done"])
    {
        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)confirmToCertifyButtonAction
{
    // @"createAllaince" 一起玩儿创建联盟  @“SeccondHandExchangeMain” @“addSeccondHandExchange”
    if ([self.confimDone isEqualToString:@"done"]) {
        
//        if ([self.createFieldsType isEqualToString:@"createAllaince"]) {
//            TobeLeaderOfAllianceViewController *vc = [[TobeLeaderOfAllianceViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//
//        }else if([self.createFieldsType isEqualToString:@"SeccondHandExchangeMain"] || [self.createFieldsType isEqualToString:@"addSeccondHandExchange"])
//        {
//            SeccondCertifyProfileViewController *vc = [[SeccondCertifyProfileViewController alloc] init];
//            vc.pageType = @"SeccondHandExchangeCertify";
//            [self.navigationController pushViewController:vc animated:YES];
//
//        }
//        else if ([self.createFieldsType isEqualToString:@"addSeccondHandExchange"])
//        {
//            SeccondCertifyProfileViewController *vc = [[SeccondCertifyProfileViewController alloc] init];
//            vc.pageType = @"addSeccondHandExchange";
//            [self.navigationController pushViewController:vc animated:YES];
//        }
        if ([self.pageType isEqualToString:@"createAllaince"]) {
            TobeLeaderOfAllianceViewController *vc = [[TobeLeaderOfAllianceViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if([self.pageType isEqualToString:@"SeccondHandExchangeMain"] || [self.pageType isEqualToString:@"addSeccondHandExchange"])
        {
            SeccondCertifyProfileViewController *vc = [[SeccondCertifyProfileViewController alloc] init];
            vc.pageType = @"SeccondHandExchangeCertify";
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else
        {
            UINavigationController *navc = self.navigationController;
            NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
            for (UIViewController *vc in [navc viewControllers]) {
                [viewControllers addObject:vc];
                if ([vc isKindOfClass:[MyFundSupportViewController class]]) {
                    break;
                }
            }
            [navc setViewControllers:viewControllers];
        }
    }else
    {
        [YGNetService YGPOST:REQUEST_YiJianYanZheng parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
            [self doVerify:responseObject[@"url"]];
        
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}
- (void)doVerify:(NSString* )url {
    // 这里使用固定appid 20000067
    
    NSString *alipayUrl = [NSString stringWithFormat:@"alipays://platformapi/startapp?appId=20000067&url=%@",
                           [self URLEncodedStringWithUrl:url]];
    if ([self canOpenAlipay]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alipayUrl] options:@{} completionHandler:nil];
    } else {
        //引导安装支付宝 根据需求这里也可以跳转到一个VC界面进行网页认证
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否下载并安装支付宝完成认证?"
                                                           delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
        [alertView show];
        //网页认证
        //（传入认证 URL）
        CertifyViewController *zmCreditVC = [[CertifyViewController alloc] init];
        zmCreditVC.zmUrl = url;
        [self.navigationController pushViewController:zmCreditVC animated:YES];
        
        
        
    }
    
}

- (NSString *)URLEncodedStringWithUrl:(NSString *)url {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)url,NULL,(CFStringRef) @"!'();:@&=+$,%#[]|",kCFStringEncodingUTF8));
    return encodedString;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *appstoreUrl = @"itms-apps://itunes.apple.com/app/id333206289";
        if ([YGAppTool getIOSVersion] < 10.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrl]];

        }else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrl] options:@{} completionHandler:nil];

        }

    }
}

- (BOOL)canOpenAlipay {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]];
}


@end
