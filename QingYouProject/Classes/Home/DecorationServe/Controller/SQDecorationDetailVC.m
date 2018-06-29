//
//  SQDecorationDetailVC.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/24.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationDetailVC.h"
#import "YGSegmentView.h"
#import "SQDecorationDetailBottomView.h"
#import "SQConfirmDecorationOrderVC.h"
#import "SQLinkJSWebView.h"

#import "SQSaveWebImage.h"



@interface SQDecorationDetailVC () <YGSegmentViewDelegate, decorationDetailBottomViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) YGSegmentView       *seg;
@property (nonatomic, strong) SQDecorationDetailBottomView       *bottomView;
@property (nonatomic, strong) SQLinkJSWebView       *webView;
@property (nonatomic, strong) SQDecorationDetailModel       *detailModel;

@end

@implementation SQDecorationDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)configAttribute {
    UIBarButtonItem *itme = [self createBarbuttonWithNormalImageName:@"Details_page_nav_icon"
                                                   selectedImageName:@"Details_page_nav_icon"
                                                            selector:@selector(rightButtonItemAciton)];
    self.navigationItem.rightBarButtonItem = itme;
    
    self.navigationItem.titleView = self.seg;
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.webView];
    
}


- (void)segmentButtonClickWithIndex:(int)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self scrollAnimationWithPoint:CGPointZero];
            break;
        case 1:
            [self scrollAnimationWithPoint:CGPointMake(0, self.detailModel.productInfoHeight)];
            break;
        case 2:
            [self scrollAnimationWithPoint:CGPointMake(0, self.detailModel.priceSheetHeight)];
            break;
        default:
            break;
    }
}

- (void)scrollAnimationWithPoint:(CGPoint)point {
    [UIView  animateWithDuration:0.2 animations:^{
        self.webView.scrollView.contentOffset = point;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y<self.detailModel.productInfoHeight&&
        self.seg.selectedIndex!=0) {
        [self.seg selectButtonWithIndex:0];
        
    } else if (scrollView.contentOffset.y<self.detailModel.priceSheetHeight&&
               scrollView.contentOffset.y>self.detailModel.productInfoHeight&&
               self.seg.selectedIndex!=1) {
        [self.seg selectButtonWithIndex:1];
        
    } else if (scrollView.contentOffset.y>self.detailModel.priceSheetHeight&&
               self.seg.selectedIndex!=2){
        [self.seg selectButtonWithIndex:2];
    }
}



- (void)rightButtonItemAciton {
    [YGAppTool shareWithShareUrl:self.detailModel.shareUrl shareTitle:self.detailModel.title shareDetail:@"青网科技园，让创业更简单" shareImageUrl:self.detailModel.imageUrl shareController:self];
}


- (void)clickedPayButton {
    if (self.detailModel.productSkuId.length!=0) {
        SQConfirmDecorationOrderVC  *vc = [[SQConfirmDecorationOrderVC alloc] init];
        vc.detailModel = self.detailModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {//调起选择sku的弹框
        [self.webView ocCallJsWithMethodName:@"vum.changedialog()" back:nil];
    }
}





#pragma lazyLoad
- (YGSegmentView *)seg {
    if (!_seg) {
        CGRect frame = CGRectMake(0, 0, YGScreenWidth - 150, 22);
        NSArray *titleArr = @[@"商品", @"详情", @"报价单"];
        _seg = [[YGSegmentView alloc] initWithFrame:frame titlesArray:titleArr lineColor:colorWithMainColor delegate:self];
        _seg.backgroundColor = kCOLOR_333;
        _seg.normalTitleColor = KCOLOR_WHITE;
        [_seg setTitleFont:KFONT(38)];
        [_seg hiddenBottomLine];
    }
    return _seg;
}

- (SQDecorationDetailBottomView *)bottomView {
    if (!_bottomView) {
        CGRect bottomFrame = CGRectMake(0, KAPP_HEIGHT-KSCAL(107)-KNAV_HEIGHT, KAPP_WIDTH, KSCAL(107));
        _bottomView = [[SQDecorationDetailBottomView alloc] initWithFrame: bottomFrame];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (SQLinkJSWebView  *)webView {
    if (!_webView) {
        _webView = [[SQLinkJSWebView alloc] initWithFrame:CGRectMake(0, 0, KAPP_WIDTH, KAPP_HEIGHT-KNAV_HEIGHT-KSCAL(107))];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.delegate = self;
        [_webView loadWebWithUrl:self.styleModel.linkurl];
        [[YGConnectionService sharedConnectionService] showLoadingViewWithSuperView:YGAppDelegate.window];
        
        NSArray *regisArr = @[@"DOWNLOADIMAGEFORIOS", @"GETPRODUCTINFOFORIOS"];
        
        WeakSelf(weakSelf);
        [_webView registJSFunctionWithName:regisArr back:^(NSString *methodName, id  _Nullable paramValue) {
            [[YGConnectionService sharedConnectionService] dissmissLoadingView];
            [weakSelf.view bringSubviewToFront:weakSelf.bottomView];
            if ([methodName isEqualToString:@"DOWNLOADIMAGEFORIOS"]) {
                [SQSaveWebImage saveImageWithUrl:paramValue];
            } else if ([methodName isEqualToString:@"GETPRODUCTINFOFORIOS"]) {
                SQDecorationDetailModel *model = [SQDecorationDetailModel yy_modelWithJSON:paramValue];
                weakSelf.detailModel = model;
            }
        }];
    }
    return _webView;
}

- (void)setDetailModel:(SQDecorationDetailModel *)detailModel {
    _detailModel = detailModel;
    self.bottomView.detailModel = detailModel;
}


@end
