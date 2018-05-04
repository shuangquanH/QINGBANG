//
//  AdvertisesForInfoViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AdvertisesForInfoViewController.h"
#import "AdvertisesForInfoTableViewCell.h"
#import "AdvertisesForinfoPopView.h"
#import "YGCityPikerView1.h"
#import "YGPikerView.h"

#import "AdvertisesForInfoDetailViewController.h"
#import "MyIntroduceViewController.h"

@interface AdvertisesForInfoViewController ()<UITableViewDelegate,UITableViewDataSource,AdvertisesForInfoTableViewCellDelegate,AdvertisesForinfoPopViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    AdvertisesForinfoPopView *_popView;
    int   _index;
    NSString *_cityString;
    NSString *_jobidString;
    NSString *_priceString;
    NSString *_benefitidString;
    
    
    NSMutableArray *_jobRightTabelArray;
    NSMutableArray *_jobLeftDataArray;
    NSMutableArray *_salaryArray;
    NSMutableArray *_IssueChooseWellBeingArray;
}

@end

@implementation AdvertisesForInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)configAttribute
{
    self.naviTitle = @"招聘信息";
    _listArray = [[NSMutableArray alloc] init];
    _jobLeftDataArray = [[NSMutableArray alloc] init];
    _jobRightTabelArray = [[NSMutableArray alloc] init];
    _salaryArray = [[NSMutableArray alloc] init];
    _IssueChooseWellBeingArray = [[NSMutableArray alloc] init];
    _jobidString = @"";
    _priceString = @"";
    _benefitidString = @"";
    _cityString = @"";
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_RecruitmentQueryFiltering parameters:@{@"city":_cityString,@"jobid":_jobidString,@"price":_priceString,@"benefitid":_benefitidString,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }

        [_listArray addObjectsFromArray:[AdvertiseModel mj_objectArrayWithKeyValuesArray:responseObject[@"RecruitmentInformationList"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        if ([(NSArray *)responseObject[@"RecruitmentInformationList"] count] == 0) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
- (void)configUI
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    baseView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:baseView];
    NSArray *titleArr = @[@"城市",@"职位",@"薪资",@"福利"];
    for (int i =0; i<titleArr.count; i++)
    {
        UIView *buttonView  = [[UIView alloc] initWithFrame:CGRectMake(YGScreenWidth/4*i,0,YGScreenWidth/4,40)];
        [baseView addSubview:buttonView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonView.width-20, buttonView.height)];
        label.textColor = colorWithBlack;
        label.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.text = titleArr[i];
        //        label.y = 20-label.height/2;
        label.tag = 555+i;
        label.textAlignment = NSTextAlignmentCenter;
        [buttonView addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(YGScreenWidth/4-20, label.y, 17, 17)];
        imageView.image = [UIImage imageNamed:@"steward_talents_unfold_gray"];
        [imageView sizeToFit];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.tag = 560+i;
        [buttonView addSubview: imageView];
        imageView.centery = label.centery;
        
        
        UIButton *deliverCurriculumButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,YGScreenWidth/4,40)];
        [deliverCurriculumButton addTarget:self action:@selector(deliverCurriculumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        deliverCurriculumButton.tag = 100000+i;
        [buttonView addSubview:deliverCurriculumButton];
    }
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 41, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[AdvertisesForInfoTableViewCell class] forCellReuseIdentifier:@"AdvertisesForInfoTableViewCell"];
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
    AdvertisesForInfoTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"AdvertisesForInfoTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    AdvertiseModel *model = _listArray[indexPath.section];
    model.name = model.job;
    model.price = model.salary;
    model.indexPath = indexPath;
    [cell setModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdvertiseModel *model = _listArray[indexPath.section];
    AdvertisesForInfoDetailViewController *vc = [[AdvertisesForInfoDetailViewController alloc] init];
    vc.recruitmentItemId = model.id;
    vc.pageType = @"delieveradver";
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    AdvertiseModel *model = _listArray[section];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    footerView.backgroundColor = colorWithYGWhite;
    
    UILabel  *money = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , YGScreenWidth-70, 40)];
    money.text = model.company;
    money.textAlignment = NSTextAlignmentLeft;
    money.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    money.textColor = colorWithDeepGray;
    [money sizeToFit];
    money.frame = CGRectMake(10,money.y , money.width, 40);
    [footerView addSubview:money];
    
    UILabel  *identifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(money.x+money.width+10,money.y , 100, 18)];
    identifyLabel.text = @"认证";
    identifyLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    identifyLabel.textColor = colorWithMainColor;
    [identifyLabel sizeToFit];
    identifyLabel.frame = CGRectMake(identifyLabel.x,identifyLabel.y , identifyLabel.width+3, identifyLabel.height+1);
    identifyLabel.textAlignment = NSTextAlignmentCenter;
    identifyLabel.layer.cornerRadius = 3;
    identifyLabel.layer.borderColor = colorWithMainColor.CGColor;
    identifyLabel.layer.borderWidth = 1;
    identifyLabel.clipsToBounds = YES;
    [footerView addSubview:identifyLabel];
    identifyLabel.centery = money.centery;
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (void)deliverCurriculumButtonAction:(UIButton *)btn
{
    if (_popView) {
        [_popView dismiss];

    }
    if (_index+100000 == btn.tag && btn.selected == YES)
    {
        btn.selected = NO;
        return;
    }
    btn.selected = YES;
    _popView = [[AdvertisesForinfoPopView alloc] init];
    _popView.delegate = self;
    UILabel *lable = [self.view viewWithTag:555+btn.tag-100000];
    lable.textColor = colorWithMainColor;
    UIImageView *arrowImageView = [self.view viewWithTag:560+btn.tag-100000];
    arrowImageView.image = [UIImage imageNamed:@"steward_talents_packup_green"];
    
    if (btn.tag == 100000) {
        YGCityPikerView1 *cityPickView = [YGCityPikerView1 showWithHandler:^(NSString *province, NSString *city) {
            UIButton *btn = [self.view viewWithTag:_index +100000];
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
    if (btn.tag == 100001) {
        
        for (AdvertisesForInfoModel *modelLeftArray in _jobLeftDataArray)
        {
            modelLeftArray.isSelect = NO;
        }
        for (NSArray *modelArray in _jobRightTabelArray)
        {
            for (AdvertisesForInfoModel *model in modelArray)
            {
                model.isSelect = NO;
            }
        }
    
        int index = 0;
        int rightIndex = 0;
        //判断id是不是相同，找到之后赋值选中
        if (![_jobidString isEqualToString:@""])
        {
            int i = 0;//左边的列表
            for (NSArray  *modelArray in _jobRightTabelArray)
            {
                int j = 0;//右边某个数组的index
                for (AdvertisesForInfoModel *model in modelArray)
                {
                    if ([model.id isEqualToString:_jobidString])
                    {
                        model.isSelect = YES;
                        AdvertisesForInfoModel *modelLeftArray = _jobLeftDataArray[i];
                        modelLeftArray.isSelect = YES;
                        index = i;
                        rightIndex = j;

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
    if (btn.tag == 100002) {
        
        for (AdvertisesForInfoModel *model in _salaryArray) {
            model.isSelect = NO;
        }
        int i = 0;
        if (![_priceString isEqualToString:@""]) {
            for (AdvertisesForInfoModel *model in _salaryArray) {
                if ([model.id isEqualToString:_priceString]) {
                    model.isSelect = YES;
                    break;
                }
                i++;
            }
        }
        [_popView createPopChooseViewWithDataSorce:_salaryArray andLeftDataArray:nil withType:pageTypeChooseSalary withLeftIndex:i withRightIndex:0];
        
    }
    if (btn.tag == 100003) {
        
        for (AdvertisesForInfoModel *model in _IssueChooseWellBeingArray)
        {
            model.isSelect = NO;
        }
        if (![_benefitidString isEqualToString:@""])
        {
            NSArray *array = [_benefitidString componentsSeparatedByString:@","];
            
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
        [_popView createPopChooseViewWithDataSorce:_IssueChooseWellBeingArray andLeftDataArray:nil withType:pageTypeChooseWellbeing withLeftIndex:0 withRightIndex:0];
        
    }
    
    [self.view addSubview:_popView];
    _index =(int) btn.tag -100000;
    
}



- (void)deliverIntroduceWithModel:(AdvertiseModel *)model
{
    
    [YGNetService YGPOST:REQUEST_FindMyResume parameters:@{@"userid":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if ([responseObject[@"state"] isEqualToString:@"0"]) {
            [YGAlertView showAlertWithTitle:@"您还没有简历，请去创建简历。" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    MyIntroduceViewController *vc = [[MyIntroduceViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }else
        {
            [YGNetService YGPOST:REQUEST_Resumedeliver parameters:@{@"id":model.id,@"userid":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
                [YGAppTool showToastWithText:@"简历投递成功"];
            } failure:^(NSError *error) {
                
            }];
        }
    
    } failure:^(NSError *error) {
        
    }];
    
 

}
- (void)dismissChangeColor
{
    for (int i =0; i<4; i++)
    {
        UILabel *lable = [self.view viewWithTag:555+i];
        lable.textColor = colorWithBlack;
        UIImageView *arrowImageView = [self.view viewWithTag:560+i];
        arrowImageView.image = [UIImage imageNamed:@"steward_talents_unfold_gray"];
    }
    
}
//筛选关键字
- (void)siftDataWithKeyModel:(AdvertisesForInfoModel *)model
{
    UIButton *btn = [self.view viewWithTag:_index +100000];
    btn.selected = NO;
    
    if (_index == 1) {
        UILabel *lable = [self.view viewWithTag:555+_index];
        lable.text = model.name;
        _jobidString = model.id;
        
    }
    if (_index == 2) {
        UILabel *lable = [self.view viewWithTag:555+_index];
        lable.text = model.name;
        _priceString = model.id;
        
    }
    if (_index == 3) {
        UILabel *lable = [self.view viewWithTag:555+_index];
        lable.text = model.name;
        _benefitidString = model.id;
        
    }
    [self refreshActionWithIsRefreshHeaderAction:YES];
    
}


- (void)getData
{
    [YGNetService showLoadingViewWithSuperView:self.view];
    
    [self startPostWithURLString:REQUEST_FindJobList parameters:@{} showLoadingView:NO scrollView:nil];
    [self startPostWithURLString:REQUEST_FindSalaryList parameters:@{} showLoadingView:NO scrollView:nil];
    [self startPostWithURLString:REQUEST_FindBenefitsList parameters:@{} showLoadingView:NO scrollView:nil];
    
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
    
    if ([URLString isEqualToString:REQUEST_FindBenefitsList]) {
        
        _IssueChooseWellBeingArray =  [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"BenefitsList"]];
        
    }

    if (_jobLeftDataArray.count != 0 && _salaryArray.count != 0 && _IssueChooseWellBeingArray.count != 0 ) {
        [YGNetService dissmissLoadingView];
        [self configUI];
        
    }
}
@end
