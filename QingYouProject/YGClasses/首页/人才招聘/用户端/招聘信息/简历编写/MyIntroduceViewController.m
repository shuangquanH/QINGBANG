//
//  MyIntroduceViewController.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyIntroduceViewController.h"
#import "MyResumeModel.h"
#import "MyIntroduceTableViewCell.h"
#import "YGPickerView.h"
#import "YGDatePickerView.h"
#import "YGCityPikerView1.h"
#import "YYCache.h"
#import "YGActionSheetView.h"
#import "SeeAndSaveViewController.h"
#import "ChooseJobPositionViewController.h"

@interface MyIntroduceViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, MyIntroduceTableViewCellDelegate,ChooseJobPositionViewControllerDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    MyResumeModel *_model;
}
@end

@implementation MyIntroduceViewController
{
    NSMutableArray *_salaryArray;
    NSMutableArray *_educationArray;
    NSMutableArray *_experienceArray;
    NSMutableArray *_gardenArray;
    NSMutableArray *_jobidArray;
    
    
    NSString *_cityString;
    NSString *_jobidString;
    NSString *_priceString;
    NSString *_educationalidString;
    NSString *_experienceidString;
    NSString *_gardenidString;
    NSString *_experienceJobidString;
    NSIndexPath  *_indexPath;
    
    NSString *_characterString;
    NSString *_jobStateString;
    NSString *_sexString;
    NSString *_parkString;
    AdvertisesForInfoModel *_positionModelNow;
    AdvertisesForInfoModel *_positionModelExperience;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)back
{
    [YGAlertView showAlertWithTitle:@"返回上一页将不保存当前填写的信息，确定返回吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (void)configAttribute
{
    self.fd_interactivePopDisabled = YES;
    _listArray = [[NSMutableArray alloc] init];
    _model = [[MyResumeModel alloc] init];
    self.navigationItem.rightBarButtonItem = [self createBarbuttonWithNormalTitleString:@"预览并保存" selectedTitleString:@"预览并保存" selector:@selector(saveButtonClick)];
//    self.naviTitle = @"我的简历";
    UILabel *naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth - 120, 20)];
    naviTitleLabel.textColor = colorWithBlack;
    naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    naviTitleLabel.text = @"我的简历" ;
    [naviTitleLabel sizeToFit];
    naviTitleLabel.frame = CGRectMake(YGScreenWidth/2-naviTitleLabel.width/2, 0, naviTitleLabel.width, 20);
    self.navigationItem.titleView = naviTitleLabel;
    
    
    _salaryArray = [[NSMutableArray alloc] init];
    _gardenArray = [[NSMutableArray alloc] init];
    _experienceArray = [[NSMutableArray alloc] init];
    _educationArray = [[NSMutableArray alloc] init];
    _jobidArray = [[NSMutableArray alloc] init];
    
    _jobidString = @"";
    _priceString = @"";
    _sexString = @"";
    _cityString = @"";
    _educationalidString = @"";
    _experienceidString = @"";
    _experienceJobidString = @"";
    _jobStateString = @"";
    _gardenidString = @"";
    _characterString = @"";
    
    _parkString = @"";
    
    [self getData];
    
    //indexName 组标题
    //isSelected 是否展开
    //title label的标题
    //placeHolder textField的placeHolder
    //showArrow 是否有右箭头
    //modelArg textField内容对应的model参数名
    //pickerArray pickerView对应的数据源
    //type 0.纯文本 1.pickerView 2.datePickerView 3.cityPickerView 4.跳转
    
    NSArray *tempArray = @[
                           @{
                               @"indexName" : @"个人信息",
                               @"isSelected": @(NO),
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
                                           @"showArrow"  : @(YES),
                                           @"modelArg"   : @"sex",
                                           @"pickerArray": @[
                                                   @"男",
                                                   @"女"
                                                   ].mutableCopy
                                           },
                                       @{
                                           @"type"     : @"2",
                                           @"title"    : @"出生日期",
                                           @"showArrow": @(YES),
                                           @"modelArg" : @"birthday"
                                           },
                                       @{
                                           @"type"       : @"1",
                                           @"title"      : @"工作年限",
                                           @"showArrow"  : @(YES),
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
                                           @"showArrow": @(YES),
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
                                           @"showArrow": @(YES),
                                           @"modelArg" : @"park"
                                           }
                                       ]
                               },
                           @{
                               @"indexName" : @"求职意向",
                               @"isSelected": @(NO),
                               @"list"      : @[
                                       @{
                                           @"type"       : @"1",
                                           @"title"      : @"工作性质",
                                           @"showArrow"  : @(YES),
                                           @"modelArg"   : @"character",
                                           @"pickerArray": @[
                                                   @"全职",
                                                   @"兼职"
                                                   ].mutableCopy
                                           },
                                       @{
                                           @"type"     : @"3",
                                           @"title"    : @"工作地点",
                                           @"showArrow": @(YES),
                                           @"modelArg" : @"jobcity"
                                           },
                                       @{
                                           @"type"       : @"1",
                                           @"title"      : @"期望薪资",
                                           @"showArrow"  : @(YES),
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
                                           @"showArrow": @(YES),
                                           @"modelArg" : @"job"
                                           },
                                       @{
                                           @"type"       : @"1",
                                           @"title"      : @"工作状态",
                                           @"showArrow"  : @(YES),
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
                               @"isSelected": @(NO),
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
                                           @"showArrow"  : @(YES),
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
                                           @"showArrow": @(YES),
                                           @"modelArg" : @"time"
                                           }
                                       ]
                               },
                           @{
                               @"indexName" : @"工作经验",
                               @"isSelected": @(NO),
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
                                           @"showArrow": @(YES),
                                           @"modelArg" : @"startTime"
                                           },
                                       @{
                                           @"type"     : @"2",
                                           @"title"    : @"结束时间",
                                           @"showArrow": @(YES),
                                           @"modelArg" : @"endTime"
                                           },
                                       @{
                                           @"type"     : @"4",
                                           @"title"    : @"职位类别",
                                           @"showArrow": @(YES),
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
                               @"isSelected": @(NO),
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
    [YGNetService YGPOST:REQUEST_FindMyResume parameters:@{@"userid":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        if (![responseObject[@"state"] isEqualToString:@"0"])
        {
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
            [_tableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)saveButtonClick
{
    [self.view endEditing:YES];
    for (NSDictionary *infoDic in _listArray)
    {
        for (NSDictionary *subDic in infoDic[@"list"])
        {
            if ([infoDic[@"type"] integerValue] != 0)
            {
                if ([YGAppTool isEmpty:[_model performSelector:NSSelectorFromString(subDic[@"modelArg"])] name:infoDic[@"title"]])
                {
                    return;
                }
            }
        }
    }
    

    //姓名
    if(![YGAppTool isVerifiedWithText:_model.name name:@"姓名" maxLength:10 minLength:2 shouldEmpty:NO])
    {
        return;
    }
    
    if ([_sexString isEqualToString:@""]) {
        if (![_model.sexValue isEqualToString:@""]) {
            _sexString = _model.sexValue;
        }
        if ([_model.sexValue isEqualToString:@""] || _model.sexValue == nil) {
            [YGAppTool showToastWithText:@"请选择您的性别"];
            return;
        }
    }
    //生日
    if ([_model.birthday isEqualToString:@""]) {
        return;

    }
    
    if ([_experienceidString isEqualToString:@""] && ![_model.experienceValue isEqualToString:@""]) {
        if (![_model.experienceValue isEqualToString:@""]) {
            _experienceidString = _model.experienceValue;
        }
        if ([_model.experienceValue isEqualToString:@""] || _model.experienceValue == nil) {
            [YGAppTool showToastWithText:@"请选择工作年限"];
            return;
        }
    }
    
    if ([_gardenidString isEqualToString:@""] ) {
        if (![_model.parkvalue isEqualToString:@""]) {
            _gardenidString = _model.parkvalue;
        }
        if ([_model.parkvalue isEqualToString:@""] || _model.parkvalue == nil) {
            [YGAppTool showToastWithText:@"请选择您所在园区"];
            return;
        }
    }
    
    if ([YGAppTool isNotPhoneNumber:_model.phone])
    {
        return;
    }
    
    if ([_characterString isEqualToString:@""]) {
        if (![_model.characterValue isEqualToString:@""]) {
            _characterString = _model.characterValue;
        }
        if ([_model.characterValue isEqualToString:@""] || _model.characterValue == nil) {
            [YGAppTool showToastWithText:@"请选择工作性质"];
            return;
        }
    }
    
    
    if ([_priceString isEqualToString:@""] ) {
        if (![_model.salaryValue isEqualToString:@""]) {
            _priceString = _model.salaryValue;
        }
        if ([_model.salaryValue isEqualToString:@""] || _model.salaryValue == nil) {
            [YGAppTool showToastWithText:@"请选择您的期望薪资"];
            return;
        }
    }
    //如果是没改值直接保存
    if ([_experienceJobidString isEqualToString:@""] ) {
        if (![_model.experienceJobValue isEqualToString:@""]) {
            _experienceJobidString = _model.experienceJobValue;
        }
        if ([_model.experienceJobValue isEqualToString:@""] || _model.experienceJobValue == nil) {
            [YGAppTool showToastWithText:@"请选择工作经验的职位类别"];
            return;
        }
    }
    if ([_jobStateString isEqualToString:@""] ) {
        if (![_model.jobStateValue isEqualToString:@""]) {
            _jobStateString = _model.jobStateValue;
        }
        if ([_model.jobStateValue isEqualToString:@""] || _model.jobStateValue == nil) {
            [YGAppTool showToastWithText:@"请选择工作状态"];
            return;
        }
    }
    if (![YGAppTool isVerifiedWithText:_model.school name:@"学校名称" maxLength:30 minLength:2 shouldEmpty:NO])
    {
        return;
    }
    
    if (![YGAppTool isVerifiedWithText:_model.major name:@"专业名称" maxLength:15 minLength:2 shouldEmpty:NO])
    {
        return;
    }
    
    if (![YGAppTool isVerifiedWithText:_model.company name:@"公司名称" maxLength:20 minLength:2 shouldEmpty:NO])
    {
        return;
    }
    
    if (![YGAppTool isVerifiedWithText:_model.jobName name:@"职位名称" maxLength:10 minLength:2 shouldEmpty:NO])
    {
        return;
    }
    
    if ([_educationalidString isEqualToString:@""]) {
        
        if (![_model.educationalValue isEqualToString:@""]) {
            _educationalidString = _model.educationalValue;
        }
        if ([_model.educationalValue isEqualToString:@""] || _model.educationalValue == nil) {
            [YGAppTool showToastWithText:@"请选择您的学历"];
            return;
        }
    }
    
    
    if (![YGAppTool isPureInt:_model.price])
    {
        [YGAppTool showToastWithText:@"请输入整数职位薪金"];
        return;
    }
    
    if (![YGAppTool isVerifiedWithText:_model.description name:@"工作描述" maxLength:200 minLength:2 shouldEmpty:NO])
    {
        return;
    }
    
    if (![YGAppTool isVerifiedWithText:_model.selfEvaluation name:@"自我评价" maxLength:200 minLength:2 shouldEmpty:NO])
    {
        return;
    }

    
    if ([_jobidString isEqualToString:@""]) {
        if (![_model.jobValue isEqualToString:@""]) {
            _jobidString = _model.jobValue;
        }
        if ([_model.jobValue isEqualToString:@""] || _model.jobValue == nil) {
            [YGAppTool showToastWithText:@"请选择求职意向的职位类别"];
            return;
        }
    }

    
    NSArray *array = @[@{
                           @"company":_model.company,
                           @"startTime":_model.startTime,
                           @"endDate":_model.endTime,
                           @"jobid":_experienceJobidString,  //gongzuoid
                           @"jobName":_model.jobName,
                           @"price":_model.price,
                           @"content":_model.description
                           
                           }];
    NSDictionary *dict = @{
                           @"userid":YGSingletonMarco.user.userId,
                           @"name":_model.name,
                           @"sex":_sexString,
                           @"birthday":_model.birthday,
                           @"experienceid":_experienceidString, //经验id
                           @"city":_model.city,
                           @"phone":_model.phone,
                           @"park":_gardenidString,
                           @"characters":_characterString,
                           @"jobcity":_model.jobcity,
                           @"salaryid":_priceString, //薪资 id
                           @"jobid":_jobidString, //gongzuo id
                           @"jobState":_jobStateString,
                           @"school":_model.school,
                           @"time":_model.time,
                           @"major":_model.major,
                           @"educationalid":_educationalidString, //学历id
                           @"selfEvaluation":_model.selfEvaluation,
                           @"list":array
                           };
    [YGNetService YGPOST:REQUEST_CreateResume parameters:dict showLoadingView:NO scrollView:nil success:^(id responseObject) {
        SeeAndSaveViewController *controller = [[SeeAndSaveViewController alloc] init];
        controller.lastArray = _listArray;
        controller.model = _model;
        [self.navigationController pushViewController:controller animated:YES];
    } failure:^(NSError *error) {
        
    }];
    
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
    [_tableView registerClass:[MyIntroduceTableViewCell class] forCellReuseIdentifier:@"xx"];
    _tableView.rowHeight = 50;
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
        return 150;
    }
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyIntroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xx" forIndexPath:indexPath];
    cell.infoDic = _listArray[indexPath.section][@"list"][indexPath.row];
    cell.detailTextField.text = [_model performSelector:NSSelectorFromString(_listArray[indexPath.section][@"list"][indexPath.row][@"modelArg"])];
    cell.delegate = self;
    if ((indexPath.section == 0 && indexPath.row == 5) || (indexPath.section == 3 && indexPath.row == 5))
    {
        cell.detailTextField.keyboardType = UIKeyboardTypePhonePad;
    }
    else
    {
        cell.detailTextField.keyboardType = UIKeyboardTypeDefault;
        
    }
    return cell;
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

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 150)];
    sectionFooterView.backgroundColor = colorWithYGWhite;
    if ((section == 3 || section == 4) && [_listArray[section][@"isSelected"] boolValue])
    {

        if (section == 3)
        {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.textColor = colorWithDeepGray;
            titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
            [titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
            [titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
            titleLabel.text = @"工作描述";
            [sectionFooterView addSubview:titleLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
             {
                 make.left.mas_equalTo(12);
                 make.top.mas_equalTo(12);
             }];
            
            UITextView *textView = [[UITextView alloc] init];
            textView.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
            textView.textColor = colorWithBlack;
            textView.delegate = self;
            textView.tag = 1000;
            textView.text = _model.description;
            [sectionFooterView addSubview:textView];
            
            UILabel *placeHolderLabel = [[UILabel alloc] init];
            placeHolderLabel.text = @"简述一下岗位职责和工作成绩";
            placeHolderLabel.textColor = colorWithLightGray;
            placeHolderLabel.font = textView.font;
            placeHolderLabel.tag = 2000;
            [textView addSubview:placeHolderLabel];
            
            [placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make)
             {
                 make.left.mas_equalTo(3);
                 make.top.mas_equalTo(8);
             }];
            
            [textView mas_makeConstraints:^(MASConstraintMaker *make)
             {
                 make.left.mas_equalTo(12);
                 make.right.mas_equalTo(-12);
                 make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
                 make.bottom.mas_equalTo(-10);
             }];
            [self textViewDidChange:textView];
        }
        
        if (section == 4)
        {
            
            UITextView *textView = [[UITextView alloc] init];
            textView.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
            textView.textColor = colorWithBlack;
            textView.delegate = self;
            textView.tag = 1001;
            textView.text = _model.selfEvaluation;
            [sectionFooterView addSubview:textView];
            
            UILabel *placeHolderLabel = [[UILabel alloc] init];
            placeHolderLabel.text = @"【示例】本人从事设计行业4年，擅长XX、XX等软件，为人善于沟通，忠厚老实，责任心强...";
            placeHolderLabel.textColor = colorWithLightGray;
            placeHolderLabel.font = textView.font;
            [placeHolderLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth - 24 - 6];
            placeHolderLabel.x = 3;
            placeHolderLabel.y = 8;
            placeHolderLabel.tag = 2001;
            [textView addSubview:placeHolderLabel];
            
            [textView mas_makeConstraints:^(MASConstraintMaker *make)
             {
                 make.left.mas_equalTo(12);
                 make.right.mas_equalTo(-12);
                 make.top.mas_equalTo(10);
                 make.bottom.mas_equalTo(-10);
             }];
            [self textViewDidChange:textView];
        }
        
        
    }
    
    
    return sectionFooterView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    //所有弹窗选择走这里
    if ([_listArray[indexPath.section][@"list"][indexPath.row][@"showArrow"] boolValue])
    {
        //原值
        NSString *lastValue = [self modelArgWithIndexPath:indexPath];
        
        //还你妈有个至今我操
        if (indexPath.section == 3 && indexPath.row == 2) //工作经验
        {
            [YGActionSheetView showAlertWithTitlesArray:@[@"至今",@"结束时间"] handler:^(NSInteger selectedIndex, NSString *selectedString)
             {
                 if(selectedIndex == 0)
                 {
                     [self setModelArgWithIndexPath:indexPath string:@"至今"];
                 }
                 else
                 {
                     NSDateFormatter *startFormat = [[NSDateFormatter alloc] init];
                     startFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                     NSDate *startDate = [startFormat dateFromString:@"1960-1-1 00:00:00"];
                     
                     YGDatePickerView *datePickerView = [YGDatePickerView showWithStartDate:startDate endDate:[NSDate date] titleString:@"请选择" datePickerMode:UIDatePickerModeDate handler:^(NSDate *selectedDate)
                                                         {
                                                             NSDateFormatter *selectedFormat = [[NSDateFormatter alloc] init];
                                                             selectedFormat.dateFormat = @"yyyy-MM-dd";
                                                             [self setModelArgWithIndexPath:indexPath string:[selectedFormat stringFromDate:selectedDate]];
                                                         }];
                     [datePickerView selectWithDate:[startFormat dateFromString:[lastValue stringByAppendingString:@" 00:00:00"]]];
                 }
             }];
            return;
        }
        
        switch ([_listArray[indexPath.section][@"list"][indexPath.row][@"type"] intValue])
        {
                //pickerView
            case 1:
            {
                if (indexPath.section == 0 && indexPath.row == 3) //工作年限
                {
                    
                    YGPickerView *pickerView = [YGPickerView showWithPickerViewDataSource:_listArray[indexPath.section][@"list"][indexPath.row][@"pickerArray"] titleString:@"请选择" handler:^(NSInteger selectedRow, NSString *selectedString)
                                                {
                                                    for (AdvertisesForInfoModel *model in _experienceArray) {
                                                        if ([model.name isEqualToString:selectedString]) {
                                                            _experienceidString = model.id;
                                                        }
                                                    }
                                                    [self setModelArgWithIndexPath:indexPath string:selectedString];
                                                }];
                    [pickerView selectWithTitleString:lastValue];
                }
                if (indexPath.section == 0 && indexPath.row == 6) //园区
                {
                    
                    YGPickerView *pickerView = [YGPickerView showWithPickerViewDataSource:_listArray[indexPath.section][@"list"][indexPath.row][@"pickerArray"] titleString:@"请选择" handler:^(NSInteger selectedRow, NSString *selectedString)
                                                {
                                                    for (AdvertisesForInfoModel *model in _gardenArray) {
                                                        if ([model.label isEqualToString:selectedString]) {
                                                            _gardenidString = model.value;
                                                        }
                                                    }
                                                    [self setModelArgWithIndexPath:indexPath string:selectedString];
                                                }];
                    [pickerView selectWithTitleString:lastValue];
                }
                if (indexPath.section == 1 && indexPath.row == 2) //薪资
                {
                    
                    
                    YGPickerView *pickerView = [YGPickerView showWithPickerViewDataSource:_listArray[indexPath.section][@"list"][indexPath.row][@"pickerArray"] titleString:@"请选择" handler:^(NSInteger selectedRow, NSString *selectedString)
                                                {
                                                    for (AdvertisesForInfoModel *model in _salaryArray) {
                                                        if ([model.name isEqualToString:selectedString]) {
                                                            _priceString = model.id;
                                                        }
                                                    }
                                                    [self setModelArgWithIndexPath:indexPath string:selectedString];
                                                }];
                    [pickerView selectWithTitleString:lastValue];
                    
                }
                
                if (indexPath.section == 2 && indexPath.row == 2) //学历
                {
                    YGPickerView *pickerView = [YGPickerView showWithPickerViewDataSource:_listArray[indexPath.section][@"list"][indexPath.row][@"pickerArray"] titleString:@"请选择" handler:^(NSInteger selectedRow, NSString *selectedString)
                                                {
                                                    for (AdvertisesForInfoModel *model in _educationArray) {
                                                        if ([model.name isEqualToString:selectedString]) {
                                                            _educationalidString = model.id;
                                                        }
                                                    }
                                                    [self setModelArgWithIndexPath:indexPath string:selectedString];
                                                }];
                    [pickerView selectWithTitleString:lastValue];
                    //                    }
                }
                
                if (indexPath.section == 1 && indexPath.row == 0)
                {
                    YGPickerView *pickerView = [YGPickerView showWithPickerViewDataSource:_listArray[indexPath.section][@"list"][indexPath.row][@"pickerArray"] titleString:@"请选择" handler:^(NSInteger selectedRow, NSString *selectedString){
                        _characterString = [NSString stringWithFormat:@"%ld",selectedRow+1];
                        [self setModelArgWithIndexPath:indexPath string:selectedString];
                        
                    }];
                    
                    [pickerView selectWithTitleString:lastValue];
                    
                }
                
                if (indexPath.section == 1 && indexPath.row == 4)
                {
                    YGPickerView *pickerView = [YGPickerView showWithPickerViewDataSource:_listArray[indexPath.section][@"list"][indexPath.row][@"pickerArray"] titleString:@"请选择" handler:^(NSInteger selectedRow, NSString *selectedString){
                        _jobStateString = [NSString stringWithFormat:@"%ld",selectedRow];
                        [self setModelArgWithIndexPath:indexPath string:selectedString];
                        
                    }];
                    
                    [pickerView selectWithTitleString:lastValue];
                }
                if(indexPath.section == 0 && indexPath.row == 1)
                {
                    YGPickerView *pickerView = [YGPickerView showWithPickerViewDataSource:_listArray[indexPath.section][@"list"][indexPath.row][@"pickerArray"] titleString:@"请选择" handler:^(NSInteger selectedRow, NSString *selectedString){
                        _sexString = [NSString stringWithFormat:@"%ld",selectedRow+1];
                        [self setModelArgWithIndexPath:indexPath string:selectedString];
                    }];
                    [pickerView selectWithTitleString:lastValue];
                }
            }
                break;
                //datePickerView
            case 2:
            {
                //时间不带至今的选择器
                NSDateFormatter *startFormat = [[NSDateFormatter alloc] init];
                startFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSDate *startDate = [startFormat dateFromString:@"1960-1-1 00:00:00"];
                
                YGDatePickerView *datePickerView = [YGDatePickerView showWithStartDate:startDate endDate:[NSDate date] titleString:@"请选择" datePickerMode:UIDatePickerModeDate handler:^(NSDate *selectedDate)
                                                    {
                                                        NSDateFormatter *selectedFormat = [[NSDateFormatter alloc] init];
                                                        selectedFormat.dateFormat = @"yyyy-MM-dd";
                                                        [self setModelArgWithIndexPath:indexPath string:[selectedFormat stringFromDate:selectedDate]];
                                                    }];
                [datePickerView selectWithDate:[startFormat dateFromString:[lastValue stringByAppendingString:@" 00:00:00"]]];
            }
                break;
                //cityPickerView
            case 3:
            {
                //城市选择
                YGCityPikerView1 *cityPikerView1 = [YGCityPikerView1 showWithHandler:^(NSString *province, NSString *city)
                                                    {
                                                        [self setModelArgWithIndexPath:indexPath string:[NSString stringWithFormat:@"%@ %@", province, city]];
                                                    }];
                if([lastValue isEqualToString:@""])
                {
                    return;
                }
                NSArray *sepArray = [lastValue componentsSeparatedByString:@" "];
                [cityPikerView1 selectProvince:sepArray[0] city:sepArray[1]];
            }
                break;
                //跳转
            case 4:
            {
                _indexPath = indexPath;
                
                ChooseJobPositionViewController *vc = [[ChooseJobPositionViewController alloc] init];
                vc.pageType = @"introduce";
                vc.delegate = self;
                if (indexPath.section == 1 && ![_positionModelNow.name isEqualToString:@""] && _positionModelNow.name != nil ) {
                    vc.model = _positionModelNow;
                }
                if (indexPath.section == 3 && ![_positionModelNow.name isEqualToString:@""] && _positionModelNow.name != nil ) {
                    vc.model = _positionModelExperience;
                }
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
        }
    }
}

- (BOOL)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 1000)
    {
        _model.description = textView.text;
    }
    else
    {
        _model.selfEvaluation = textView.text;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        [textView viewWithTag:textView.tag + 1000].hidden = NO;
        
    }
    else
    {
        [textView viewWithTag:textView.tag + 1000].hidden = YES;
    }
}

- (void)sectionHeaderButtonClick:(UIButton *)button
{
    [self.view endEditing:YES];
    button.selected = !button.isSelected;
    _listArray[button.tag - 300][@"isSelected"] = @(button.isSelected);
    [_tableView reloadData];
}

- (void)myIntroduceTableViewCell:(MyIntroduceTableViewCell *)cell textFieldDidEndEditingWithString:(NSString *)string
{
    [self setModelArgWithIndexPath:[_tableView indexPathForCell:cell] string:string];
}

- (void)setModelArgWithIndexPath:(NSIndexPath *)indexPath string:(NSString *)string
{
    //给模型赋值
    NSString *methodName = _listArray[indexPath.section][@"list"][indexPath.row][@"modelArg"];
    NSString *firstUpperCaseString = [methodName substringToIndex:1].uppercaseString;
    NSString *setMethodName = [NSString stringWithFormat:@"set%@%@:", firstUpperCaseString, [methodName substringFromIndex:1]];
    [_model performSelector:NSSelectorFromString(setMethodName) withObject:string];
    [_tableView reloadData];
}

- (id)modelArgWithIndexPath:(NSIndexPath *)indexPath
{
    return [_model performSelector:NSSelectorFromString(_listArray[indexPath.section][@"list"][indexPath.row][@"modelArg"])];
}

- (void)takePositionModel:(AdvertisesForInfoModel *)model
{
    [self setModelArgWithIndexPath:_indexPath string:model.name];
    if (_indexPath.section == 1 && _indexPath.row == 3) //职位类别
    {
        _jobidString = model.id;
        _positionModelNow = model;
    }
    if (_indexPath.section == 3 && _indexPath.row == 3) //职位类别
    {
        _experienceJobidString = model.id;
        _positionModelExperience = model;
    }
    [self setModelArgWithIndexPath:_indexPath string:model.name];
    
}

- (void)getData
{
    [YGNetService showLoadingViewWithSuperView:self.view];
    
    [self startPostWithURLString:REQUEST_FindJobList parameters:@{} showLoadingView:NO scrollView:nil];
    [self startPostWithURLString:REQUEST_FindExperienceList parameters:@{} showLoadingView:NO scrollView:nil];
    [self startPostWithURLString:REQUEST_ChooseGarden parameters:@{} showLoadingView:NO scrollView:nil];
    [self startPostWithURLString:REQUEST_FindSalaryList parameters:@{} showLoadingView:NO scrollView:nil];
    [self startPostWithURLString:REQUEST_FindEducationalList parameters:@{} showLoadingView:NO scrollView:nil];
    
}
- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    
    
    if ([URLString isEqualToString:REQUEST_FindJobList]) {
        [_jobidArray addObjectsFromArray: responseObject[@"JobList"]];
    }
    if ([URLString isEqualToString:REQUEST_FindExperienceList]) {
        NSMutableArray *rootArray = responseObject[@"ExperienceList"];
        _experienceArray = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:rootArray];
        NSMutableArray *pickExperienceArray = [[NSMutableArray alloc] init];
        for (AdvertisesForInfoModel *model in _experienceArray) {
            [pickExperienceArray addObject:model.name];
        }
        [_listArray[0][@"list"][3] setObject:pickExperienceArray.mutableCopy forKey:@"pickerArray"];
    }
    if ([URLString isEqualToString:REQUEST_ChooseGarden]) {
        NSMutableArray *rootArray = responseObject[@"list"];
        _gardenArray = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:rootArray];
        NSMutableArray *gardenArray = [[NSMutableArray alloc] init];
        for (AdvertisesForInfoModel *model in _gardenArray) {
            [gardenArray addObject:model.label];
        }
        [_listArray[0][@"list"][6] setObject:gardenArray.mutableCopy forKey:@"pickerArray"];
    }
    if ([URLString isEqualToString:REQUEST_FindSalaryList]) {
        NSMutableArray *rootArray = responseObject[@"SalaryList"];
        _salaryArray = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:rootArray];
        NSMutableArray *pickSalaryArray = [[NSMutableArray alloc] init];
        for (AdvertisesForInfoModel *model in _salaryArray) {
            [pickSalaryArray addObject:model.name];
        }
        [_listArray[1][@"list"][2] setObject:pickSalaryArray.mutableCopy forKey:@"pickerArray"];
    }
    if ([URLString isEqualToString:REQUEST_FindEducationalList]) {
        NSMutableArray *rootArray = responseObject[@"EducationalList"];
        _educationArray = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:rootArray];
        NSMutableArray *pickEducationArray = [[NSMutableArray alloc] init];
        for (AdvertisesForInfoModel *model in _educationArray) {
            [pickEducationArray addObject:model.name];
        }
        [_listArray[2][@"list"][2] setObject:pickEducationArray.mutableCopy forKey:@"pickerArray"];
    }
    if (_jobidArray.count != 0 && _experienceArray.count != 0 && _gardenArray.count != 0 &&_salaryArray.count != 0 && _educationArray.count != 0) {
        [YGNetService dissmissLoadingView];
        [self configUI];
        
    }
}
- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{
    
}
@end
