//
//  ProjectApplyForViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ProjectApplyForViewController.h"
#import "LXScollTitleView.h"
#import "LXScrollContentView.h"
#import "CrowdFundingAddProjectChooseTypeModel.h"
#import "ProjectApplyModel.h"
#define heraderHeight (YGScreenWidth/2*2+45+50)


#import "ProjectApplyMainTableViewCell.h"
#import "ProjectApplyForSubModel.h"
#import "ProjectApplyDetailViewController.h"
#import "ProjectApplyForWebDetailViewController.h"

@interface ProjectApplyForViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray          *dataSource;  //数据源
@property (nonatomic, strong) LXScollTitleView *titleView;
@property (nonatomic, assign) int       index;

@end

@implementation ProjectApplyForViewController
{
    SDCycleScrollView *_adScrollview; //广告轮播
    UIView          *_baseView;
    UILabel *_titleLabel;
    UILabel *_newPriceLabel;
    UILabel  *_oldPriceLabel;
    UIImageView *_posterImageView; //海报
    NSMutableArray                      *_typeArr;          //类型数组
    NSMutableArray                      *_titleArr;          //类型数组
    NSMutableArray * _controllersArray;//Controller数组
    //    UIScrollView * _scrollView;
    UIView *_titleBaseView;
    UILabel  *_noResumeLabel;
    
    
    
    NSMutableArray *_listArray;
    UITableView *_tableView;
    NSMutableArray *_commentArray;
    UIView *_topBaseView;
    
    NSArray *_imgList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configAttribute];
    [self loadData];
}

#pragma mark ---- 重写导航条
- (void)configAttribute
{
    UILabel *naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth - 100, 20)];
    naviTitleLabel.textColor = KCOLOR_WHITE;
    naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    naviTitleLabel.text = @"项目申报" ;
    
    [naviTitleLabel sizeToFit];
    naviTitleLabel.frame = CGRectMake(YGScreenWidth/2-naviTitleLabel.width/2, 0, naviTitleLabel.width, 20);
    self.navigationItem.titleView = naviTitleLabel;
    
    _typeArr = [[NSMutableArray alloc] init];
    _titleArr = [[NSMutableArray alloc] init];
    
    self.view.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-45);
    _listArray = [[NSMutableArray alloc] init];
   
}

- (void)loadData
{
    
    [YGNetService YGPOST:REQUEST_DeclarePicture parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        _imgList =[[NSArray alloc] initWithArray:[ProjectApplyModel  mj_objectArrayWithKeyValuesArray:responseObject[@"imgList"]]];
        ProjectApplyModel *topImageModel = _imgList[0];
        
        
        _typeArr = [CrowdFundingAddProjectChooseTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"titleList"]];
        CrowdFundingAddProjectChooseTypeModel *typeAllModel = [[CrowdFundingAddProjectChooseTypeModel alloc] init];
        typeAllModel.id = @"";
        typeAllModel.grade = @"全部";
        [_typeArr insertObject:typeAllModel atIndex:0];
        
        for (CrowdFundingAddProjectChooseTypeModel *model in _typeArr) {
            [_titleArr addObject:model.grade];
        }
        _index = 0;
        [self configUI];
        [self.titleView reloadViewWithTitles:_titleArr];
        [_posterImageView sd_setImageWithURL:[NSURL URLWithString:topImageModel.picture] placeholderImage:YGDefaultImgTwo_One];
        
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        
        for (ProjectApplyModel *model in _imgList) {
            if (![model.position isEqualToString:@"1"]) {
                [imageArray addObject:model.picture];
            }
        }
        _adScrollview.imageURLStringsGroup = imageArray;
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark ---- 配置UI
-(void)configUI
{
    
    /********************** 头视图两个按钮 *****************/
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, heraderHeight)];
    _baseView.backgroundColor = colorWithYGWhite;
    
    
    _posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth/2)];
    _posterImageView.contentMode = UIViewContentModeScaleAspectFill;
    _posterImageView.clipsToBounds = YES;
    _posterImageView.userInteractionEnabled = YES;
    [_baseView addSubview:_posterImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(posterImageViewTapAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_posterImageView addGestureRecognizer:tap];
    
    //热门推荐label
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _titleLabel.text = @"合作成果展示";
    _titleLabel.frame = CGRectMake(15, _posterImageView.height,YGScreenWidth-30, 45);
    [_baseView addSubview:_titleLabel];
    
    
    
    //广告滚动
    _adScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, YGScreenWidth/2+45, YGScreenWidth, YGScreenWidth/2) delegate:self placeholderImage:YGDefaultImgTwo_One];
    _adScrollview.imageURLStringsGroup = @[@"http://i4.eiimg.com/567571/c6639be3ed7ea595.png",@"http://i4.eiimg.com/567571/c6639be3ed7ea595.png",@"http://i4.eiimg.com/567571/c6639be3ed7ea595.png",@"http://i4.eiimg.com/567571/c6639be3ed7ea595.png"];
    _adScrollview.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _adScrollview.autoScroll = YES;
    _adScrollview.infiniteLoop = YES;
    _adScrollview.delegate = self;
    //    _adScrollview.localizationImageNamesGroup = @[@"home_tool1.png",@"home_tool1.png"];
    [_baseView addSubview:_adScrollview];
    

    
    /********************** 分割线 ********************/
    UIView *seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, _adScrollview.y+_adScrollview.height, YGScreenWidth, 10)];
    seperateView.backgroundColor = colorWithTable;
    [_baseView addSubview:seperateView];
    
    /********************** 选择器 ********************/
    
    _titleBaseView  = [[UIView alloc] initWithFrame:CGRectMake(0, _baseView.height-40, YGScreenWidth,40)];
    _titleBaseView.backgroundColor = colorWithYGWhite;
    [_baseView addSubview:_titleBaseView];
    
    self.titleView = [[LXScollTitleView alloc] initWithFrame:CGRectZero];
    self.titleView.backgroundColor = colorWithYGWhite;
    __weak typeof(self) weakSelf = self;
    self.titleView.selectedBlock = ^(NSInteger index){
        __weak typeof(self) strongSelf = weakSelf;
        weakSelf.index = (int)index;
        [strongSelf refreshActionWithIsRefreshHeaderAction:YES];
    };
    self.titleView.titleWidth = 110.f;
    self.titleView.normalColor = colorWithBlack;
    self.titleView.selectedColor = colorWithMainColor;
    [_titleBaseView addSubview:self.titleView];
    
    //tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[ProjectApplyMainTableViewCell class] forCellReuseIdentifier:@"TradeRecordCell"];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = _baseView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [self refreshActionWithIsRefreshHeaderAction:YES];
}



- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.titleView.frame = CGRectMake(15, self.titleView.y, self.view.frame.size.width-15, 40);
    
//    self.contentView.frame = CGRectMake(0, self.contentView.y, self.view.frame.size.width, self.view.frame.size.height - 50);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_tableView.contentOffset.y>=_baseView.height-40) {
        _titleBaseView.y = 0;
        [self.view addSubview:_titleBaseView];
    }
    if (_tableView.contentOffset.y<_baseView.height-40) {
        _titleBaseView.y = _baseView.height-40;
        [_baseView addSubview:_titleBaseView];
    }
}


- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    CrowdFundingAddProjectChooseTypeModel *model = _typeArr[_index];

    [YGNetService YGPOST:REQUEST_DeclareFund parameters:@{@"gradeId":model.id,@"total":self.totalString,@"count":self.countString}  showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }
        
        [_listArray addObjectsFromArray:[ProjectApplyForSubModel mj_objectArrayWithKeyValuesArray:responseObject[@"fund"]]];
        
        [_noResumeLabel removeFromSuperview];
        if (_listArray.count == 0 ) {
            _noResumeLabel = [[UILabel alloc] init];
            _noResumeLabel.textColor = colorWithDeepGray;
            _noResumeLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
            _noResumeLabel.text = @"没有数据哦~";
            [_tableView addSubview:_noResumeLabel];
            [_noResumeLabel sizeToFit];
            _noResumeLabel.centerx = YGScreenWidth / 2;
            _noResumeLabel.y = heraderHeight+30;
        }
        if ([responseObject[@"fund"] count] <= 10) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectApplyMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradeRecordCell" forIndexPath:indexPath];
    cell.backgroundColor = colorWithYGWhite;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:_listArray[indexPath.row]];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectApplyForSubModel *model = _listArray[indexPath.section];
    ProjectApplyDetailViewController*vc = [[ProjectApplyDetailViewController alloc] init];
    vc.itemID = model.ids;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)posterImageViewTapAction
{
    ProjectApplyModel *topImageModel = _imgList[0];
    ProjectApplyForWebDetailViewController *vc = [[ProjectApplyForWebDetailViewController alloc] init];
    vc.contentUrl = topImageModel.cooperationPictures;
    vc.naviTitleString = @"详情介绍";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma 轮播代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    ProjectApplyModel *topImageModel = _imgList[index+1];

    ProjectApplyForWebDetailViewController *vc = [[ProjectApplyForWebDetailViewController alloc] init];
    vc.contentUrl = topImageModel.cooperationPictures;
    vc.naviTitleString = @"成果展示";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
