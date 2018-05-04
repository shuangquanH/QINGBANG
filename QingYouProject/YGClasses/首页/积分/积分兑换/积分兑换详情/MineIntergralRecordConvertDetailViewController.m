//
//  MineIntergralRecordConvertDetailViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MineIntergralRecordConvertDetailViewController.h"
#import "GoodsPlaceView.h"
#import "ManageMailPostModel.h"
#import "ManageMailPostViewController.h"
#import "IntegralExchangeCell.h"
#import "MineIntergralViewController.h"

@interface MineIntergralRecordConvertDetailViewController ()<UITableViewDelegate,UITableViewDataSource,GoodsPlaceViewDelegate,ManageMailPostViewControllerDelegate>
{
    UITableView *_tableView;
}

/** 地址View  */
@property (nonatomic,strong) GoodsPlaceView * placeView;
@property (nonatomic,strong) NSString * payFlag;//"支付标示" 0不能支付1可以支付
@property(nonatomic,strong)NSString *addressPhone;
@property(nonatomic,strong)NSString *addressID;
@property(nonatomic,strong)NSString *addressName;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSDictionary *dataDic;//数据字典

@end

@implementation MineIntergralRecordConvertDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.naviTitle = @"青币兑换详情";
    
    //关闭侧滑
    [self setFd_interactivePopDisabled:YES];
    
    self.dataDic = [[NSDictionary alloc]init];
    
     [self loadData];
}


-(void)loadData
{
    [YGNetService YGPOST:@"ExchangeDetails" parameters:@{@"userId":YGSingletonMarco.user.userId,@"imd":self.idString} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        self.dataDic = responseObject;
        
        self.addressID = responseObject[@"addressID"];
        self.addressPhone = responseObject[@"addressPhone"];
        self.addressName = responseObject[@"addressName"];
        self.address = responseObject[@"address"];
        
        
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(0, YGScreenHeight - 50 - YGNaviBarHeight - YGStatusBarHeight, YGScreenWidth, 50);
        if ([responseObject[@"point"]integerValue] >= [responseObject[@"commodityIntegral"]integerValue])
        {
            confirmButton.backgroundColor = colorWithMainColor;
            [confirmButton setTitle:@"立即兑换" forState:UIControlStateNormal];
            [confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            confirmButton.backgroundColor = colorWithLightGray;
            [confirmButton setTitle:@"青币不足" forState:UIControlStateNormal];
            confirmButton.userInteractionEnabled = NO;
        }
        [self.view addSubview:confirmButton];
        
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
    [_tableView registerNib:[UINib nibWithNibName:@"IntegralExchangeCell" bundle:nil] forCellReuseIdentifier:@"IntegralExchangeCell"];
    _tableView.backgroundColor = colorWithTable;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
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
    IntegralExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntegralExchangeCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"picture"]]];
    cell.nameLabel.text = self.dataDic[@"title"];
    cell.integralLabel.text = self.dataDic[@"commodityIntegral"];
    return cell;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YGScreenWidth * 0.27;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    view.backgroundColor = colorWithTable;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 50)];
    footerView.backgroundColor = [UIColor whiteColor];
    UILabel *nowIntergralLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, YGScreenWidth - 20, 50)];
    nowIntergralLabel.font = [UIFont systemFontOfSize:16.0];
    nowIntergralLabel.textColor = colorWithOrangeColor;
    [nowIntergralLabel addAttributedWithString:[NSString stringWithFormat:@"当前青币: %@",self.dataDic[@"point"]] lineSpace:8];
    [nowIntergralLabel addAttributedWithString:[NSString stringWithFormat:@"当前青币: %@",self.dataDic[@"point"]] range:NSMakeRange(0, @"当前青币:".length) color:colorWithBlack];
//    nowIntergralLabel.text = @"当前青币: 6000";
    [footerView addSubview:nowIntergralLabel];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
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

//立即兑换
-(void)confirmClick:(UIButton *)button
{
    [YGAlertView showAlertWithTitle:@"确定兑换？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService YGPOST:@"ImmediatelyChange" parameters:@{@"userId":YGSingletonMarco.user.userId,@"addressId":self.addressID,@"merchandiseId":self.idString} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
                
                NSLog(@"%@",responseObject);
                
                [YGAppTool showToastWithText:@"兑换成功"];
                
                UINavigationController *navc = self.navigationController;
                NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
                for (UIViewController *vc in [navc viewControllers]) {
                    [viewControllers addObject:vc];
                    if ([vc isKindOfClass:[MineIntergralViewController class]]) {
                        break;
                    }
                }
                [navc setViewControllers:viewControllers];

                
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
