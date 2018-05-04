//
//  DesignEffectViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "DesignEffectViewController.h"
#import "DesignEffectCell.h"
#import "CutomCollectionViewLayout.h"
#import "KSPhotoBrowser.h"
#import "ApplyInformationViewController.h"
#import "DesignEffectModel.h"


@interface DesignEffectViewController ()<CutomCollectionViewLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)KSPhotoBrowser *browser;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSString *effectIdString;
@property(nonatomic,strong)NSString *designerIdString;
@property(nonatomic,assign)NSInteger selectItem;//选中的item是第几个
@property(nonatomic,strong)NSMutableArray *picDetailArray;//详细图片数组
@property(nonatomic,strong)NSMutableArray *picNameArray;//详细Name
@property(nonatomic,strong) UILabel *companyLabel;//公司名


@end

@implementation DesignEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"设计效果";
     _picNameArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KSPhotoBrowserScroll:) name:@"KSPhotoBrowserScroll" object:nil];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _dataArray = [NSMutableArray array];
    _picDetailArray = [NSMutableArray array];
   
    [self configUI];
   
}

-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:@"getEffectById" parameters:@{@"id":self.caseId,@"total":self.totalString,@"count":self.countString} showLoadingView:YES scrollView:_collectionView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if (((NSArray *)responseObject[@"eList"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_collectionView];
        }
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
         _dataArray = [DesignEffectModel mj_objectArrayWithKeyValuesArray:responseObject[@"elist"]];
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_collectionView headerAction:YES];
        [_collectionView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

//图片详情
-(void)loadDetailData
{
    [YGNetService YGPOST:@"getEffectDetailById" parameters:@{@"id":self.effectIdString} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        self.picDetailArray = [responseObject valueForKey:@"pList"];
        
        [self pushDetailVC];
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)configUI
{
    CutomCollectionViewLayout *layout = [[CutomCollectionViewLayout alloc]init];
    layout.delegate = self;

    //创建UICollectionView对象, 将layout添加到collectionViewLayout:里面
    self.collectionView =  [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight) collectionViewLayout:layout];
//    self.collectionView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight);
    self.collectionView.backgroundColor = colorWithTable;
    // 设置数据源,展示数据
    self.collectionView.dataSource = self;
    //设置代理,监听
    self.collectionView.delegate = self;
    /* 设置UICollectionView的属性 */
//    //设置滚动条
//    self.collectionView.showsHorizontalScrollIndicator = NO;
//    self.collectionView.showsVerticalScrollIndicator = NO;
    //设置是否需要弹簧效果
    self.collectionView.bounces = NO;
    
    [self.view addSubview:self.collectionView];
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"DesignEffectCell" bundle:nil] forCellWithReuseIdentifier:@"DesignEffectCell"];
    
    [self createRefreshWithScrollView:_collectionView containFooter:YES];
    [_collectionView.mj_header beginRefreshing];
}
// 告诉系统一共多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 告诉系统每组多少个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

// 告诉系统每个Cell如何显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 1.从缓存池中取
    static NSString *ID = @"DesignEffectCell";
    DesignEffectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = _dataArray[indexPath.item];
    return cell;
}
#pragma mark -UICollectionViewDelegate
//UICollectionView被选中的时候调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectItem = indexPath.item;
    self.effectIdString = [_dataArray[indexPath.item] valueForKey:@"ID"];
    self.designerIdString = [_dataArray[indexPath.item] valueForKey:@"designer"];
    [self loadDetailData];
    
}
-(CGSize)itemSizeForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
//    UIImage *image = imageArray[indexPath.item];
    CGFloat width = self.view.frame.size.width;
    if(indexPath.item == 0)
    {
        return CGSizeMake((width-10*2-10)/2,(width-10*2-10)/2 * 1.01);
    }
    return CGSizeMake((width-10*2-10)/2, (width-10*2-10)/2 * 1.13);
    
    //    return CGSizeMake((width-10*2-10)/2,image.size.height/image.size.width*(width-10*2-10)/2 );
}

//查看详情
-(void)pushDetailVC
{
    DesignEffectCell * cell = (DesignEffectCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectItem inSection:0]];
    NSMutableArray *items = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < _picDetailArray.count; i++)
    {
//        NSString *pickey = [NSString stringWithFormat:@"pictureUrl%d",i + 1];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:(UIImageView *)cell.picImageView imageUrl:[NSURL URLWithString:[_picDetailArray[i] valueForKey:@"pictureUrl"]]];
        [items addObject:item];
        
//        NSString *picNameKey = [NSString stringWithFormat:@"pictureName%d",i + 1];
        [self.picNameArray addObject:[_picDetailArray[i] valueForKey:@"pictureName"]];
        
    }
    self.browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:0];
    self.browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    self.browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    self.browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
    self.browser.noSingleTap = YES;
    
    self.companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, YGScreenHeight - 50, YGScreenWidth - 100, 20)];
    self.companyLabel.backgroundColor = [UIColor clearColor];
    self.companyLabel.textColor = [UIColor whiteColor];
    self.companyLabel.font = [UIFont systemFontOfSize:15.0];
    //    companyLabel.text = @"公司休息室";
    [self.browser.view addSubview:self.companyLabel];
    
    UILabel *desingerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, YGScreenHeight - 30, YGScreenWidth - 100, 20)];
    desingerLabel.textAlignment = NSTextAlignmentLeft;
    desingerLabel.backgroundColor = [UIColor clearColor];
    desingerLabel.textColor = [UIColor whiteColor];
    desingerLabel.font = [UIFont systemFontOfSize:15.0];
    desingerLabel.text = [self.dataArray[_selectItem] valueForKey:@"pictureName1"];
    [desingerLabel sizeToFit];
    [self.browser.view addSubview:desingerLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 15, 60, 30);
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_white_left"] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    backButton.layer.cornerRadius = 15;
    [backButton addTarget:self action:@selector(backNow:) forControlEvents:UIControlEventTouchUpInside];
    [self.browser.view addSubview:backButton];
    
    
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applyButton.frame = CGRectMake(YGScreenWidth - 90, 15, 80, 28);
    applyButton.backgroundColor = colorWithMainColor;
    [applyButton setTitle:@"立即申请" forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    applyButton.layer.cornerRadius = 14;
    [applyButton addTarget:self action:@selector(applyNow:) forControlEvents:UIControlEventTouchUpInside];
    [self.browser.view addSubview:applyButton];
    [self.browser showFromViewController:self];
}

//图片返回
-(void)backNow:(UIButton *)button
{
    [self.browser showDismissalAnimation];
}

//立即申请
-(void)applyNow:(UIButton *)button
{
    [self.browser showDismissalAnimation];
    ApplyInformationViewController *vc = [[ApplyInformationViewController alloc]init];
    vc.effectIdString = self.effectIdString;
    vc.designerIdString = self.designerIdString;
    [self.navigationController pushViewController:vc animated:YES];
}

//
-(void)KSPhotoBrowserScroll:(NSNotification *)noti
{
    NSInteger pageIndex = [[noti.userInfo valueForKey:@"index"] integerValue];
    self.companyLabel.text = self.picNameArray[pageIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
