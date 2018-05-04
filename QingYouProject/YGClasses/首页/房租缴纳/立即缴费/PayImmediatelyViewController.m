//
//  PayImmediatelyViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PayImmediatelyViewController.h"
#import "IssueInvoiceViewController.h"
#import "PayConfirmViewController.h"
#import "BillDetailModel.h"

@interface PayImmediatelyViewController ()<IssueInvoiceViewControllerDelegate>

@end

@implementation PayImmediatelyViewController
{
    UIView *_bottomHeaderView;
    UILabel * _titleHeaderLabel;
//    UILabel * _invoiceLabel;
    UIButton *_coverButton;
    UIImageView *_arrowImageView;
    BillDetailModel *_model;
    NSString  *_isIssueInvoice;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)configAttribute
{
}
- (void)loadData
{
    [self startPostWithURLString:REQUEST_BillingDetails parameters:@{@"phone":YGSingletonMarco.user.myContractPhoneNumber,@"type":self.type} showLoadingView:YES scrollView:nil];
}

-(void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    _model = [[BillDetailModel alloc] init];

   [_model setValuesForKeysWithDictionary:responseObject[@"housingOrder"]];
    [self configUI];
}

- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{
    
}

- (void)configUI
{
    self.naviTitle = @"账单详情";
    NSArray *list  = (NSMutableArray *)@[@"用户", @"应缴金额",@"账单时间"];
    NSArray *contentArray = @[_model.name,_model.price,[NSString stringWithFormat:@"%@ 至 %@",_model.startTime,_model.endTime]];
    UIScrollView *headerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight)];
    headerView.backgroundColor = colorWithTable;
    [self.view addSubview:headerView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    view.backgroundColor = colorWithYGWhite;
    [headerView addSubview:view];
    
    //最新账单
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    titleLabel.text = [self.type isEqualToString:@"1"]?@"房租":([self.type isEqualToString:@"2"]?@"水费":@"电费");
    titleLabel.frame = CGRectMake(10, 10,YGScreenWidth-20, 20);
    [view addSubview:titleLabel];
    
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, view.y+view.height+1, YGScreenWidth, 45*3+20)];
    middleView.backgroundColor = colorWithYGWhite;
    [headerView addSubview:middleView];
    
    for (int i = 0; i<3; i++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0,(46*i), YGScreenWidth, 45)];
        baseView.backgroundColor = colorWithYGWhite;
        [middleView addSubview:baseView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 75, 45)];
        nameLabel.text = list[i];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        nameLabel.textColor = colorWithDeepGray;
        [baseView addSubview:nameLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width+20, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-20, nameLabel.height)];
        textField.tag = 100+i;
        textField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        textField.textAlignment = NSTextAlignmentRight;
        textField.textColor = colorWithBlack;
        [baseView addSubview:textField];
        textField.text = contentArray[i];
        [textField setEnabled:NO];
        
        
    }
    _bottomHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,middleView.y+middleView.height+10, YGScreenWidth, 90)];
    _bottomHeaderView.backgroundColor = colorWithYGWhite;
    [headerView addSubview:_bottomHeaderView];

    UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(10,10,80,30)];
    coverButton.clipsToBounds = YES;
    coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [coverButton setTitle:@"开具发票" forState:UIControlStateNormal];
    [coverButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [coverButton sizeToFit];
    [_bottomHeaderView addSubview:coverButton];
    coverButton.frame = CGRectMake(coverButton.x, coverButton.y, coverButton.width+3, 30);
    
    //开关
    UISwitch *typeSwitch = [[UISwitch alloc] init];
    typeSwitch.frame = CGRectMake(YGScreenWidth-10-typeSwitch.bounds.size.width, 0, 40, 30);
    typeSwitch.centery = coverButton.centery;
    [typeSwitch setTintColor:colorWithYGWhite]; //关闭时颜色
    [typeSwitch setBackgroundColor:colorWithLightGray]; //背景色
    [typeSwitch setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter]; //居中
    [typeSwitch setOnTintColor:colorWithMainColor]; //开始颜色
    [typeSwitch setThumbTintColor:colorWithYGWhite]; //
    typeSwitch.layer.cornerRadius = typeSwitch.bounds.size.height/2.0; //背景的圆角
    typeSwitch.layer.masksToBounds = YES;
    [_bottomHeaderView addSubview:typeSwitch];
    [typeSwitch addTarget:self action:@selector(switchShiftAction:) forControlEvents:UIControlEventValueChanged];
    typeSwitch.selected = NO;
    
    //房租账单明细
    _titleHeaderLabel = [[UILabel alloc]init];
    _titleHeaderLabel.textColor = colorWithBlack;
    _titleHeaderLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _titleHeaderLabel.text = @"房租账单明细";
    _titleHeaderLabel.frame = CGRectMake(10, 60,YGScreenWidth-20, 20);
    _titleHeaderLabel.numberOfLines = 0;
    [_bottomHeaderView addSubview:_titleHeaderLabel];
    
    


    
    _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YGScreenWidth-25, _titleHeaderLabel.y, 15, 15)];
    _arrowImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
    [_arrowImageView sizeToFit];
    [_bottomHeaderView addSubview:_arrowImageView];
    
    _arrowImageView.centery = _titleHeaderLabel.centery;
    
    _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _coverButton.frame = CGRectMake(YGScreenWidth-150, _titleHeaderLabel.y,120, 30);
    [_coverButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    _coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [_coverButton addTarget:self action:@selector(issueInvoiceParkAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomHeaderView addSubview:_coverButton];
    _coverButton.centery = _titleHeaderLabel.centery;

    [self switchShiftAction:typeSwitch];
    
    //默认选第一个
    
    UIButton *surePayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, YGScreenHeight - YGBottomMargin - YGNaviBarHeight - YGStatusBarHeight - 45, YGScreenWidth, 45 + YGBottomMargin)];
    [surePayButton setTitle:@"支付" forState:UIControlStateNormal];
    surePayButton.backgroundColor = colorWithMainColor;
    surePayButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    surePayButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
    [surePayButton addTarget:self action:@selector(surePayButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:surePayButton];
}

