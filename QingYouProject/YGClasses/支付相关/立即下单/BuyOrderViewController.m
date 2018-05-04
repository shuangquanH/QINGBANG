//
//  BuyOrderViewController.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/9/25.
//  Copyright © 2017 ccyouge. All rights reserved.
//

#import "BuyOrderViewController.h"
#import "ShopItemModel.h"
#import "BuyOrderPayWayModel.h"
#import "BuyOrderTableViewCell.h"
#import "ResultViewController.h"
#import <Pingpp.h>

@interface BuyOrderViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UIButton *_pointsPayCheckButton;
    UILabel *_offPriceLabel;
    UITableView *_tableView;
    NSMutableArray *_listArray;
    NSIndexPath *_lastIndexPath;
    UILabel *_realPriceLabel;
    UILabel *_pointsDetailLabel;
    NSString *_price;
    NSString *_pointPrice;
    NSString *_isCheck;
    UILabel *_kindLabel;
    NSString * _getPoint;
}
@end

@implementation BuyOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isCheck = @"0";
    [self configUI];
    [self netService];
    //接收支付结果的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushViewController:) name:@"paySuccess" object:nil];
}


- (void)configAttribute
{
    self.naviTitle = @"立即下单";

    _listArray = @[].mutableCopy;
    NSArray *listArray = @[
            @{
                    @"imageName" : @"pay_alipay",
                    @"payTitle"  : @"支付宝支付",
                    @"isSelected": @(YES)
            },
            @{
                    @"imageName" : @"pay-wechat",
                    @"payTitle"  : @"微信支付",
                    @"isSelected": @(NO)
            },
            @{
                    @"imageName" : @"pay_offline",
                    @"payTitle"  : @"线下支付",
                    @"isSelected": @(NO)
            }
    ];
    _lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_listArray addObjectsFromArray:[BuyOrderPayWayModel mj_objectArrayWithKeyValuesArray:listArray]];
}


- (void)configUI
{
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0)];
    tableHeaderView.backgroundColor = colorWithYGWhite;

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];

    titleLabel.text = self.titleLabelStr;

    [titleLabel sizeToFitHorizontal];
    titleLabel.x = 10;
    titleLabel.y = 13;
    [tableHeaderView addSubview:titleLabel];

    float tempMaxY = CGRectGetMaxY(titleLabel.frame);
    if (_model.type.intValue == 2 || _model.type.intValue == 3)
    {
        _kindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, YGScreenWidth - 20, 16)];
        _kindLabel.textColor = colorWithDeepGray;
        _kindLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _kindLabel.text = [NSString stringWithFormat:@"类别：%@", _model.kind];
//        [kindLabel sizeToFitHorizontal];
        _kindLabel.x = titleLabel.x;
        _kindLabel.y = CGRectGetMaxY(titleLabel.frame) + 13;
        [tableHeaderView addSubview:_kindLabel];
        tempMaxY = CGRectGetMaxY(_kindLabel.frame);

        if (_model.type.intValue == 2) {
            UILabel *yearLabel = [[UILabel alloc] init];
            yearLabel.textColor = _kindLabel.textColor;
            yearLabel.font = _kindLabel.font;
            yearLabel.text = [NSString stringWithFormat:@"年限：%@", _model.year];
            [yearLabel sizeToFitHorizontal];
            yearLabel.x = titleLabel.x;
            yearLabel.y = CGRectGetMaxY(_kindLabel.frame) + 13;
            [tableHeaderView addSubview:yearLabel];
            tempMaxY = CGRectGetMaxY(yearLabel.frame);
        }
    }

    _realPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.x, tempMaxY + 13, YGScreenWidth -20, 15)];
    _realPriceLabel.textColor = colorWithOrangeColor;
    _realPriceLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
     _realPriceLabel.text = [NSString stringWithFormat:@"¥%@", _model.price];
    _price = _model.price;
    [tableHeaderView addSubview:_realPriceLabel];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _realPriceLabel.y + _realPriceLabel.height + 13, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithLine;
    [tableHeaderView addSubview:lineView];

    UILabel *pointsLabel = [[UILabel alloc] init];
    pointsLabel.textColor = titleLabel.textColor;
    pointsLabel.font = titleLabel.font;
    pointsLabel.text = @"青币购支付";
    [pointsLabel sizeToFitHorizontal];
    pointsLabel.x = titleLabel.x;
    pointsLabel.y = CGRectGetMaxY(lineView.frame) + 13;
    [tableHeaderView addSubview:pointsLabel];

     _pointsDetailLabel= [[UILabel alloc] init];
    _pointsDetailLabel.textColor = colorWithDeepGray;
    _pointsDetailLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    
    _pointsDetailLabel.x = CGRectGetMaxX(pointsLabel.frame) + 12;
