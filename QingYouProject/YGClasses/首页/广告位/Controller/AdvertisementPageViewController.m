//
//  AdvertisementPageViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/9/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AdvertisementPageViewController.h"
#import "AdvertisementLocationViewCell.h"
#import "CooperateClientCell.h"
#import "AdvertisementDetailController.h"
#import "YGActionSheetView.h"
#import "AdvertisementLocationCell.h"
#import "NetDetailViewController.h"
#import "AdvertisementDetailController.h"

@interface AdvertisementPageViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{
    UITableView *_tableView;
    SDCycleScrollView *_adScrollview; //广告轮播
    NSMutableArray *_adDataArray; //广告数据源
    NSMutableArray *_bannerDataArray;//轮播图数据源
    NSString *_bottomImageString; //合作伙伴图片源
    NSMutableArray *_showMutableArray;//园区列表name
    NSMutableArray *_showvalueMutableArray;//园区列表value
    NSString *_gardernValue; //园区的value
}
@property(nonatomic,assign) float scale;//比例

@end

@implementation AdvertisementPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"广告位置";
    _adDataArray = [NSMutableArray array];
    _bannerDataArray = [NSMutableArray array];
    
    
    [self configUI];
    [self loadDataFromServer];
    [self loadGardernData];
}


-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight -YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStyleGrouped];
    //    if (@available(iOS 11.0, *)) {
    //        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    //    }
    _tableView.backgroundColor = colorWithTable;
    _tableView.sectionFooterHeight = 0.0001;
    _tableView.sectionHeaderHeight = 0.0001;
    _tableView.estimatedRowHeight = 200;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    [self.view addSubview:_tableView];
    
    [self configHeaderView];
}

//第一次请求数据
-(void)loadDataFromServer
{
    [YGNetService YGPOST:REQUEST_AdsIndex parameters:@{} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        _adDataArray = [responseObject valueForKey:@"ads"];
        _bannerDataArray = [responseObject valueForKey:@"banner"];
        _bottomImageString = [responseObject valueForKey:@"bottom"];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_bottomImageString]];
        UIImage *image = [UIImage imageWithData:data];
        NSLog(@"w = %f,h = %f",image.size.width,image.size.height);
        self.scale = image.size.height / image.size.width;
        if (image.size.width <= 0) {
            self.scale = 0;
        }
        
        NSMutableArray *imageArray = [NSMutableArray array];
        for (int i = 0 ; i < _bannerDataArray.count; i++) {
            [imageArray addObject:[_bannerDataArray[i] valueForKey:@"bannerImg"]];
        }
        _adScrollview.imageURLStringsGroup = imageArray;
        
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}


//加载数据
-(void)loadRefreshData
{
    [YGNetService YGPOST:REQUEST_AdsGarden parameters:@{@"garden":_gardernValue} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        _adDataArray = [responseObject valueForKey:@"ads"];;
        
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

//加载园区数据
-(void)loadGardernData
{
    _showMutableArray = [NSMutableArray array];
    _showvalueMutableArray = [NSMutableArray array];
    [YGNetService YGPOST:@"ChooseGarden" parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        NSArray *listArray = [NSArray array];
        listArray = [responseObject valueForKey:@"list"];
        for (int i = 0; i < listArray.count; i++) {
            [_showMutableArray addObject:[listArray[i] valueForKey:@"label"]];
            [_showvalueMutableArray addObject:[listArray[i] valueForKey:@"value"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
        
}


-(void)configHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth *0.63)];
    
    //广告滚动
    _adScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth / 2) delegate:self placeholderImage:YGDefaultImgTwo_One];
    _adScrollview.imageURLStringsGroup = @[];
    _adScrollview.autoScroll = YES;
    _adScrollview.infiniteLoop = YES;
    _adScrollview.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;//page指示在右边
    [headerView addSubview:_adScrollview];
    
    UIView *chooseAreaView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenWidth / 2, YGScreenWidth, YGScreenWidth *0.13)];
    chooseAreaView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(YGScreenWidth - (YGScreenWidth * 0.13 - 24), 17, 15, YGScreenWidth * 0.13 - 34)];
    rightImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
    [chooseAreaView addSubview:rightImageView];
    
    UILabel *chooseAreaLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth - 40, YGScreenWidth * 0.13)];
    chooseAreaLabel.tag = 1994;
    chooseAreaLabel.textColor = colorWithBlack;
    chooseAreaLabel.text = @"请选择当前园区";
    chooseAreaLabel.font = [UIFont systemFontOfSize:15.0];
    chooseAreaLabel.textAlignment = NSTextAlignmentCenter;
    [chooseAreaView addSubview:chooseAreaLabel];
    
    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseButton setTitle:@"" forState:UIControlStateNormal];
    chooseButton.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.13);
    [chooseButton addTarget:self action:@selector(chooseArea:) forControlEvents:UIControlEventTouchUpInside];
    [chooseAreaView addSubview:chooseButton];
    [headerView addSubview:chooseAreaView];
    _tableView.tableHeaderView = headerView;
}


#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        AdvertisementLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdvertisementLocationCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AdvertisementLocationCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSString *imageString = [_adDataArray[indexPath.row] valueForKey:@"adsImgIndex"];
        [cell.areaImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:YGDefaultImgFour_Three];
        cell.areaLabel.text = [_adDataArray[indexPath.row] valueForKey:@"adsName"];
        
        return cell;
    }
    CooperateClientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CooperateClientCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CooperateClientCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_bottomImageString.length) {
        [cell.clientImageView sd_setImageWithURL:[NSURL URLWithString:_bottomImageString] placeholderImage:YGDefaultImgFour_Three];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _adDataArray.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return YGScreenWidth * 0.5;
    }
    return YGScreenWidth * self.scale;
//    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    AdvertisementDetailController *controller = [[AdvertisementDetailController alloc]init];
    controller.adsIDString = [_bannerDataArray[index] valueForKey:@"adsID"];
    [self.navigationController pushViewController:controller animated:YES];
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    
}

//跳转到广告详情页
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (![self loginOrNot])
        {
            return;
        }
        AdvertisementDetailController *controller = [[AdvertisementDetailController alloc]init];
        controller.adsIDString = [_adDataArray[indexPath.row] valueForKey:@"adsID"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


//选择园区
-(void)chooseArea:(UIButton *)button
{
    [YGActionSheetView showAlertWithTitlesArray:_showMutableArray handler:^(NSInteger selectedIndex, NSString *selectedString) {
            UILabel *areaLabel = [self.view viewWithTag:1994];
            areaLabel.text = selectedString;
            areaLabel.textColor = colorWithBlack;
            _gardernValue = _showvalueMutableArray[selectedIndex];
            [self loadRefreshData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
