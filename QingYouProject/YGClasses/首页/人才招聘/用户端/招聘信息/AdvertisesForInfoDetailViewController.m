//
//  AdvertisesForInfoDetailViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AdvertisesForInfoDetailViewController.h"
#import "YGSpreadView.h"
#import "MyAdvertisesViewController.h"
#import "AdvertisesForEnterpriseViewController.h"
#import "AdvertisesForInfoModel.h"
#import "AdvertisesForInfoDetailModel.h"

@interface AdvertisesForInfoDetailViewController ()<YGSpreadViewDelegate>

@end

@implementation AdvertisesForInfoDetailViewController
{
    UIScrollView *_scrollView;
    UILabel *_jobTitleLabel;
    UILabel  *_moneyLabel;
    UITextView  *_companyTextView;
    UILabel  *_identifyLabel;
    
    UILabel  *_addressLabel;
    
    UIView *_jobIntroduceMiddleView;
    //    YGSpreadView *_addressSpreadView;
    //    YGSpreadView *_jobIntroduceSpreadView;
    
    UIView *_bottomView;
    UILabel  *_contanctLabel;
    UILabel  *_phoneLabel;
    BOOL   _addressDown;
    BOOL   _jobIntroduceDown;
    AdvertisesForInfoDetailModel *_detailModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)configAttribute
{
    self.naviTitle = @"招聘详情";
    _detailModel = [[AdvertisesForInfoDetailModel alloc] init];
    if (_listArray)
    {
        _detailModel.name = ((AdvertisesForInfoModel *)_listArray[0]).content;
        _detailModel.job = ((AdvertisesForInfoModel *)_listArray[1]).content;
        _detailModel.number = ((AdvertisesForInfoModel *)_listArray[2]).content;
        _detailModel.salary = ((AdvertisesForInfoModel *)_listArray[3]).content;
        _detailModel.educational = ((AdvertisesForInfoModel *)_listArray[4]).content;
        _detailModel.experience = ((AdvertisesForInfoModel *)_listArray[5]).content;
        _detailModel.address = ((AdvertisesForInfoModel *)_listArray[6]).content;
        _detailModel.benefits = ((AdvertisesForInfoModel *)_listArray[7]).content;
        _detailModel.contact = ((AdvertisesForInfoModel *)_listArray[8]).content;
        _detailModel.contacts = ((AdvertisesForInfoModel *)_listArray[9]).content;
        _detailModel.description = ((AdvertisesForInfoModel *)_listArray[10]).content;
        
        [self configUI];
    }else
    {
        [self loadData];
    }
    
    
}
- (void)back
{
//    if ([self.pageType isEqualToString:@"enterprise"]) {
//
//        [self.navigationController popViewControllerAnimated:YES];
//
//    }else
//    {
        [self.navigationController popViewControllerAnimated:YES];
//    }
    
}

- (void)loadData
{
    [self startPostWithURLString:REQUEST_RecruitmentDetails parameters:@{@"id":self.recruitmentItemId} showLoadingView:NO scrollView:nil];
}

