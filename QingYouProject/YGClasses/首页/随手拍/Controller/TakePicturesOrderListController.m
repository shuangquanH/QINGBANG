//
//  TakePicturesOrderListController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "TakePicturesOrderListController.h"
#import "PictureLeftTextRightCell.h"
#import "TakePicturesOrderDetailController.h"
#import "TakePhotosOrderModel.h"
#import "EvaluateViewController.h"


@interface TakePicturesOrderListController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}

@property(nonatomic,strong)NSString *stateSting;//待服务：1  处理中：2    已结单：3
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UILabel *wuLabel;//没有订单的label显示暂无订单


@end

@implementation TakePicturesOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray array];
    
    switch (_pageType) {
        case 0:
            self.stateSting = @"1";
            break;
        case 1:
            self.stateSting = @"2";
            break;
        case 2:
            self.stateSting = @"3";
            break;
            
        default:
            break;
    }
    self.wuLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, YGScreenWidth, 50)];
    self.wuLabel.text = @"您还没有相关订单~";
    self.wuLabel.textColor = colorWithLightGray;
    self.wuLabel.textAlignment = NSTextAlignmentCenter;
    
    [self configUI];
}


//请求
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_SearchSnapshotOrder parameters:@{@"userId":YGSingletonMarco.user.userId,@"orderState":self.stateSting,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if (((NSArray *)responseObject[@"aList"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        if (headerAction == YES) {
            [self.dataArray removeAllObjects];
        }
        
        [self.dataArray addObjectsFromArray:[TakePhotosOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"SnapshotList"]]];
        
//        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:YES];
        if(!self.dataArray.count)
        {
            [self.view addSubview:self.wuLabel];
        }
        else
        {
            [self.wuLabel removeFromSuperview];
        }
        
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}



-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight) style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
//    _tableView.sectionHeaderHeight = 10;
//    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PictureLeftTextRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureLeftTextRightCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PictureLeftTextRightCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *imageString = [self.dataArray[indexPath.section] valueForKey:@"img"];
    NSURL *picUrl = [NSURL URLWithString:imageString];
    [cell.leftimageView sd_setImageWithURL:picUrl placeholderImage:YGDefaultImgFour_Three];
    cell.orderModel = self.dataArray[indexPath.section];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YGScreenWidth * 0.33;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    sectionView.backgroundColor = colorWithTable;
    [headerView addSubview:sectionView];
    
    UILabel *serviceNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, YGScreenWidth - 30, 40)];
    serviceNumberLabel.textColor = colorWithDeepGray;
    serviceNumberLabel.font = [UIFont systemFontOfSize:14.0];
    serviceNumberLabel.text = [NSString stringWithFormat:@"服务工单号 %@",[self.dataArray[section] valueForKey:@"orderNum"]];
    [headerView addSubview:serviceNumberLabel];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
//    footView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.28);
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(YGScreenWidth - 15 - 90, (YGScreenWidth * 0.12 - 30) / 2, 90, 30);
    [cancelButton setTitle:@"取消工单" forState:UIControlStateNormal];
    [cancelButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    cancelButton.clipsToBounds = YES;
    cancelButton.layer.cornerRadius = 15;
    cancelButton.layer.borderColor = colorWithLine.CGColor;
    cancelButton.layer.borderWidth = 1;
    [cancelButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = section;
    
    UILabel *processingLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, YGScreenWidth - 15, YGScreenWidth * 0.12)];
    processingLabel.textColor = colorWithDeepGray;
//    processingLabel.text = [NSString stringWithFormat:@"您的工单正在处理中！ 2017-09-13 14：00"];
    processingLabel.font = [UIFont systemFontOfSize:14.0];
    
    UILabel *processedLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, YGScreenWidth * 0.12, YGScreenWidth - 15, YGScreenWidth * 0.08)];
    processedLabel.textColor = colorWithDeepGray;
