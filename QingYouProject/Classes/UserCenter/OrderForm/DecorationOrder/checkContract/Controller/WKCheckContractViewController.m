//
//  WKCheckContractViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKCheckContractViewController.h"

#import "WKCheckContactScaleView.h"

@interface WKCheckContractViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) WKCheckContactScaleView *scaleDisplayView;

@end

@implementation WKCheckContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.naviTitle = @"查看合同";
    [self setupSubviews];
}

- (void)setupSubviews {
    _imageView = [UIImageView new];
    _imageView.image = [UIImage imageNamed:@"mine_fund_my_investment"];
    [self.view addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.height.mas_equalTo(90);
    }];
    
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_displayView)]];
}

- (void)tap_displayView {
    [self.scaleDisplayView showWithImageUrls:@[
                                               @"http://img4.imgtn.bdimg.com/it/u=1972873509,2904368741&fm=27&gp=0.jpg",
                                               @"http://img07.tooopen.com/images/20170316/tooopen_sy_201956178977.jpg",
                                               @"http://img.zcool.cn/community/01f09e577b85450000012e7e182cf0.jpg@1280w_1l_2o_100sh.jpg"] selectIndex:0 captureView:self.imageView];
}

- (WKCheckContactScaleView *)scaleDisplayView {
    if (!_scaleDisplayView) {
        _scaleDisplayView = [[WKCheckContactScaleView alloc] initWithFrame:self.view.bounds];
    }
    return _scaleDisplayView;
}


@end
