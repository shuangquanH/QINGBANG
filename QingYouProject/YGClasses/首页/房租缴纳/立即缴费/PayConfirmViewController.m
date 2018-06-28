//
//  PayConfirmViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PayConfirmViewController.h"
#import "ShopItemModel.h"
#import "BuyOrderPayWayModel.h"
#import "BuyOrderTableViewCell.h"
#import "ResultViewController.h"

#import <Pingpp.h>

@interface PayConfirmViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIButton *_pointsPayCheckButton;
    UILabel *_offPriceLabel;
    UITableView *_tableView;
    NSMutableArray *_listArray;
    NSIndexPath *_lastIndexPath;
    NSString  *_personalOrCommonType; //个人小规模
}

@end

@implementation PayConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
- (void)setModel:(BillDetailModel *)model
{
    _model = model;
}
- (void)configAttribute
{
    self.naviTitle = @"立即支付";
    
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
                               }
//                           @{
//                               @"imageName" : @"tab_1_selected",
//                               @"payTitle"  : @"线下支付",
//                               @"isSelected": @(NO)
//                               }
                           ];
    _lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_listArray addObjectsFromArray:[BuyOrderPayWayModel mj_objectArrayWithKeyValuesArray:listArray]];
    
//    //接收支付结果的消息
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushViewController:) name:@"paySuccess" object:nil];
}

- (void)configUI
{
    NSArray *list  = @[@"用户", @"应缴金额",@"账单时间"];
    NSArray *contentArray = @[_model.name,_model.price,[NSString stringWithFormat:@"%@至%@",_model.startTime,_model.endTime]];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    headerView.backgroundColor = colorWithTable;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    view.backgroundColor = colorWithYGWhite;
    [headerView addSubview:view];
    
    //最新账单
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    titleLabel.text = [self.type isEqualToString:@"1"]?@"房租":([self.type isEqualToString:@"2"]?@"水费":@"电费");
    titleLabel.frame = CGRectMake(10, 10,YGScreenWidth-20, 20);
    [view addSubview:titleLabel];
    
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, view.y+view.height+1, YGScreenWidth, 30*3+20)];
    middleView.backgroundColor = colorWithYGWhite;
    [headerView addSubview:middleView];
    
    for (int i = 0; i<list.count; i++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0,10+(30*i), YGScreenWidth, 30)];
        baseView.backgroundColor = colorWithYGWhite;
        [middleView addSubview:baseView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 75, 30)];
        nameLabel.text = list[i];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        nameLabel.textColor = colorWithDeepGray;
        [nameLabel sizeToFit];
        [baseView addSubview:nameLabel];
        nameLabel.frame = CGRectMake(nameLabel.x, nameLabel.y, nameLabel.width, 30);
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width+20, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-20, nameLabel.height)];
        textField.tag = 100+i;
        textField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        textField.textColor = colorWithBlack;
        [baseView addSubview:textField];
        textField.text = contentArray[i];
        [textField setEnabled:NO];
        if (i == 1) {
            textField.textColor = colorWithOrangeColor;
            textField.text = [NSString stringWithFormat:@"¥%@", contentArray[i]];
        }
    }
    headerView.frame = CGRectMake(0, 0, YGScreenWidth,middleView.y+middleView.height);
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
    _tableView.tableHeaderView = headerView;
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
}

- (void)surePayButtonClick
{
    if (_lastIndexPath == nil)
    {
        [YGAppTool showToastWithText:@"请选择支付方式"];
        return;
    }
    
    __weak typeof(self)Weakself = self;
    
    NSString *channel = _lastIndexPath.row == 0?@"alipay":@"wx";
    [YGNetService YGPOST:REQUEST_HousePay parameters:@{@"phone":YGSingletonMarco.user.myContractPhoneNumber,@"status":self.isIssueInvoice,@"channel":channel,@"type":self.type} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        [Pingpp createPayment:responseObject[@"charge"] viewController:Weakself appURLScheme:@"qingyouhui" withCompletion:^(NSString *result, PingppError *error){
            if ([result isEqualToString:@"success"])
            {
                /** 原来代码 */
//                if ([channel isEqualToString:@"alipay"]) {
//                    //支付宝
//                    ResultViewController *controller = [[ResultViewController alloc] init];
//                    controller.pageType = ResultPageTypeSubmitHousePayResult;
//                    controller.earnPoints = 10;
//                    [self.navigationController pushViewController:controller animated:YES];
//                }
//
                /** 新改代码 */
                switch (_lastIndexPath.row) {
                    case 0: {
                        //支付宝
                        ResultViewController *controller = [[ResultViewController alloc] init];
                        controller.pageType = ResultPageTypeSubmitHousePayResult;
                        controller.earnPoints = 10;
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                        break;
                    case 1: {
                        //微信
                        ResultViewController *controller = [[ResultViewController alloc] init];
                        controller.pageType = ResultPageTypeSubmitHousePayResult;
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                        break;
                }
               
                NSLog(@"success");
            } else {
                if (error.code == PingppErrWxNotInstalled) {
                    [YGAppTool showToastWithText:@"请安装微信客户端"];
                } else {
                    [YGAppTool showToastWithText:@"支付失败"];
                }
                NSLog(@"PingppError: code=%lu msg=%@", error.code, [error getMsg]);
            }
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
    
 
    
    
}

/** 原来代码 **/
//- (void)pushViewController:(NSNotification *)notif
//{
//    NSString *state = notif.userInfo[@"successOrNot"];
//
//    if ([state isEqualToString:@"1"])
//    {
//        switch (_lastIndexPath.row)
//        {
//
//            case 0:
//            {
//                //支付宝
//                ResultViewController *controller = [[ResultViewController alloc] init];
//                controller.pageType = ResultPageTypeSubmitHousePayResult;
//                controller.earnPoints = 10;
//                [self.navigationController pushViewController:controller animated:YES];
//            }
//                break;
//            case 1:
//            {
//                //微信
//                ResultViewController *controller = [[ResultViewController alloc] init];
//                controller.pageType = ResultPageTypeSubmitHousePayResult;
//                [self.navigationController pushViewController:controller animated:YES];
//            }
//                break;
////            case 2:
////            {
////                //余额
////                ResultViewController *controller = [[ResultViewController alloc] init];
////                controller.pageType = ResultPageTypeSubmitResult;
////                [self.navigationController pushViewController:controller animated:YES];
////            }
////                break;
//        }
//
//        [YGAppTool showToastWithText:@"支付成功"];
//    }
//    else
//    {
//        [YGAppTool showToastWithText:@"支付失败"];
//    }
//}


@end
