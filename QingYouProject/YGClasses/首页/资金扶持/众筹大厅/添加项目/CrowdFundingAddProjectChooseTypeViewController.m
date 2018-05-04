//
//  CrowdFundingAddProjectChooseTypeViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CrowdFundingAddProjectChooseTypeViewController.h"

@interface CrowdFundingAddProjectChooseTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CrowdFundingAddProjectChooseTypeViewController
{
    UITableView *_tableView;
    NSMutableArray *_typeArr;
    NSString *_requestUrl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)configAttribute
{
    self.naviTitle = @"选择类型";
    _requestUrl = REQUEST_getProType;
    if ([self.pageFromController isEqualToString:@"RoadShowHallApplyViewController"]) {
        self.naviTitle = @"选择行业领域";
        _requestUrl = REQUEST_getTrade;

    }
    _typeArr = [[NSMutableArray alloc] init];
}
- (void)loadData
{
    [self startPostWithURLString:_requestUrl parameters:@{} showLoadingView:NO scrollView:nil];
}
- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    if ([_requestUrl isEqualToString:REQUEST_getProType]) {
        _typeArr = [CrowdFundingAddProjectChooseTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"plist"]];
    }else
    {
        _typeArr = [CrowdFundingAddProjectChooseTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"tradeList"]];

    }
    [_tableView reloadData];
}
- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{
   
}
- (void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = colorWithLine;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _typeArr.count;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = colorWithDeepGray;
    cell.textLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    CrowdFundingAddProjectChooseTypeModel *model =_typeArr[indexPath.row];
    cell.textLabel.text = [_requestUrl isEqualToString:REQUEST_getProType]?model.type:model.tradeName;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CrowdFundingAddProjectChooseTypeModel *model =_typeArr[indexPath.row];
    [self.delegate takeTypeValueBackWithModel:model];
    [self back];
}

@end