-(void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    if ([URLString isEqualToString:REQUEST_PostJob])
    {
        [YGAppTool showToastWithText:@"发布成功"];
        MyAdvertisesViewController *vc = [[MyAdvertisesViewController alloc] init];
        vc.pageType = @"issueAdvertisement";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([URLString isEqualToString:REQUEST_RecruitmentDetails])
    {
        [_detailModel setValuesForKeysWithDictionary:responseObject[@"RecruitmentInformation"]];
        [self configUI];
    }
}

- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{
    
}

- (void)configUI
{
    
    _scrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64-45-YGBottomMargin)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _scrollView.height);
    _scrollView.backgroundColor = colorWithTable;
    [self.view addSubview:_scrollView];
    
    if ([self.pageType isEqualToString:@"enterprise"]) {
        UIBarButtonItem *item = [self createBarbuttonWithNormalTitleString:@"发布" selectedTitleString:@"发布" selector:@selector(submit)];
        self.navigationItem.rightBarButtonItem = item;
        _scrollView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64);
    }else if ([self.pageType isEqualToString:@"delieveradver"])
    {
        UIButton *surePayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, YGScreenHeight - YGBottomMargin - YGNaviBarHeight - YGStatusBarHeight - 45, YGScreenWidth, 45 + YGBottomMargin)];
        [surePayButton setTitle:@"投递简历" forState:UIControlStateNormal];
        surePayButton.backgroundColor = colorWithMainColor;
        surePayButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        surePayButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
        [surePayButton addTarget:self action:@selector(deliverIntroduceButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:surePayButton];
    }
    
    //顶部到工作地点
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 200)];
    topView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:topView];
    
    _companyTextView = [[UITextView alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 30)];
    _companyTextView.text = _detailModel.name;
    _companyTextView.textAlignment = NSTextAlignmentLeft;
    _companyTextView.font = [UIFont systemFontOfSize:YGFontSizeBigThree];
    _companyTextView.textColor = colorWithBlack;
    [_companyTextView sizeToFit];
    _companyTextView.selectedRange = NSMakeRange(_companyTextView.text.length-2, 2);
    _companyTextView.frame = CGRectMake(10,_companyTextView.y , _companyTextView.width, _companyTextView.height+10);
    [topView addSubview:_companyTextView];
    NSArray *rects = [_companyTextView selectionRectsForRange:_companyTextView.selectedTextRange];


//        _identifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(_companyTextView.x+_companyTextView.width+10,_companyTextView.y , 100, 20)];
        _identifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(_companyTextView.x+_companyTextView.width+20,_companyTextView.y , 100, 20)];
        _identifyLabel.text = @"认证";
        _identifyLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _identifyLabel.textColor = colorWithMainColor;
        [_identifyLabel sizeToFit];
        _identifyLabel.frame = CGRectMake(_identifyLabel.x,_identifyLabel.y+4 , _identifyLabel.width+3, _identifyLabel.height+1);
        _identifyLabel.layer.cornerRadius = 3;
        _identifyLabel.layer.borderColor = colorWithMainColor.CGColor;
        _identifyLabel.layer.borderWidth = 1;
        _identifyLabel.clipsToBounds = YES;
        [topView addSubview:_identifyLabel];
