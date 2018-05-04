//
//  RoadShowHallAllViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RoadShowHallAllViewController.h"
#import "RoadShowHallAllTableViewCell.h"
#import "RoadShowHallModel.h"
#import "YGBirthdayDataPickerView.h"

#import "RoadShowHallDetailViewController.h"
#import "RoadShowHallCrowdFundingViewController.h"

@interface RoadShowHallAllViewController ()<UITableViewDataSource,UITableViewDelegate,YGBirthdayDataPickerViewDelegate>
{
    NSMutableArray *_listArray;
    UIButton *_startTimeButton;
    UIButton *_endTimeButton;
    NSString *_startTimeStr;
    NSString *_endTimeStr;
    UIView *_clearBackGroundView;
    int  _selectBtnIndex; //1是开始 2是结束
}
@end

@implementation RoadShowHallAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    
    
}

- (void)configAttribute
{
    _listArray = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = colorWithTable;
}

- (void)setModel:(CrowdFundingAddProjectChooseTypeModel *)model
{
    _model = model;
    _startTimeStr = @"";
    _endTimeStr = @"";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (NSString *)dataFormatter
{
    NSDate *date =[NSDate date];//简书 FlyElephant
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
    
    NSLog(@"currentDate = %@ ,year = %ld ,month=%ld, day=%ld",date,currentYear,currentMonth,currentDay);
    return [NSString stringWithFormat:@"%ld-%ld-%ld",currentYear,currentMonth,currentDay];
}

- (void)configUI
{
    UIView *searchBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 35)];
    searchBaseView.backgroundColor = colorWithPlateSpacedColor;
    [self.view addSubview:searchBaseView];
    
    UIView *lineTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
    lineTopView.backgroundColor = colorWithLine;
    [searchBaseView addSubview:lineTopView];
    
   
//    
//    _startTimeStr = [self dataFormatter];
//    _endTimeStr = [self dataFormatter];

    _startTimeButton = [[UIButton alloc]initWithFrame:CGRectMake(0,5,YGScreenWidth/2,25)];
    [_startTimeButton addTarget:self action:@selector(startTimeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    _startTimeButton.backgroundColor = colorWithYGWhite;
    _startTimeButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [searchBaseView addSubview:_startTimeButton];
    [_startTimeButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [_startTimeButton setTitle:[NSString stringWithFormat:@"开始 %@",[self dataFormatter]] forState:UIControlStateNormal];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_startTimeButton.x+_startTimeButton.width-1, 5, 1, 25)];
    lineView.backgroundColor = colorWithLine;
    [searchBaseView addSubview:lineView];
    lineView.centery = _startTimeButton.centery;
    
    _endTimeButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth/2,5,YGScreenWidth/2,25)];
    [_endTimeButton addTarget:self action:@selector(endTimeButtonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    _endTimeButton.backgroundColor = colorWithYGWhite;
    _endTimeButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [searchBaseView addSubview:_endTimeButton];
    [_endTimeButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [_endTimeButton setTitle:[NSString stringWithFormat:@"截止 %@",[self dataFormatter]] forState:UIControlStateNormal];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, searchBaseView.height, YGScreenWidth, YGScreenHeight-64-YGBottomMargin-45-searchBaseView.height-40) style:UITableViewStyleGrouped];
    _tableView.sectionHeaderHeight = 10;
    _tableView.backgroundColor = colorWithTable;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[RoadShowHallAllTableViewCell class] forCellReuseIdentifier:@"FundSupportTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoadShowHallModel *model = _listArray[indexPath.section];
    
    RoadShowHallAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FundSupportTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (YGScreenWidth-20)*0.56+70;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RoadShowHallModel *model = _listArray[indexPath.section];
    RoadShowHallDetailViewController *controller = [[RoadShowHallDetailViewController alloc]init];
    controller.roadShowProjectModel = model;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{

    [YGNetService YGPOST:REQUEST_getRoadShow parameters:@{@"typeId":_model.typeId,@"beginDate":_startTimeStr,@"endDate":_endTimeStr,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
            
        }
        if ([responseObject[@"showList"] count] == 0) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        
        [_listArray addObjectsFromArray:[RoadShowHallModel mj_objectArrayWithKeyValuesArray:responseObject[@"showList"]]];
        
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        
        [_tableView reloadData];

    } failure:^(NSError *error) {
        
    }];
   
}

#pragma 时间代理
-(void)clickOptionsButton:(NSString *)dateStr buttonIndex:(int)index
{
    //生日
   (_selectBtnIndex == 1)?(_startTimeStr = dateStr):(_endTimeStr = dateStr);
    [_clearBackGroundView removeFromSuperview];
    
    //点击取消按钮
    if (index == 0)
    {
        
    }
    else  //点击确定按钮
    {
        (_selectBtnIndex == 1)?([_startTimeButton setTitle:[NSString stringWithFormat:@"开始 %@",_startTimeStr] forState:UIControlStateNormal]):([_endTimeButton setTitle:[NSString stringWithFormat:@"截止 %@",_endTimeStr] forState:UIControlStateNormal]);
        if (_selectBtnIndex == 2) {
            
            if ([_startTimeStr isEqualToString:@""]) {
                _startTimeStr = [self dataFormatter];
//                [YGAppTool showToastWithText:@"请选择起始日期"];
//                return;
            }
//
//            if ([_endTimeStr isEqualToString:@""]) {
//                [YGAppTool showToastWithText:@"请选择终止日期"];
//                return;
//            }
//            if ([_model.tradeName isEqualToString:@"全部"]) {
            
                [YGNetService YGPOST:REQUEST_getRoadShow parameters:@{@"typeId":_model.typeId,@"beginDate":_startTimeStr,@"endDate":_endTimeStr,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
                    
                    [_listArray removeAllObjects];
                    if ([responseObject[@"showList"] count] == 0) {
                        [self noMoreDataFormatWithScrollView:_tableView];
                    }
                    
                    [_listArray addObjectsFromArray:[RoadShowHallModel mj_objectArrayWithKeyValuesArray:responseObject[@"showList"]]];
                    
                    [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:YES];
                    
                    [_tableView reloadData];
                    
                } failure:^(NSError *error) {
                    
                }];
//            }
        }
        
    }
}
#pragma 点击事件
- (void)startTimeButtonAction:(UIButton *)btn
{
    _selectBtnIndex = 1;
    [self pickerViewPopwithInitDateString:[btn.titleLabel.text componentsSeparatedByString:@" "][1]];
}

- (void)endTimeButtonButtonAction:(UIButton *)btn
{
    _selectBtnIndex = 2;
    [self pickerViewPopwithInitDateString:[btn.titleLabel.text componentsSeparatedByString:@" "][1]];
    
}

- (void)pickerViewPopwithInitDateString:(NSString *)initDateString
{
    if (_clearBackGroundView != nil)
    {
        [_clearBackGroundView removeFromSuperview];
    }
    //背景透明view
    _clearBackGroundView = [[UIView alloc]init];
    _clearBackGroundView.frame = [[UIScreen mainScreen]bounds];
    _clearBackGroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self.navigationController.view addSubview:_clearBackGroundView];
    
    //datePickerView
    YGBirthdayDataPickerView *pickView = [[YGBirthdayDataPickerView alloc]initWithTitleString:@"" withDefultDateString:initDateString];
    pickView.delegate = self;
    [pickView show];
}

@end
