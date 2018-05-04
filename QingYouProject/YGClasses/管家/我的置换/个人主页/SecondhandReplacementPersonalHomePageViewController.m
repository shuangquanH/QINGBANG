//
//  SecondhandReplacementPersonalHomePageViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplacementPersonalHomePageViewController.h"
#import "AllianceMainModel.h"
#import "SecondhandReplacementIBoughtViewController.h"
#import "SecondhandReplacementISelloutViewController.h"
#import "SecondhandReplacementSubstitutionViewController.h"
#import "SecondhandReplacementICreateViewController.h"
#import "SecondhandReplacementICollectViewController.h"
#import "SecondhandReplacementMyInteractionViewController.h"
#import "SecondhandReplacementMyFollowViewController.h"
#import "SecondhangReplacementMyFansViewController.h"

#define heraderHeight (210+20)

@interface SecondhandReplacementPersonalHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray * _dataArray;
    UIView * _headerView;
    UIImageView *_coverImageView;
    UIImageView *_headerImageView;
    UIImageView *_realeNameImageView;

    UILabel *_nameLabel;
    UILabel *_signLabel;
    AllianceMainModel *_userModel;
    UIView *_titleBaseView;
    NSDictionary * _dict;
    NSString * _dolCounts;
    NSString * _fanCounts;
}
@end

@implementation SecondhandReplacementPersonalHomePageViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle =@"个人主页";
    self.view.backgroundColor =colorWithTable;
    
    _dataArray = @[@"我买到的",@"我卖出的",@"我的置换",@"我收藏的",@"我发布的",@"我的互动"].mutableCopy;
    self.view.backgroundColor = [UIColor whiteColor];
    
     [self configUI];
    
}
- (void)loadData
{
    [YGNetService YGPOST:@"replacementPersonlPage" parameters:@{@"uid":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        _dict = [[NSDictionary alloc]init];
        _dict  = responseObject;
       
        
        _nameLabel.text = _dict[@"uName"];
        CGFloat nameLabelW = [UILabel calculateWidthWithString:_dict[@"uName"] textFont:[UIFont systemFontOfSize:YGFontSizeBigTwo] numerOfLines:1].width;
//        _nameLabel.width = nameLabelW;
        _nameLabel.frame = CGRectMake((YGScreenWidth -  nameLabelW)/2, _headerImageView.y+_headerImageView.height+10, nameLabelW, 20);

        
        _realeNameImageView.frame = CGRectMake(_nameLabel.x + _nameLabel.width + 5, _nameLabel.y + 3, 52, 14);
        NSString * authFlag = [NSString stringWithFormat:@"%@",_dict[@"authFlag"]] ;
        if([authFlag isEqualToString:@"1"])
            _realeNameImageView.image =[UIImage imageNamed:@"home_playtogether_realname"];
        else
            _realeNameImageView.hidden =YES;
        
         _signLabel.text = _dict[@"uDis"];
        
        NSString * colCounts  = [NSString stringWithFormat:@"%@",responseObject[@"colCounts"]];
         _dolCounts = [NSString stringWithFormat:@"%@",responseObject[@"dolCounts"]];
         _fanCounts = [NSString stringWithFormat:@"%@",responseObject[@"fanCounts"]];

        NSArray *contentArr = @[colCounts,_dolCounts,_fanCounts];
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"uImg"]] placeholderImage:YGDefaultImgAvatar];
        
        for (int i = 0; i<3; i++)
        {
            UILabel *label = [_titleBaseView viewWithTag:10000+i];
            label.text = contentArr[i];
        }
       
        
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark ---- 配置UI
-(void)configUI
{
    
    /********************** 头视图两个按钮 *****************/
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, heraderHeight)];
    _headerView.backgroundColor = colorWithYGWhite;
    //水滴
    _coverImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"steward_rencai_bg"]];
    _coverImageView.frame = CGRectMake(0,0,YGScreenWidth, 220);
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    _coverImageView.clipsToBounds = YES;
    _coverImageView.userInteractionEnabled = YES;
    _coverImageView.backgroundColor = colorWithMainColor;
    [_headerView addSubview:_coverImageView];
    
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
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _headerImageView.y+_headerImageView.height+10, YGScreenWidth-20, 20)];
    _nameLabel.textColor = colorWithYGWhite;
//    _nameLabel.text = _dict[@"uName"];
//    CGFloat nameLabelW = [UILabel calculateWidthWithString:_dict[@"uName"] textFont:[UIFont systemFontOfSize:YGFontSizeBigTwo] numerOfLines:1].width;
//    _nameLabel.width = nameLabelW;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    [alphaView addSubview:_nameLabel];
    _nameLabel.centerx = alphaView.centerx;
    
    _realeNameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_nameLabel.x + _nameLabel.width + 5, _nameLabel.y + 3, 52, 14)];