//        _identifyLabel.centery = _companyTextView.centery;

    if (_companyTextView.height <=20) {
        _identifyLabel.frame = CGRectMake(_companyTextView.x+_companyTextView.width+35,10+_identifyLabel.y+4 , _identifyLabel.width+3, _identifyLabel.height+1);

    }else
    {
        UITextSelectionRect *textRect = [rects lastObject];
        CGRect frame = textRect.rect;
        _identifyLabel.frame = frame;
        [_identifyLabel sizeToFit];
        _identifyLabel.frame = CGRectMake(_identifyLabel.x+15,10+_identifyLabel.y+4 , _identifyLabel.width+3, _identifyLabel.height+1);
    }
    _identifyLabel.textAlignment = NSTextAlignmentCenter;

    _jobTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _companyTextView.y+_companyTextView.height+10, YGScreenWidth-20, 20)];
    _jobTitleLabel.text = _detailModel.job;
    _jobTitleLabel.textAlignment = NSTextAlignmentLeft;
    _jobTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _jobTitleLabel.textColor = colorWithBlack;
    [topView addSubview:_jobTitleLabel];
    
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,_jobTitleLabel.y+_jobTitleLabel.height+7 , YGScreenWidth-20, 20)];
    _moneyLabel.text = [NSString stringWithFormat:@"%@/月", _detailModel.salary];
    if ([_detailModel.salary isEqualToString:@"面议"] || [_detailModel.salary isEqualToString:@"不限"]) {
        _moneyLabel.text = _detailModel.salary;
        _moneyLabel.textColor = colorWithOrangeColor;
        
    }
    _moneyLabel.textAlignment = NSTextAlignmentLeft;
    _moneyLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _moneyLabel.textColor = colorWithOrangeColor;
    [_moneyLabel sizeToFit];
    _moneyLabel.frame = CGRectMake(10,_moneyLabel.y , _moneyLabel.width, 20);
    [topView addSubview:_moneyLabel];
    
    NSArray *list  = (NSMutableArray *)@[@"招聘人数", @"学历要求",@"工作年限"];
    NSArray *listContentArray  = @[_detailModel.number, _detailModel.educational,_detailModel.experience];

    for (int i = 0; i<3; i++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0,_moneyLabel.y+_moneyLabel.height+7+(25*i), YGScreenWidth, 25)];
        baseView.backgroundColor = colorWithYGWhite;
        [topView addSubview:baseView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 75, 25)];
        nameLabel.text = list[i];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        nameLabel.textColor = colorWithDeepGray;
        [baseView addSubview:nameLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width+10, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-20, nameLabel.height)];
        textField.tag = 100+i;
        textField.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        textField.textColor = colorWithBlack;
        [baseView addSubview:textField];
        textField.text = listContentArray[i];
        [textField setEnabled:NO];
    }
    
    topView.frame = CGRectMake(0, 0, YGScreenWidth, _moneyLabel.y+_moneyLabel.height+10+25*3+10);
    //工作地点开始到岗位描述
    UIView *addressMiddleView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.y+topView.height, YGScreenWidth,70+30*3+10)];
    addressMiddleView.backgroundColor = colorWithYGWhite;
    
    UIView *addressTopLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
    addressTopLineView.backgroundColor = colorWithLine;
    [addressMiddleView addSubview:addressTopLineView];
    
    UILabel *addressTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , 75, 20)];
    addressTitleLabel.text = @"工作地点";
    addressTitleLabel.textAlignment = NSTextAlignmentLeft;
    addressTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    addressTitleLabel.textColor = colorWithDeepGray;
    [addressMiddleView addSubview:addressTitleLabel];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressTitleLabel.x+addressTitleLabel.width+10,addressTitleLabel.y , YGScreenWidth-addressTitleLabel.x-addressTitleLabel.width-10, 20)];
    _addressLabel.text = _detailModel.address;
    _addressLabel.textAlignment = NSTextAlignmentLeft;
    _addressLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _addressLabel.textColor = colorWithBlack;
    _addressLabel.numberOfLines = 0;
    [_addressLabel sizeToFit];
    _addressLabel.frame = CGRectMake(_addressLabel.x, _addressLabel.y, _addressLabel.width, 5+_addressLabel.height);
    [addressMiddleView addSubview:_addressLabel];
    
    UIView *addressLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _addressLabel.y+_addressLabel.height+5, YGScreenWidth, 1)];
    addressLineView.backgroundColor = colorWithLine;
    [addressMiddleView addSubview:addressLineView];

    UILabel *wellbeingTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,addressLineView.y+addressLineView.height+10 , 70, 20)];
    wellbeingTitleLabel.text = @"公司福利";
    wellbeingTitleLabel.textAlignment = NSTextAlignmentLeft;
    wellbeingTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    wellbeingTitleLabel.textColor = colorWithDeepGray;
    [addressMiddleView addSubview:wellbeingTitleLabel];
    
    
    NSArray *array = [NSArray arrayWithArray:[_detailModel.benefits componentsSeparatedByString:@","]];
    int k = 0;
    for (int i = 0; i<array.count; i++) {
        int x = i%3;
        int y = i/3;
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(10+(YGScreenWidth-20)/3*x,wellbeingTitleLabel.y+wellbeingTitleLabel.height+5+(30*y), (YGScreenWidth-20)/3, 30)];
        baseView.backgroundColor = colorWithYGWhite;
        [addressMiddleView addSubview:baseView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , baseView.width, 30)];
        nameLabel.text = array[i];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        nameLabel.textColor = colorWithBlack;
        [baseView addSubview:nameLabel];
        k = y;
    }
    
    //    _addressSpreadView = [[YGSpreadView alloc] initWithOrigin:CGPointMake(0, topView.y+topView.height+1) inView:addressMiddleView startHeight:90];
    //    _addressSpreadView.delegate = self;
    addressMiddleView.frame = CGRectMake(0, topView.y+topView.height, YGScreenWidth, wellbeingTitleLabel.y+wellbeingTitleLabel.height+5+30*(k+1)+10);
    [_scrollView addSubview:addressMiddleView];
    
    
    //岗位描述开始到联系人
    _jobIntroduceMiddleView = [[UIView alloc] initWithFrame:CGRectMake(0, addressMiddleView.y+addressMiddleView.height+10, YGScreenWidth, 180+30*3)];
    _jobIntroduceMiddleView.backgroundColor = colorWithYGWhite;
    
    UILabel *jobIntroduceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , 70, 20)];
    jobIntroduceTitleLabel.text = @"岗位描述";
    jobIntroduceTitleLabel.textAlignment = NSTextAlignmentLeft;
    jobIntroduceTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    jobIntroduceTitleLabel.textColor = colorWithDeepGray;
    [_jobIntroduceMiddleView addSubview:jobIntroduceTitleLabel];
    
    //    UILabel *jobDutyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,jobIntroduceTitleLabel.y+ jobIntroduceTitleLabel.height , 70, 20)];
    //    jobDutyTitleLabel.text = @"岗位职责";
    //    jobDutyTitleLabel.textAlignment = NSTextAlignmentLeft;
    //    jobDutyTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    //    jobDutyTitleLabel.textColor = colorWithDeepGray;
    //    [_jobIntroduceMiddleView addSubview:jobDutyTitleLabel];
    
    //    NSArray *dutyArray  = (NSMutableArray *)@[@"所在园区所在园区所在园区所在园区所在园区所在园区所在园区所在园区", @"房屋编号所在园区所在园区所在园区",@"付款方式所在园区所在园区所在园区所在园区所在园区",@"租金单价所在园区所在园区",@"物业费所在园区所在园区",@"租金涨幅所在园区所在园区"];
    //    CGFloat heightCount = 0.0;
    //    for (NSString *dutyStr in dutyArray) {
    UILabel *dutyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,jobIntroduceTitleLabel.y+jobIntroduceTitleLabel.height+10, YGScreenWidth-20, 20)];
    dutyLabel.text = _detailModel.description;
    dutyLabel.textAlignment = NSTextAlignmentLeft;
    dutyLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    dutyLabel.textColor = colorWithBlack;
    dutyLabel.numberOfLines = 0;
    [dutyLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-20];
    dutyLabel.frame = CGRectMake(dutyLabel.x, dutyLabel.y, dutyLabel.width, dutyLabel.height);
    //        heightCount = heightCount+dutyLabel.height+10;
    [_jobIntroduceMiddleView addSubview:dutyLabel];
    //    }
    
    //    UILabel *qualificationsForAJobTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,jobDutyTitleLabel.y+jobDutyTitleLabel.height+heightCount+10 , 70, 20)];
    //    qualificationsForAJobTitleLabel.text = @"任职资格";
    //    qualificationsForAJobTitleLabel.textAlignment = NSTextAlignmentLeft;
    //    qualificationsForAJobTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    //    qualificationsForAJobTitleLabel.textColor = colorWithDeepGray;
    //    [_jobIntroduceMiddleView addSubview:qualificationsForAJobTitleLabel];
    
    
    //    NSArray *qualificationsForAJobArray  = (NSMutableArray *)@[@"所在园区所在园区所在园区所在园区所在园区所在园区所在园区所在园区", @"房屋编号所在园区所在园区所在园区",@"付款方式所在园区所在园区所在园区所在园区所在园区",@"租金单价所在园区所在园区",@"物业费所在园区所在园区",@"租金涨幅所在园区所在园区"];
    //    CGFloat qualificationsForAJobHeightCount = 0.0;
    //    for (NSString *dutyStr in qualificationsForAJobArray) {
    //        UILabel *dutyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,qualificationsForAJobTitleLabel.y+qualificationsForAJobTitleLabel.height+qualificationsForAJobHeightCount+10, YGScreenWidth-20, 20)];
    //        dutyLabel.text = dutyStr;
    //        dutyLabel.textAlignment = NSTextAlignmentLeft;
    //        dutyLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    //        dutyLabel.textColor = colorWithBlack;
    //        dutyLabel.numberOfLines = 0;
    //        [dutyLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-20];
    //        dutyLabel.frame = CGRectMake(dutyLabel.x, dutyLabel.y, dutyLabel.width, dutyLabel.height);
    //        qualificationsForAJobHeightCount = qualificationsForAJobHeightCount+dutyLabel.height+10;
    //        [_jobIntroduceMiddleView addSubview:dutyLabel];
    //    }
    _jobIntroduceMiddleView.frame = CGRectMake(_jobIntroduceMiddleView.x, _jobIntroduceMiddleView.y, _jobIntroduceMiddleView.width, dutyLabel.y+dutyLabel.height+10);
    
    //    _jobIntroduceSpreadView = [[YGSpreadView alloc] initWithOrigin:CGPointMake(0, _addressSpreadView.y+_addressSpreadView.height+10) inView:_jobIntroduceMiddleView startHeight:qualificationsForAJobTitleLabel.y+qualificationsForAJobTitleLabel.height];
    //    _jobIntroduceSpreadView.delegate = self;
    [_scrollView addSubview:_jobIntroduceMiddleView];
    
    
    //联系人
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _jobIntroduceMiddleView.y+_jobIntroduceMiddleView.height+10, YGScreenWidth, 60)];
    _bottomView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:_bottomView];
    
    NSArray *listBottomArray  = (NSMutableArray *)@[@"联系人", @"联系电话"];
    NSArray *listBottomContentArray  = (NSMutableArray *)@[_detailModel.contacts,_detailModel.contact];
    
    for (int i = 0; i<listBottomArray.count; i++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0,30*i, YGScreenWidth, 30)];
        baseView.backgroundColor = colorWithYGWhite;
        [_bottomView addSubview:baseView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 75, 30)];
        nameLabel.text = listBottomArray[i];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        nameLabel.textColor = colorWithDeepGray;
        [baseView addSubview:nameLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width+20, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-20, nameLabel.height)];
        textField.tag = 100+i;
        textField.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        textField.textColor = colorWithBlack;
        [baseView addSubview:textField];
        textField.text = listBottomContentArray[i];
        [textField setEnabled:NO];
    }
    
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _bottomView.y+_bottomView.height+20);
}
//- (void)YGSpreadView:(YGSpreadView *)spreadView willChangeHeight:(float)height down:(BOOL)down
//{
//
//    if (spreadView == _addressSpreadView) {
//
//        _jobIntroduceSpreadView.y = _jobIntroduceSpreadView.y+height;
//        _bottomView.y = _bottomView.y;
//
//    }
//    if (spreadView == _jobIntroduceSpreadView) {
//
//        _bottomView.y = _bottomView.y+height;
//    }
//
//    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _bottomView.y+_bottomView.height+20);
//
//}

