//
//  MyHouseRentPayDetailViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/11/16.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyHouseRentPayDetailViewController.h"
#import "InvoiceHistoryModel.h"

@interface MyHouseRentPayDetailViewController ()

@end

@implementation MyHouseRentPayDetailViewController
{
    UIScrollView *_scrollView;
    UILabel *_statusLabel;
    UILabel *_priceLabel;
    InvoiceHistoryModel *_model;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}
- (void)configAttribute
{
    self.naviTitle = @"订单详情";
}
- (void)loadData
{
    [YGNetService YGPOST:REQUEST_PaymentRecordsDetail parameters:@{@"id":_itemID} showLoadingView:NO scrollView:nil success:^(id responseObject) {

        _model = [[InvoiceHistoryModel alloc] init];
        [_model setValuesForKeysWithDictionary:responseObject[@"Detail"]];
        [self configUI];

    } failure:^(NSError *error) {
        
    }];
}
- (void)configUI
{
    self.view.backgroundColor = colorWithTable;
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, YGScreenWidth, 100);
    [self.view addSubview:_scrollView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
    topView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:topView];

    //热门推荐label
    _statusLabel = [[UILabel alloc]init];
    _statusLabel.textColor = colorWithMainColor;
    _statusLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _statusLabel.text = @"交易成功";
    _statusLabel.frame = CGRectMake(20, 40,YGScreenWidth-40, 20);
    [topView addSubview:_statusLabel];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.centery = topView.centery;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.height+10, YGScreenWidth, 45)];
    titleView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:titleView];
    
    UILabel *priceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 75, 45)];
    priceTitleLabel.text = @"付款金额:";
    priceTitleLabel.textAlignment = NSTextAlignmentLeft;
    priceTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    priceTitleLabel.textColor = colorWithDeepGray;
    [titleView addSubview:priceTitleLabel];

    
    //热门推荐label
    _priceLabel = [[UILabel alloc]init];
    _priceLabel.textColor = colorWithBlack;
    _priceLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _priceLabel.text = _model.money;
    _priceLabel.frame = CGRectMake(priceTitleLabel.x+priceTitleLabel.width+10, 0,120, 45);
    [titleView addSubview:_priceLabel];
    
    

    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, titleView.y+titleView.height+1, YGScreenWidth, 100)];
    middleView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:middleView];
    
    NSArray *titleArray = @[@"付款方式",@"缴费说明",@"户号"];
   _model.content = _model.content == nil?@"" :_model.content;
    _model.address = _model.address == nil?@"" :_model.address;

    NSArray *contentArray = @[_model.content,_model.type ,_model.address];
    for (int i = 0; i<3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,10+30*i , 80, 25)];
        label.text = titleArray[i];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        label.textColor = colorWithDeepGray;
        [middleView addSubview:label];
        
        
        //热门推荐label
        UILabel  *contentLabel = [[UILabel alloc]init];
        contentLabel.textColor = colorWithBlack;
        contentLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        contentLabel.text = contentArray[i];
        contentLabel.frame = CGRectMake(label.x+label.width+10, label.y,YGScreenWidth/2, 20);
        [middleView addSubview:contentLabel];

    }
    
  
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, middleView.y+middleView.height+1, YGScreenWidth,70)];
    bottomView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:bottomView];
    
    NSArray *bottomTitleArray = @[@"创建时间",@"订单号"];
    _model.time = _model.time == nil?@"" :_model.time;
    _model.number = _model.number == nil?@"" :_model.number;
    NSArray *bottomContentArray = @[_model.time,_model.number];
    for (int i = 0; i<2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,10+30*i , 80, 25)];
        label.text = bottomTitleArray[i];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        label.textColor = colorWithDeepGray;
        [bottomView addSubview:label];
        
        
        //热门推荐label
        UILabel  *contentLabel = [[UILabel alloc]init];
        contentLabel.textColor = colorWithBlack;
        contentLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        contentLabel.text = bottomContentArray[i];
        contentLabel.frame = CGRectMake(label.x+label.width+10, label.y,YGScreenWidth/2, 20);
        [bottomView addSubview:contentLabel];
        
    }
    _scrollView.frame = CGRectMake(0, 0, YGScreenWidth, bottomView.y+bottomView.height+10);

    
}
@end
