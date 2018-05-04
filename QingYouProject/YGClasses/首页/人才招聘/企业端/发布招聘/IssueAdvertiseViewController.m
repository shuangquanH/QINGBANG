//
//  IssueAdvertiseViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "IssueAdvertiseViewController.h"
#import "AdvertisesForInfoModel.h"
#import "IssueAdvertiseViewTableViewCell.h"
#import "AdvertisesForInfoDetailViewController.h"
#import "ChooseJobPositionViewController.h"
#import "YGPikerView.h"
#import "YGCityPikerView.h"
#import "IssueChooseWellBeingView.h"
#import "IssueAdvertiseViewSpreadTableViewCell.h"

@interface IssueAdvertiseViewController ()<UITableViewDelegate,UITableViewDataSource,IssueAdvertiseViewTableViewCellDelegate,ChooseJobPositionViewControllerDelegate,YGPikerViewDelegate,YGCityPikerViewDelegate,IssueChooseWellBeingViewDelegate>

@end

@implementation IssueAdvertiseViewController
{
    NSMutableArray *_listArray;
    YGPikerView *_salaryPickerView;
    YGPikerView *_educationPickView;
    YGPikerView *_experiencepickerView;
    
    NSMutableArray *_salaryArray;
    NSMutableArray *_educationArray;
    NSMutableArray *_experienceArray;
    NSMutableArray *_IssueChooseWellBeingArray;
    NSString *_benefitsId;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)configAttribute
{
    _listArray = [[NSMutableArray alloc] init];
    self.naviTitle = @"发布招聘信息";
    _salaryArray = [[NSMutableArray alloc] init];
    _educationArray = [[NSMutableArray alloc] init];
    _experienceArray = [[NSMutableArray alloc] init];
    _IssueChooseWellBeingArray = [[NSMutableArray alloc] init];;


}

