
//
//  HomePageViewController.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/1/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageTableViewCell.h"
#import "SelectCityPopView.h"
#import "ManagerViewController.h"
#import "YGStartPageView.h"
#import "RushPurchaseViewController.h"
#import "YGGravityImageView.h"
#import "HomePageSeccondTableViewCell.h"
#import "SMKCycleScrollView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>


#import "FinancialAccountingViewController.h"
#import "IntegrationIndustryCommerceController.h"
#import "OrderCheckHouseViewController.h"

#import <AMapLocationKit/AMapLocationKit.h>
#import "CommentViewController.h"
#import "YGVideoPickerController.h"

//项目申报等等
#import "PlayTogetherViewController.h"
#import "PlayTogetherDetailViewController.h"//详情
#import "NewThingsViewController.h"
#import "NewThingsDetailController.h" //详情
#import "OfficePurchaseViewController.h"
#import "OfficePurchaseDetailViewController.h"//办公室采购详情页
#import "RushPurchaseViewController.h"
#import "RushPurchaseDetailViewController.h"//详情页
#import "SeccondHandExchangeViewController.h"//详情页
#import "BabyDetailsController.h"

#import "ProjectApplyForWebDetailViewController.h"
#import "ProjectApplyForViewController.h"
#import "DecorationCarMainController.h"
#import "FundSupportViewController.h"
#import "NetManagerVC.h"
#import "HomePageLegalServiceViewController.h"



#define CHANGE_RANGE 146


#import "PayRentViewController.h"
#import "HouseRentAuditViewController.h"
#import "CheckUserInfoViewController.h"
#import "AdvertisesForViewController.h"
#import "UpLoadIDFatherViewController.h"
#import "YGCityPikerView1.h"
#import "LoginViewController.h"


@interface HomePageViewController()
<UITableViewDelegate,
UITableViewDataSource,
SDCycleScrollViewDelegate,
//YGVideoPickerControllerDelegate,
HomePageTableViewCellDelegate,
CLLocationManagerDelegate>
{
    NSMutableArray *_listArray;
    UITableView *_tableView;
    NSArray *_coverArray;
    SDCycleScrollView *_adScrollview; //广告轮播
    SDCycleScrollView *_playTogetherScrollview; //一起玩轮播

    NSMutableArray *_advertiseArray;
    NSMutableArray *_neswArray;
//    YGVideoPickerController *_videoPicker;
    NSArray         *_sectionHeaderArray;
    NSMutableArray *_projectDecorationFundNetModelArray;
    NSArray *_PlaySlideshowList;
    NSArray *_IndexSlideshowList;
    NSArray *_freshNewsList;
    UIButton *_coverLeftNaviButton;
}
@property (nonatomic, strong) SMKCycleScrollView *cycleScrollView;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)NSString *currentCity;//长春市
@property(nonatomic,strong)NSString *nowLocalAddress;//吉林省长春市
@property(nonatomic,strong)NSString *locateAddress;//传给后台的地址

@end

@implementation HomePageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_adScrollview  adjustWhenControllerViewWillAppera];
    [_playTogetherScrollview  adjustWhenControllerViewWillAppera];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLaunches];//引导页
    [self configUI];//ui层
}

- (void)loadLaunches {
    if (![YGUserDefaults objectForKey:USERDEF_FIRSTOPENAPP]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lastPage) name:@"last" object:nil];
        NSMutableArray *imageNameArray = @[].mutableCopy;
        for (int i = 0; i<4; i++) {
            [imageNameArray addObject:[NSString stringWithFormat:@"%d_%.0f", i+1, YGScreenHeight]];
        }
        [YGStartPageView showWithLocalPhotoNamesArray:imageNameArray];
    }
}
- (void)lastPage {
    [self.locationManager startUpdatingLocation];
    [YGUserDefaults setObject:@"1" forKey:USERDEF_FIRSTOPENAPP];
}



