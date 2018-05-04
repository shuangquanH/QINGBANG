//
//  BillsDetailViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "BillsDetailViewController.h"
#import "BillDetailModel.h"
#import "BillDetailTableViewCell.h"
#import "PayImmediatelyViewController.h"

@interface BillsDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation BillsDetailViewController

{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    NSMutableArray *_dataArray;
//    NSMutableArray *_headerTitleArray;
    NSMutableArray *_dataSource;
    UIView *_middleView;
    UIView *_bottomView;
    UIButton *_applyButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)loadData
{
    if ([self.pageType isEqualToString:@"waitToPay"]) {
        [self startPostWithURLString:REQUEST_HouserPayDetails parameters:@{@"phone":YGSingletonMarco.user.myContractPhoneNumber} showLoadingView:YES scrollView:nil];

    }else
    {
        [self startPostWithURLString:REQUEST_breachOfContract parameters:@{@"phone":YGSingletonMarco.user.myContractPhoneNumber} showLoadingView:YES scrollView:nil];

    }
}

-(void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{

    [_dataArray addObjectsFromArray:[BillDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"OderList"]]];
    for (BillDetailModel *model in _dataArray) {
        model.isExpand = @"0";
    }
    
    [_tableView reloadData];
    NSDictionary *rootDict = responseObject[@"housingContract"];
    NSMutableArray *topArray = (NSMutableArray *)@[@"park",@"number",@"payment",@"price",@"propertyfee",@"rentincreases",@"proportion",@"leasetime"];
    NSMutableArray *bottomArray = (NSMutableArray *) @[@"contacts",@"phone",@"company"];
    NSMutableArray *arrayTop = [[NSMutableArray alloc] init];
    
    NSArray *uinitArray = @[@"",@"",@"",@"元/㎡/月",@"元/㎡/月",@"%",@"㎡",@""];
    int  i = 0;
    for (NSString *str in topArray) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[NSString stringWithFormat:@"%@%@",rootDict[str],uinitArray[i]] forKey:@"title"];
        [arrayTop addObject:dict];
        i++;
    }
    NSMutableArray *arrayBottom = [[NSMutableArray alloc] init];
    for (NSString *str in bottomArray) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:rootDict[str] forKey:@"title"];
        [arrayBottom addObject:dict];
    }
    [_dataSource addObject:arrayTop];
    [_dataSource addObject:arrayBottom];
 
    
    for (int i = 0; i<8; i++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0,10+(30*i), YGScreenWidth, 30)];
        baseView.backgroundColor = colorWithYGWhite;
        [_middleView addSubview:baseView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 75, 30)];
        nameLabel.text = _listArray[0][i];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        nameLabel.textColor = colorWithDeepGray;
        [baseView addSubview:nameLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width+20, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-20, nameLabel.height)];
        textField.tag = 100+i;
        textField.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        textField.textColor = colorWithBlack;
        [baseView addSubview:textField];
        textField.text = _dataSource[0][i][@"title"];
        [textField setEnabled:NO];
    }
    
    for (int i = 0; i<3; i++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0,10+30*i, YGScreenWidth, 30)];
        baseView.backgroundColor = colorWithYGWhite;
        [_bottomView addSubview:baseView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 75, 30)];
        nameLabel.text = _listArray[1][i];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        nameLabel.textColor = colorWithDeepGray;
        [baseView addSubview:nameLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width+20, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-20, nameLabel.height)];
        textField.tag = 100+i;
        textField.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        textField.textColor = colorWithBlack;
        [baseView addSubview:textField];
        textField.text = _dataSource[1][i][@"title"];
        [textField setEnabled:NO];
        
    }
}

- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{
    
}
- (void)configAttribute
{
    _dataSource = [[NSMutableArray alloc] init];
    _dataArray = [[NSMutableArray alloc] init];

    
}
- (void)configUI
{
    self.naviTitle = @"账单详情";
    _listArray  = (NSMutableArray *)@[@[@"所在园区", @"房屋编号",@"付款方式",@"租金单价",@"物业费",@"租金涨幅",@"租赁面积",@"合同租期"],@[@"联系人",@"联系电话",@"公司名称"]];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    headerView.backgroundColor = colorWithTable;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    view.backgroundColor = colorWithYGWhite;
    [headerView addSubview:view];
    
    //最新账单
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    titleLabel.text = @"合同信息";
    titleLabel.frame = CGRectMake(10, 10,YGScreenWidth-20, 20);
    [view addSubview:titleLabel];
    
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, view.y+view.height+1, YGScreenWidth, 30*8+20)];
    _middleView.backgroundColor = colorWithYGWhite;
    [headerView addSubview:_middleView];
    
 
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,_middleView.y+_middleView.height+1, YGScreenWidth, 30*3+20)];
    _bottomView.backgroundColor = colorWithYGWhite;
    [headerView addSubview:_bottomView];
    
 
    
    UIView *bottomHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,_bottomView.y+_bottomView.height+10, YGScreenWidth, 40)];
    bottomHeaderView.backgroundColor = colorWithYGWhite;
    [headerView addSubview:bottomHeaderView];
    
    //房租账单明细
    UILabel * titleHeaderLabel = [[UILabel alloc]init];
    titleHeaderLabel.textColor = colorWithBlack;
    titleHeaderLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    titleHeaderLabel.text = @"房租账单明细";
    titleHeaderLabel.frame = CGRectMake(10, 10,YGScreenWidth-20, 20);
    [bottomHeaderView addSubview:titleHeaderLabel];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0,39, YGScreenWidth, 0.7)];
    bottomLineView.backgroundColor = colorWithLine;
    [bottomHeaderView addSubview:bottomLineView];
    
    headerView.frame = CGRectMake(0, 0, YGScreenWidth, bottomHeaderView.height+bottomHeaderView.y);

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = headerView;
    [_tableView registerClass:[BillDetailTableViewCell class] forCellReuseIdentifier:@"BillDetailTableViewCell"];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    if ([self.pageType isEqualToString:@"waitToPay"]) {
        _applyButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
        _applyButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
        [_applyButton addTarget:self action:@selector(payImmediately) forControlEvents:UIControlEventTouchUpInside];
        _applyButton.backgroundColor = colorWithMainColor;
        _applyButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [self.view addSubview:_applyButton];
        [_applyButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
        [_applyButton setTitle:@"立即缴费" forState:UIControlStateNormal];
        
        _tableView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-45-YGBottomMargin-YGNaviBarHeight-YGStatusBarHeight   );

    }
   

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //判断该行收起的话就给行数为0 否则给该有的行数
    BillDetailModel *model = _dataArray[section];

    if([model.isExpand isEqualToString:@"1"]){
        return 1;
    }
    return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillDetailTableViewCell" forIndexPath:indexPath];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BillDetailModel *model = _dataArray[indexPath.section];
    [cell setModel:model withType:self.pageType];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BillDetailModel *model = _dataArray[section];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    view.backgroundColor = colorWithYGWhite;
    
    //房租账单明细
    UILabel * titleHeaderLabel = [[UILabel alloc]init];
    titleHeaderLabel.textColor = colorWithDeepGray;
    titleHeaderLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
//    titleHeaderLabel.text = [NSString stringWithFormat:@"第%@期账单",model.name];
    titleHeaderLabel.text = [NSString stringWithFormat:@"%@",model.name];
    titleHeaderLabel.frame = CGRectMake(10, 10,YGScreenWidth/2-20, 20);
    [view addSubview:titleHeaderLabel];
    
    //流水号
    UILabel * serialNumberLabel = [[UILabel alloc]init];
    serialNumberLabel.textColor = colorWithPlaceholder;
    serialNumberLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    serialNumberLabel.text = [NSString stringWithFormat:@"%@-%@",model.startTime,model.endTime];
    serialNumberLabel.textAlignment = NSTextAlignmentRight;
    serialNumberLabel.frame = CGRectMake(titleHeaderLabel.x+titleHeaderLabel.width, 10,YGScreenWidth-titleHeaderLabel.x-titleHeaderLabel.width-40, 20);
    [view addSubview:serialNumberLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YGScreenWidth-30, 15, 20, 20)];
    arrowImageView.image = [UIImage imageNamed:@"steward_paytherent_packup"];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    arrowImageView.clipsToBounds = YES;
    [arrowImageView sizeToFit];
    [view addSubview:arrowImageView];
    
    
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    coverButton.frame = CGRectMake(0, 0, view.width, view.height);
    coverButton.tag = 1000+section*100;
    [coverButton addTarget:self action:@selector(extendSectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:coverButton];
    
    if ([model.isExpand isEqualToString:@"0"]) {
        //图片旋转
        [UIView animateWithDuration:0.3 animations:^{
            arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);//旋转180度
        }];
    }else
    {
        arrowImageView.transform = CGAffineTransformMakeRotation(0);//旋转0度
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

#pragma 点击事件
- (void)extendSectionAction:(UIButton *)btn
{
    NSInteger index = (btn.tag-1000)/100;
    BillDetailModel *model = _dataArray[index];

    if ([model.isExpand isEqualToString:@"0"])
    {
        model.isExpand = @"1";

    }else
    {
        model.isExpand = @"0";
    }
    [_tableView reloadData];
}

- (void)payImmediately
{
    PayImmediatelyViewController *vc = [[PayImmediatelyViewController alloc] init];
    vc.type = [self.pageType isEqualToString:@"waitToPay"]?@"1":self.pageType;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
