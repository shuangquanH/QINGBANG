//
//  SecondHandPayController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/12/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondHandPayController.h"
#import "GoodsPlaceView.h"//收货人信息:地址 电话 姓名
#import "SecondHandPayCell.h"
#import "ManageMailPostModel.h"
#import "ManageMailPostViewController.h"
#import "PayWayCell.h"
#import "SecondPaySuccessViewController.h"
#import "SecondPayNotesViewController.h"
#import <Pingpp.h>
#import "SecondPayNotesViewController.h"

@interface SecondHandPayController ()<UITableViewDelegate,UITableViewDataSource,GoodsPlaceViewDelegate,ManageMailPostViewControllerDelegate>
{
    UITableView *_tableView;
    NSArray *_iconArray;
    NSArray *_titleArray;
    
}
/** 地址View  */
@property (nonatomic,strong) GoodsPlaceView * placeView;

@property (nonatomic,strong) NSDictionary * orderDic;//数据
@property (nonatomic,strong) NSString * payFlag;//"支付标示" 0不能支付1可以支付
@property(nonatomic,copy)NSString *payStatus; //alipay : 支付宝支付  wx： 微信支付
@property(nonatomic,strong)NSString *addressPhone;
@property(nonatomic,strong)NSString *addressID;
@property(nonatomic,strong)NSString *addressName;
@property(nonatomic,strong)NSString *address;

@end

@implementation SecondHandPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"立即支付";
    
    //关闭侧滑
    [self setFd_interactivePopDisabled:YES];
    
    _iconArray = [NSArray arrayWithObjects:@"pay_alipay",@"pay-wechat", nil];
    _titleArray = [NSArray arrayWithObjects:@"支付宝支付",@"微信支付", nil];
    
    //接收支付结果的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushViewController:) name:@"paySuccess" object:nil];
    
    if(self.replaceIdString.length)
    {
        [self loadReplaceData];
    }
    else if (self.orderNumberString.length)
    {
        [self loadOrderData];
    }
    else
    {
        [self loadData];
    }
}
//生成订单
-(void)loadData
{
    [YGNetService YGPOST:@"addReplacementOrder" parameters:@{@"uid":YGSingletonMarco.user.userId,@"buyWay":self.payType,@"merchandiseId":self.idString} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        self.orderDic = responseObject[@"order"];
        
        self.payFlag = responseObject[@"payFlag"];
        
        self.addressID = responseObject[@"addressID"];
        self.addressPhone = responseObject[@"addressPhone"];
        self.addressName = responseObject[@"addressName"];
        self.address = responseObject[@"address"];
        
        [self configUI];
        
    } failure:^(NSError *error) {
        
    }];
}
//置换去支付
-(void)loadReplaceData
{
    [YGNetService YGPOST:@"ReplaceToPay" parameters:@{@"id":self.replaceIdString} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        self.orderDic = responseObject[@"order"];
        
        self.payFlag = responseObject[@"payFlag"];
        
        self.addressID = responseObject[@"addressID"];
        self.addressPhone = responseObject[@"addressPhone"];
        self.addressName = responseObject[@"addressName"];
        self.address = responseObject[@"address"];
        
        [self configUI];
        
    } failure:^(NSError *error) {
        
    }];
}
//订单详情
-(void)loadOrderData
{
    [YGNetService YGPOST:@"getReplacementOrderDetail" parameters:@{@"orderNum":self.orderNumberString} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        self.orderDic = responseObject[@"order"];
        
        self.payFlag = responseObject[@"payFlag"];
        
        self.addressID = responseObject[@"addressID"];
        self.addressPhone = responseObject[@"addressPhone"];
        self.addressName = responseObject[@"addressName"];
        self.address = responseObject[@"address"];
        
        [self configUI];
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - 网络请求
- (void)sendRequest{
    if(self.addressID.length)
    {
        [self.placeView reloadDataWithName:[NSString stringWithFormat:@"收货人: %@",self.addressName] phone:[NSString stringWithFormat:@"%@",self.addressPhone] place:[NSString stringWithFormat:@"收货地址: %@",self.address]];
        self.placeView.isShowNewButton = NO;
    }
    else
        self.placeView.isShowNewButton = YES;
    
}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - 50 - YGBottomMargin) style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:@"SecondHandPayCell" bundle:nil] forCellReuseIdentifier:@"SecondHandPayCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PayWayCell" bundle:nil] forCellReuseIdentifier:@"PayWayCell"];
    _tableView.backgroundColor = colorWithTable;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(0, YGScreenHeight - 50 - YGNaviBarHeight - YGStatusBarHeight, YGScreenWidth, 50);
    confirmButton.backgroundColor = colorWithMainColor;
    [confirmButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    
    [self configAddress];
}