- (void)configAttribute {
    self.automaticallyAdjustsScrollViewInsets = NO;
    _listArray = [[NSMutableArray alloc]init];
    _sectionHeaderArray = @[@"一起玩",@"为您推荐",@"新鲜事"];
    _projectDecorationFundNetModelArray = [[NSMutableArray alloc] init];
    

    // 左边城市
    _coverLeftNaviButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_coverLeftNaviButton setImage:[UIImage imageNamed:@"home_address_ico_black"] forState:UIControlStateNormal];
    [_coverLeftNaviButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [_coverLeftNaviButton setTitle:[YGUserDefaults objectForKey:USERDEF_NOWCITY] forState:UIControlStateNormal];
    _coverLeftNaviButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [_coverLeftNaviButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    _coverLeftNaviButton.frame =  CGRectMake(0, 0, YGScreenWidth, 40);
    self.navigationItem.titleView = _coverLeftNaviButton;
    [_coverLeftNaviButton setTitle:@"青网欢迎您" forState:UIControlStateNormal];
}

- (void)configUI {
    
    //头部视图容器
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0)];
    tableHeaderView.backgroundColor = colorWithTable;
    
    //广告滚动
    _adScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth/2) delegate:self placeholderImage:YGDefaultImgTwo_One];
    _adScrollview.autoScroll = YES;
    _adScrollview.infiniteLoop = YES;
    [tableHeaderView addSubview:_adScrollview];
    
    //功能按钮底部
    UIView *topBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, _adScrollview.y + _adScrollview.height, YGScreenWidth, 0)];
    topBaseView.backgroundColor = colorWithYGWhite;
    [tableHeaderView addSubview:topBaseView];
    
    NSArray *imageNameArray = @[
                                @{@"title":@"抢购",@"image":@"home_rushpurchase"},
                                @{@"title":@"一起玩",@"image":@"home_havefun"},
                                @{@"title":@"预约看房",@"image":@"home_ordertable"},
                                @{@"title":@"二手置换",@"image":@"home_secondhand"}
                                ];
    
    for (int i = 0; i<imageNameArray.count; i++) {
        UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(YGScreenWidth/4*i, 0, YGScreenWidth/4, 0)];
        [topBaseView addSubview:baseView];
        
        //小图
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageNameArray[i][@"image"]]];
        [imageView sizeToFit];
        imageView.y = 20;
        imageView.centerx = baseView.width/2;
        [baseView addSubview:imageView];
        
        //小文字
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        label.textColor = colorWithBlack;
        label.text = imageNameArray[i][@"title"];
        [label sizeToFitHorizontal];
        label.centerx = imageView.centerx;
        label.y = imageView.y + imageView.height + 10;
        [baseView addSubview:label];
        
        baseView.height = label.y + label.height + 20;
        
        //大button
        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, baseView.width, baseView.height)];
        coverButton.tag = 100 + i;
        [coverButton addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:coverButton];
        
        if (i == 0)
        {
            topBaseView.height = baseView.height;
            //🔥
            UIImageView *fireImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_hot.png"]];
            [fireImageView sizeToFit];
            fireImageView.centery = label.centery;
            fireImageView.x = label.x + label.width;
            [baseView addSubview:fireImageView];
        }
    }
    
    
    //热门推荐view
    UIView *bottomBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, topBaseView.height+topBaseView.y + 10, YGScreenWidth, 60)];
    bottomBaseView.backgroundColor = colorWithYGWhite;
    [tableHeaderView addSubview:bottomBaseView];
    
    //左线
    UIImageView *todaysTopNewsImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_today_green"]];
    todaysTopNewsImageView.frame = CGRectMake(10, 10, 2, 20);
    [todaysTopNewsImageView sizeToFit];
    [bottomBaseView addSubview:todaysTopNewsImageView];
    todaysTopNewsImageView.frame = CGRectMake(10, 30-todaysTopNewsImageView.height/2, todaysTopNewsImageView.width, todaysTopNewsImageView.height);

    //左线
    UIImageView *leftLineImageView = [[UIImageView alloc]init];
    leftLineImageView.frame = CGRectMake(todaysTopNewsImageView.width+todaysTopNewsImageView.x+10, 5, 1, todaysTopNewsImageView.height-5);
    leftLineImageView.backgroundColor = colorWithLightGray;
    [bottomBaseView addSubview:leftLineImageView];
    leftLineImageView.centery = todaysTopNewsImageView.centery;
    
    self.cycleScrollView = [[SMKCycleScrollView alloc] init];
    self.cycleScrollView.frame = CGRectMake(leftLineImageView.x+leftLineImageView.width+10, 0, YGScreenWidth-leftLineImageView.x-20, 35);
    self.cycleScrollView.centery = leftLineImageView.centery;
    self.cycleScrollView.backColor = [UIColor clearColor];
    self.cycleScrollView.titleColor = colorWithLightGray;
    self.cycleScrollView.titleFont = [UIFont systemFontOfSize:YGFontSizeNormal];
    [bottomBaseView addSubview:self.cycleScrollView];
    self.cycleScrollView.centery = todaysTopNewsImageView.centery;

    
    //一起玩儿view
    UIView *playTogetherBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, bottomBaseView.height+bottomBaseView.y + 10, YGScreenWidth, YGScreenWidth*0.8)];
    playTogetherBaseView.backgroundColor = colorWithYGWhite;
    [tableHeaderView addSubview:playTogetherBaseView];

    //
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    headerView.backgroundColor = colorWithYGWhite;
    [playTogetherBaseView addSubview:headerView];
    
    //热门推荐label
    UILabel *describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    describeLabel.textColor = colorWithBlack;
    describeLabel.text = @"一起玩";
    describeLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [describeLabel sizeToFitHorizontal];
    [headerView addSubview:describeLabel];
    
    //一起玩轮播
    _playTogetherScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 40, YGScreenWidth, YGScreenWidth*0.65) delegate:self placeholderImage:YGDefaultImgFour_Three];
    _playTogetherScrollview.autoScroll = NO;
    _playTogetherScrollview.infiniteLoop = YES;
    [playTogetherBaseView addSubview:_playTogetherScrollview];
    playTogetherBaseView.frame = CGRectMake(0, playTogetherBaseView.y,playTogetherBaseView.width , _playTogetherScrollview.y+_playTogetherScrollview.height);
    
    tableHeaderView.frame = CGRectMake(0, 0,YGScreenWidth , playTogetherBaseView.y+playTogetherBaseView.height+10);
    
    
    
    //tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight- YGNaviBarHeight-YGStatusBarHeight-YGTabBarHeight) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = tableHeaderView;
    [_tableView registerClass:[HomePageTableViewCell class] forCellReuseIdentifier:@"HomePageTableViewCell"];
    [_tableView registerClass:[HomePageSeccondTableViewCell class] forCellReuseIdentifier:@"HomePageSeccondTableViewCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = colorWithTable;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:NO];
    [self refreshActionWithIsRefreshHeaderAction:YES];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    

}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {

    [YGNetService YGPOST:REQUEST_IndexInformationDetail parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        [self endRefreshWithScrollView:_tableView];
        if (headerAction) {
            [_listArray removeAllObjects];
        }
        //顶上滚动图
        _IndexSlideshowList =[NSMutableArray arrayWithArray: [HomePageModel mj_objectArrayWithKeyValuesArray:responseObject[@"IndexSlideshowList"]]];
        NSMutableArray *IndexSlideScrollArray = [[NSMutableArray alloc] init];
        for (HomePageModel *model in _IndexSlideshowList) {
            [IndexSlideScrollArray addObject:model.img];
        }
        _adScrollview.imageURLStringsGroup = IndexSlideScrollArray;
        
        //一起玩滚动图
        _PlaySlideshowList = [NSMutableArray arrayWithArray:[HomePageModel mj_objectArrayWithKeyValuesArray:responseObject[@"PlaySlideshowList"]]];
        NSMutableArray *PlaySlideScrollArray = [[NSMutableArray alloc] init];
        for (HomePageModel *model in _PlaySlideshowList) {
            [PlaySlideScrollArray addObject:model.img];
        }
        _playTogetherScrollview.imageURLStringsGroup = PlaySlideScrollArray;
        
        
        //新鲜事
        _freshNewsList = [HomePageModel mj_objectArrayWithKeyValuesArray:responseObject[@"freshNewsList"]];
        NSMutableArray *freshNewsArray;
        
        if (_freshNewsList.count == 0)
        {
           freshNewsArray = [[NSMutableArray alloc] init];

        }else if (_freshNewsList.count == 1)
        {
            
           freshNewsArray = [[NSMutableArray alloc] initWithObjects:_freshNewsList[0],nil];


        }else
        {
            freshNewsArray = [[NSMutableArray alloc] initWithObjects:_freshNewsList[0], _freshNewsList[1],nil];

        }
        
        //滚动新闻
        NSMutableArray *newsScrollArray = [[NSMutableArray alloc] init];
        
    
        for (HomePageModel *model in _freshNewsList) {
            [newsScrollArray addObject:model.name];
        }
        
        if (_freshNewsList.count == 0)
        {
            newsScrollArray = (NSMutableArray *)@[@"新闻公告"];
            [newsScrollArray addObject:newsScrollArray[0]];

        }
        if (_freshNewsList.count == 1)
        {
            [newsScrollArray addObject:newsScrollArray[0]];
            
        }
        self.cycleScrollView.titleArray = newsScrollArray;
        
        __weak typeof(self) weakSelf = self;

        __weak typeof (NSArray *)weakArray = _freshNewsList;
        
        [self.cycleScrollView setSelectedBlock:^(NSInteger index, NSString *title) {
            
            if (![weakSelf loginOrNot])
            {
                return;
            }
            if ([title isEqualToString:@"新闻公告"]) {
                return ;
            }
            HomePageModel *model;
            if (weakArray.count == 1) {
                model = weakArray[0];
            }else
            {
                model = weakArray[index];
            }
            
            NewThingsDetailController *vc = [[NewThingsDetailController alloc] init];
            vc.idString = model.id;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            NSLog(@"%zd-----%@",index,title);
        }];
        
        
        //图片 type判断1234566.。。
        NSArray *indexModuleList = [NSMutableArray arrayWithArray:[HomePageModel mj_objectArrayWithKeyValuesArray:responseObject[@"indexModuleList"]]];
        
        
        //办公采购 抢购 二手置换 123
        NSMutableArray *officePurchaseSeccondArray = [[NSMutableArray alloc] init];
 
        //工商一体化 财务代记账 45
        NSMutableArray *industryFinancialArray = [[NSMutableArray alloc] init];
        
        
        for (HomePageModel *model in indexModuleList) {
            for (int  i = 1; i<4; i++) {
                if ([model.type intValue] == i) {
                    [officePurchaseSeccondArray addObject:model];
                }
            }
  
            for (int  i = 6; i<10; i++) {
                if ([model.type intValue] == i) {
                    //项目申报 装修直通车 资金扶持 网络管家 6789
                    [_projectDecorationFundNetModelArray addObject:model];
                }
            }
            if ([model.type isEqualToString:@"4"]) {
                model.name = @"工商一体化";
                model.content = @"高效专业、快捷便利";
                [industryFinancialArray addObject:model];

            }
            if ([model.type isEqualToString:@"5"]) {
                model.name = @"财务代记账";
                model.content = @"专业的水准，完善的服务";
                [industryFinancialArray addObject:model];
                
            }
            
//            if ([model.type isEqualToString:@"10"]) {
//                model.name = @"法律服务";
//                model.content = @"专业解读法律，热情服务企业";
//                [industryFinancialArray addObject:model];
//                
//            }
        }

     
        [_listArray addObject:officePurchaseSeccondArray];
        [_listArray addObject:industryFinancialArray];
        [_listArray addObject:freshNewsArray];
        
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [self endRefreshWithScrollView:_tableView];
    }];

    
    

}


