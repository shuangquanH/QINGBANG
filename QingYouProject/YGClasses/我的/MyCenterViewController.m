//
//  MyCenterViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/7.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyCenterViewController.h"
#import "MyCenterCell.h"
#import "MyHeaderView.h"
#import "TakePicturesStatusController.h"
#import "MyManagerListController.h"
#import "MyFundSupportViewController.h"
#import "SetupViewController.h"
#import "LoginViewController.h"
#import "MyCollectionListController.h"
#import "PersonalInformationViewController.h"
#import "MyRecruitViewController.h"
#import "MyIntegrationIndustryCommerceController.h"
#import "MyFinancialAccountViewController.h"
#import "RushPurchaseOrderListViewController.h"
#import "OrderManagerController.h"
#import "MineIntergralViewController.h"
#import "MyPushInformationController.h"

@interface MyCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *menuArray;
@property(nonatomic,strong)MyHeaderView *myHeaderView;

@end

@implementation MyCenterViewController

-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (YGSingletonMarco.user.userId.length) {
        self.myHeaderView.nameLabel.text = YGSingletonMarco.user.userName;
        self.myHeaderView.instructionLabel.text = YGSingletonMarco.user.description;
        [self.myHeaderView.headImageView sd_setImageWithURL:[NSURL URLWithString:YGSingletonMarco.user.userImg] placeholderImage:YGDefaultImgAvatar];
        if (!YGSingletonMarco.user.point) {
            self.myHeaderView.pointsLabel.text = @"0";
        }
        if (!YGSingletonMarco.user.description.length) {
            self.myHeaderView.instructionLabel.text = @"暂无简介...";
        }
    }else
    {
        self.myHeaderView.nameLabel.text = @"未登录";
        self.myHeaderView.pointsLabel.text = @"0";
        self.myHeaderView.instructionLabel.text = @"暂无简介...";
        self.myHeaderView.headImageView.image = YGDefaultImgAvatar;
        
    }
    if (YGSingletonMarco.user.userId.length)
    {
         [self loadPointsData];
    }
}
-(void)loadPointsData
{
    [YGNetService YGPOST:@"UserIntegral" parameters:@{@"userId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        YGSingletonMarco.user.point = [NSString stringWithFormat:@"%@",responseObject[@"point"]] ;
        NSLog(@"%@",responseObject);
        if (![self.myHeaderView.pointsLabel.text isEqualToString:[NSString stringWithFormat:@"%@",responseObject[@"point"]]]) {
            self.myHeaderView.pointsLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"point"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.naviTitle = @"我的";
    
    //标题居中
    UILabel *naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth - 120, 20)];
    naviTitleLabel.textColor = colorWithBlack;
    naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    naviTitleLabel.text = @"我的" ;
    [naviTitleLabel sizeToFit];
    naviTitleLabel.frame = CGRectMake(YGScreenWidth/2-naviTitleLabel.width/2, 0, naviTitleLabel.width, 20);
    self.navigationItem.titleView = naviTitleLabel;
    
    UIButton *contactButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [contactButton setImage:[UIImage imageNamed:@"service_black"] forState:UIControlStateNormal];
    [contactButton addTarget:self action:@selector(contact:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:contactButton];
    
    UIButton *informationButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [informationButton setImage:[UIImage imageNamed:@"mine_message"] forState:UIControlStateNormal];
    [informationButton addTarget:self action:@selector(information:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:informationButton];
    self.navigationItem.rightBarButtonItems = @[rightBtnItem,leftBtnItem];
    
    self.menuArray = [NSArray array];
    NSString *path=[[NSBundle mainBundle]pathForResource:@"Mine" ofType:@"plist"];
    NSArray *arrayDict=[NSArray arrayWithContentsOfFile:path];
    _menuArray = arrayDict;

    [self configUI];
}
-(void)configUI
{
    self.tableView.backgroundColor = colorWithTable;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    self.tableView.sectionHeaderHeight = 0.001;
    self.tableView.sectionFooterHeight = 0.001;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.myHeaderView = [[[NSBundle mainBundle]loadNibNamed:@"MyHeaderView" owner:self options:nil] firstObject];
    self.myHeaderView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.29);
    self.myHeaderView.headImageView.clipsToBounds = YES;
    self.myHeaderView.headImageView.layer.cornerRadius = 30;
    self.tableView.tableHeaderView = self.myHeaderView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewTap)];
    [self.myHeaderView addGestureRecognizer:tap];
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCenterCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyCenterCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        cell.leftLabel.text = [self.menuArray[0] valueForKey:@"name"];
        cell.centerLabel.text = [self.menuArray[1] valueForKey:@"name"];
        cell.rightLabel.text = [self.menuArray[2] valueForKey:@"name"];
        cell.leftImageView.image = [UIImage imageNamed:[self.menuArray[0] valueForKey:@"image"]];
        cell.centerImageView.image = [UIImage imageNamed:[self.menuArray[1] valueForKey:@"image"]];
        cell.rightImageVIew.image = [UIImage imageNamed:[self.menuArray[2] valueForKey:@"image"]];
    }
    else if(indexPath.section == 1 && indexPath.row == 2)
    {
        cell.leftLabel.text = [self.menuArray[9] valueForKey:@"name"];
        cell.leftImageView.image = [UIImage imageNamed:[self.menuArray[9] valueForKey:@"image"]];
        cell.centerLabel.text = [self.menuArray[10] valueForKey:@"name"];
        cell.centerImageView.image = [UIImage imageNamed:[self.menuArray[10] valueForKey:@"image"]];
        cell.rightButton.hidden = YES;
        cell.rightImageVIew.hidden = YES;
        cell.rightLabel.hidden = YES;
    }
    else
    {
        cell.leftLabel.text = [self.menuArray[indexPath.row * 3 + 3] valueForKey:@"name"];
        cell.centerLabel.text = [self.menuArray[indexPath.row * 3 + 4] valueForKey:@"name"];
        cell.rightLabel.text = [self.menuArray[indexPath.row * 3 + 5] valueForKey:@"name"];
        cell.leftImageView.image = [UIImage imageNamed:[self.menuArray[indexPath.row * 3 + 3] valueForKey:@"image"]];
        cell.centerImageView.image = [UIImage imageNamed:[self.menuArray[indexPath.row * 3 + 4] valueForKey:@"image"]];
        cell.rightImageVIew.image = [UIImage imageNamed:[self.menuArray[indexPath.row * 3 + 5] valueForKey:@"image"]];
    }
    [cell.leftButton addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.centerButton addTarget:self action:@selector(centerClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.leftButton.tag = indexPath.row + indexPath.section;
    cell.centerButton.tag = indexPath.row + indexPath.section;
    cell.rightButton.tag = indexPath.row + indexPath.section;
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YGScreenWidth * 0.27;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    view.backgroundColor = colorWithTable;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(void)leftClick:(UIButton *)button
{
    if (![self loginOrNot])
    {
        return;
    }
    if (button.tag == 0) {
        //随手拍
        NSArray * titleArr = @[@"待处理",@"处理中",@"已处理"];
        NSArray * classArr = @[@"TakePicturesOrderListController",@"TakePicturesOrderListController",@"TakePicturesOrderListController"];
        TakePicturesStatusController * toVC= [[TakePicturesStatusController alloc] initWithTitleArray:titleArr viewControllerClassStringArray:classArr navgationTitle:@"随手拍"];
        [self.navigationController pushViewController:toVC animated:YES];
    }
    if (button.tag == 1) {
        //我的收藏
        MyCollectionListController *vc = [[MyCollectionListController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 2) {
        //我的一起玩
        OrderManagerController *vc = [[OrderManagerController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 3) {
        //我的资金扶持
        MyFundSupportViewController *controller = [[MyFundSupportViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
-(void)centerClick:(UIButton *)button
{
    if (button.tag == 0) {
        if (![self loginOrNot])
        {
            return;
        }
        //工商一体化
        MyIntegrationIndustryCommerceController * myIntegrationIndustry = [[MyIntegrationIndustryCommerceController alloc]init];
        [self.navigationController pushViewController:myIntegrationIndustry animated:YES];
    }
    if (button.tag == 1) {
        if (![self loginOrNot])
        {
            return;
        }
        //我的青币
        MineIntergralViewController *mVC = [[MineIntergralViewController alloc]init];
        [self.navigationController pushViewController:mVC animated:YES];

    }
    if (button.tag == 2) {
        if (![self loginOrNot])
        {
            return;
        }
        //我的管家
        MyManagerListController *mVC = [[MyManagerListController alloc]init];
        [self.navigationController pushViewController:mVC animated:YES];
    }
    if (button.tag == 3) {
        //设置
        SetupViewController *setVC = [[SetupViewController alloc]init];
        [self.navigationController pushViewController:setVC animated:YES];
    }
}
-(void)rightClick:(UIButton *)button
{
    if (![self loginOrNot])
    {
        return;
    }
    if (button.tag == 0) {
        //财务代记账
        MyFinancialAccountViewController * myFinancialAccount = [[MyFinancialAccountViewController alloc]init];
        [self.navigationController pushViewController:myFinancialAccount animated:YES];
    }
    if (button.tag == 1) {
        //我的抢购
        RushPurchaseOrderListViewController * rushPurchaseOrderList =[[RushPurchaseOrderListViewController alloc]init];
        [self.navigationController pushViewController:rushPurchaseOrderList animated:YES];
    }
    if (button.tag == 2) {
        //我的人才服务
        MyRecruitViewController *vc = [[MyRecruitViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

//联系客服
-(void)contact:(UIButton *)button
{
    [self contactWithCustomerServerWithType:ContactServerMine button:button];
}
//消息通知
-(void)information:(UIButton *)button
{
    if (![self loginOrNot])
    {
        return;
    }
    MyPushInformationController *miVC= [[MyPushInformationController alloc] init];
    [self.navigationController pushViewController:miVC animated:YES];
}
//点击头像栏
-(void)headerViewTap
{
    if (![self loginOrNot])
    {
        return;
    }
    PersonalInformationViewController *vc = [[PersonalInformationViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
