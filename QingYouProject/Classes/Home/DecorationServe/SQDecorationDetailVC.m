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


@interface SQDecorationDetailVC () <YGSegmentViewDelegate, decorationDetailBottomViewDelegate>

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
    
    CGRect frame = CGRectMake(0, 0, YGScreenWidth - 150, 22);
    NSArray *titleArr = @[@"商品", @"详情", @"报价单"];
    YGSegmentView   *seg = [[YGSegmentView alloc] initWithFrame:frame titlesArray:titleArr lineColor:colorWithMainColor delegate:self];
    seg.backgroundColor = kBlackColor;
    seg.normalTitleColor = kWhiteColor;
    [seg setTitleFont:KFONT(38)];
    [seg hiddenBottomLine];
    self.navigationItem.titleView = seg;
    
    CGRect bottomFrame = CGRectMake(0, KAPP_HEIGHT-KSCAL(107)-KNAV_HEIGHT, KAPP_WIDTH, KSCAL(107));
    SQDecorationDetailBottomView    *bottomView = [[SQDecorationDetailBottomView alloc] initWithFrame: bottomFrame];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
}


- (void)segmentButtonClickWithIndex:(int)buttonIndex {
    NSLog(@"%d", buttonIndex);
}
- (void)rightButtonItemAciton {
    [YGAppTool shareWithShareUrl:@"dd" shareTitle:@"分享" shareDetail:@"" shareImageUrl:@"" shareController:self];
}


- (void)clickedCollectionBtn {
    
}
-(void)clickedContactButton {
    
}
- (void)clickedPayButton {
    SQConfirmDecorationOrderVC  *vc = [[SQConfirmDecorationOrderVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}






@end
