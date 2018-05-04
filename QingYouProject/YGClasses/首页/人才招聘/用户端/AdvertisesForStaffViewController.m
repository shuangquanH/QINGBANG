//
//  AdvertisesForStaffViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AdvertisesForStaffViewController.h"
#import "AdvertisesForInfoViewController.h"
#import "DeliverRecoredViewController.h"
#import "MyResumeViewController.h"

@interface AdvertisesForStaffViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    UIImageView *_coverImageView;
}


@end

@implementation AdvertisesForStaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadCoverImage];
    // Do any additional setup after loading the view.
}
- (void)loadCoverImage
{
    //房租缴纳审核
    [YGNetService YGPOST:REQUEST_RecruitmentSecondLevel parameters:@{@"type":@"1"} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"img"]] placeholderImage:YGDefaultImgFour_Three];
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)configUI
{
    self.naviTitle = @"个人端";
    
    _listArray  = (NSMutableArray *)@[
                                      @{
                                          @"img":@"steward_recuit_employment",
                                          @"title":@"招聘信息"
                                          },
                                      @{
                                          @"img":@"steward_recuit_delivery_record",
                                          @"title":@"投递记录"
                                          },
                                      @{
                                          @"img":@"steward_recruit_resume",
                                          @"title":@"我的简历"
                                          }
                                      ];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth/2)];
    //水滴
    _coverImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"steward_rencai_bg"]];
    _coverImageView.frame = CGRectMake(0,0,YGScreenWidth, YGScreenWidth/2);
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    _coverImageView.clipsToBounds = YES;
    _coverImageView.backgroundColor = colorWithMainColor;
    [headerView addSubview:_coverImageView];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth/2)];
    alphaView.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.3];
    [_coverImageView addSubview:alphaView];

    //头像
    UIImageView *headerImageView = [[UIImageView alloc]init];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:YGSingletonMarco.user.userImg] placeholderImage:YGDefaultImgAvatar];
    headerImageView.frame = CGRectMake(0,YGScreenWidth/4-40,60, 60);
    headerImageView.layer.cornerRadius = 30;
    headerImageView.layer.borderColor = colorWithTable.CGColor;
    headerImageView.layer.borderWidth = 1;
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.clipsToBounds = YES;
    headerImageView.backgroundColor = colorWithMainColor;
    [alphaView addSubview:headerImageView];
    headerImageView.centerx = alphaView.centerx;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, headerImageView.y+headerImageView.height+10, YGScreenWidth-20, 20)];
    nameLabel.textColor = colorWithYGWhite;
    nameLabel.text = YGSingletonMarco.user.userName;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [alphaView addSubview:nameLabel];
    
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithPlateSpacedColor;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = headerView;
    [self.view addSubview:_tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];

        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, YGScreenWidth-20, 120)];
        baseView.backgroundColor = colorWithYGWhite;
        baseView.layer.cornerRadius = 5;
        baseView.clipsToBounds = YES;
        [cell.contentView addSubview:baseView];
        
        UIButton *coverButton = [[UIButton alloc]init];
        coverButton.tag = 1000+indexPath.section;
        coverButton.backgroundColor = colorWithMainColor;
        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        [baseView addSubview:coverButton];
        coverButton.frame = CGRectMake(baseView.width/2-(baseView.height-30)/2, 0, baseView.height-30, baseView.height-30);
        coverButton.centery = baseView.centery;
    }
    UIButton *coverButton = [cell.contentView viewWithTag:1000+indexPath.section];
    NSDictionary *dict = _listArray[indexPath.section];
    UIImage *titleImage = [UIImage imageNamed:dict[@"img"]];
    coverButton.backgroundColor = colorWithYGWhite;
    [coverButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [coverButton setTitle:dict[@"title"] forState:UIControlStateNormal];
    [coverButton setImage:titleImage forState:UIControlStateNormal];
    coverButton.userInteractionEnabled = NO;
    coverButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [coverButton setTitleEdgeInsets:UIEdgeInsetsMake(coverButton.imageView.frame.size.height ,-coverButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [coverButton setImageEdgeInsets:UIEdgeInsetsMake(-coverButton.imageView.frame.size.height*0.8, 0.0,0.0, -coverButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AdvertisesForInfoViewController *vc = [[AdvertisesForInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        DeliverRecoredViewController *vc = [[DeliverRecoredViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 2) {
        
        MyResumeViewController *vc = [[MyResumeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
