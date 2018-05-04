//
//  SerchAdvertisesViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SerchAdvertisesViewController.h"
#import "SearchAdvertieseTableViewCell.h"
#import "AdvertisesForinfoPopView.h"
#import "YGCityPikerView1.h"

#import "CheckAdvertisesViewController.h"
#import "SearchAdvertiesePopSiftView.h"
#import "AdvertiseModel.h"


@interface SerchAdvertisesViewController ()<UITableViewDelegate,UITableViewDataSource,AdvertisesForinfoPopViewDelegate,UISearchBarDelegate,SearchAdvertiesePopSiftViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    AdvertisesForinfoPopView *_popView;
    int   _index;
//    UIView *_blackView;
    SearchAdvertiesePopSiftView *_searchSiftView;
    UIButton *_backButton;
    
    NSString *_cityString;
    NSString *_jobidString;
    NSString *_priceString;
    NSString *_sexString;
    NSString *_educationalidString;
    NSString *_experienceidString;
    
    NSMutableArray *_sexArray;
    NSMutableArray *_educationArray;
    NSMutableArray *_experienceArray;
    NSMutableArray *_jobRightTabelArray;
    NSMutableArray *_jobLeftDataArray;
    NSMutableArray *_salaryArray;
    NSMutableArray *_IssueChooseWellBeingArray;
    NSString   *_selectString;
    
    UITextField *_searchTextFieldView;
    UIView *_alphaView;
    
    UIView *_baseView;
}


@end

@implementation SerchAdvertisesViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    // Do any additional setup after loading the view.
}


- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_ResumeQueryFiltering parameters:@{@"city":_cityString,@"jobid":_jobidString,@"price":_priceString,@"sex":_sexString,@"educationalid":_educationalidString,@"experienceid":_experienceidString,@"total":self.totalString,@"count":self.countString,@"select":_selectString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }

        [_listArray addObjectsFromArray:[AdvertiseModel mj_objectArrayWithKeyValuesArray:responseObject[@"ResumeInformationList"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        if ([(NSArray *)responseObject[@"ResumeInformationList"] count] == 0) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)configAttribute
{
    self.naviTitle = @"招聘信息";
    _listArray = [[NSMutableArray alloc] init];
    _jobLeftDataArray = [[NSMutableArray alloc] init];
    _jobRightTabelArray = [[NSMutableArray alloc] init];
    _salaryArray = [[NSMutableArray alloc] init];
    _IssueChooseWellBeingArray = [[NSMutableArray alloc] init];
    _experienceArray = [[NSMutableArray alloc] init];
    _educationArray = [[NSMutableArray alloc] init];
    _sexArray = [[NSMutableArray alloc] init];
    
    _jobidString = @"";
    _priceString = @"";
    _sexString = @"";
    _cityString = @"";
    _educationalidString = @"";
    _experienceidString = @"";
    _selectString = @"";
    
   
    

}
- (void)configUI
{
    

    
    _backButton = [[UIButton alloc] init];
    _backButton.frame = CGRectMake(0, 0, 20, 20);
    [_backButton setImage:[UIImage imageNamed:@"back_black"]  forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [_backButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [_backButton sizeToFit];
    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 5, YGScreenWidth - 40 - 15, YGNaviBarHeight - 10)];
    searchBar.placeholder = @"搜索感兴趣的简历";
    searchBar.delegate = self;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.tintColor = [UIColor whiteColor];
    searchBar.barTintColor = [UIColor whiteColor];
    // 改变UISearchBar内部输入框样式
    UIView *searchTextFieldView = nil;
    searchTextFieldView = [[[searchBar.subviews firstObject] subviews] lastObject];
    // 改变输入框背景色
    searchTextFieldView.subviews[0].superview.backgroundColor = YGUIColorFromRGB(0xefeff4, 1);
    searchTextFieldView.layer.cornerRadius = 5.0;
    [searchTextFieldView setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGNaviBarHeight)];
    _searchTextFieldView = [searchBar valueForKey:@"_searchField"];
    
    
    if([_searchTextFieldView isKindOfClass:UITextField.class])
    {
        _searchTextFieldView.inputAccessoryView = [UIView new];
        _searchTextFieldView.font = [UIFont systemFontOfSize:14.0];
    }
    
    [navView addSubview:searchBar];
    self.navigationItem.titleView = navView;
    
    //四个segment按钮
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    _baseView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:_baseView];
    
    NSArray *titleArr = @[@"工作城市",@"职位类型",@"期望薪资",@"筛选"];
    for (int i =0; i<titleArr.count; i++)
    {
        UIView *buttonView  = [[UIView alloc] initWithFrame:CGRectMake(YGScreenWidth/4*i,0,YGScreenWidth/4,40)];
        [_baseView addSubview:buttonView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonView.width-17, buttonView.height)];
        label.textColor = colorWithBlack;
        label.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.text = titleArr[i];
        //        label.y = 20-label.height/2;
        label.tag = 555+i;
        label.textAlignment = NSTextAlignmentCenter;
        [buttonView addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(YGScreenWidth/4-17, label.y, 17, 17)];
        imageView.image = [UIImage imageNamed:@"steward_talents_unfold_gray"];
        [imageView sizeToFit];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.tag = 560+i;
        [buttonView addSubview: imageView];
        imageView.centery = label.centery;
        
        
        UIButton *deliverCurriculumButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,YGScreenWidth/4,40)];
        [deliverCurriculumButton addTarget:self action:@selector(deliverCurriculumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        deliverCurriculumButton.tag = 111111+i;
        [buttonView addSubview:deliverCurriculumButton];
        
        
        if (i == 3) {

            label.textColor = colorWithRedColor;
            imageView.image = [UIImage imageNamed:@"steward_talents_filter_red"];
            label.frame = CGRectMake(label.x, label.y, buttonView.width*0.6, label.height);
            imageView.frame = CGRectMake(label.width+5, imageView.y, imageView.width, imageView.height);
        }
    }
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 41, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SearchAdvertieseTableViewCell class] forCellReuseIdentifier:@"SearchAdvertieseTableViewCell"];
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    
  
    _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, YGScreenWidth, YGStatusBarHeight-YGNaviBarHeight-YGStatusBarHeight-40)];
    _alphaView.backgroundColor = [colorWithBlack colorWithAlphaComponent:0];
    [self.view addSubview:_alphaView];
    _alphaView.hidden = YES;
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
    SearchAdvertieseTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchAdvertieseTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AdvertiseModel *model = _listArray[indexPath.section];
    model.name = model.name;
    model.price = model.salary;
    model.indexPath = indexPath;
    [cell setModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdvertiseModel *model = _listArray[indexPath.section];
    CheckAdvertisesViewController *vc = [[CheckAdvertisesViewController alloc] init];
    vc.recruitmentItemId = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)deliverCurriculumButtonAction:(UIButton *)btn
{
    [_searchTextFieldView resignFirstResponder];
    [self resignFirstResponder];
    
    if (_popView) {
        [_popView dismiss];

    }
    if (_searchSiftView) {
        [_searchSiftView dismiss];
    }
    
    if (_index+111111 == btn.tag && btn.selected == YES)
    {
        btn.selected = NO;
        return;
    }
    btn.selected = YES;
    

    
    UILabel *lable = [self.view viewWithTag:555+btn.tag-111111];
    lable.textColor = colorWithMainColor;
    UIImageView *arrowImageView = [self.view viewWithTag:560+btn.tag-111111];
    arrowImageView.image = [UIImage imageNamed:@"steward_talents_packup_green"];

    
    if (btn.tag == 111111) {
        
//        YGCityPikerView *cityPickView = [[YGCityPikerView alloc] init];
//        cityPickView.delegate = self;
//        [cityPickView show];
        YGCityPikerView1 *cityPickView = [YGCityPikerView1 showWithHandler:^(NSString *province, NSString *city) {
            UIButton *btn = [self.view viewWithTag:_index +111111];
            btn.selected = NO;
            UILabel *lable = [self.view viewWithTag:555];
            lable.text = city;
            _cityString = [NSString stringWithFormat:@"%@ %@",province,city];
            [self refreshActionWithIsRefreshHeaderAction:YES];
        }];
        if (![_cityString isEqualToString:@""]) {
            NSArray *arry = [_cityString componentsSeparatedByString:@" "];
            [cityPickView selectProvince:arry[0] city:arry[1]];
        }
    }
    if (btn.tag == 111112) {
        _popView = [[AdvertisesForinfoPopView alloc] init];
        _popView.delegate = self;
        [self.view addSubview:_popView];
        
        for (AdvertisesForInfoModel *model in _jobLeftDataArray)
        {
            model.isSelect = NO;
        }
        
        for (NSArray *array in _jobRightTabelArray)
        {
            for (AdvertisesForInfoModel *model in array)
            {
                model.isSelect = NO;
            }
        }
        
        int index = 0;
        int rightIndex = 0;
            if (![_jobidString isEqualToString:@""]) {
                //判断id是不是相同，找到之后赋值选中
               int i = 0;
                for (NSArray *array in _jobRightTabelArray)
                {
                    int j = 0;
                    for (AdvertisesForInfoModel *model in array)
                    {
                        
                        if ([_jobidString isEqualToString:model.id])
                        {
                            model.isSelect = YES;
                            //找到当前选择的
                            AdvertisesForInfoModel *modelFather = _jobLeftDataArray[i];
                            index = i;
                            rightIndex = j;
                            modelFather.isSelect = YES;
                            break;
                        }
                        j++;
                    }
                    i++;
                }
             
            }
    

            [_popView createPopChooseViewWithDataSorce:_jobRightTabelArray
                                      andLeftDataArray:_jobLeftDataArray
                                              withType: pageTypeChoosePosition withLeftIndex:index withRightIndex:rightIndex];

    }
    if (btn.tag == 111113) {
        
        _popView = [[AdvertisesForinfoPopView alloc] init];
        _popView.delegate = self;
        [self.view addSubview:_popView];
        
        for (AdvertisesForInfoModel *model in _salaryArray)
        {
            model.isSelect = NO;

        }
        int i = 0;
        if (![_priceString isEqualToString:@""]) {
            for (AdvertisesForInfoModel *model in _salaryArray)
            {
                if ([_priceString isEqualToString:model.id])
                {
                    model.isSelect = YES;
                    break;
                }
                i++;
            }
        }
        [_popView createPopChooseViewWithDataSorce:_salaryArray andLeftDataArray:nil withType:pageTypeChooseSalary withLeftIndex:i withRightIndex:0];

    }
    if (btn.tag == 111114) {
        
        [_searchSiftView dismiss];

      
            if (![_sexString isEqualToString:@""]) {
                for (AdvertisesForInfoModel *model in _sexArray)
                {
                    if ([_sexString isEqualToString:model.name])
                    {
                        model.isSelect = YES;
                    }
                }
            }
            if (![_educationalidString isEqualToString:@""]) {
                for (AdvertisesForInfoModel *model in _educationArray)
                {
                    if ([_educationalidString isEqualToString:model.id])
                    {
                        model.isSelect = YES;
                    }
                }
            }
            if (![_experienceidString isEqualToString:@""]) {
                for (AdvertisesForInfoModel *model in _experienceArray)
                {
                    if ([_experienceidString isEqualToString:model.id])
                    {
                        model.isSelect = YES;
                    }
                }
            }
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:_sexArray];
            [array addObject:_educationArray];
            [array addObject:_experienceArray];
            
            _searchSiftView = [[SearchAdvertiesePopSiftView alloc] init];
            [self.view addSubview:_searchSiftView];
            [_searchSiftView createPopChooseViewWithDataSorce:array];
            _searchSiftView.delegate = self;
 
    }
    
    _index =(int) btn.tag -111111;
    
}



