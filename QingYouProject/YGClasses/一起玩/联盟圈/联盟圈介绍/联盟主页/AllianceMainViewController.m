//
//  AllianceMainViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/29.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceMainViewController.h"
//#define heraderHeight (YGScreenWidth*0.53+60+10)
#define heraderHeight (230+50)

#import "YGSegmentView.h"

#import "AllianceMainTableViewCell.h"
#import "PlayTogetherDetailViewController.h"
#import "AllianceMainModel.h"

#import "AllianceMainMemberViewController.h"
#import "AllianceMainSettingViewController.h"
#import "PublishActivityController.h"
#import "AllianceMainEditPostViewController.h"

@interface AllianceMainViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@end

@implementation AllianceMainViewController
{
    YGSegmentView * _segmentView;//选择器
    UILabel *_signLabel;
    NSMutableArray * _controllersArray;//Controller数组
    UIView *_titleBaseView;
    UILabel  *_noResumeLabel;
    NSMutableArray *_listArray;
    UITableView *_tableView;
    UIView *_topBaseView;
    AllianceMainModel *_userModel;
    int _index;
    UIImageView *_coverImageView;
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UIView *headerView;
    UIView *_segmentBaseView;
    UIImageView *_noDataImageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
#pragma mark ---- 重写导航条
- (void)configAttribute
{
    
    
    UILabel *naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth - 100, 20)];
    naviTitleLabel.textColor = colorWithBlack;
    naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    naviTitleLabel.text = @"联盟主页" ;
    
    [naviTitleLabel sizeToFit];
    naviTitleLabel.frame = CGRectMake(YGScreenWidth/2-naviTitleLabel.width/2, 0, naviTitleLabel.width, 20);
    self.navigationItem.titleView = naviTitleLabel;
    

    
    self.view.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-45);
    _listArray = [[NSMutableArray alloc] init];
    _userModel = [[AllianceMainModel alloc] init];
}

