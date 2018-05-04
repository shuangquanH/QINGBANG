//
//  OrderCheckHouseViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderCheckHouseViewController.h"
#import "AdvertisesForinfoPopView.h"
#import "YGCityPikerView.h"
#import "OrderCheckHouseModel.h"

#import "CheckAdvertisesViewController.h"
#import "OrderCheckHouseTableViewCell.h"

#import "SearchAdvertiesePopSiftView.h"

#import "OrderCheckHouseDetailViewController.h"

#import "OrderCheckHouseSearchViewController.h"

@interface OrderCheckHouseViewController ()<UITableViewDelegate,UITableViewDataSource,AdvertisesForinfoPopViewDelegate,YGCityPikerViewDelegate,UISearchBarDelegate,SearchAdvertiesePopSiftViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    AdvertisesForinfoPopView *_popView;
    int   _index;
    //    UIView *_blackView;
    
    NSString *_gardenIdString;
    NSString *_priceIdString;
    NSString *_decorationIdString;
    NSString *_areaidString;
    NSString *_historyIdString;
    
    NSMutableArray *_gardenArray;
    NSMutableArray *_priceArray;
    NSMutableArray *_decorationArray;
    NSMutableArray *_areaArray;
    NSMutableArray *_historyArray;
    SearchAdvertiesePopSiftView *_searchSiftView;
}


@end

@implementation OrderCheckHouseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    // Do any additional setup after loading the view.
}



