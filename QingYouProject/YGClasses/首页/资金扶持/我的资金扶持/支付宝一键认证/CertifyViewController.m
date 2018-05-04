//
//  CertifyViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CertifyViewController.h"

@interface CertifyViewController ()
@property (nonatomic, strong) UIWebView            *zmWeb;

@end

@implementation CertifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //_zmUrl 这个世后台返回的一个认证后的url 加载授权认证网页
    [self.zmWeb loadHTMLString:_zmUrl baseURL:nil];
    [self.view addSubview:self.zmWeb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
