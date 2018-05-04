//
//  MyHouseRentPayViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/11/16.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyHouseRentPayViewController.h"
#import "HistoryPayRecoredViewController.h"
#import "InvoiceHistoryViewController.h"

@interface MyHouseRentPayViewController ()

@end

@implementation MyHouseRentPayViewController
{
    UIScrollView    *_mainScrollView;
    UIImageView *_topImageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadDate];
    // Do any additional setup after loading the view.
}
- (void)loadDate
{
    [YGNetService YGPOST:REQUEST_HousePayIndexImg parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        NSArray *imageArray = (NSMutableArray *)[responseObject[@"imgs"] componentsSeparatedByString:@","];
        [_topImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[0]] placeholderImage:YGDefaultImgThree_Four];
    } failure:^(NSError *error) {
        
    }];
}
- (void)configUI
{
    self.naviTitle = @"我的房租缴纳";
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64)];
    _mainScrollView.backgroundColor = colorWithYGWhite;
    _mainScrollView.contentSize = CGSizeMake(YGScreenWidth, YGScreenHeight);
    [self.view addSubview:_mainScrollView];
    
    _topImageView = [[UIImageView alloc] init];
    _topImageView.image = YGDefaultImgThree_Four;
    _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    _topImageView.clipsToBounds = YES;
    _topImageView.frame = CGRectMake(0, 0, YGScreenWidth, 0.47*YGScreenWidth);
    [_mainScrollView addSubview:_topImageView];
    
    NSArray *itemsArray  = @[
                             @{
                                 @"img":@"steward_rent_payment_history",
                                 @"title":@"我的缴费记录"
                                 },
                             @{
                                 @"img":@"steward_rent_pay_bills",
                                 @"title":@"房租水电发票"
                                 }
                        
                             ];
    
    int r = 0;
    int k = 0;
    for (int i = 0 ; i<itemsArray.count;i++) {
        NSDictionary *dict = itemsArray[i];
        UIButton *coverButton = [[UIButton alloc]init];
        coverButton.tag = 1000+i;
        [coverButton addTarget:self action:@selector(functionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        coverButton.backgroundColor = colorWithMainColor;
        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        [_mainScrollView addSubview:coverButton];
        coverButton.frame = CGRectMake(YGScreenWidth/2*r, _topImageView.height+10+YGScreenWidth/2*k, YGScreenWidth/2, YGScreenWidth/2);
        UIImage *titleImage = [UIImage imageNamed:dict[@"img"]];
        coverButton.backgroundColor = [UIColor clearColor];
        [coverButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
        [coverButton setTitle:dict[@"title"] forState:UIControlStateNormal];
        [coverButton setImage:titleImage forState:UIControlStateNormal];
        coverButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
        [coverButton setTitleEdgeInsets:UIEdgeInsetsMake(coverButton.imageView.frame.size.height-YGBottomMargin ,-coverButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [coverButton setImageEdgeInsets:UIEdgeInsetsMake(-YGBottomMargin-coverButton.imageView.frame.size.height, 0.0,0.0, -coverButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
        r++;
        if ((i+1)%2==0) {
            k++;
            r=0;
            UIView *linehoribleView = [[UIView alloc] initWithFrame:CGRectMake(0, coverButton.height*(k+1)-1, YGScreenWidth, 1)];
            linehoribleView.backgroundColor = colorWithLine;
            [_mainScrollView addSubview:linehoribleView];
        }
        
    }
    UIView *lineVerticalView = [[UIView alloc] initWithFrame:CGRectMake(YGScreenWidth/2, _topImageView.height+10, 1, (YGScreenWidth/2))];
    lineVerticalView.backgroundColor = colorWithLine;
    [_mainScrollView addSubview:lineVerticalView];
    
    _mainScrollView.contentSize = CGSizeMake(YGScreenWidth, _topImageView.height+YGScreenWidth/2*3+10);
    
}

- (void)functionBtnAction:(UIButton *)btn
{
    
    switch (btn.tag -1000) {
        case 0:
        {
            HistoryPayRecoredViewController *controller = [[HistoryPayRecoredViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 1:
        {

            InvoiceHistoryViewController *controller = [[InvoiceHistoryViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
    }
}

- (void)back
{
    NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
}

@end
