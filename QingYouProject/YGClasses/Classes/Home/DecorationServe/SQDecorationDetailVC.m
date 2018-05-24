//
//  SQDecorationDetailVC.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/24.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationDetailVC.h"
#import "YGSegmentView.h"


@interface SQDecorationDetailVC () <YGSegmentViewDelegate>

@end

@implementation SQDecorationDetailVC 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *itme = [self createBarbuttonWithNormalImageName:@"mine_instashot"
                                                   selectedImageName:@"mine_instashot"
                                                            selector:@selector(rightButtonItemAciton)];
    self.navigationItem.rightBarButtonItem = itme;
    
    
}
- (void)configAttribute {
    CGRect frame = CGRectMake(0, 0, YGScreenWidth - 150, 22);
    NSArray *titleArr = @[@"商品", @"详情", @"报价单"];
    YGSegmentView   *seg = [[YGSegmentView alloc] initWithFrame:frame titlesArray:titleArr lineColor:colorWithMainColor delegate:self];
    [seg setTitleFont:[UIFont systemFontOfSize:18]];
    [seg hiddenBottomLine];
    self.navigationItem.titleView = seg;
}


- (void)segmentButtonClickWithIndex:(int)buttonIndex {
    NSLog(@"%d", buttonIndex);
}
- (void)rightButtonItemAciton {
    [YGAlertView showAlertWithTitle:@"分享" buttonTitlesArray:@[@"YES", @"NO"] buttonColorsArray:@[colorWithMainColor, kBlueColor] handler:nil];
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