//
//  MyResumeViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/9.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyResumeViewController.h"
#import "MyResumeModel.h"
#import "MyIntroduceTableViewCell.h"
#import "YGPickerView.h"
#import "YGDatePickerView.h"
#import "YGCityPikerView1.h"
#import "YYCache.h"
#import "YGActionSheetView.h"
#import "SeeAndSaveTableViewCell.h"
#import "MyIntroduceViewController.h"

@interface MyResumeViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, MyIntroduceTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    MyResumeModel *_model;
    UILabel  *_noResumeLabel;
}

@end

@implementation MyResumeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    
}
- (void)loadData
{
    
    [YGNetService YGPOST:REQUEST_FindMyResume parameters:@{@"userid":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        [_noResumeLabel removeFromSuperview];
        //创建数据源
        NSArray *tempArray = @[
                               @{
                                   @"indexName" : @"个人信息",
                                   @"isSelected": @(YES),
                                   @"list"      : @[
                                           @{
                                               @"type"       : @"0",
                                               @"title"      : @"姓名",
                                               @"placeHolder": @"请输入姓名",
                                               @"showArrow"  : @(NO),
                                               @"modelArg"   : @"name"
                                               },
                                           @{
                                               @"type"       : @"1",
                                               @"title"      : @"性别",
                                               @"showArrow"  : @(NO),
                                               @"modelArg"   : @"sex",
                                               @"pickerArray": @[
                                                       @"男",
                                                       @"女"
                                                       ].mutableCopy
                                               },
                                           @{
                                               @"type"     : @"2",
                                               @"title"    : @"出生日期",
                                               @"showArrow": @(NO),
                                               @"modelArg" : @"birthday"
                                               },
                                           @{
                                               @"type"       : @"1",
                                               @"title"      : @"工作年限",
                                               @"showArrow"  : @(NO),
                                               @"modelArg"   : @"experience",
                                               @"pickerArray": @[
                                                       @"应届生",
                                                       @"1年以下",
                                                       @"1~2年",
                                                       @"3~5年",
                                                       @"5年以上"
                                                       ].mutableCopy
                                               },
                                           @{
                                               @"type"     : @"3",
                                               @"title"    : @"所在城市",
                                               @"showArrow": @(NO),
                                               @"modelArg" : @"city"
                                               },
                                           @{
                                               @"type"       : @"0",
                                               @"title"      : @"手机号码",
                                               @"placeHolder": @"请输入真实号码",
                                               @"showArrow"  : @(NO),
                                               @"modelArg"   : @"phone"
                                               },
                                           @{
                                               @"type"     : @"1",
                                               @"title"    : @"所在园区",
                                               @"showArrow": @(NO),
                                               @"modelArg" : @"park"
                                               }
                                           ]
                                   },
                               @{
                                   @"indexName" : @"求职意向",
                                   @"isSelected": @(YES),
                                   @"list"      : @[
                                           @{
                                               @"type"       : @"1",
                                               @"title"      : @"工作性质",
                                               @"showArrow"  : @(NO),
                                               @"modelArg"   : @"character",
                                               @"pickerArray": @[
                                                       @"不限",
                                                       @"全职",
                                                       @"兼职"
                                                       ].mutableCopy
                                               },
                                           @{
                                               @"type"     : @"3",
                                               @"title"    : @"工作地点",
                                               @"showArrow": @(NO),
                                               @"modelArg" : @"jobcity"
                                               },
                                           @{
                                               @"type"       : @"1",
                                               @"title"      : @"期望薪资",
                                               @"showArrow"  : @(NO),
                                               @"modelArg"   : @"salary",
                                               @"pickerArray": @[
                                                       @"1000元以下",
                                                       @"1000-2000元",
                                                       @"2000-3000元",
                                                       @"3000-5000元",
                                                       @"5000-8000元",
                                                       @"8000-12000元",
                                                       @"12000-20000元",
                                                       @"20000-25000元",
                                                       @"25000元以上"
                                                       ].mutableCopy
                                               
                                               },
                                           @{
                                               @"type"     : @"4",
                                               @"title"    : @"职位类别",
                                               @"showArrow": @(NO),
                                               @"modelArg" : @"job"
                                               },
                                           @{
                                               @"type"       : @"1",
                                               @"title"      : @"工作状态",
                                               @"showArrow"  : @(NO),
                                               @"modelArg"   : @"jobState",
                                               @"pickerArray": @[
                                                       @"应届毕业生",
                                                       @"我目前处于离职状态，可立即上岗",
                                                       @"我目前处于在岗状态，正考虑换个新环境",
                                                       @"我目前处于在岗状态，暂无跳槽打算",
                                                       @"我目前处于在岗状态，有更好的机会也可以考虑"
                                                       ].mutableCopy
                                               
                                               }
                                           ]
                                   },
                               @{
                                   @"indexName" : @"教育背景",
                                   @"isSelected": @(YES),
                                   @"list"      : @[
                                           @{
                                               @"type"       : @"0",
                                               @"title"      : @"学校名称",
                                               @"showArrow"  : @(NO),
                                               @"placeHolder": @"请输入学校名称",
                                               @"modelArg"   : @"school"
                                               },
                                           @{
                                               @"type"       : @"0",
                                               @"title"      : @"专业名称",
                                               @"placeHolder": @"请输入您的专业",
                                               @"showArrow"  : @(NO),
                                               @"modelArg"   : @"major"
                                               },
                                           @{
                                               @"type"       : @"1",
                                               @"title"      : @"学位/学历",
                                               @"showArrow"  : @(NO),
                                               @"modelArg"   : @"educational",
                                               @"pickerArray": @[
                                                       @"不限",
                                                       @"博士",
                                                       @"硕士",
                                                       @"本科",
                                                       @"大专",
                                                       @"高中",
                                                       @"中专及以下"
                                                       ].mutableCopy
                                               },
                                           @{
                                               @"type"     : @"2",
                                               @"title"    : @"毕业时间",
                                               @"showArrow": @(NO),
                                               @"modelArg" : @"time"
                                               }
                                           ]
                                   },
                               @{
                                   @"indexName" : @"工作经验",
                                   @"isSelected": @(YES),
                                   @"list"      : @[
                                           @{
                                               @"type"       : @"0",
                                               @"title"      : @"公司名称",
                                               @"showArrow"  : @(NO),
                                               @"placeHolder": @"请输入公司名称",
                                               @"modelArg"   : @"company"
                                               },
                                           @{
                                               @"type"     : @"2",
                                               @"title"    : @"开始时间",
                                               @"showArrow": @(NO),
                                               @"modelArg" : @"startTime"
                                               },
                                           @{
                                               @"type"     : @"2",
                                               @"title"    : @"结束时间",
                                               @"showArrow": @(NO),
                                               @"modelArg" : @"endTime"
                                               },
                                           @{
                                               @"type"     : @"4",
                                               @"title"    : @"职位类别",
                                               @"showArrow": @(NO),
                                               @"modelArg" : @"experienceJob"
                                               },
                                           @{
                                               @"type"       : @"0",
                                               @"title"      : @"职位名称",
                                               @"showArrow"  : @(NO),
                                               @"placeHolder": @"请输入您的职位",
                                               @"modelArg"   : @"jobName"
                                               },
                                           @{
                                               @"type"       : @"0",
                                               @"title"      : @"职位薪金（税前）",
                                               @"showArrow"  : @(NO),
                                               @"placeHolder": @"请输入薪金",
                                               @"modelArg"   : @"price"
                                               }
                                           ]
                                   },
                               @{
                                   @"indexName" : @"自我评价",
                                   @"isSelected": @(YES),
                                   @"list"      : @[]
                                   },
                               ];
        
        for (int i = 0; i < tempArray.count; ++i)
        {
            NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:tempArray[i]];
            subDic[@"list"] = [NSMutableArray arrayWithArray:tempArray[i][@"list"]];
            for (int j = 0; j < [subDic[@"list"] count]; ++j)
            {
                NSMutableDictionary *subDic1 = [[NSMutableDictionary alloc] initWithDictionary:subDic[@"list"][j]];
                subDic[@"list"][j] = subDic1;
            }
            [_listArray addObject:subDic];
        }
        
        //判断是否有简历
        if ([responseObject[@"state"] isEqualToString:@"0"]) {
            
            self.navigationItem.rightBarButtonItem = [self createBarbuttonWithNormalTitleString:@"创建简历" selectedTitleString:@"创建简历" selector:@selector(createResume)];
            _noResumeLabel = [[UILabel alloc] init];
            _noResumeLabel.textColor = colorWithBlack;
            _noResumeLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
            _noResumeLabel.text = @"您还没有建立个人简历！";
            [self.view addSubview:_noResumeLabel];
            [_noResumeLabel sizeToFit];
            _noResumeLabel.centerx = YGScreenWidth / 2;
            _noResumeLabel.centery = 120;
            return ;
        }
        self.navigationItem.rightBarButtonItem = [self createBarbuttonWithNormalTitleString:@"编辑简历" selectedTitleString:@"编辑简历" selector:@selector(createResume)];
        
        [_model setValuesForKeysWithDictionary:responseObject[@"ResumeInformation"]];
        NSArray *array = responseObject[@"ResumeInformation"][@"list"];
        NSDictionary *dict = array[0];
        _model.company = dict[@"company"];
        _model.startTime = dict[@"startTime"];
        _model.endTime = dict[@"endTime"];
        _model.experienceJob = dict[@"job"];
        _model.jobName = dict[@"jobName"];
        _model.price = dict[@"price"];
        _model.description = dict[@"description"];
        _model.experienceid = dict[@"id"];
        _model.experienceJobValue = dict[@"jobValue"];
        
        for (NSMutableDictionary *infoDic in _listArray)
        {
            for (NSMutableDictionary *subDic in infoDic[@"list"])
            {
                subDic[@"detail"] = [_model performSelector:NSSelectorFromString(subDic[@"modelArg"])];
            }
        }
        [self configUI];
    } failure:^(NSError *error) {
        
    }];
    
    
}
- (void)configAttribute
{
    
    self.naviTitle = @"我的简历";
    _model = [[MyResumeModel alloc] init];
    _listArray = [[NSMutableArray alloc] init];
}