- (void)deliverIntroduceButtonClick
{
    [YGNetService YGPOST:REQUEST_Resumedeliver parameters:@{@"id":_detailModel.id,@"userid":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        [YGAppTool showToastWithText:@"简历投递成功"];
    } failure:^(NSError *error) {
        
    }];
}


- (void)submit
{
    
    NSDictionary *dict = @{
                           @"name":((AdvertisesForInfoModel *)_listArray[0]).content,
                           @"jobId":((AdvertisesForInfoModel *)_listArray[1]).id,
                           @"number":((AdvertisesForInfoModel *)_listArray[2]).content,
                           @"salaryId":((AdvertisesForInfoModel *)_listArray[3]).id,
                           @"educationalId":((AdvertisesForInfoModel *)_listArray[4]).id,
                           @"experienceId":((AdvertisesForInfoModel *)_listArray[5]).id,
                           @"adress":((AdvertisesForInfoModel *)_listArray[6]).content,
                           @"benefitsId":_benefitsId,
                           @"contacts":((AdvertisesForInfoModel *)_listArray[8]).content,
                           @"contact":((AdvertisesForInfoModel *)_listArray[9]).content,
                           @"description":((AdvertisesForInfoModel *)_listArray[10]).content,
                           @"phone":YGSingletonMarco.user.phone};
    [self startPostWithURLString:REQUEST_PostJob parameters:dict showLoadingView:YES scrollView:nil];
    
}

@end