#pragma mark ------------tabelView相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return ((NSArray *)_listArray[section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return (YGScreenWidth-40)/3*1.3+20;
    }
    if (indexPath.section == 1) {
        return 90;
    }
    if (indexPath.section == 2) {
        return 90;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        HomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = colorWithYGWhite;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.modelArray = _listArray[indexPath.section];
        return cell;
        
    }else
    {
        HomePageSeccondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageSeccondTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = colorWithYGWhite;
        if (indexPath.section == 1)
        {
            [cell setModel:_listArray[indexPath.section][indexPath.row] withType:@"remmend"];

        }else
        {
            [cell setModel:_listArray[indexPath.section][indexPath.row] withType:@"news"];

        }
        return cell;
    }
    return nil;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 ) {
        return nil;
    }
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    headerView.backgroundColor = colorWithYGWhite;
    //热门推荐label
    UILabel *describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    describeLabel.textColor = colorWithBlack;
    describeLabel.text = _sectionHeaderArray[section];
    describeLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [describeLabel sizeToFitHorizontal];
    [headerView addSubview:describeLabel];
    
    if (section != 1)
    {
        UIImage *image = [UIImage imageNamed:@"home_more_btn_green"];
        //大button
        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-image.size.width-10-20, 0, image.size.width+20, 40)];
        [coverButton setImage:image forState:UIControlStateNormal];
        [coverButton addTarget:self action:@selector(moreCoverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:coverButton];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView =[[UIView alloc] init];
    footerView.backgroundColor = colorWithYGWhite;
    if (section == 0)
    {
        footerView.frame = CGRectMake(0, 0, YGScreenWidth, 10);
        //高度为10 的线
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, footerView.height-10, YGScreenWidth, 10)];
        view.backgroundColor = colorWithTable;
        [footerView addSubview:view];
        return footerView;
    }
    if (section == 1)
    {
        //高度为10 的线
        UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
        viewTop.backgroundColor = colorWithTable;
        [footerView addSubview:viewTop];
        
        int tag = 0;
        NSArray *titleArray = @[@[@"项目申报",@"装修直通车"],@[@"资金扶持",@"网络管家"]];
        for (int i = 0; i<2; i++)
        {
            for (int j = 0; j<2; j++)
            {
                HomePageModel *model = _projectDecorationFundNetModelArray[tag];
                //图
                UIImageView *leftTopImageView = [[UIImageView alloc]init];
                [leftTopImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:YGDefaultImgThree_Four];
                leftTopImageView.tag = 1000*tag+1000;
                leftTopImageView.layer.cornerRadius = 5;
                leftTopImageView.contentMode = UIViewContentModeScaleAspectFill;
                leftTopImageView.clipsToBounds = YES;
                leftTopImageView.userInteractionEnabled = YES;
                [footerView addSubview:leftTopImageView];
                leftTopImageView.frame = CGRectMake((YGScreenWidth-(YGScreenWidth*0.45*2))/3*(1+j)+YGScreenWidth*0.45*j, viewTop.height+10+10*i+YGScreenWidth*0.45/2*i, YGScreenWidth*0.45, YGScreenWidth*0.45/2);
                
                UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,leftTopImageView.width,leftTopImageView.height)];
                coverButton.tag = 1000 + section + tag;
                coverButton.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.5];
                [coverButton addTarget:self action:@selector(imageTapAction:) forControlEvents:UIControlEventTouchUpInside];
                [coverButton setTitle:titleArray[i][j] forState:UIControlStateNormal];
                [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
                coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
                [leftTopImageView addSubview:coverButton];
                tag ++;
            }
        }
        footerView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth*0.4+45+25);
        //高度为10 的线
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, footerView.height-10, YGScreenWidth, 10)];
        view.backgroundColor = colorWithTable;
        [footerView addSubview:view];
    }
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    if (section == 1)
    {
        return YGScreenWidth*0.4+45+25;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self loginOrNot])
    {
        return;
    }
    
    if (indexPath.section ==1)
    {
        if (indexPath.row == 0)
        {
            IntegrationIndustryCommerceController *vc = [[IntegrationIndustryCommerceController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1)
        {
            FinancialAccountingViewController *vc = [[FinancialAccountingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            HomePageLegalServiceViewController * legalService = [[HomePageLegalServiceViewController alloc]init];
            [self.navigationController pushViewController:legalService animated:YES];
        }
    }
    if (indexPath.section ==2)
    {
        HomePageModel *model = _listArray[indexPath.section][indexPath.row];
        NewThingsDetailController *vc = [[NewThingsDetailController alloc] init];
        vc.idString = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }

}



#pragma mark  ------------点击事件响应
//四个图标点击
- (void)coverButtonClick:(UIButton *)button
{
    
    if (![self loginOrNot])
    {
        return;
    }
    switch (button.tag-100) {
        case 0:
        {
            [self.tabBarController setSelectedIndex:2];

            break;
        }
        case 1:
        {
            //    btn.tag = 1000+  != 1
        
            PlayTogetherViewController *controller = [[PlayTogetherViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            

            break;
        }
        case 2:
        {
            OrderCheckHouseViewController *controller = [[OrderCheckHouseViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
  
            break;
        }
        case 3:
        {

            SeccondHandExchangeViewController *controller = [[SeccondHandExchangeViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
    }
}
- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    //返回值state ==0是请提交审核材料 ==1待审核 ==2审核通过直接跳到房租缴纳首页 ==3审核不通过跳到传身份证页面并提示请重新上传资料审核
    if ([URLString isEqualToString:REQUEST_HouserAudit]) {
        if ([responseObject[@"state"] isEqualToString:@"1"]) {
            HouseRentAuditViewController *controller = [[HouseRentAuditViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        }else if([responseObject[@"state"] isEqualToString:@"2"])
        {
            CheckUserInfoViewController *controller = [[CheckUserInfoViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];

            
        }else if ([responseObject[@"state"] isEqualToString:@"3"])
        {
            UpLoadIDFatherViewController *controller = [[UpLoadIDFatherViewController alloc]init];
            controller.notioceString = @"您的资料未通过审核,请重新上传资料";
            [self.navigationController pushViewController:controller animated:YES];
        }else
        {
            UpLoadIDFatherViewController *controller = [[UpLoadIDFatherViewController alloc]init];
            controller.notioceString = @"请上传资料进行审核，审核通过后可进行房租缴纳";
            [self.navigationController pushViewController:controller animated:YES];
        }
    
    }
}
- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{
 
}
//sectionheader 更多查看
- (void)moreCoverButtonClick:(UIButton *)btn
{
    if (![self loginOrNot])
    {
        return;
    }
    NewThingsViewController * ntVC= [[NewThingsViewController alloc] init];
    [self.navigationController pushViewController:ntVC animated:YES];

}

//两个图标点击
- (void)bottomButtonClick:(UIButton *)button
{
    if (![self loginOrNot])
    {
        return;
    }
    
    RushPurchaseViewController *controller = [[RushPurchaseViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)imageTapAction:(UIButton *)btn
{
    if (![self loginOrNot])
    {
        return;
    }

    NSInteger tagValue = (btn.tag-1000)-1;
    switch (tagValue) {
        case 0:
        {
            ProjectApplyForViewController *controller = [[ProjectApplyForViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 1:
        {
            DecorationCarMainController *controller = [[DecorationCarMainController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 2:
        {
            FundSupportViewController *controller = [[FundSupportViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 3:
        {
            NetManagerVC *controller = [[NetManagerVC alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }

    }
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (![self loginOrNot])
    {
        return;
    }
    if (cycleScrollView == _adScrollview) {
        HomePageModel *model = _IndexSlideshowList[index];
        ProjectApplyForWebDetailViewController *controller = [[ProjectApplyForWebDetailViewController alloc]init];
        controller.pageType = @"webUrl";
        controller.naviTitleString = @"";
        controller.contentUrl = model.url;
        [self.navigationController pushViewController:controller animated:YES];
    }
    if (cycleScrollView == _playTogetherScrollview) {
        HomePageModel *model = _PlaySlideshowList[index];
        if ([model.id isEqualToString:@""]) {
            PlayTogetherViewController *controller = [[PlayTogetherViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        }else
        {
            PlayTogetherDetailViewController *controller = [[PlayTogetherDetailViewController alloc]init];
            controller.activityID = model.id;
            controller.official = model.official;
            [self.navigationController pushViewController:controller animated:YES];
        }
      
    }
}


//按钮图标在右边的情况   如 ：详情>
- (UIButton *)createButtonWithTitle:(NSString *)titleString andImagePath:(NSString *)imagePath baseView:(UIView *)topView
{
    UILabel *describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    describeLabel.textColor = colorWithBlack;
    describeLabel.text = titleString;
    describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [describeLabel sizeToFitHorizontal];
    
    //大button
    UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-describeLabel.width-10-20, 0, describeLabel.width+20, 40)];
    [coverButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
    NSTextAttachment *attatchment = [[NSTextAttachment alloc] init];
    attatchment.image = [UIImage imageNamed:imagePath];
    attatchment.bounds = CGRectMake(0, -3, attatchment.image.size.width, attatchment.image.size.height);
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",titleString]]];
    [attributedText appendAttributedString:[NSAttributedString attributedStringWithAttachment:attatchment]];
    [coverButton setAttributedTitle:attributedText forState:UIControlStateNormal];
    return coverButton;
}
- (void)HomePageTableViewCellTapImageViewWithIndex:(int)index
{
    if (![self loginOrNot])
    {
        return;
    }
    NSMutableArray *array = _listArray[0];
    HomePageModel *model = array[index];
    switch (index) {
        case 0:
        {
            if ([model.id isEqualToString:@""]) {
                OfficePurchaseViewController *vc = [[OfficePurchaseViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                OfficePurchaseDetailViewController *vc = [[OfficePurchaseDetailViewController alloc] init];
                vc.commodityID = model.id;
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
        case 1:
        {
            if ([model.id isEqualToString:@""]) {
                [self.tabBarController setSelectedIndex:2];

                //                RushPurchaseViewController *vc = [[RushPurchaseViewController alloc] init];
//                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                RushPurchaseDetailViewController *vc = [[RushPurchaseDetailViewController alloc] init];
                vc.itemId = model.id;
                [self.navigationController pushViewController:vc animated:YES];
            }

            break;
        }
        case 2:
        {
            if ([model.id isEqualToString:@""]) {
                SeccondHandExchangeViewController *vc = [[SeccondHandExchangeViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                BabyDetailsController *vc = [[BabyDetailsController alloc] init];
                vc.idString = model.id;
                [self.navigationController pushViewController:vc animated:YES];
            }

            break;
        }
    }
  
}

#pragma mark-----dingwei

- (CLLocationManager    *)locationManager {
    if ([CLLocationManager locationServicesEnabled]) {
        if (_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc]init];
            _locationManager.delegate = self;
            _currentCity = [[NSString alloc]init];
            [_locationManager requestWhenInUseAuthorization];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.distanceFilter = 5.0;
        }
    }
    return _locationManager;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
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
                self.nowLocalAddress = [NSString stringWithFormat:@"%@",placeMark.administrativeArea];
                self.navigationItem.titleView = _coverLeftNaviButton;
                [_coverLeftNaviButton setTitle:self.nowLocalAddress forState:UIControlStateNormal];
            }else
            {
                self.nowLocalAddress = [NSString stringWithFormat:@"%@%@",placeMark.administrativeArea,_currentCity];
                self.navigationItem.titleView = _coverLeftNaviButton;
                [_coverLeftNaviButton setTitle:self.nowLocalAddress forState:UIControlStateNormal];
            }
            
        }else if (error == nil && placemarks.count){
            NSLog(@"NO location and error return");
        }else if (error){
            [_coverLeftNaviButton setTitle:@"青网欢迎您" forState:UIControlStateNormal];
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

@end