-(void)configAddress
{
    self.placeView = [[GoodsPlaceView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 90)];
    self.placeView.backgroundColor = [UIColor whiteColor];
    self.placeView.delegate = self;
    [self.placeView lableWithThick];
    _tableView.tableHeaderView = self.placeView;
    
    [self sendRequest];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        SecondHandPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondHandPayCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.picImageview sd_setImageWithURL:[NSURL URLWithString:self.orderDic[@"com"]] placeholderImage:YGDefaultImgSquare];
        cell.nameLabel.text = self.orderDic[@"merchandiseId"];
        return cell;
    }
    if (indexPath.section == 1 && [self.payType isEqualToString:@"2"]) {
        PayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayWayCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconImageView.image = [UIImage imageNamed:_iconArray[indexPath.row]];
        cell.paywayLabel.text = _titleArray[indexPath.row];
        if (indexPath.row == 0)
        {
            self.payStatus = @"alipay";
            cell.radioButton.selected = YES;
        }
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    if(indexPath.section == 0 && indexPath.row == 1)
    {
        if([self.payType isEqualToString:@"1"])
        {
            cell.textLabel.text = @"应付青币";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@青币",self.orderDic[@"price"]];
        }
        if([self.payType isEqualToString:@"2"])
        {
            cell.textLabel.text = @"应付金额";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",self.orderDic[@"price"]];
        }
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        
    }
    if(indexPath.section == 0 && indexPath.row == 2)
    {
        cell.textLabel.text = @"交易须知";
        
        UIButton *knowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        knowButton.frame = CGRectMake(YGScreenWidth - 40, 10, 30, 30);
        [knowButton setTitle:@"" forState:UIControlStateNormal];
        [knowButton setImage:[UIImage imageNamed:@"home_playtogether_disabuse_blue"] forState:UIControlStateNormal];
        [knowButton addTarget:self action:@selector(konwClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:knowButton];
        
    }
    if([self.payType isEqualToString:@"1"] && indexPath.section == 1)
    {
        cell.textLabel.text = @"当前青币";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@青币",self.orderDic[@"buyer"]];
        cell.detailTextLabel.textColor = colorWithOrangeColor;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 3;
    }else
    {
        if ([self.payType isEqualToString:@"1"]) {
            return 1;
        }
        return 2;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return YGScreenWidth * 0.27;
    }
    if (indexPath.section == 1 && [self.payType isEqualToString:@"2"]) {
        return 60;
    }
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 && [self.payType isEqualToString:@"1"]) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
        return view;
    }
    if (section == 1 && [self.payType isEqualToString:@"2"]) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 30)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, YGScreenWidth - 20, 30)];
        label.text = @"支付方式";
        label.font = [UIFont systemFontOfSize:13.0];
        [view addSubview:label];
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 && [self.payType isEqualToString:@"1"]) {
        return 10;
    }
    if (section == 1 && [self.payType isEqualToString:@"2"]) {
        return 30;
    }
    return 0.00001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && [self.payType isEqualToString:@"2"]) {
        PayWayCell *unselectCell0 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        unselectCell0.radioButton.selected = NO;
        PayWayCell *unselectCell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        unselectCell1.radioButton.selected = NO;
        
        
        PayWayCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.radioButton.selected = YES;
        if(indexPath.row == 0)
        {
            self.payStatus = @"alipay";
        }
        else
        {
            self.payStatus = @"wx";
        }
    }
    
}

//交易须知
-(void)knowClick:(UIButton *)button
{
    SecondPayNotesViewController *vc = [[SecondPayNotesViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - GoodsPlaceViewDelegate 地址点击代理事件
- (void)goodsPlaceViewNewerPlaceButtonClick{
    
    ManageMailPostViewController * mailPost =[[ManageMailPostViewController alloc]init];
    mailPost.shippingAddressViewControllerdelegate =self;
    [self.navigationController pushViewController:mailPost animated:YES];
    
}
-(void)passModel:(ManageMailPostModel *)model
{
    [self.placeView reloadDataWithName:[NSString stringWithFormat:@"收货人: %@",model.name] phone:[NSString stringWithFormat:@"%@",model.phone] place:[NSString stringWithFormat:@"收货地址: %@%@%@%@",model.prov,model.city,model.dist,model.address]];
    self.addressID = model.ID;
    self.placeView.isShowNewButton = NO;
    
}

//确认支付
-(void)confirmClick:(UIButton *)button
{
    if ([self.payFlag isEqualToString:@"0"]) {
        [YGAppTool showToastWithText:@"对不起,当前无法支付!"];
        return;
    }
    
    if ([self.payType isEqualToString:@"1"]) {
        self.payStatus = @"";
    }
    
    NSDictionary *orderDic = @{@"channel":self.payStatus,@"orderNum":[self.orderDic valueForKey:@"orderNum"],@"address":self.addressID};
    
    [YGNetService YGPOST:@"replacementPay" parameters:orderDic showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if ([self.payType isEqualToString:@"1"])
        {
            SecondPaySuccessViewController *vc = [[SecondPaySuccessViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [Pingpp createPayment:responseObject[@"charge"] viewController:self appURLScheme:@"qingyouhui" withCompletion:^(NSString *result, PingppError *error){
                if ([result isEqualToString:@"success"])
                {
                    if ([self.payStatus isEqualToString:@"alipay"]) {
                        [YGAppTool showToastWithText:@"购买成功"];
                        SecondPaySuccessViewController *vc = [[SecondPaySuccessViewController alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    NSLog(@"success");
                    
                } else {
                    //                        if (error.code == PingppErrWxNotInstalled || [self.payStatus isEqualToString:@"alipay"]) {
                    //                            [YGAppTool showToastWithText:@"请安装支付宝客户端"];
                    //                        }
                    if (error.code == PingppErrWxNotInstalled) {
                        [YGAppTool showToastWithText:@"请安装微信客户端"];
                    }
                    NSLog(@"PingppError: code=%lu msg=%@", error.code, [error getMsg]);
                }
            }];
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

//交易须知
-(void)konwClick:(UIButton *)button
{
    SecondPayNotesViewController *vc = [[SecondPayNotesViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)pushViewController:(NSNotification *)notif
{
    NSString *state = notif.userInfo[@"successOrNot"];
    if ([state isEqualToString:@"1"])
    {
        [YGAppTool showToastWithText:@"购买成功"];
        SecondPaySuccessViewController *vc = [[SecondPaySuccessViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [YGAppTool showToastWithText:@"购买失败"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
