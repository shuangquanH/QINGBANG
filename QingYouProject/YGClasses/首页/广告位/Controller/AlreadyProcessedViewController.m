//
//  AlreadyProcessedViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/9/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AlreadyProcessedViewController.h"
#import "AdvertisementApplyCell.h"
#import "OrderListModel.h"
#import "AdvertisementRemarkCell.h"

@interface AlreadyProcessedViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}

@property(nonatomic,strong)NSMutableArray *dataArray; //数据源

@end

@implementation AlreadyProcessedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    
    [self configUI];
    
}


//请求
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_AdsOrder parameters:@{@"userID":YGSingletonMarco.user.userId,@"type":self.typeString,@"total":self.totalString,@"count":self.countString} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if (((NSArray *)responseObject[@"orderList"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        if (headerAction == YES) {
            [self.dataArray removeAllObjects];
        }
        
        [self.dataArray addObjectsFromArray:[OrderListModel mj_objectArrayWithKeyValuesArray:responseObject[@"orderList"]]];
        
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:YES];
        
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}


-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight) style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.estimatedRowHeight = 40;
    _tableView.sectionHeaderHeight = 10;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"AdvertisementRemarkCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AdvertisementRemarkCell"];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        AdvertisementApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdvertisementApplyCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AdvertisementApplyCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.orderModel = self.dataArray[indexPath.section];
        return cell;
    }
    AdvertisementRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdvertisementRemarkCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *remarkString = [self.dataArray[indexPath.section] valueForKey:@"remarks"];
    cell.remarkLabel.text = remarkString;
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count) {
        NSString *remarkString = [self.dataArray[section] valueForKey:@"remarks"];
        if(remarkString.length)
        {
            return 2;
        }
         return 1;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return YGScreenWidth * 0.54 - 40;
    }
    NSString *remarkString = [self.dataArray[indexPath.section] valueForKey:@"remarks"];
    if(remarkString.length)
    {
        return [tableView fd_heightForCellWithIdentifier:@"AdvertisementRemarkCell"                    cacheByIndexPath:indexPath configuration:^(AdvertisementRemarkCell *cell) {
            cell.remarkLabel.text = remarkString;
        }];;
    }
    return 0;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 110)];
    footView.backgroundColor = [UIColor whiteColor];
//    UILabel *remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, YGScreenWidth - 15, 40)];
//    remarkLabel.text = @"备注内容";
//    remarkLabel.numberOfLines = 0;
//    remarkLabel.textColor = colorWithDeepGray;
//    remarkLabel.textAlignment = NSTextAlignmentLeft;
//    remarkLabel.font = [UIFont systemFontOfSize:14.0];
//    [footView addSubview:remarkLabel];
//
//    UILabel *topLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, YGScreenWidth, 0.5)];
//    topLineLabel.text = @"";
//    topLineLabel.backgroundColor = colorWithLine;
//    [footView addSubview:topLineLabel];
    
    UILabel *processingLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, YGScreenWidth - 15, 20)];
    processingLabel.textColor = colorWithDeepGray;
    processingLabel.text = @"您的服务正在处理中！ 2017-09-13 14：00";
    processingLabel.font = [UIFont systemFontOfSize:14.0];

    
    UILabel *processedLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, YGScreenWidth - 15, 20)];
    processedLabel.textColor = colorWithDeepGray;
    processedLabel.text = @"您的服务已处理完成！ 2017-09-13 14：20";
    processedLabel.font = [UIFont systemFontOfSize:14.0];

    UILabel *bottomLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 69, YGScreenWidth, 0.5)];
    bottomLineLabel.text = @"";
    bottomLineLabel.backgroundColor = colorWithLine;

    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, YGScreenWidth, 50)];
    UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    delButton.frame = CGRectMake(YGScreenWidth - 15 - 90, 10, 90, 30);
    [delButton setTitle:@"删除订单" forState:UIControlStateNormal];
    [delButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    delButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    delButton.clipsToBounds = YES;
    delButton.layer.cornerRadius = 15;
    delButton.layer.borderColor = colorWithLine.CGColor;
    delButton.tag = section;
    [delButton addTarget:self action:@selector(delButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    delButton.layer.borderWidth = 1;
    
    switch (_pageType) {
        case 0:
            break;
        case 1:
            footView.frame = CGRectMake(0, 0, YGScreenWidth, 40);
            [footView addSubview:processingLabel];
            processingLabel.text = [NSString stringWithFormat:@"您的服务正在处理中！ %@",[self.dataArray[section] valueForKey:@"beginDate"]];
            [footView addSubview:processingLabel];
            break;
            
        default:
            footView.frame = CGRectMake(0, 0, YGScreenWidth, 120);
            processingLabel.text = [NSString stringWithFormat:@"您的服务正在处理中！ %@",[self.dataArray[section] valueForKey:@"beginDate"]];
            processedLabel.text = [NSString stringWithFormat:@"您的服务已经处理完！ %@",[self.dataArray[section] valueForKey:@"endDate"]];
            [footView addSubview:processingLabel];
            [footView addSubview:processedLabel];
            [footView addSubview:bottomLineLabel];
            [bottomView addSubview:delButton];
            [footView addSubview:bottomView];
            break;
    }
    
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.typeString isEqualToString:@"1"]) {
        return 0.001;
    }
    if ([self.typeString isEqualToString:@"2"]) {
        return 40;
    }
    return 120;
}
//删除订单
-(void)delButtonClick:(UIButton *)button
{
    [YGAlertView showAlertWithTitle:@"确认删除订单吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService YGPOST:REQUEST_AdsOrderDelete parameters:@{@"orderID":[self.dataArray[button.tag] valueForKey:@"orderID"]} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
                NSLog(@"%@",responseObject);
                [YGAppTool showToastWithText:@"删除成功!"];
                [self.dataArray removeObjectAtIndex:button.tag];
                [_tableView reloadData];
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