- (void)deliverIntroduceWithModel:(AdvertiseModel *)model
{
    
}
- (void)dismissChangeColor
{
    for (int i =0; i<4; i++)
    {
        UILabel *lable = [_baseView viewWithTag:555+i];
        lable.textColor = colorWithBlack;
        UIImageView *arrowImageView = [self.view viewWithTag:560+i];
        arrowImageView.image = [UIImage imageNamed:@"steward_talents_unfold_gray"];
        if (i == 3) {
            lable.textColor = colorWithMainColor;
            arrowImageView.image = [UIImage imageNamed:@"steward_talents_filter_green"];
            
        }
        
    }
    
}
//筛选关键字 工作
- (void)siftDataWithKeyModel:(AdvertisesForInfoModel *)model
{
    UIButton *btn = [_baseView viewWithTag:_index +111111];
    btn.selected = NO;
    if (_index == 1) {
        UILabel *lable = [_baseView viewWithTag:555+_index];
        lable.text = model.name;
        _jobidString = model.id;

    }
    if (_index == 2) {
        _priceString = model.id;
    }
        [self refreshActionWithIsRefreshHeaderAction:YES];
}
//选省市后
//- (void)selectedProvince:(NSString *)province city:(NSString *)city district:(NSString *)district
//{
//    UILabel *lable = [self.view viewWithTag:555];
//    lable.text = city;
//    _cityString = [NSString stringWithFormat:@"%@ %@",province,city];
//    [self refreshActionWithIsRefreshHeaderAction:YES];
//}

#pragma searchBar
#pragma mark - searchBar的一些设置
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.frame = CGRectMake(- 20, 5, YGScreenWidth - 20, YGNaviBarHeight - 10);
    _backButton.hidden = YES;