- (void)configUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 20)];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"SeeAndSaveTableViewCell" bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:@"xx"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_listArray[section][@"isSelected"] boolValue])
    {
        return [_listArray[section][@"list"] count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ((section == 3 || section == 4) && [_listArray[section][@"isSelected"] boolValue])
    {
        if(section == 3)
        {
            return (CGFloat) ([UILabel calculateWidthWithString:_model.description textFont:[UIFont systemFontOfSize:YGFontSizeSmallOne] numerOfLines:0 maxWidth:YGScreenWidth - 24].height + 24.0 + 12 + 13);
        }
        else
        {
            return [UILabel calculateWidthWithString:_model.selfEvaluation textFont:[UIFont systemFontOfSize:YGFontSizeSmallOne] numerOfLines:0 maxWidth:YGScreenWidth - 24].height + 24;
        }
    }
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeeAndSaveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xx" forIndexPath:indexPath];
    cell.infoDic = _listArray[indexPath.section][@"list"][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 3 && indexPath.row == 7) || indexPath.section == 4 || (indexPath.section == 1 && indexPath.row == 4)) {
        return [tableView fd_heightForCellWithIdentifier:@"xx" cacheByIndexPath:indexPath configuration:^(SeeAndSaveTableViewCell *cell)
                {
                    cell.infoDic = _listArray[indexPath.section][@"list"][indexPath.row];
                }];
        
    }
    return 45;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 50)];
    sectionHeaderView.backgroundColor = colorWithTable;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    titleLabel.text = _listArray[section][@"indexName"];
    [sectionHeaderView addSubview:titleLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"steward_paytherent_packup.png"]];
    [sectionHeaderView addSubview:arrowImageView];
    
    UIButton *sectionHeaderButton = [[UIButton alloc] init];
    sectionHeaderButton.tag = 300 + section;
    [sectionHeaderButton addTarget:self action:@selector(sectionHeaderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    sectionHeaderButton.selected = [_listArray[section][@"isSelected"] boolValue];
    [sectionHeaderView addSubview:sectionHeaderButton];
    
    arrowImageView.transform = CGAffineTransformRotate(arrowImageView.transform, (CGFloat) (sectionHeaderButton.isSelected * M_PI));
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.mas_equalTo(12);
         make.centerY.mas_equalTo(sectionHeaderButton.mas_centerY);
     }];
    
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.right.mas_equalTo(-12);
         make.centerY.mas_equalTo(titleLabel.mas_centerY);
     }];
    
    [sectionHeaderButton mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.right.top.bottom.mas_equalTo(0);
     }];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithLine;
    [sectionHeaderView addSubview:lineView];
    
    
    return sectionHeaderView;
}

