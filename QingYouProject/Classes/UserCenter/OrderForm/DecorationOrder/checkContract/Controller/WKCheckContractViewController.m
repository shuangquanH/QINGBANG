//
//  WKCheckContractViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKCheckContractViewController.h"

#import "WKCheckContactScaleView.h"
#import "WKImageCollectionView.h"

#import "SQDecorationDetailModel.h"

@interface WKCheckContractViewController ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) WKCheckContactScaleView *scaleDisplayView;

@property (nonatomic, strong) WKImageCollectionView *imageCollectView;

@property (nonatomic, strong) NSArray<NSString *> *contractUrls;

@end

@implementation WKCheckContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.naviTitle = @"查看合同";
    [self setupSubviews];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
    }];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(30));
        make.top.mas_equalTo(KSCAL(30));
        if (!_imageCollectView) {
            make.bottom.mas_equalTo(-KSCAL(40));
        }
    }];
    [_imageCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tipLabel);
        make.top.equalTo(_tipLabel.mas_bottom).offset(KSCAL(32));
        make.bottom.mas_equalTo(-KSCAL(40));
        make.width.mas_equalTo(KSCAL(130) * 3 + KSCAL(20) * 2);
    }];
}

- (void)setupSubviews {
    
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    self.contractUrls = [self.orderInfo.order_info.contractImages componentsSeparatedByString:@";"];

    _tipLabel = [UILabel labelWithFont:KSCAL(32) textColor:kCOLOR_333 text:@"合同文件"];
    [_tipLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [_bgView addSubview:_tipLabel];
    
    if (self.contractUrls.count) {
        _imageCollectView = [[WKImageCollectionView alloc] initWithMaxCount:self.contractUrls.count hasDeleteAction:NO];
        [_bgView addSubview:_imageCollectView];
        
        for (int i = 0; i < self.contractUrls.count; i++) {
            [_imageCollectView setImageUrl:self.contractUrls[i] forIndex:i];
        }
        
        @weakify(self)
        _imageCollectView.viewClicker = ^(UIView *view, NSInteger index) {
            @strongify(self)
            [self.scaleDisplayView showWithImageUrls:self.contractUrls selectIndex:index captureView:view];
        };
    }
}

- (WKCheckContactScaleView *)scaleDisplayView {
    if (!_scaleDisplayView) {
        _scaleDisplayView = [[WKCheckContactScaleView alloc] initWithFrame:CGRectZero];
    }
    return _scaleDisplayView;
}


@end