- (void)loadData
{

    [YGNetService YGPOST:REQUEST_AllianceIndex parameters:@{@"allianceID":_allianceID,@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        [_userModel setValuesForKeysWithDictionary:responseObject];
        _index = 0;
        NSArray *contentArr = @[_userModel.activityCount,_userModel.memberCount,_userModel.attentionCount];

        for (int i = 0; i<3; i++)
        {
            UILabel *label = [_titleBaseView viewWithTag:10000+i];
            label.text = contentArr[i];
        }
        for (UIView *view in self.view.subviews) {
            [view removeFromSuperview];
        }
        [self configUI];
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_userModel.userImg] placeholderImage:YGDefaultImgAvatar];

    } failure:^(NSError *error) {

    }];


}
#pragma mark ---- 配置UI
-(void)configUI
{
    
    /********************** 头视图两个按钮 *****************/
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, heraderHeight)];
    headerView.backgroundColor = colorWithYGWhite;
    //水滴
    _coverImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"steward_rencai_bg"]];
    _coverImageView.frame = CGRectMake(0,0,YGScreenWidth, 230);
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
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_userModel.userImg] placeholderImage:YGDefaultImgAvatar];
    _headerImageView.frame = CGRectMake(0,25,70, 70);
    _headerImageView.layer.cornerRadius = 35;
    _headerImageView.layer.borderColor = colorWithTable.CGColor;
    _headerImageView.layer.borderWidth = 1;
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.clipsToBounds = YES;
    _headerImageView.backgroundColor = colorWithMainColor;
    [alphaView addSubview:_headerImageView];
    _headerImageView.centerx = alphaView.centerx;
    
    
    UIButton *focusButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-100, 40, 70, 30)];
    [focusButton addTarget:self action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    focusButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [focusButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [focusButton setTitle:@"关注Ta" forState:UIControlStateNormal];
    [focusButton setTitle:@"取消关注" forState:UIControlStateSelected];
    focusButton.layer.borderColor = colorWithYGWhite.CGColor;
    focusButton.layer.borderWidth = 1;
    focusButton.layer.cornerRadius = 15;
    focusButton.clipsToBounds = YES;
    [alphaView addSubview:focusButton];
    focusButton.centery = _headerImageView.centery;
    focusButton.selected = [_userModel.isAttention boolValue];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _headerImageView.y+_headerImageView.height+10, YGScreenWidth-20, 20)];
    _nameLabel.textColor = colorWithYGWhite;
    _nameLabel.text = _userModel.userName;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    [alphaView addSubview:_nameLabel];
    
    //热门推荐label
    _signLabel = [[UILabel alloc]init];
    _signLabel.textColor = colorWithYGWhite;
    _signLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _signLabel.text = _userModel.allianceInfo;
    _signLabel.textAlignment = NSTextAlignmentCenter;
    _signLabel.frame = CGRectMake(15, _nameLabel.y+_nameLabel.height+7,YGScreenWidth-30, 20);
    [alphaView addSubview:_signLabel];

    //    /********************** 分割线 ********************/
    
    /********************** 选择器 ********************/
    
    _titleBaseView  = [[UIView alloc] initWithFrame:CGRectMake(0, _coverImageView.height-55, YGScreenWidth,50)];
    [alphaView addSubview:_titleBaseView];
    
    NSArray *titleArr = @[@"活动",@"参与人数",@"粉丝"];
    NSArray *contentArr = @[_userModel.activityCount,_userModel.memberCount,_userModel.attentionCount];

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
    
    UIView *oldLineView = [[UIView alloc] initWithFrame:CGRectMake(0,headerView.height-50, YGScreenWidth, 10)];
    oldLineView.backgroundColor = colorWithLine;
    [headerView addSubview:oldLineView];
    
    _segmentBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.height-40, YGScreenWidth, 40)];
    _segmentBaseView.backgroundColor = colorWithYGWhite;
    [headerView addSubview:_segmentBaseView];

    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(30, 0, YGScreenWidth-60, 40) titlesArray:@[@"进行中的活动",@"全部活动"] lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
    _segmentView.lineColor = colorWithMainColor;
    [_segmentBaseView addSubview:_segmentView];
    
    
    //tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[AllianceMainTableViewCell class] forCellReuseIdentifier:@"AllianceMainTableViewCell"];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [self refreshActionWithIsRefreshHeaderAction:YES];
    

    NSLog(@"%@",YGSingletonMarco.user.allianceID); 
    if (YGSingletonMarco.user.allianceID != nil && [YGSingletonMarco.user.allianceID isEqualToString:_allianceID]) {

        focusButton.hidden = YES;
        
        UIButton *barButton = [[UIButton alloc] initWithFrame:CGRectMake(YGScreenWidth-50, 30, 40, 40)];
        [barButton setImage:[UIImage imageNamed:@"home_playtogether_set_black"] forState:UIControlStateNormal];
        [barButton addTarget:self action:@selector(allianceSettingAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
        self.navigationItem.rightBarButtonItem = barButtonItem;
        
        _tableView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-50-YGBottomMargin);
        
        UIView *bottomView  = [[UIView alloc] initWithFrame:CGRectMake(0, YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-50-YGBottomMargin, YGScreenWidth, 50+YGBottomMargin)];
        bottomView.backgroundColor = colorWithYGWhite;
        [self.view addSubview:bottomView];
        
        NSArray *btnTitleArr = @[@{@"title":@"查看盟成员",@"img":@"home_playtogether_member"},@{@"title":@"编辑公告",@"img":@"home_playtogether_notice"}];
        for (int i = 0; i<3; i++)
        {
            UIButton *coverButton = [[UIButton alloc]init];
            coverButton.tag = 1000+i;
            [coverButton addTarget:self action:@selector(checkMemberOrEditADOrPostActivityBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            coverButton.backgroundColor = colorWithMainColor;
            coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
            [bottomView addSubview:coverButton];
            
            if (i == 0 || i == 1)
            {
                coverButton.frame = CGRectMake(YGScreenWidth/4*i, 0, YGScreenWidth/4, 50+YGBottomMargin);
                UIImage *titleImage = [UIImage imageNamed:btnTitleArr[i][@"img"]];
                coverButton.backgroundColor = colorWithYGWhite;
                [coverButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
                [coverButton setTitle:btnTitleArr[i][@"title"] forState:UIControlStateNormal];
                [coverButton setImage:titleImage forState:UIControlStateNormal];
                if (i == 1) {
                    [coverButton setImage:[UIImage imageNamed:@"collect_icon_selected_little"] forState:UIControlStateSelected];
                    coverButton.selected = NO;
                }
                [coverButton.imageView sizeToFit];
                coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
                coverButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
                [coverButton setTitleEdgeInsets:UIEdgeInsetsMake(coverButton.imageView.frame.size.height-YGBottomMargin ,-coverButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
                [coverButton setImageEdgeInsets:UIEdgeInsetsMake(-YGBottomMargin-coverButton.imageView.frame.size.height, 0.0,0.0, -coverButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
                
            }else
            {
                coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
                coverButton.frame = CGRectMake(YGScreenWidth/2, 0, YGScreenWidth/2, 50+YGBottomMargin);
                [coverButton setTitleEdgeInsets:UIEdgeInsetsMake(-YGBottomMargin ,0, 0.0,0.0)];
                coverButton.backgroundColor = colorWithMainColor;
                [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
                [coverButton setTitle:@"发布活动" forState:UIControlStateNormal];
            }
            
        }
        UIView *bottomLineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth,0.7)];
        bottomLineView.backgroundColor = colorWithLine;
        [bottomView addSubview:bottomLineView];
       
    }
    
}

#pragma mark ---- 改变当前Controller
-(void)segmentButtonClickWithIndex:(int)buttonIndex
{
    _index = buttonIndex;
    [self refreshActionWithIsRefreshHeaderAction:YES];
    
//    [UIView animateWithDuration:0.25 animations:^{
//        _scrollView.contentOffset = CGPointMake(buttonIndex * YGScreenWidth, _scrollView.contentOffset.y);
//    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_tableView.contentOffset.y>=headerView.height-40) {
        _segmentBaseView.y = 0;
        [self.view addSubview:_segmentBaseView];
    }
    if (_tableView.contentOffset.y<headerView.height-40) {
        _segmentBaseView.y = headerView.height-40;
        [headerView addSubview:_segmentBaseView];
    }
}


- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    if (headerAction == YES) {
        self.totalString = @"0";
        self.countString = @"10";
    }
    [YGNetService YGPOST:REQUEST_AllianceActivity parameters:@{@"allianceID":_allianceID,@"userID":YGSingletonMarco.user.userId,@"type":[NSString stringWithFormat:@"%d",_index+1],@"total":self.totalString,@"count":self.countString}  showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }
        [_listArray addObjectsFromArray:[AllianceMainModel mj_objectArrayWithKeyValuesArray:responseObject[@"activityList"]]];
        if ([responseObject[@"activityList"] count] < 10) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        [_noDataImageView removeFromSuperview];
        if (_listArray.count == 0 ) {
            _noDataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodata"]];
            [_noDataImageView sizeToFit];
            _noDataImageView.centerx = YGScreenWidth / 2;
            _noDataImageView.y = heraderHeight+100;
            [_tableView addSubview:_noDataImageView];
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
    AllianceMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllianceMainTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = colorWithYGWhite;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:_listArray[indexPath.row]];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllianceMainModel *model = _listArray[indexPath.row];
    if ([model.isEnd isEqualToString:@"1"]) {
        return;
    }
    PlayTogetherDetailViewController*vc = [[PlayTogetherDetailViewController alloc] init];
    vc.activityID = model.activityID;
    vc.official = model.official;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma 点击事件
- (void)allianceSettingAction
{
    AllianceMainSettingViewController *vc = [[AllianceMainSettingViewController alloc] init];
    vc.allianceID = _allianceID;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)focusButtonAction:(UIButton *)btn
{
    [YGNetService YGPOST:REQUEST_attentionAlliance parameters:@{@"allianceID":_allianceID,@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        btn.selected = !btn.selected;
        [YGNetService YGPOST:REQUEST_AllianceIndex parameters:@{@"allianceID":_allianceID,@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
            [_userModel setValuesForKeysWithDictionary:responseObject];
            NSArray *contentArr = @[_userModel.activityCount,_userModel.memberCount,_userModel.attentionCount];            
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

- (void)checkMemberOrEditADOrPostActivityBtnAction:(UIButton *)btn
{
    if (btn.tag - 1000 == 0)
    {
        AllianceMainMemberViewController *vc = [[AllianceMainMemberViewController alloc]init];
        vc.allianceID = _allianceID;
        [self.navigationController pushViewController:vc animated:YES];

    }
    if (btn.tag - 1000 == 1)
    {
        AllianceMainEditPostViewController *vc = [[AllianceMainEditPostViewController alloc]init];
        vc.allianceID = _allianceID;
        vc.content = _userModel.allianceNotice;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn.tag - 1000 == 2)
    {
        PublishActivityController *vc = [[PublishActivityController alloc] init];
#pragma 发布活动需要联盟id
        vc.allianceID = _allianceID;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
@end