- (void)configAttribute
{

    self.naviTitle = @"预约看房";
    UIButton *barButton = [[UIButton alloc] initWithFrame:CGRectMake(YGScreenWidth-50, 30, 40, 40)];
    [barButton setImage:[UIImage imageNamed:@"steward_capital_search"] forState:UIControlStateNormal];
    [barButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    [barButton addTarget:self action:@selector(searchOrderCheckHouseAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    _listArray = [[NSMutableArray alloc] init];
    _gardenArray = [[NSMutableArray alloc] init];
    _priceArray = [[NSMutableArray alloc] init];
    _decorationArray = [[NSMutableArray alloc] init];
    _areaArray = [[NSMutableArray alloc] init];
    _historyArray = [[NSMutableArray alloc] init];

    _gardenIdString = @"";
    _priceIdString = @"";
    _decorationIdString = @"";
    _areaidString = @"";


}
- (void)configUI
{

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
    [_tableView registerClass:[OrderCheckHouseTableViewCell class] forCellReuseIdentifier:@"OrderCheckHouseTableViewCell"];
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    baseView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:baseView];
    NSArray *titleArr = @[@"区域",@"价格",@"装修",@"更多"];
    for (int i =0; i<titleArr.count; i++)
    {
        UIView *buttonView  = [[UIView alloc] initWithFrame:CGRectMake(YGScreenWidth/4*i,0,YGScreenWidth/4,40)];
        [baseView addSubview:buttonView];
        
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
        deliverCurriculumButton.tag = 100000+i;
        [buttonView addSubview:deliverCurriculumButton];
        
        if (i == 3) {
            label.textColor = colorWithBlack;
            imageView.image = [UIImage imageNamed:@"steward_talents_unfold_gray"];
            
        }
    }
    
    [self.view bringSubviewToFront:baseView];
    
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
    OrderCheckHouseTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCheckHouseTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrderCheckHouseModel *model = _listArray[indexPath.row];
    [cell setModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCheckHouseModel *model = _listArray[indexPath.row];
    OrderCheckHouseDetailViewController *vc = [[OrderCheckHouseDetailViewController alloc] init];
    vc.sourceId = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)deliverCurriculumButtonAction:(UIButton *)btn
{
    
    if (_popView) {
        [_popView dismiss];
    }
    if (_searchSiftView) {
        [_searchSiftView dismiss];
    }
    if (_index == btn.tag-100000 && btn.selected == YES)
    {
        btn.selected = NO;
        return;
    }
    
    btn.selected = YES;
    
    UILabel *lable = [self.view viewWithTag:555+btn.tag-100000];
    lable.textColor = colorWithMainColor;
    UIImageView *arrowImageView = [self.view viewWithTag:560+btn.tag-100000];
    arrowImageView.image = [UIImage imageNamed:@"steward_talents_packup_green"];
    
    
    if (btn.tag == 100000) {
        
        _popView = [[AdvertisesForinfoPopView alloc] init];
        _popView.delegate = self;
        [self.view addSubview:_popView];
        for ( AdvertisesForInfoModel *model in _gardenArray) {
            model.isSelect = NO;
            model.name = model.label;
            
        }
        int i = 0  ;
        
        for ( AdvertisesForInfoModel *model in _gardenArray) {
            if ([_gardenIdString isEqualToString:model.id]) {
                model.isSelect = YES;
                break;
            }
            i++;
        }
        [_popView createPopChooseViewWithDataSorce:_gardenArray andLeftDataArray:nil  withType: pageTypeChooseSalary withLeftIndex:i withRightIndex:i];
        
    }
    if (btn.tag == 100001) {
        _searchSiftView = [[SearchAdvertiesePopSiftView alloc] init];
        _searchSiftView.delegate = self;
        [self.view addSubview:_searchSiftView];
        for ( AdvertisesForInfoModel *model in _priceArray) {
            model.isSelect = NO;
            
        }
        for ( AdvertisesForInfoModel *model in _priceArray) {
            if ([_priceIdString isEqualToString:model.id]) {
                model.isSelect = YES;
                break;
            }
        }
        
        
        [_searchSiftView createOrderHouseCheckPopChooseViewWithDataSorce:@[_priceArray] withTitle: @" 价格（元/月/㎡）"];
    }
    if (btn.tag == 100002) {
        _popView = [[AdvertisesForinfoPopView alloc] init];
        _popView.delegate = self;
        [self.view addSubview:_popView];
        
        for ( AdvertisesForInfoModel *model in _decorationArray) {
            model.isSelect = NO;
            
        }
        int i = 0  ;
        
        for ( AdvertisesForInfoModel *model in _decorationArray) {
            if ([_decorationIdString isEqualToString:model.id]) {
                model.isSelect = YES;
                break;
            }
            i++;
        }
        [_popView createPopChooseViewWithDataSorce:_decorationArray andLeftDataArray:nil withType:pageTypeChooseSalary withLeftIndex:i withRightIndex:i];
    }
    if (btn.tag == 100003) {
        _searchSiftView = [[SearchAdvertiesePopSiftView alloc] init];
        _searchSiftView.delegate = self;
        [self.view addSubview:_searchSiftView];
        for ( AdvertisesForInfoModel *model in _areaArray) {
            model.isSelect = NO;
            
        }
        for ( AdvertisesForInfoModel *model in _areaArray) {
            if ([_areaidString isEqualToString:model.id]) {
                model.isSelect = YES;
                break;
            }
        }
        [_searchSiftView createOrderHouseCheckPopChooseViewWithDataSorce:@[_areaArray] withTitle: @" 面积（㎡）"];
    }
    
    _index =(int) btn.tag -100000;
    
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
    
    if (_index == 0) {
        UILabel *lable = [self.view viewWithTag:555+_index];
        lable.text = model.name;
        _gardenIdString = model.value;

    }
    if (_index == 2) {
        _decorationIdString = model.id;
    }
    [self refreshActionWithIsRefreshHeaderAction:YES];
}

-(void)siftDataWithKeyModelArray:(NSArray *)modelArray
{
    UIButton *btn = [self.view viewWithTag:_index +100000];
    btn.selected = NO;
    
    if (modelArray.count != 0) {
        
        AdvertisesForInfoModel *model = modelArray[0];
        if (_index == 1)
        {
            for (AdvertisesForInfoModel *modelPrice in _priceArray)
            {
                modelPrice.isSelect = NO;
                if ([model.id isEqualToString:modelPrice.id])
                {
                    modelPrice.isSelect = YES;
                }
            }
            _priceIdString = model.id;
        }
        if (_index == 3)
        {
            _areaidString = model.id;
        }
    }else
    {
        if (_index == 1)
        {
            _priceIdString = @"";

        }
        if (_index == 3)
        {
            _areaidString = @"";
        }
    }
    [self refreshActionWithIsRefreshHeaderAction:YES];
}
- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_otSelectList parameters:@{@"area":_gardenIdString,@"price":_priceIdString,@"degree":_decorationIdString,@"proprotion":_areaidString,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }
        
        [_listArray addObjectsFromArray:[OrderCheckHouseModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        if ([responseObject[@"list"] count] == 0) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)getData
{
    [YGNetService showLoadingViewWithSuperView:self.view];
    [self startPostWithURLString:REQUEST_ChooseGarden parameters:@{} showLoadingView:NO scrollView:nil];
    [self startPostWithURLString:REQUEST_OtPriceSelectList parameters:@{} showLoadingView:NO scrollView:nil];
    [self startPostWithURLString:REQUEST_OtProportionSelectList parameters:@{} showLoadingView:NO scrollView:nil];
    [self startPostWithURLString:REQUEST_OtDegreeSelectList parameters:@{} showLoadingView:NO scrollView:nil];
}
- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    
    if ([URLString isEqualToString:REQUEST_ChooseGarden]) {
        NSMutableArray *rootArray = responseObject[@"list"];
        _gardenArray = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:rootArray];
//        NSMutableArray *gardenArray = [[NSMutableArray alloc] init];
//        for (AdvertisesForInfoModel *model in _gardenArray) {
//            [gardenArray addObject:model.label];
//        }
        
    }
   
    if ([URLString isEqualToString:REQUEST_OtPriceSelectList]) {
        NSMutableArray *rootArray = responseObject[@"list"];
        _priceArray = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:rootArray];
        NSMutableArray *pickEducationArray = [[NSMutableArray alloc] init];
        for (AdvertisesForInfoModel *model in _priceArray) {
            [pickEducationArray addObject:model.name];
        }
    }
    if ([URLString isEqualToString:REQUEST_OtProportionSelectList]) {
        NSMutableArray *rootArray = responseObject[@"list"];
        _areaArray  = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:rootArray];
        NSMutableArray *pickEducationArray = [[NSMutableArray alloc] init];
        for (AdvertisesForInfoModel *model in _areaArray) {
            [pickEducationArray addObject:model.name];
        }

    }
    if ([URLString isEqualToString:REQUEST_OtDegreeSelectList]) {
        
        NSMutableArray *rootArray = responseObject[@"list"];
        _decorationArray = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:rootArray];
        NSMutableArray *pickEducationArray = [[NSMutableArray alloc] init];
        for (AdvertisesForInfoModel *model in _decorationArray) {
            [pickEducationArray addObject:model.name];
        }
    }
    
    if (_areaArray.count != 0 && _gardenArray.count != 0 && _decorationArray.count != 0 &&_priceArray.count != 0) {
        [YGNetService dissmissLoadingView];
        [self configUI];
      
    }
    
}

- (void)searchOrderCheckHouseAction
{
    OrderCheckHouseSearchViewController *vc = [[OrderCheckHouseSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