- (void)sectionHeaderButtonClick:(UIButton *)button
{
    [self.view endEditing:YES];
    button.selected = !button.isSelected;
    _listArray[button.tag - 300][@"isSelected"] = @(button.isSelected);
    [_tableView reloadData];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 150)];
    sectionFooterView.backgroundColor = colorWithYGWhite;
    if ((section == 3 || section == 4) && [_listArray[section][@"isSelected"] boolValue])
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = colorWithBlack;
        titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [sectionFooterView addSubview:titleLabel];
        titleLabel.x = 12;
        titleLabel.y = 12;
        if (section == 3)
        {
            titleLabel.text = _model.description;
            
            UILabel *titleLabel1 = [[UILabel alloc] init];
            titleLabel1.textColor = colorWithDeepGray;
            titleLabel1.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
            titleLabel1.text = @"工作描述";
            [titleLabel1 sizeToFit];
            titleLabel1.x = 12;
            titleLabel1.y = 12;
            titleLabel.y = titleLabel1.y + titleLabel1.height + 12;
            [sectionFooterView addSubview:titleLabel1];
            
            
        }
        
        if (section == 4)
        {
            titleLabel.text = _model.selfEvaluation;
        }
        [titleLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth - 24];
        
    }
    return sectionFooterView;
}

- (void)createResume
{
    MyIntroduceViewController *vc = [[MyIntroduceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