//    [self configSearchHistoryTableView];
    searchBar.showsCancelButton = YES;       //显示“取消”按钮
    for(id cc in [searchBar subviews])
    {
        for (UIView *view in [cc subviews]) {
            if ([NSStringFromClass(view.class) isEqualToString:@"UINavigationButton"])
            {
                UIButton *btn = (UIButton *)view;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
                [btn setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
            }
        }
    }

}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (_popView) {
        [_popView dismiss];
        
    }
    if (_searchSiftView) {
        [_searchSiftView dismiss];
    }
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.frame = CGRectMake(0, 5, YGScreenWidth - 40 - 15, YGNaviBarHeight - 10);
    _backButton.hidden = NO;
    

}

//searchbar的取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _backButton.hidden = NO;
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    _selectString = @"";
    [self refreshActionWithIsRefreshHeaderAction:YES];

}

//搜索键盘上的搜索按钮点击响应事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    _selectString = _searchTextFieldView.text;
    [self refreshActionWithIsRefreshHeaderAction:YES];
    [searchBar resignFirstResponder];

    
}
//男女选择
-(void)siftDataWithKeyModelArray:(NSArray *)modelArray
{
    UIButton *btn = [_baseView viewWithTag:_index +111111];
    btn.selected = NO;
    
    _sexString = [((AdvertisesForInfoModel *)modelArray[0]).name isEqualToString:@"不限"]?@"":([((AdvertisesForInfoModel *)modelArray[0]).name isEqualToString:@"男"]?@"1":@"2");
    _educationalidString = ((AdvertisesForInfoModel *)modelArray[1]).id;
    _experienceidString = ((AdvertisesForInfoModel *)modelArray[2]).id;
    [self refreshActionWithIsRefreshHeaderAction:YES];
}


- (void)getData
{
    [YGNetService showLoadingViewWithSuperView:self.view];
    
    [self startPostWithURLString:REQUEST_FindJobList parameters:@{} showLoadingView:NO scrollView:nil];
    [self startPostWithURLString:REQUEST_FindSalaryList parameters:@{} showLoadingView:NO scrollView:nil];
    [self startPostWithURLString:REQUEST_FindEducationalList parameters:@{} showLoadingView:NO scrollView:nil];

    [self startPostWithURLString:REQUEST_FindExperienceList parameters:@{} showLoadingView:NO scrollView:nil];
    
}
- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    
    
    if ([URLString isEqualToString:REQUEST_FindJobList]) {
        NSMutableArray  *dataSource = [[NSMutableArray alloc] init];
        for (NSDictionary  *listDict in responseObject[@"JobList"]) {
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            AdvertisesForInfoModel *model = [[AdvertisesForInfoModel alloc] init];
            model.id = listDict[@"id"];
            model.name = listDict[@"name"];
            [dataSource addObject:model];
            for (NSDictionary *rightListDict in listDict[@"list"])
            {
                AdvertisesForInfoModel *modelRight = [[AdvertisesForInfoModel alloc] init];
                modelRight.id = rightListDict[@"id"];
                modelRight.name = rightListDict[@"name"];
                [dataArray addObject:modelRight];
            }
            [_jobRightTabelArray addObject:dataArray];
        }
        [_jobLeftDataArray addObjectsFromArray:dataSource];
    }
    
    if ([URLString isEqualToString:REQUEST_FindSalaryList]) {
        NSMutableArray *rootArray = responseObject[@"SalaryList"];
        _salaryArray = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:rootArray];
    }
    
    if ([URLString isEqualToString:REQUEST_FindEducationalList]) {
        NSMutableArray *rootArray = responseObject[@"EducationalList"];
        _educationArray = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:rootArray];
        AdvertisesForInfoModel *eduModel = _educationArray[0];
        eduModel.isSelect = YES;
    }
    if ([URLString isEqualToString:REQUEST_FindExperienceList]) {
        NSMutableArray *rootArray = responseObject[@"ExperienceList"];
        NSArray *sexArray  =  @[
                                @{@"name":@"不限"},
                                @{@"name":@"男"},
                                @{@"name":@"女"}
                                ];
        _sexArray = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:sexArray];
        _experienceArray = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:rootArray];
        AdvertisesForInfoModel *sexModel = _sexArray[0];
        sexModel.isSelect = YES;
        AdvertisesForInfoModel *experienceModel = _experienceArray[0];
        experienceModel.isSelect = YES;
    }



    if (_jobLeftDataArray.count != 0 && _salaryArray.count != 0 && _educationArray.count != 0 &&_jobRightTabelArray.count != 0 && _experienceArray.count != 0) {
        [YGNetService dissmissLoadingView];
        [self configUI];
        
    }
}
@end
