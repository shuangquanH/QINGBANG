//
//  AreaSelectDetailViewController.m
//  QingYouProject
//
//  Created by apple on 2017/11/6.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AreaSelectDetailViewController.h"

@interface AreaSelectDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;


@end

@implementation AreaSelectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"所在地";

    [self.view addSubview:self.tableView];
    
  
}
- (UITableView *)tableView{
    
    if (!_tableView) {
        CGFloat H = kScreenH  - YGStatusBarHeight - YGNaviBarHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        if (@available(iOS 11.0, *)) {
            
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.cityArry.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * address = [NSString stringWithFormat:@"%@ %@",self.selectedProvince,self.cityArry[indexPath.row]];
    switch (self.tag) {
        case 0://申请维护
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"immediatelyApply" object:address];
            break;
        case 1://申请VIP
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"VIPApply" object:address];
            break;
        case 2://装修直通车
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"decoration" object:address];
            break;
        case 3://室内报修
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"IndoorMaintenanceView" object:address];
            break;
        case 4://二手置换
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"SeccondHandExchangePublishAddressSelect" object:address];
        default:
        case 5://法律服务
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"HomePageLegalService" object:address];
            break;
            
            break;
    }
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count- 3] animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    //取消点击效果
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.textLabel .text = self.cityArry[indexPath.row];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
