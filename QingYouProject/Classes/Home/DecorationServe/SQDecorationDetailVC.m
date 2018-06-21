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
@property (nonatomic, copy) NSString       *skuId;
@property (nonatomic, assign) CGFloat       productInfoHeight;
@property (nonatomic, assign) CGFloat       priceSheetHeight;

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
    
    [SQSaveWebImage saveImageWithUrl:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1529586573845&di=238d6bb8d20b0366cb0224468c036b4b&imgtype=0&src=http%3A%2F%2Fd.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fb64543a98226cffc9d56fb38b5014a90f603ea38.jpg"];
}


- (void)segmentButtonClickWithIndex:(int)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self scrollAnimationWithPoint:CGPointZero];
            break;
        case 1:
            [self scrollAnimationWithPoint:CGPointMake(0, self.productInfoHeight)];
            break;
        case 2:
            [self scrollAnimationWithPoint:CGPointMake(0, self.priceSheetHeight)];
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
    if (scrollView.contentOffset.y<self.productInfoHeight&&
        self.seg.selectedIndex!=0) {
        [self.seg selectButtonWithIndex:0];
        
    } else if (scrollView.contentOffset.y<self.priceSheetHeight&&
               scrollView.contentOffset.y>self.productInfoHeight&&
               self.seg.selectedIndex!=1) {
        [self.seg selectButtonWithIndex:1];
        
    } else if (scrollView.contentOffset.y>self.priceSheetHeight&&
               self.seg.selectedIndex!=2){
        [self.seg selectButtonWithIndex:2];
    }
}




- (void)rightButtonItemAciton {
    [YGAppTool shareWithShareUrl:@"dd" shareTitle:@"分享" shareDetail:@"" shareImageUrl:@"" shareController:self];
}


- (void)clickedCollectionBtn {
    
}
-(void)clickedContactButton {
    
}
- (void)clickedPayButton {
    if (self.skuId) {
        SQConfirmDecorationOrderVC  *vc = [[SQConfirmDecorationOrderVC alloc] init];
        vc.skuId = self.skuId;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        [self.webView ocCallJsWithMethodName:@"vum.changedialog()" back:^(NSString *methodName, id  _Nullable returnValue) {
            NSLog(@"%@", methodName);
        }];
    }
}





#pragma lazyLoad
- (YGSegmentView *)seg {
    if (!_seg) {
        CGRect frame = CGRectMake(0, 0, YGScreenWidth - 150, 22);
        NSArray *titleArr = @[@"商品", @"详情", @"报价单"];
        _seg = [[YGSegmentView alloc] initWithFrame:frame titlesArray:titleArr lineColor:colorWithMainColor delegate:self];
        _seg.backgroundColor = kBlackColor;
        _seg.normalTitleColor = kWhiteColor;
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
        
        NSArray *regisArr = @[@"GETHTMLHEIGHTFORIOS", @"CHOOSESKUPARAMFORIOS"];
        
        WeakSelf(weakSelf);
        [_webView registJSFunctionWithName:regisArr back:^(NSString *methodName, id  _Nullable paramValue) {
            [weakSelf.view bringSubviewToFront:weakSelf.bottomView];
            if ([methodName isEqualToString:@"CHOOSESKUPARAMFORIOS"]) {
                weakSelf.skuId = [NSString stringWithFormat:@"%@", paramValue];
            } else if ([methodName isEqualToString:@"GETHTMLHEIGHTFORIOS"]) {
                weakSelf.productInfoHeight = [paramValue[@"productInfoHeight"] floatValue];
                weakSelf.priceSheetHeight = [paramValue[@"priceSheetHeight"] floatValue];
            }
        }];
    }
    return _webView;
}



@end
