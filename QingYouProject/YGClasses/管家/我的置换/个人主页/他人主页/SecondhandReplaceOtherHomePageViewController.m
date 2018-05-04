//
//  SecondhandReplaceOtherHomePageViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplaceOtherHomePageViewController.h"
#import "SecondhandReplaceOtherHomePageModel.h"
#import "SecondhandReplaceOtherHomePageTableViewCell.h"
#import "BabyDetailsController.h"

#define heraderHeight (210+60+10)

@interface SecondhandReplaceOtherHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    
    UILabel *_signLabel;
    NSMutableArray * _controllersArray;//Controller数组
    UIView *_titleBaseView;
    UILabel  *_noResumeLabel;
    UIImageView  *_noDataImageView;

    NSMutableArray *_dataArray;
    UITableView *_tableView;
    UIView *_topBaseView;
    SecondhandReplaceOtherHomePageModel *_userModel;
    int _index;
    UIImageView *_coverImageView;
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UIView *headerView;
    UIView *_segmentBaseView;
    NSDictionary * _dict;
    UIImageView *_realeNameImageView;
    UIButton *_focusButton;
}
@end

@implementation SecondhandReplaceOtherHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [[NSMutableArray alloc]init];
    [self loadData];
}
#pragma mark ---- 配置UI
-(void)configUI
{
    
    /********************** 头视图两个按钮 *****************/
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, heraderHeight)];
    headerView.backgroundColor = colorWithYGWhite;
    //水滴
    _coverImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"steward_rencai_bg"]];
    _coverImageView.frame = CGRectMake(0,0,YGScreenWidth, 220);
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    _coverImageView.clipsToBounds = YES;
    _coverImageView.userInteractionEnabled = YES;
    _coverImageView.backgroundColor = colorWithMainColor;
    [headerView addSubview:_coverImageView];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, _coverImageView.height)];
    alphaView.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.3];
    [_coverImageView addSubview:alphaView];
    
    //头像
    _headerImageView = [[UIImageView alloc]init];
//    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_userModel.userImg] placeholderImage:YGDefaultImgAvatar];
    _headerImageView.frame = CGRectMake(0,25,70, 70);
    _headerImageView.layer.cornerRadius = 35;
    _headerImageView.layer.borderColor = colorWithTable.CGColor;
    _headerImageView.layer.borderWidth = 1;
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.clipsToBounds = YES;
    _headerImageView.backgroundColor = colorWithMainColor;
    [alphaView addSubview:_headerImageView];
    _headerImageView.centerx = alphaView.centerx;
    
    
     _focusButton= [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-100, 40, 70, 30)];
    [_focusButton addTarget:self action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _focusButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [_focusButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [_focusButton setTitle:@"关注Ta" forState:UIControlStateNormal];
    [_focusButton setTitle:@"取消关注" forState:UIControlStateSelected];
    _focusButton.layer.borderColor = colorWithYGWhite.CGColor;
    _focusButton.layer.borderWidth = 1;
    _focusButton.layer.cornerRadius = 15;
    _focusButton.clipsToBounds = YES;
    [alphaView addSubview:_focusButton];
    _focusButton.centery = _headerImageView.centery;
    _focusButton.selected = [_dict[@"colFlag"] boolValue];
    
    if([YGSingletonMarco.user.userId isEqualToString:self.otherId])
    {
        _focusButton.hidden = YES;
    }
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _headerImageView.y+_headerImageView.height+10, YGScreenWidth-20, 20)];
    _nameLabel.textColor = colorWithYGWhite;
    _nameLabel.text = _dict[@"uName"];
    CGFloat nameLabelW = [UILabel calculateWidthWithString:_dict[@"uName"] textFont:[UIFont systemFontOfSize:YGFontSizeBigTwo] numerOfLines:1].width;
    _nameLabel.width = nameLabelW;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    [alphaView addSubview:_nameLabel];
    _nameLabel.centerx = alphaView.centerx;
    
    _realeNameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_nameLabel.x + _nameLabel.width + 5, _nameLabel.y + 3, 52, 14)];
    NSString * authFlag = [NSString stringWithFormat:@"%@",_dict[@"authFlag"]] ;
    if([authFlag isEqualToString:@"1"])
        _realeNameImageView.image =[UIImage imageNamed:@"home_playtogether_realname"];
    else
        _realeNameImageView.hidden =YES;
    [alphaView addSubview:_realeNameImageView];
    
    //热门推荐label
    _signLabel = [[UILabel alloc]init];
    _signLabel.textColor = colorWithYGWhite;
    _signLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _signLabel.text = _dict[@"uDis"];
    //简介部分判断修改
    if([_dict[@"uDis"] isEqualToString:@"说点什么，介绍一下你自己~"])
        _signLabel.text = @"Ta很懒，什么都没有留下。";
    _signLabel.textAlignment = NSTextAlignmentCenter;
    _signLabel.frame = CGRectMake(15, _nameLabel.y+_nameLabel.height+7,YGScreenWidth-30, 20);
    [alphaView addSubview:_signLabel];
    
    //    /********************** 分割线 ********************/
    
    /********************** 选择器 ********************/
    
    _titleBaseView  = [[UIView alloc] initWithFrame:CGRectMake(0, _coverImageView.height-55, YGScreenWidth,50)];
    [alphaView addSubview:_titleBaseView];
    
    NSArray *titleArr = @[@"收藏",@"关注",@"粉丝"];
    NSArray *contentArr ;