- (void)switchShiftAction:(UISwitch *)swich
{

    if (swich.selected == NO) {
        _isIssueInvoice = @"0";
        _titleHeaderLabel.hidden = YES;
        _arrowImageView.hidden = YES;
        _coverButton.hidden = YES;
        _bottomHeaderView.frame = CGRectMake(_bottomHeaderView.x, _bottomHeaderView.y, YGScreenWidth, 50);
    }else
    {
        _isIssueInvoice = @"1";
        _titleHeaderLabel.hidden = NO;
        _titleHeaderLabel.text = @"发票详情";
        [_titleHeaderLabel sizeToFit];
        _titleHeaderLabel.frame = CGRectMake(_titleHeaderLabel.x, _titleHeaderLabel.y,_titleHeaderLabel.width, _titleHeaderLabel.height);
        _bottomHeaderView.frame = CGRectMake(_bottomHeaderView.x, _bottomHeaderView.y, YGScreenWidth, _titleHeaderLabel.y+_titleHeaderLabel.height+10);
        _arrowImageView.hidden = NO;
        _coverButton.hidden = NO;

    }
        swich.selected = !swich.selected;

}

- (void)issueInvoiceParkAction
{
    IssueInvoiceViewController *VC= [[IssueInvoiceViewController alloc] init];
    VC.delegate =self;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)issueInvoiceViewControllerTakeNumber:(NSString *)number andTitle:(NSString *)title
{
    if ([_model.number isEqualToString:@""]) {
        _model.number = number;
    }
    if (![number isEqualToString:@""]) {
        _model.number = number;
    }
    [_coverButton setTitle:title forState:UIControlStateNormal];
    [_coverButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -_coverButton.width+20)];
}

- (void)surePayButtonClick
{
    if ([_model.number isEqualToString:@""] && [_isIssueInvoice isEqualToString:@"1"]) {
        [YGAppTool showToastWithText:@"请填写发票信息！"];
        return ;
    }
    PayConfirmViewController *VC= [[PayConfirmViewController alloc] init];
    VC.model = _model;
    VC.type = self.type;
    VC.isIssueInvoice = _isIssueInvoice;
    [self.navigationController pushViewController:VC animated:YES];
}
@end