- (void)configUI
{
    
    UIButton *barButton = [[UIButton alloc] init];
    [barButton setTitle:@"预览" forState:UIControlStateNormal];
    [barButton setTitle:@"预览" forState:UIControlStateSelected];
    barButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [barButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [barButton sizeToFit];
    [barButton addTarget:self action:@selector(showNow) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    NSArray * titlesArr = @[
                            
                          
                                @{
                                    @"title":@"企业名称",
                                    @"content":@""
                                    },
                                @{
                                    @"title":@"招聘职位",
                                    @"content":@""
                                    },
                                @{
                                    @"title":@"招聘人数",
                                    @"content":@""
                                    },
                                @{
                                    @"title":@"薪资待遇",
                                    @"content":@""
                                    },
                                
                             @{
                                    @"title":@"学历要求",
                                    @"content":@""
                                    },
                                @{
                                    @"title":@"工作年限",
                                    @"content":@""
                                    },
                                @{
                                    @"title":@"工作地点",
                                    @"content":@""
                                    },
                                @{
                                    @"title":@"福利待遇",
                                    @"content":@""
                                    },
                                @{
                                    @"title":@"联系人",
                                    @"content":@""
                                    },
                                @{
                                    @"title":@"联系方式",
                                    @"content":@""
                                    },
                                @{
                                    @"title":@"职位描述",
                                    @"content":@""
                                    }
                                
                            ];
    [_listArray addObjectsFromArray:[AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:titlesArr]];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[IssueAdvertiseViewTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelllabel"];
    
    [_tableView registerClass:[IssueAdvertiseViewTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelltextfieldCompanyName"];
    [_tableView registerClass:[IssueAdvertiseViewTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelltextfieldCount"];
    [_tableView registerClass:[IssueAdvertiseViewTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelltextfieldName"];
    [_tableView registerClass:[IssueAdvertiseViewTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelltextfieldPhone"];
    [_tableView registerClass:[IssueAdvertiseViewTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelltextView"];

    [_tableView registerClass:[IssueAdvertiseViewSpreadTableViewCell class] forCellReuseIdentifier:@"IssueAdvertiseViewSpreadTableViewCell"];


    [self.view addSubview:_tableView];
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IssueAdvertiseViewTableViewCell *cell;
    if (indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdFundingAddProjectTableViewCelltextfieldCompanyName" forIndexPath:indexPath];
    }else if(indexPath.row == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdFundingAddProjectTableViewCelltextfieldCount" forIndexPath:indexPath];

    }else if(indexPath.row == 8)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdFundingAddProjectTableViewCelltextfieldName" forIndexPath:indexPath];
    }else if(indexPath.row == 9)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdFundingAddProjectTableViewCelltextfieldPhone" forIndexPath:indexPath];

    }else if(indexPath.row == 10)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdFundingAddProjectTableViewCelltextView" forIndexPath:indexPath];
//        cell.userInteractionEnabled = NO;
        cell.viewcontroller = self;
    }else if(indexPath.row == 7)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"IssueAdvertiseViewSpreadTableViewCell" forIndexPath:indexPath];
       
        
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdFundingAddProjectTableViewCelllabel" forIndexPath:indexPath];

    }
  
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AdvertisesForInfoModel *model = _listArray[indexPath.row];
    cell.delegate = self;
    [cell setModel:model withIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(indexPath.row == 10)
    {
        AdvertisesForInfoModel *model = _listArray[10];
         UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , YGScreenWidth-20, 45)];
        nameLabel.text = model.content;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        nameLabel.numberOfLines  = 0;
        [nameLabel sizeToFit];
        return nameLabel.height+100;
    }
    if (indexPath.row == 7) {
      return   [tableView fd_heightForCellWithIdentifier:@"IssueAdvertiseViewSpreadTableViewCell" cacheByIndexPath:indexPath configuration:^(IssueAdvertiseViewSpreadTableViewCell *cell) {
          cell.fd_enforceFrameLayout = YES;
          AdvertisesForInfoModel *model = _listArray[indexPath.row];
          [cell setModel:model withIndexPath:indexPath];
        }];
    }
    return 45;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

 
        AdvertisesForInfoModel *poistionModel = _listArray[indexPath.row];

            switch (indexPath.row) {
                case 1:
                {
                    ChooseJobPositionViewController *vc = [[ChooseJobPositionViewController alloc] init];
                    vc.delegate = self;
                    if (![poistionModel.content isEqualToString:@""] && poistionModel.content != nil) {
                        vc.model = poistionModel;
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                    break;

                }
                case 3:
                {
   
                        NSMutableArray *pickSalaryArray = [[NSMutableArray alloc] init];
                        for (AdvertisesForInfoModel *model in _salaryArray) {
                            [pickSalaryArray addObject:model.name];
                        }
                        _salaryPickerView = [[YGPikerView alloc] initWithPikerViewDataSource:pickSalaryArray titleString:@"薪资待遇"];
                        if ( ![poistionModel.content isEqualToString:@""]) {
                            [_salaryPickerView setPikerViewSelectWithRow:(int)poistionModel.row];
                        }
                        _salaryPickerView.delegate = self;
                        [_salaryPickerView show];
//                    }
                    
                    
                    break;

                }
                case 4:
                {
                        NSMutableArray *pickEducationArray = [[NSMutableArray alloc] init];
                        for (AdvertisesForInfoModel *model in _educationArray) {
                            [pickEducationArray addObject:model.name];
                        }
                        
                        _educationPickView = [[YGPikerView alloc] initWithPikerViewDataSource:pickEducationArray titleString:@"学历要求"];
                    if ( ![poistionModel.content isEqualToString:@""]) {
                        [_educationPickView setPikerViewSelectWithRow:(int)poistionModel.row];
                    }
                    _educationPickView.delegate = self;
                    [_educationPickView show];
//                    }
                    break;

                }
                case 5:
                {


                        NSMutableArray *pickExperienceArray = [[NSMutableArray alloc] init];
                        for (AdvertisesForInfoModel *model in _experienceArray) {
                            [pickExperienceArray addObject:model.name];
                        }
                    _experiencepickerView = [[YGPikerView alloc] initWithPikerViewDataSource:pickExperienceArray titleString:@"工作经验"];
                    if (![poistionModel.content isEqualToString:@""]) {
                        [_experiencepickerView setPikerViewSelectWithRow:(int)poistionModel.row];
                    }
                    _experiencepickerView.delegate = self;
                    [_experiencepickerView show];
                    break;

                }
                case 6:
                {
                
                    
                    YGCityPikerView *cityPickView = [[YGCityPikerView alloc] init];
                    if (![poistionModel.content isEqualToString:@""]) {
                        NSArray *array = [poistionModel.content componentsSeparatedByString:@" "];
                        [cityPickView setSelectProvince:array[0] city:array[1] district:array[2]];
                    }

                    cityPickView.delegate = self;
                    [cityPickView show];
                    break;

                }
                case 7:
                {
                    IssueChooseWellBeingView * wellBeingView = [[IssueChooseWellBeingView alloc] init];
                    wellBeingView.delegate = self;
                        for (AdvertisesForInfoModel *model in _IssueChooseWellBeingArray)
                        {
                            model.isSelect = NO;
                        }
                        if (![_benefitsId isEqualToString:@""])
                        {
                            NSArray *array = [_benefitsId componentsSeparatedByString:@","];
                            for (int i = 0; i<array.count; i++)
                            {
                                for (AdvertisesForInfoModel *model in _IssueChooseWellBeingArray)
                                {
                                    if ([array[i] isEqualToString:model.id]) {
                                        model.isSelect = YES;
                                    }
                                }
                            }
                        }
                        [wellBeingView createPopChooseViewWithDataSorce:_IssueChooseWellBeingArray];

//                    }
                    break;

                }
            }

    
}


#pragma 代理
//选择类型带回来的值
- (void)takeTypeValueBackWithValue:(NSString *)value
{
    AdvertisesForInfoModel *model = _listArray[0][0];
    model.content = value;
    [_tableView reloadData];
}

////填写项目名称带回来的值
//- (void)takeProjectNameValueBackWithValue:(NSString *)value
//{
//    AdvertisesForInfoModel *model = _listArray[0][1];
//    model.content = value;
//    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//
//    [_tableView reloadData];
//}

- (void)reloadCellHeight:(CGFloat)height withText:(NSString *)text
{
    AdvertisesForInfoModel *model = _listArray[10];
    model.content = text;
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:10 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)textViewCell:(id)cell didChangeText:(NSString *)text
{
  AdvertisesForInfoModel *model = _listArray[10];
    model.content = text;
    
}

- (void)showNow
{

    if ([((AdvertisesForInfoModel *)_listArray[0]).content isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请填写企业名称"];
        return;
    }
    if ([((AdvertisesForInfoModel *)_listArray[1]).id isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请选择招聘职位"];
        return;
    }
    if ([((AdvertisesForInfoModel *)_listArray[2]).content isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请填写招聘人数"];
        return;
    }
    if ([((AdvertisesForInfoModel *)_listArray[3]).id isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请选择薪资待遇"];
        return;
    }
    if ([((AdvertisesForInfoModel *)_listArray[4]).id isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请选择学历要求"];
        return;
    }
    if ([((AdvertisesForInfoModel *)_listArray[5]).id isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请选择工作年限"];
        return;
    }
    if ([((AdvertisesForInfoModel *)_listArray[6]).content isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请选择工作地点"];
        return;
    }
    if ([_benefitsId isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请选择福利待遇"];
        return;
    }
    if ([((AdvertisesForInfoModel *)_listArray[8]).content isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请填写联系人信息"];
        return;
    }
    if ([((AdvertisesForInfoModel *)_listArray[9]).content isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请填写联系方式"];
        return;
    }
    if ([YGAppTool isNotPhoneNumber:((AdvertisesForInfoModel *)_listArray[9]).content]) {
        return;
    }
    if ([((AdvertisesForInfoModel *)_listArray[10]).content isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请填写职位描述"];
        return;
    }
    AdvertisesForInfoDetailViewController *descriptionVc = [[AdvertisesForInfoDetailViewController alloc] init];
    descriptionVc.pageType = @"enterprise";
    descriptionVc.listArray = _listArray;
    descriptionVc.benefitsId = _benefitsId;
    [self.navigationController pushViewController:descriptionVc animated:YES];
}

- (void)takePositionModel:(AdvertisesForInfoModel *)model
{
    AdvertisesForInfoModel *poistionModel = _listArray[1];
    poistionModel.fatherIndexPath = model.fatherIndexPath;
    poistionModel.content = model.name;
    poistionModel.id = model.id;
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
//选择框弹出来选择后的数据回馈
- (void)YGPikerView:(YGPikerView *)pikerView OkButtonClickdidSelectRow:(NSInteger)row withString:(NSString *)titleString
{
    int  indexRow = 0;
    AdvertisesForInfoModel *poistionModel;
    AdvertisesForInfoModel *model ;
    if (pikerView == _salaryPickerView) {
        poistionModel = _listArray[3];
        indexRow = 3;
        model = _salaryArray[row];
    }
    if (pikerView == _educationPickView) {
        poistionModel = _listArray[4];
        indexRow = 4;
        model = _educationArray[row];

    }
    if (pikerView == _experiencepickerView) {
        poistionModel = _listArray[5];
        indexRow = 5;
        model = _experienceArray[row];

    }
    poistionModel.row = row;
    poistionModel.content = titleString;
    poistionModel.id = model.id;
    
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(NSInteger)indexRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

}
//省事选择返回
- (void)selectedProvince:(NSString *)province city:(NSString *)city district:(NSString *)district
{
    AdvertisesForInfoModel *poistionModel;
    poistionModel = _listArray[6];
    poistionModel.content = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

}

//福利待遇
- (void)siftDataWithKeyModelArray:(NSArray *)modelArray
{
    AdvertisesForInfoModel *poistionModel;
    poistionModel = _listArray[7];
    NSString *contentStr =@"";
    _benefitsId = @"";
    for (AdvertisesForInfoModel *model in modelArray)
    {
        contentStr = [contentStr stringByAppendingString:model.name];
        _benefitsId = [_benefitsId stringByAppendingString:model.id];
        if (![model isEqual:[modelArray lastObject]]) {
            contentStr =  [contentStr stringByAppendingString:@","];
            _benefitsId =  [_benefitsId stringByAppendingString:@","];
        }
    }
    poistionModel.content = contentStr;
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:7 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (void)textfieldEndEdtingWithModel:(AdvertisesForInfoModel *)model withIndexPath:(NSIndexPath *)indexpath
{
    AdvertisesForInfoModel *poistionModel;
    poistionModel = _listArray[indexpath.row];
    poistionModel.content = model.content;
    [_tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (void)getData
{
    [YGNetService showLoadingViewWithSuperView:self.view];
    [self startPostWithURLString:REQUEST_FindSalaryList parameters:@{} showLoadingView:NO scrollView:nil];
    [self startPostWithURLString:REQUEST_FindEducationalList parameters:@{} showLoadingView:NO scrollView:nil];
    [self startPostWithURLString:REQUEST_FindExperienceList parameters:@{} showLoadingView:NO scrollView:nil];
    [self startPostWithURLString:REQUEST_FindBenefitsList parameters:@{} showLoadingView:NO scrollView:nil];
    
}
- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    if ([URLString isEqualToString:REQUEST_FindSalaryList]) {
        
        NSMutableArray *rootArray = responseObject[@"SalaryList"];
        _salaryArray = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:rootArray];
        NSMutableArray *pickSalaryArray = [[NSMutableArray alloc] init];
        for (AdvertisesForInfoModel *model in _salaryArray) {
            [pickSalaryArray addObject:model.name];
        }
        
    }
    if ([URLString isEqualToString:REQUEST_FindEducationalList]) {
        NSMutableArray *rootArray = responseObject[@"EducationalList"];
        _educationArray = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:rootArray];
        NSMutableArray *pickEducationArray = [[NSMutableArray alloc] init];
        for (AdvertisesForInfoModel *model in _educationArray) {
            [pickEducationArray addObject:model.name];
        }
        
    }
    if ([URLString isEqualToString:REQUEST_FindExperienceList]) {
        NSMutableArray *rootArray = responseObject[@"ExperienceList"];
        _experienceArray = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:rootArray];
        NSMutableArray *pickExperienceArray = [[NSMutableArray alloc] init];
        for (AdvertisesForInfoModel *model in _experienceArray) {
            [pickExperienceArray addObject:model.name];
        }
        
    }
    if ([URLString isEqualToString:REQUEST_FindBenefitsList]) {
        _IssueChooseWellBeingArray = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"BenefitsList"]];
        
    }

    if (_salaryArray.count != 0 && _educationArray.count != 0 && _experienceArray.count != 0 &&_IssueChooseWellBeingArray.count != 0)
    {
        [YGNetService dissmissLoadingView];
        [self configUI];
        
    }
}
@end