//    _pointsDetailLabel.centery = pointsLabel.centery;
    _pointsDetailLabel.y = CGRectGetMaxY(lineView.frame) + 15;

    [tableHeaderView addSubview:_pointsDetailLabel];
    

    _pointsPayCheckButton = [[UIButton alloc] init];
    [_pointsPayCheckButton setImage:[UIImage imageNamed:@"order_nochoice_btn_gray"] forState:UIControlStateNormal];
    [_pointsPayCheckButton setImage:[UIImage imageNamed:@"order_choice_btn_green"] forState:UIControlStateSelected];
    [_pointsPayCheckButton sizeToFit];
    [_pointsPayCheckButton addTarget:self action:@selector(pointsPayCheckButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:_pointsPayCheckButton];
    [_pointsPayCheckButton mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.centerY.mas_equalTo(pointsLabel);
        make.right.mas_equalTo(-10);
    }];

    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(lineView.x, pointsLabel.y + pointsLabel.height + 13, lineView.width, lineView.height)];
    lineView1.backgroundColor = lineView.backgroundColor;
    [tableHeaderView addSubview:lineView1];

    UILabel *offPriceTextLabel = [[UILabel alloc] init];
    offPriceTextLabel.textColor = titleLabel.textColor;
    offPriceTextLabel.font = titleLabel.font;
    offPriceTextLabel.text = @"还需支付";
    [offPriceTextLabel sizeToFitHorizontal];
    offPriceTextLabel.x = titleLabel.x;
    offPriceTextLabel.y = CGRectGetMaxY(lineView1.frame) + 13;
    [tableHeaderView addSubview:offPriceTextLabel];

    _offPriceLabel = [[UILabel alloc] init];
    _offPriceLabel.textColor = colorWithOrangeColor;
    _offPriceLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    _offPriceLabel.text = [NSString stringWithFormat:@"¥%@", _model.price];
    [tableHeaderView addSubview:_offPriceLabel];

    [_offPriceLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(offPriceTextLabel);
    }];

    tableHeaderView.height = CGRectGetMaxY(offPriceTextLabel.frame) + 13;

    UIButton *surePayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, YGScreenHeight - YGBottomMargin - YGNaviBarHeight - YGStatusBarHeight - 45, YGScreenWidth, 45 + YGBottomMargin)];
    [surePayButton setTitle:@"确认支付" forState:UIControlStateNormal];
    surePayButton.backgroundColor = colorWithMainColor;
    surePayButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    surePayButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
    [surePayButton addTarget:self action:@selector(surePayButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:surePayButton];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - surePayButton.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = tableHeaderView;
    _tableView.rowHeight = 57;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BuyOrderTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"xx"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xx" forIndexPath:indexPath];
    cell.model = _listArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 33)];
    sectionHeaderView.backgroundColor = colorWithTable;

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, sectionHeaderView.width - 10, sectionHeaderView.height)];
    headerLabel.text = @"支付方式";
    headerLabel.textColor = colorWithDeepGray;
    headerLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [sectionHeaderView addSubview:headerLabel];
    return sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_lastIndexPath)
    {
        if([_lastIndexPath isEqual:indexPath])
        {
            return;
        }
        BuyOrderPayWayModel *model = _listArray[_lastIndexPath.row];
        model.isSelected = NO;
    }
    BuyOrderPayWayModel *model = _listArray[indexPath.row];
    model.isSelected = YES;
    [_tableView reloadData];
    _lastIndexPath = indexPath;
    if(_lastIndexPath.row == 2)
    {
        _pointsPayCheckButton.selected  = NO;
       _pointsPayCheckButton.userInteractionEnabled = NO;
        _offPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", _price.floatValue];
        _isCheck = @"0";
        [YGAlertView showAlertWithTitle:@"线下支付不支持青币购支付" buttonTitlesArray:@[@"确定"] buttonColorsArray:@[colorWithBlack] handler:^(NSInteger buttonIndex) {
            
        } ];
    }
    else
        _pointsPayCheckButton.userInteractionEnabled = YES;

}

- (void)pointsPayCheckButtonClick:(UIButton *)button
{
    button.selected = !button.isSelected;
    if(button.isSelected)
    {
        _offPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [_price floatValue] - _pointPrice.floatValue];
         _isCheck = @"1";
    }
    else
    {
        _offPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", _price.floatValue];
         _isCheck = @"0";
    }
}

