//
//  MineIntergralOrderDetailsController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MineIntergralOrderDetailsController.h"
#import "MineIntergralRecordOrderTableViewCell.h"

@interface MineIntergralOrderDetailsController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,strong)NSString *orderType;//订单状态，0待发货，1待收货，2已完成

@end

@implementation MineIntergralOrderDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"订单详情";
    
    self.dataDic = [[NSDictionary alloc]init];
    
    [self loadData];
}


-(void)loadData
{
    [YGNetService YGPOST:@"integralOrderDetails" parameters:@{@"oId":self.idString} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        self.dataDic = responseObject;
        
        self.orderType = [responseObject valueForKey:@"orederState"];//订单状态，0待发货，1待收货，2已完成
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenHeight - YGStatusBarHeight - YGNaviBarHeight - 50, YGScreenWidth, 50)];
        bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-100,10,90,30)];
        [deleteButton addTarget:self action:@selector(deliverCurriculumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.layer.borderWidth = 1;
        deleteButton.layer.cornerRadius = 15;
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
//        [deleteButton sizeToFit];
        if ([self.orderType isEqualToString:@"1"]) {
            [deleteButton setTitle:@"确认收货" forState:UIControlStateNormal];
            [deleteButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
            deleteButton.layer.borderColor = colorWithMainColor.CGColor;
            [bottomView addSubview:deleteButton];
            [self.view addSubview:bottomView];
        }
        if ([self.orderType isEqualToString:@"2"]) {
            [deleteButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [deleteButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            deleteButton.layer.borderColor = colorWithLine.CGColor;
            [bottomView addSubview:deleteButton];
            [self.view addSubview:bottomView];
        }
        [self configUI];
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - 50 - YGBottomMargin) style:UITableViewStyleGrouped];
    [_tableView registerClass:[MineIntergralRecordOrderTableViewCell class] forCellReuseIdentifier:@"MineIntergralRecordOrderTableViewCell"];
    _tableView.backgroundColor = colorWithTable;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self configHeader];
    [self configFooterView];
}


-(void)configHeader
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.18 + 10)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *orderStatelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, YGScreenWidth - 20, YGScreenWidth * 0.18)];
    switch ([self.orderType integerValue]) {
        case 0:
            orderStatelabel.text = @"待发货";
            break;
        case 1:
            orderStatelabel.text = @"待收货";
            break;
        case 2:
            orderStatelabel.text = @"已完成";
            break;
        default:
            break;
    }
    
    orderStatelabel.font = [UIFont boldSystemFontOfSize:18.0];
    orderStatelabel.textColor = colorWithOrangeColor;
    [headerView addSubview:orderStatelabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenWidth * 0.18, YGScreenWidth, 10)];
    lineView.backgroundColor = colorWithTable;
    [headerView addSubview:lineView];
    
    if([self.orderType isEqualToString:@"1"] || [self.orderType isEqualToString:@"2"])
    {
        headerView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.18 + 60);
        UILabel *expressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, YGScreenWidth * 0.18 + 10, YGScreenWidth - 20, 50)];
        expressLabel.font = [UIFont systemFontOfSize:15.0];
        [headerView addSubview:expressLabel];
        
        expressLabel.text = [NSString stringWithFormat:@"%@:%@",self.dataDic[@"expressCompany"],self.dataDic[@"expressNumber"]];
        
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, YGScreenWidth * 0.18 + 59, YGScreenWidth, 1)];
        lineLabel.text = @"";
        lineLabel.backgroundColor = colorWithLine;
        [headerView addSubview:lineLabel];
        
    }
    _tableView.tableHeaderView = headerView;
}

-(void)configFooterView
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 80)];
    footerView.backgroundColor = [UIColor whiteColor];
    UILabel *footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, YGScreenWidth - 10, 60)];
    footerLabel.font = [UIFont systemFontOfSize:15.0];
    footerLabel.textColor = colorWithDeepGray;
    footerLabel.numberOfLines = 0;
    if([self.orderType isEqualToString:@"2"])
    {
        footerLabel.text = [NSString stringWithFormat:@"订单单号: %@\n下单时间: %@\n完成时间: %@",self.dataDic[@"orederNum"],self.dataDic[@"createDate"],self.dataDic[@"completeDate"]];
    }
    else
    {
        footerLabel.text = [NSString stringWithFormat:@"订单单号: %@\n下单时间: %@",self.dataDic[@"orederNum"],self.dataDic[@"createDate"]];
        footerView.frame = CGRectMake(0, 0, YGScreenWidth, 60);
        footerLabel.frame = CGRectMake(10, 10, YGScreenWidth - 10, 40);
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:footerLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [footerLabel.text length])];
    footerLabel.attributedText = attributedString;
    [footerLabel sizeToFit];
    [footerView addSubview:footerLabel];
    _tableView.tableFooterView = footerView;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineIntergralRecordOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineIntergralRecordOrderTableViewCell" forIndexPath:indexPath];
    [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"picture"]] placeholderImage:YGDefaultImgFour_Three];
    cell.goodsNamelabel.text = self.dataDic[@"title"];
    NSString *integralString = self.dataDic[@"commodityIntegral"];
//    cell.goodsPrice.text = [NSString stringWithFormat:@"%@ 青币",self.dataDic[@"commodityIntegral"]];
    [cell.goodsPrice addAttributedWithString:integralString lineSpace:8];
    [cell.goodsPrice addAttributedWithString:[NSString stringWithFormat:@"%@ 青币",self.dataDic[@"commodityIntegral"]] range:NSMakeRange(0, integralString.length) color:colorWithOrangeColor];
    cell.goodsPrice.font = [UIFont systemFontOfSize:14.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    return 100;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.17)];
    addressView.backgroundColor = [UIColor whiteColor];
//    [headerView addSubview:addressView];
    
    UILabel *peopleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, YGScreenWidth, (YGScreenWidth * 0.17 - 10) / 2)];
    peopleLabel.text = [NSString stringWithFormat:@"收货人:%@           %@",self.dataDic[@"userName"],self.dataDic[@"userPhone"]];
    peopleLabel.font = [UIFont systemFontOfSize:15.0];
    [addressView addSubview:peopleLabel];
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, (YGScreenWidth * 0.17 - 10) / 2 + 5, YGScreenWidth, (YGScreenWidth * 0.17 - 10) / 2)];
    addressLabel.text = [NSString stringWithFormat:@"收货地址:%@",self.dataDic[@"address"]];
    addressLabel.font = [UIFont systemFontOfSize:15.0];
    [addressView addSubview:addressLabel];
    
    return addressView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  YGScreenWidth * 0.17;
}


-(void)deliverCurriculumButtonAction:(UIButton *)button
{
    if([button.titleLabel.text isEqualToString:@"确认收货"])
    {
        [YGAlertView showAlertWithTitle:@"是否确认收货？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                return ;
            }else
            {
                [YGNetService YGPOST:@"GoodsReceipt" parameters:@{@"oId":self.dataDic[@"orderId"]} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
                    
                    NSLog(@"%@",responseObject);
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } failure:^(NSError *error) {
                    
                }];
            }
        }];
    }
    else
    {
        [YGAlertView showAlertWithTitle:@"确定删除此订单？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                return ;
            }else
            {
                [YGNetService YGPOST:@"DeleteOrder" parameters:@{@"id":self.dataDic[@"orderId"]} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
                    
                    NSLog(@"%@",responseObject);
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } failure:^(NSError *error) {
                    
                }];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
