//
//  AdvertisesForEnterpriseViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved
//

#import "AdvertisesForEnterpriseViewController.h"
#import "MyAdvertisesViewController.h"
#import "JobOutsourceViewController.h"
#import "IssueAdvertiseViewController.h"
#import "SerchAdvertisesViewController.h"
#import "HouseRentAuditViewController.h"
#import "UpLoadIDFatherViewController.h"

@interface AdvertisesForEnterpriseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    UIImageView *_coverImageView;
}

@end

@implementation AdvertisesForEnterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCertifyInfo];

}
- (void)configAttribute
{

}
- (void)loadCertifyInfo
{
    //房租缴纳审核
    [YGNetService YGPOST:REQUEST_HouserAudit parameters:@{@"userid":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        self.state = responseObject[@"state"];
        [self configUI];
        [self loadCoverImage];
    } failure:^(NSError *error) {
        
    }];
}
- (void)loadCoverImage
{
    //房租缴纳审核
    [YGNetService YGPOST:REQUEST_RecruitmentSecondLevel parameters:@{@"type":@"2"} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"img"]] placeholderImage:YGDefaultImgFour_Three];
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)configUI
{
    self.naviTitle = @"企业端";
    
    UIButton *barButton = [[UIButton alloc] initWithFrame:CGRectMake(YGScreenWidth-50, 30, 40, 40)];
    [barButton setImage:[UIImage imageNamed:@"steward_capital_search"] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(searchAdvertieseInfoAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    _listArray  = (NSMutableArray *)@[
                                      @{
                                          @"img":@"steward_recuit_post",
                                          @"title":@"发布招聘"
                                          },
                                      @{
                                          @"img":@"steward_recuit_myjob",
                                          @"title":@"我的招聘"
                                          },
                                      @{
                                          @"img":@"steward_recruit_epiboly",
                                          @"title":@"岗位外包服务"
                                          }
                                      ];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth/2)];
    //水滴
    _coverImageView = [[UIImageView alloc]initWithImage:YGDefaultImgFour_Three];
    _coverImageView.frame = CGRectMake(0,0,YGScreenWidth, YGScreenWidth/2);
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    _coverImageView.clipsToBounds = YES;
    [headerView addSubview:_coverImageView];
    
//    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth/2)];
//    alphaView.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.5];
//    [_coverImageView addSubview:alphaView];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
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
        coverButton.userInteractionEnabled = NO;
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
    
  
         //返回值state ==0是请提交审核材料 ==1待审核 ==2审核通过直接跳到房租缴纳首页 ==3审核不通过跳到传身份证页面并提示请重新上传资料审核
    if (indexPath.section == 2)
    {
        JobOutsourceViewController *vc = [[JobOutsourceViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else
    {
         
         if([self.state isEqualToString:@"2"])
         {
             if (indexPath.section == 1)
             {
                 
                 MyAdvertisesViewController *vc = [[MyAdvertisesViewController alloc] init];
                 [self.navigationController pushViewController:vc animated:YES];
             }
         
             if (indexPath.section == 0)
             {
                 
                 IssueAdvertiseViewController *vc = [[IssueAdvertiseViewController alloc] init];
                 [self.navigationController pushViewController:vc animated:YES];
             }
             
             
         }else if ([self.state isEqualToString:@"1"])
         {
             [YGAppTool showToastWithText:@"您的申请正在审核中"];
//             HouseRentAuditViewController *controller = [[HouseRentAuditViewController alloc]init];
//             [self.navigationController pushViewController:controller animated:YES];
         }
         else
         {
             
             [YGAlertView showAlertWithTitle:@"发布招聘信息前需企业认证" buttonTitlesArray:@[@"取消",@"现在去确认"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex)
              {
                  if (buttonIndex == 1)
                  {
                      if ([self.state isEqualToString:@"3"])
                      {
                          UpLoadIDFatherViewController *controller = [[UpLoadIDFatherViewController alloc]init];
                          controller.notioceString = @"您的资料未通过审核,请重新上传资料";
                          [self.navigationController pushViewController:controller animated:YES];
                      }else
                      {
                          UpLoadIDFatherViewController *controller = [[UpLoadIDFatherViewController alloc]init];
                          controller.notioceString = @"请上传资料进行审核，审核通过后可进行相关操作";
                          [self.navigationController pushViewController:controller animated:YES];
                          
                      }
                  }
                  
                  
              }];
         }

    }
    
    
}

- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    
}
- (void)searchAdvertieseInfoAction
{
    if([self.state isEqualToString:@""] ||self.state == nil)
    {
        [YGAppTool showToastWithText:@"信息获取不完整"];
        return;
    }
    if([self.state isEqualToString:@"2"])
    {
        SerchAdvertisesViewController *vc = [[SerchAdvertisesViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.state isEqualToString:@"1"])
    {
        [YGAppTool showToastWithText:@"您的申请正在审核中"];

//        HouseRentAuditViewController *controller = [[HouseRentAuditViewController alloc]init];
//        [self.navigationController pushViewController:controller animated:YES];
    }else
    {
        
        
        
        [YGAlertView showAlertWithTitle:@"发布招聘信息前需企业认证" buttonTitlesArray:@[@"取消",@"现在去确认"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex)
         {
             if (buttonIndex == 1)
             {
                 if ([self.state isEqualToString:@"3"])
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
             
             
         }];
    }


}

@end