- (void)surePayButtonClick
{
    if([self.pageType isEqualToString:@"FinancialAccountingViewController"])
    {
        if(_lastIndexPath.row == 0 || _lastIndexPath.row ==1)
        {
            NSString * channel = @"alipay";
            if(_lastIndexPath.row ==1)
                channel = @"wx";
            
            [self.dict setObject:YGSingletonMarco.user.userId forKey:@"userID"];
            [self.dict setObject:_isCheck forKey:@"isCheck"];
            [self.dict setObject:channel forKey:@"channel"];
            [self.dict setObject:self.commerceID forKey:@"financeID"];

            NSDictionary * parameters = [NSDictionary dictionaryWithDictionary:self.dict];
            
            __weak typeof(self)Weakself = self;
            
            [YGNetService YGPOST:@"FinancePayOrder" parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
                
                NSString * charge = responseObject[@"charge"];
                _getPoint = responseObject[@"getPoint"];

                if(!charge.length)
                {
                    //支付宝
                    ResultViewController *controller = [[ResultViewController alloc] init];
                    controller.pageType =  ResultPageTypeIndustryFinancialResult;
                    controller.earnPoints = [_getPoint intValue];
                    [self.navigationController pushViewController:controller animated:YES];
                    return ;
                }
                
                [Pingpp createPayment:responseObject[@"charge"] viewController:Weakself appURLScheme:@"qingyouhui" withCompletion:^(NSString *result, PingppError *error){
                    if ([result isEqualToString:@"success"])
                    {
                        if ([channel isEqualToString:@"alipay"]) {
                            //支付宝
                            ResultViewController *controller = [[ResultViewController alloc] init];
                            controller.pageType =  ResultPageTypeIndustryFinancialResult;
                            controller.earnPoints = [_getPoint intValue];
                            [self.navigationController pushViewController:controller animated:YES];
                            
                            [YGAppTool showToastWithText:@"购买成功"];
                        }
                        NSLog(@"success");
                    } else {
                        if (error.code == PingppErrWxNotInstalled) {
                            [YGAppTool showToastWithText:@"请安装微信客户端"];
                        }
                        NSLog(@"PingppError: code=%lu msg=%@", error.code, [error getMsg]);
                    }
                }];
                
            } failure:^(NSError *error) {
                
            }];
        }else
        {
            [self.dict setObject:YGSingletonMarco.user.userId forKey:@"userID"];
            [self.dict setObject:self.commerceID forKey:@"financeID"];
            
            
            [YGNetService YGPOST:@"FinanceOfflineOrder" parameters:self.dict showLoadingView:NO scrollView:nil success:^(id responseObject) {
                
                [YGAppTool showToastWithText:@"线下支付成功"];
                ResultViewController *controller = [[ResultViewController alloc] init];
                controller.pageType =  ResultPageTypeOfflinePayResult;
                [self.navigationController pushViewController:controller animated:YES];
                
            } failure:^(NSError *error) {
                
            }];
        }
    }
    else
    {
        if(_lastIndexPath.row == 0 || _lastIndexPath.row ==1)
        {
            NSString * channel = @"alipay";
            if(_lastIndexPath.row ==1)
                channel = @"wx";
            
            [self.dict setObject:YGSingletonMarco.user.userId forKey:@"userID"];
            [self.dict setObject:_isCheck forKey:@"isCheck"];
            [self.dict setObject:channel forKey:@"channel"];
            [self.dict setObject:self.commerceID forKey:@"commerceID"];
            
            NSDictionary * parameters = [NSDictionary dictionaryWithDictionary:self.dict];
            
            __weak typeof(self)Weakself = self;
            
            [YGNetService YGPOST:@"CommercePayOrder" parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
                _getPoint = responseObject[@"getPoint"];

                NSString * charge = responseObject[@"charge"];
                if(!charge.length)
                {
                    //支付宝
                    ResultViewController *controller = [[ResultViewController alloc] init];
                    controller.pageType =  ResultPageTypeIndustryFinancialResult;
                    controller.earnPoints = [_getPoint intValue];
                    [self.navigationController pushViewController:controller animated:YES];
                    return ;
                }
                [Pingpp createPayment:responseObject[@"charge"] viewController:Weakself appURLScheme:@"qingyouhui" withCompletion:^(NSString *result, PingppError *error){
                    if ([result isEqualToString:@"success"])
                    {
                        if ([channel isEqualToString:@"alipay"]) {
                            //支付宝
                            ResultViewController *controller = [[ResultViewController alloc] init];
                            controller.pageType =  ResultPageTypeIndustryFinancialResult;
                            controller.earnPoints = [_getPoint intValue];
                            [self.navigationController pushViewController:controller animated:YES];
                            
                            [YGAppTool showToastWithText:@"购买成功"];
                        }
                        NSLog(@"success");
                    } else {
                        if (error.code == PingppErrWxNotInstalled) {
                            [YGAppTool showToastWithText:@"请安装微信客户端"];
                        }
                        NSLog(@"PingppError: code=%lu msg=%@", error.code, [error getMsg]);
                    }
                }];
                
            } failure:^(NSError *error) {
                
            }];
        }else
        {
            [self.dict setObject:YGSingletonMarco.user.userId forKey:@"userID"];
            [self.dict setObject:self.commerceID forKey:@"commerceID"];
            
            
            [YGNetService YGPOST:@"CommerceOfflineOrder" parameters:self.dict showLoadingView:NO scrollView:nil success:^(id responseObject) {
                
                [YGAppTool showToastWithText:@"线下支付成功"];
                ResultViewController *controller = [[ResultViewController alloc] init];
                controller.pageType =  ResultPageTypeOfflinePayResult;
                [self.navigationController pushViewController:controller animated:YES];
                
            } failure:^(NSError *error) {
                
            }];
        }
    }
 

}