//    NSString * authFlag = [NSString stringWithFormat:@"%@",_dict[@"authFlag"]] ;
//    if([authFlag isEqualToString:@"1"])
//        _realeNameImageView.image =[UIImage imageNamed:@"home_playtogether_realname"];
//    else
//        _realeNameImageView.hidden =YES;
    [alphaView addSubview:_realeNameImageView];

    
    //热门推荐label
    _signLabel = [[UILabel alloc]init];
    _signLabel.textColor = colorWithYGWhite;
    _signLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
//    _signLabel.text = _dict[@"uDis"];
    _signLabel.textAlignment = NSTextAlignmentCenter;
    _signLabel.frame = CGRectMake(15, _nameLabel.y+_nameLabel.height+7,YGScreenWidth-30, 20);
    [alphaView addSubview:_signLabel];
    
    //    /********************** 分割线 ********************/
    
    /********************** 选择器 ********************/
    
    _titleBaseView  = [[UIView alloc] initWithFrame:CGRectMake(0, _coverImageView.height-55, YGScreenWidth,50)];
    [alphaView addSubview:_titleBaseView];
    
    NSArray *titleArr = @[@"收藏",@"关注",@"粉丝"];
//    NSArray *contentArr = @[_userModel.activityCount,_userModel.memberCount,_userModel.attentionCount];
    
    for (int i = 0; i<3; i++)
    {
        UIView *contentBaseView  = [[UIView alloc] initWithFrame:CGRectMake(YGScreenWidth/3*i, 0, YGScreenWidth/3,60)];
        [_titleBaseView addSubview:contentBaseView];
        
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth/3, 20)];
        contentLabel.textColor = colorWithYGWhite;
        contentLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
//        contentLabel.text = contentArr[i];
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
        
        UIButton * selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth/3*i, 0, YGScreenWidth/3,60)];
        selectBtn.tag =100 +i;
        [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleBaseView addSubview:selectBtn];
        
        if (i == 1 || i == 2)
        {
            UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 1,25)];
            lineView.backgroundColor = colorWithYGWhite;
            [contentBaseView addSubview:lineView];
        }
        
    }
    
    UIView *oldLineView = [[UIView alloc] initWithFrame:CGRectMake(0,_headerView.height-10, YGScreenWidth, 10)];
    oldLineView.backgroundColor = colorWithLine;
    [_headerView addSubview:oldLineView];
    
    CGFloat H = kScreenH - YGNaviBarHeight - YGStatusBarHeight;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, H) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44;
    _tableView.tableHeaderView = _headerView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    [_tableView setSeparatorColor:colorWithLine];
    [self.view addSubview:_tableView];
}
-(void)selectBtnClick:(UIButton *)btn
{
    NSInteger tag= btn.tag -100;
    switch (tag) {
        case 0:
            {
                
            }
            break;
        case 1:
        {
            SecondhandReplacementMyFollowViewController * myFollowView =[[SecondhandReplacementMyFollowViewController alloc]init];
            myFollowView.followCount= _dolCounts;
            [self.navigationController pushViewController:myFollowView animated:YES];
        }
            break;
        case 2:
        {
            SecondhangReplacementMyFansViewController * myFansView =
            [[SecondhangReplacementMyFansViewController alloc]init];
             myFansView.fansCount = _fanCounts;
            [self.navigationController pushViewController:myFansView animated:YES];
        }
            break;
        default:
            break;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0://我买到的
        {
            SecondhandReplacementIBoughtViewController * iBoughtView = [[SecondhandReplacementIBoughtViewController alloc]init];
            [self.navigationController pushViewController:iBoughtView animated:YES];
        }
            break;
        case 1://我卖出的
        {
            SecondhandReplacementISelloutViewController * selloutView = [[SecondhandReplacementISelloutViewController alloc]init];
            [self.navigationController pushViewController:selloutView animated:YES];
        }
            break;
        case 2://我的置换
        {
            SecondhandReplacementSubstitutionViewController * replaceView = [[SecondhandReplacementSubstitutionViewController alloc]init];
            [self.navigationController pushViewController:replaceView animated:YES];
        }
            break;
        case 3://我收藏的
        {
            SecondhandReplacementICollectViewController * collectView = [[SecondhandReplacementICollectViewController alloc]init];
            [self.navigationController pushViewController:collectView animated:YES];
        }
            break;
        case 4://我发布的
        {
            SecondhandReplacementICreateViewController * iCreateView = [[SecondhandReplacementICreateViewController alloc]init];
            [self.navigationController pushViewController:iCreateView animated:YES];
        }
            break;
        case 5://我的互动
        {
            SecondhandReplacementMyInteractionViewController * myInteraction = [[SecondhandReplacementMyInteractionViewController alloc]init];
            [self.navigationController pushViewController:myInteraction animated:YES];
        }
            
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.textLabel.text =_dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = colorWithBlack;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
@end