//  @[_userModel.activityCount,_userModel.memberCount,_userModel.attentionCount];
    
    for (int i = 0; i<3; i++)
    {
        UIView *contentBaseView  = [[UIView alloc] initWithFrame:CGRectMake(YGScreenWidth/3*i, 0, YGScreenWidth/3,60)];
        [_titleBaseView addSubview:contentBaseView];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth/3, 20)];
        contentLabel.textColor = colorWithYGWhite;
        contentLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        contentLabel.text = contentArr[i];
        contentLabel.tag = 10000+i;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        [contentBaseView addSubview:contentLabel];
        
        //热门推荐label
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, YGScreenWidth/3, 20)];
        titleLabel.textColor = colorWithYGWhite;
        titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        titleLabel.text = titleArr[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [contentBaseView addSubview:titleLabel];
        
        
        
        if (i == 1 || i == 2)
        {
            UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 1,25)];
            lineView.backgroundColor = colorWithYGWhite;
            [contentBaseView addSubview:lineView];
        }
        
    }
    
    UIView *oldLineView = [[UIView alloc] initWithFrame:CGRectMake(0,headerView.height-60, YGScreenWidth, 10)];
    oldLineView.backgroundColor = colorWithLine;
    [headerView addSubview:oldLineView];
    
    UILabel * showLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, oldLineView.height + oldLineView.y, YGScreenWidth -20 , 50)];
    showLabel.text =@"Ta的宝贝";
    [headerView addSubview:showLabel];

    
    //tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SecondhandReplaceOtherHomePageTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SecondhandReplaceOtherHomePageTableViewCellID];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.rowHeight = 90;

    _tableView.sectionFooterHeight = 0.001;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
 
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
  
}
- (void)loadData
{
    [YGNetService YGPOST:@"replacementOthersPage" parameters:@{@"uid":YGSingletonMarco.user.userId,@"otherId":self.otherId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        _dict = [[NSDictionary alloc]init];
        _dict  = responseObject;
        
     
        
         self.naviTitle =[NSString stringWithFormat:@"%@的主页",responseObject[@"uName"]];
        
        [self configUI];
        NSString * colCounts  = [NSString stringWithFormat:@"%@",responseObject[@"colCounts"]];
        NSString * dolCounts = [NSString stringWithFormat:@"%@",responseObject[@"dolCounts"]];
        NSString * fanCounts = [NSString stringWithFormat:@"%@",responseObject[@"fanCounts"]];
        
        NSArray *contentArr = @[colCounts,dolCounts,fanCounts];
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"uImg"]] placeholderImage:YGDefaultImgAvatar];
        
        for (int i = 0; i<3; i++)
        {
            UILabel *label = [_titleBaseView viewWithTag:10000+i];
            label.text = contentArr[i];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)focusButtonAction:(UIButton *)btn
{
    [YGNetService YGPOST:@"replacementAttention" parameters:@{@"uid":YGSingletonMarco.user.userId,@"oid":self.otherId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        btn.selected = !btn.selected;
        [YGNetService YGPOST:@"replacementOthersPage" parameters:@{@"uid":YGSingletonMarco.user.userId,@"otherId":self.otherId} showLoadingView:NO scrollView:nil success:^(id responseObject) {


            NSString * colCounts  = [NSString stringWithFormat:@"%@",responseObject[@"colCounts"]];
            NSString * dolCounts = [NSString stringWithFormat:@"%@",responseObject[@"dolCounts"]];
            NSString * fanCounts = [NSString stringWithFormat:@"%@",responseObject[@"fanCounts"]];
            
            NSArray *contentArr = @[colCounts,dolCounts,fanCounts];
            
            for (int i = 0; i<3; i++)
            {
                UILabel *label = [_titleBaseView viewWithTag:10000+i];
                label.text = contentArr[i];
            }
            
            
        } failure:^(NSError *error) {
            
        }];
        
       
    } failure:^(NSError *error) {

    }];
}
#pragma mark - 网络请求
//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    NSDictionary *parameters = @{
                                 @"otherId":self.otherId,
                                 @"count":self.countString,
                                 @"total":self.totalString
                                 };
    NSString *url = @"replacementOthersMes";
    
    //如果不是加载过缓存
    if (!self.isAlreadyLoadCache)
    {
        //加载缓存数据
        NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
                [_dataArray addObjectsFromArray:[SecondhandReplaceOtherHomePageModel mj_objectArrayWithKeyValuesArray:cacheDic[@"mList"]]];
        [_tableView reloadData];
        self.isAlreadyLoadCache = YES;
    }
    
    [YGNetService YGPOST:url
              parameters:parameters
         showLoadingView:NO
              scrollView:_tableView
                 success:^( id responseObject) {
                     //如果是刷新
                     if (headerAction)
                     {
                         //先移除数据源所有数据
                         [_dataArray removeAllObjects];
                     }
                     //如果是加载
                     else
                     {
                         //判断服务器返回的数组是不是没数据了，如果没数据
                         if ([responseObject[@"mList"] count] == 0)
                         {
                             //调用一下没数据的方法，告诉用户没有更多
                             [self noMoreDataFormatWithScrollView:_tableView];
                             return;
                         }
                     }
                     
                    
                     
                     //将字典数组转化为模型数组，再加入到数据源
                    [_dataArray addObjectsFromArray:[SecondhandReplaceOtherHomePageModel mj_objectArrayWithKeyValuesArray:responseObject[@"mList"]]];
                    
                     [_noResumeLabel removeFromSuperview];
                     [_noDataImageView removeFromSuperview];

                     if (_dataArray.count == 0 ) {
                         
                         _noDataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodata"]];
                         [_noDataImageView sizeToFit];
                         [_tableView addSubview:_noDataImageView];
                         
                         _noDataImageView.centerx = YGScreenWidth / 2;
                         _noDataImageView.centery = heraderHeight+30 +_noDataImageView.height ;
                     }
                     [_tableView reloadData];
                 } failure:^(NSError *error)
     {
         [self addNoNetRetryButtonWithFrame:_tableView.frame listArray:_dataArray];
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BabyDetailsController *vc = [[BabyDetailsController alloc]init];
    vc.idString = [_dataArray[indexPath.row] valueForKey:@"ID"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SecondhandReplaceOtherHomePageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SecondhandReplaceOtherHomePageTableViewCellID];
    cell.model = self.dataArray[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


static NSString * const SecondhandReplaceOtherHomePageTableViewCellID = @"SecondhandReplaceOtherHomePageTableViewCellID";


- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
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