//    processedLabel.text = @"您的工单已经处理完！ 2017-09-13 14：20";
    processedLabel.font = [UIFont systemFontOfSize:14.0];
    
    UILabel *processedLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, YGScreenWidth * 0.2 - 1, YGScreenWidth, 0.5)];
    processedLineLabel.text = @"";
    processedLineLabel.backgroundColor = colorWithLine;
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenWidth * 0.2, YGScreenWidth, YGScreenWidth * 0.13)];
//    UIButton *evaButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    evaButton.frame = CGRectMake(YGScreenWidth - 30 - 180, 10, 90, 30);
//    [evaButton setTitle:@"立即评价" forState:UIControlStateNormal];
//    [evaButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
//    evaButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    evaButton.clipsToBounds = YES;
//    evaButton.layer.cornerRadius = 15;
//    evaButton.layer.borderColor = colorWithMainColor.CGColor;
//    evaButton.layer.borderWidth = 1;
//    [evaButton addTarget:self action:@selector(evaOrder:) forControlEvents:UIControlEventTouchUpInside];
//    evaButton.tag = section;
    
    UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    delButton.frame = CGRectMake(YGScreenWidth - 15 - 90, (YGScreenWidth * 0.13 - 30 ) / 2, 90, 30);
    [delButton setTitle:@"删除工单" forState:UIControlStateNormal];
    [delButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    delButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    delButton.clipsToBounds = YES;
    delButton.layer.cornerRadius = 15;
    delButton.layer.borderColor = colorWithLine.CGColor;
    delButton.layer.borderWidth = 1;
    [delButton addTarget:self action:@selector(delOrder:) forControlEvents:UIControlEventTouchUpInside];
    delButton.tag = section;
    
    switch (_pageType) {
        case 0:
            footView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.12);
            [footView addSubview:cancelButton];
            break;
        case 1:
            footView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.12);
            processingLabel.text = [NSString stringWithFormat:@"您的工单正在处理中！ %@",[self.dataArray[section] valueForKey:@"processTime"]];
            [footView addSubview:processingLabel];
            break;
            
        default:
            footView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.33);
            processingLabel.text = [NSString stringWithFormat:@"您的工单正在处理中！ %@",[self.dataArray[section] valueForKey:@"processTime"]];
            processedLabel.text = [NSString stringWithFormat:@"您的工单已经处理完！ %@",[self.dataArray[section] valueForKey:@"completedTime"]];
            [footView addSubview:processingLabel];
            [footView addSubview:processedLabel];
            [footView addSubview:processedLineLabel];
            [footView addSubview:bottomView];
            [bottomView addSubview:delButton];
//            [bottomView addSubview:evaButton];
            break;
    }
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (_pageType) {
        case 0:
            return YGScreenWidth * 0.12;
            break;
        case 1:
            return YGScreenWidth * 0.12;
            break;
        case 2:
            return YGScreenWidth * 0.33;
            break;
            
        default:
            break;
    }
//    return YGScreenWidth * 0.28;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TakePicturesOrderDetailController *tpodVC = [[TakePicturesOrderDetailController alloc]init];
    tpodVC.idString = [self.dataArray[indexPath.section] valueForKey:@"ID"];
    [self.navigationController pushViewController:tpodVC animated:YES];
    
}

//取消工单
-(void)cancelOrder:(UIButton *)button
{
    [YGAlertView showAlertWithTitle:@"确认取消工单吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService YGPOST:REQUEST_DeleteSnapshot parameters:@{@"id":[self.dataArray[button.tag] valueForKey:@"ID"]} showLoadingView:YES scrollView:nil success:^(id responseObject) {
                
                NSLog(@"%@",responseObject);
                
                [self.dataArray removeObjectAtIndex:button.tag];
                [_tableView reloadData];
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}
////立即评价
//-(void)evaOrder:(UIButton *)button
//{
//    EvaluateViewController *vc = [[EvaluateViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//删除工单
-(void)delOrder:(UIButton *)button
{
    [YGAlertView showAlertWithTitle:@"确认删除工单吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService YGPOST:REQUEST_DeleteSnapshot parameters:@{@"id":[self.dataArray[button.tag] valueForKey:@"ID"]} showLoadingView:YES scrollView:nil success:^(id responseObject) {
                
                NSLog(@"%@",responseObject);
                
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
