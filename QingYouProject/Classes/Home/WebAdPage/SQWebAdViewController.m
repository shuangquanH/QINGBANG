//
//  SQWebAdViewController.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/27.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQWebAdViewController.h"
#import "SQLinkJSWebView.h"


@interface SQWebAdViewController ()

@property (nonatomic, strong) SQLinkJSWebView       *webView;

@end

@implementation SQWebAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.naviTitle = @"广告页面";
    [self.view addSubview:self.webView];
    [_webView loadWebWithUrl:self.funcs_target_params];
}

- (SQLinkJSWebView  *)webView {
    if (!_webView) {
        _webView = [[SQLinkJSWebView alloc] initWithFrame:self.view.bounds];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _webView;
}

@end
