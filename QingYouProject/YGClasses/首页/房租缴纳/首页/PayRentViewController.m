//
//  PayRentViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PayRentViewController.h"
#import "HistoryPayRecoredViewController.h"
#import "BreakContractBillViewController.h"
#import "MyContractViewController.h"
#import "CheckUserInfoViewController.h"
#import "InvoiceManagerViewController.h"
#import "BillsDetailViewController.h"

@interface PayRentViewController ()<SDCycleScrollViewDelegate>

@end

@implementation PayRentViewController
{
    UIScrollView    *_mainScrollView;
    SDCycleScrollView *_topScrollview;
    NSMutableArray *_imageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    
    [self loadDate];
    // Do any additional setup after loading the view.
}

- (void)loadDate
{
    [YGNetService YGPOST:REQUEST_HousePayIndexImg parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        _imageArray = (NSMutableArray *)[responseObject[@"imgs"] componentsSeparatedByString:@","];
        [self configUI];
    } failure:^(NSError *error) {
        
    }];
}
- (void)configUI
{
    self.naviTitle = @"房租缴纳";
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64)];
    _mainScrollView.backgroundColor = colorWithYGWhite;
    _mainScrollView.contentSize = CGSizeMake(YGScreenWidth, YGScreenHeight);
    [self.view addSubview:_mainScrollView];
    
    _topScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth*0.45) delegate:self placeholderImage:YGDefaultImgFour_Three];
    _topScrollview.autoScroll = YES;
    _topScrollview.infiniteLoop = YES;
    _topScrollview.imageURLStringsGroup = _imageArray;
    [_mainScrollView addSubview:_topScrollview];
    
    NSArray *itemsArray  = @[
                                       @{
                                           @"img":@"steward_rent_payment_history",
                                           @"title":@"历史缴费记录"
                                           },
                                       @{
                                           @"img":@"steward_rent_pay_bills",
                                           @"title":@"待支付账单"
                                           },
                                       @{
                                           @"img":@"steward_rent_default_bills",
                                           @"title":@"违约账单"
                                           },
                                       @{
                                           @"img":@"steawrd_rent_myinvoice",
                                           @"title":@"房租水电发票  "
                                           },
                                       @{
                                           @"img":@"steward_rent_infomation",
                                           @"title":@"查询我的信息"
                                           }
                                       ];

    int r = 0;
    int k = 0;
    for (int i = 0 ; i<itemsArray.count;i++) {
        
        UIView *buttonBaseView = [[UIView alloc] initWithFrame:CGRectMake(YGScreenWidth/2*r, _topScrollview.height+10+(YGScreenWidth/2*0.73)*k, YGScreenWidth/2, (YGScreenWidth/2*0.73))];
        [_mainScrollView addSubview:buttonBaseView];
        NSDictionary *dict = itemsArray[i];
        UIImage *titleImage = [UIImage imageNamed:dict[@"img"]];
        //左线
        UIImageView *litteHeadImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_tool1.png"]];
//        [litteHeadImageView sd_setImageWithURL:[NSURL URLWithString:itemsArray[i]] placeholderImage:YGDefaultImgSquare];
        litteHeadImageView.image = titleImage;
        litteHeadImageView.frame = CGRectMake(buttonBaseView.width/2-titleImage.size.width/2,buttonBaseView.height/2-titleImage.size.height/2-10-5,titleImage.size.width,titleImage.size.height);
        litteHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
        litteHeadImageView.clipsToBounds = YES;
        [buttonBaseView addSubview:litteHeadImageView];
        
        UILabel  *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,litteHeadImageView.y+litteHeadImageView.height+5 , buttonBaseView.width, 20)];
        nameLabel.text = dict[@"title"];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        nameLabel.textColor = colorWithBlack;
        [buttonBaseView addSubview:nameLabel];
        
        
        UIButton *coverButton = [[UIButton alloc]init];
        coverButton.tag = 1000+i;
        [coverButton addTarget:self action:@selector(functionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        coverButton.frame = CGRectMake(0, 0, buttonBaseView.width, buttonBaseView.height);
        [buttonBaseView addSubview:coverButton];
        r++;
        if ((i+1)%2==0) {
            k++;
            r=0;
            UIView *linehoribleView = [[UIView alloc] initWithFrame:CGRectMake(0,_topScrollview.height+10+coverButton.height*k-1, YGScreenWidth, 1)];
            linehoribleView.backgroundColor = colorWithLine;
            [_mainScrollView addSubview:linehoribleView];
        }
    
    }
    UIView *lineVerticalView = [[UIView alloc] initWithFrame:CGRectMake(YGScreenWidth/2, _topScrollview.height+10, 1, YGScreenWidth/2*0.73*3)];
    lineVerticalView.backgroundColor = colorWithLine;
    [_mainScrollView addSubview:lineVerticalView];

    _mainScrollView.contentSize = CGSizeMake(YGScreenWidth, _topScrollview.height+YGScreenWidth/2*0.73*3+10);

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
 
            BreakContractBillViewController *controller = [[BreakContractBillViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 2:
        {
            BillsDetailViewController *controller = [[BillsDetailViewController alloc] init];
            controller.pageType = @"breakContract";
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 3:
        {
            InvoiceManagerViewController *vc = [[InvoiceManagerViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:
        {
            MyContractViewController *controller = [[MyContractViewController alloc]init];
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
