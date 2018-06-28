//
//  AreaSelectViewController.m
//  QingYouProject
//
//  Created by apple on 2017/11/6.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AreaSelectViewController.h"
#import "AreaSelectDetailViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface AreaSelectViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray     * province;
@property (nonatomic, strong) NSArray     * city;
@property (nonatomic, strong) NSDictionary * areaDic;
@property (nonatomic, strong) UIView * localView;
@property (nonatomic, strong) UIView * selectView;
@property (nonatomic, strong) NSString * selectedProvince;
//@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) NSString * nowLocalAddress;

@property (nonatomic,strong ) CLLocationManager *locationManager;//定位服务
@property (nonatomic,copy)    NSString *currentCity;//城市
@end

@implementation AreaSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"所在地";
    
    self.currentCity =@"";
    self.localView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
    self.localView.backgroundColor = colorWithTable;
    
    UILabel * localLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, YGScreenWidth -15, 45)];
    localLabel.text =@"您的位置";
    [self.localView addSubview:localLabel];
    
    self.selectView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
    self.selectView.backgroundColor = colorWithTable;
    UILabel * selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, YGScreenWidth -15, 45)];
    selectLabel.text =@"切换城市";
    [self.selectView addSubview:selectLabel];
    
    [self.view addSubview:self.tableView];
    [self getAreaValue];

    [self locatemap];

}
- (void)locatemap{
    
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
//        [_locationManager requestAlwaysAuthorization];
        _currentCity = [[NSString alloc]init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0;
        [_locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];

    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
            _currentCity = placeMark.locality;
//            if (!_currentCity) {
//                _currentCity = @"无法定位当前城市";
//            }
            //看需求定义一个全局变量来接收赋值
            
            if (!_currentCity) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                self.nowLocalAddress = placeMark.administrativeArea;
            }else
            {
                self.nowLocalAddress = [NSString stringWithFormat:@"%@%@",placeMark.administrativeArea,_currentCity];
            }

            [self.tableView reloadData];
            
        }else if (error == nil && placemarks.count){
            
            NSLog(@"NO location and error return");
        }else if (error){
            
            NSLog(@"loction error:%@",error);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{ //此方法为定位失败的时候调用。并且由于会在失败以后重新定位，所以必须在末尾停止更新
    
    if(error.code == kCLErrorLocationUnknown)
    {
        NSLog(@"Currently unable to retrieve location.");
    }
    else if(error.code == kCLErrorNetwork)
    {
        NSLog(@"Network used to retrieve location is unavailable.");
    }
    else if(error.code == kCLErrorDenied)
    {
        NSLog(@"Permission to retrieve location is denied.");
        [manager stopUpdatingLocation];
    }
    
    
}


-(void)getAreaValue{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
     _areaDic= [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [_areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[_areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    self.province = [[NSArray alloc] initWithArray: provinceTmp];
    [_tableView reloadData];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if(section == 0)
        return self.localView;
    else
        return self.selectView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (UITableView *)tableView{
    
    if (!_tableView) {
        CGFloat H = KAPP_HEIGHT  - YGStatusBarHeight - YGNaviBarHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KAPP_WIDTH, H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
//        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0)
        return 1;
    else
        return self.province.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    //取消点击效果
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 1 ) {
        cell.textLabel .text = self.province[indexPath.row];
        return cell;
    }
    cell.textLabel.text = self.nowLocalAddress;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0)
    {
        switch (self.tag) {
            case 0://申请维护
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"immediatelyApply" object:self.nowLocalAddress];
                break;
            case 1://申请VIP
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"VIPApply" object:self.nowLocalAddress];
                break;
            case 2://装修直通车
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"decoration" object:self.nowLocalAddress];
                break;
            case 3://室内报修
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"IndoorMaintenanceView" object:self.nowLocalAddress];
                break;
            case 4://二手置换
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"SeccondHandExchangePublishAddressSelect" object:self.nowLocalAddress];
                break;
            case 5://法律服务
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"HomePageLegalService" object:self.nowLocalAddress];
                break;
            default:
                break;
        }
        
        
        
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count- 2] animated:YES];

        return;
    }
    _selectedProvince = [_province objectAtIndex: indexPath.row];
    NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [_areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)indexPath.row]]];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey:_selectedProvince]];
    NSArray *cityArray = [dic allKeys];
    NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;//递减
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;//上升
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *temp = [[dic objectForKey: index] allKeys];
        [array addObject: [temp objectAtIndex:0]];
    }
    
    _city = [[NSArray alloc] initWithArray: array];
    
    
    AreaSelectDetailViewController * selectDetail =[[AreaSelectDetailViewController alloc]init];
    selectDetail.cityArry = _city;
    selectDetail.selectedProvince =self.selectedProvince;
    selectDetail.tag = self.tag;
    [self.navigationController pushViewController:selectDetail animated:YES];
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