- (void)pushViewController:(NSNotification *)notif
{
    NSString *state = notif.userInfo[@"successOrNot"];
    
   
    if ([state isEqualToString:@"1"])
    {
     
        //支付宝
        ResultViewController *controller = [[ResultViewController alloc] init];
        controller.pageType =  ResultPageTypeIndustryFinancialResult;
        controller.earnPoints = [_getPoint intValue];
        [self.navigationController pushViewController:controller animated:YES];
        
        [YGAppTool showToastWithText:@"购买成功"];
    }
    else
    {
        [YGAppTool showToastWithText:@"购买失败"];
    }
}


-(void)netService
{
    if([self.pageType isEqualToString:@"FinancialAccountingViewController"])
    {

        NSDictionary *parameters = @{
                                     @"userID":YGSingletonMarco.user.userId,
                                     @"financeID":self.commerceID,
                                     @"count":self.dict[@"count"],
                                     };
        [YGNetService YGPOST:@"FinanceOrderView" parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
//            _realPriceLabel.text = [NSString stringWithFormat:@"￥%@", responseObject[@"price"]];
//            [_realPriceLabel sizeToFitHorizontal];
            
            _offPriceLabel.text =[NSString stringWithFormat:@"￥%@", responseObject[@"price"]];
            _price =  responseObject[@"price"];
            _pointPrice = responseObject[@"pointPrice"];
//
//            _kindLabel.text = [NSString stringWithFormat:@"类别：%@", responseObject[@"labelName"]];
            
            [_pointsDetailLabel addAttributedWithString:[NSString stringWithFormat:@"(可用%@青币抵￥%@)", responseObject[@"point"],  responseObject[@"pointPrice"]] range:NSMakeRange([NSString stringWithFormat:@"(可用%@青币抵", responseObject[@"point"]].length, [NSString stringWithFormat:@"￥%@", responseObject[@"pointPrice"]].length) color:colorWithOrangeColor];
            [_pointsDetailLabel sizeToFitHorizontal];
            
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        NSString * labelID = @"";
        if(self.dict.count)
            labelID =  self.dict[@"labelID"];
        
        NSDictionary *parameters = @{
                                     @"userID":YGSingletonMarco.user.userId,
                                     @"commerceID":self.commerceID,
                                     @"labelID":labelID
                                     };
        [YGNetService YGPOST:@"CommerceOrderView" parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
            _realPriceLabel.text = [NSString stringWithFormat:@"￥%@", responseObject[@"price"]];
            [_realPriceLabel sizeToFitHorizontal];
            
            _offPriceLabel.text =[NSString stringWithFormat:@"￥%@", responseObject[@"price"]];
            _price =  responseObject[@"price"];
            _pointPrice = responseObject[@"pointPrice"];
            
            _kindLabel.text = [NSString stringWithFormat:@"类别：%@", responseObject[@"labelName"]];
            
            [_pointsDetailLabel addAttributedWithString:[NSString stringWithFormat:@"(可用%@青币抵￥%@)", responseObject[@"point"],  responseObject[@"pointPrice"]] range:NSMakeRange([NSString stringWithFormat:@"(可用%@青币抵", responseObject[@"point"]].length, [NSString stringWithFormat:@"￥%@", responseObject[@"pointPrice"]].length) color:colorWithOrangeColor];
            [_pointsDetailLabel sizeToFitHorizontal];
            
        } failure:^(NSError *error) {
            
        }];
    }

}
@end















