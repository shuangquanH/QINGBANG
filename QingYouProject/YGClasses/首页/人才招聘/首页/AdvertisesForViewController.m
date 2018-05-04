//
//  AdvertisesForViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AdvertisesForViewController.h"
#import "AdvertisesForStaffViewController.h"
#import "AdvertisesForEnterpriseViewController.h"

#import "AdvertisesForInfoViewController.h"
#import "JobOutsourceViewController.h"



@interface AdvertisesForViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableDictionary *_dataDictonary;
}

@end

@implementation AdvertisesForViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)loadData
{
    [YGNetService YGPOST:REQUEST_RecruitmentIndexList parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        _dataDictonary = responseObject[@"RecruitmentIndex"];
        [self configUI];

    } failure:^(NSError *error) {
        
    }];
}
- (void)configUI
{
    self.naviTitle = @"人才招聘";
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
    footerView.backgroundColor  =colorWithYGWhite;
    
    //热门推荐label
    UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, YGScreenWidth-20, 20)];
    descriptionLabel.textColor = colorWithBlack;
    descriptionLabel.text = _dataDictonary[@"content"];
    descriptionLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    descriptionLabel.numberOfLines = 0;
    [descriptionLabel sizeToFit];
    descriptionLabel.frame = CGRectMake(10, 10, YGScreenWidth-20, descriptionLabel.height+20);
    [footerView addSubview:descriptionLabel];
    footerView.frame = CGRectMake(0, 0, YGScreenWidth, descriptionLabel.height+20);
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = footerView;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [self.view addSubview:_tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        //水滴
        UIImageView *cellImageView = [[UIImageView alloc]initWithImage:YGDefaultImgFour_Three];
        cellImageView.frame = CGRectMake(0,0,YGScreenWidth, YGScreenWidth/2);
        cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        cellImageView.clipsToBounds = YES;
        cellImageView.tag = 1000+indexPath.section;
        [cell.contentView addSubview:cellImageView];
    }
    UIImageView *cellImageView = [cell.contentView viewWithTag:1000+indexPath.section];
    if (indexPath.section == 0) {
        [cellImageView sd_setImageWithURL:[NSURL URLWithString:_dataDictonary[@"img"]] placeholderImage:YGDefaultImgFour_Three];
    }else
    {
        [cellImageView sd_setImageWithURL:[NSURL URLWithString:_dataDictonary[@"imgs"]] placeholderImage:YGDefaultImgFour_Three];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YGScreenWidth/2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self.delegate takeTypeValueBackWithValue:_typeArr[indexPath.row]];
    //    [self back];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    headerView.backgroundColor = colorWithYGWhite;
    NSArray *sectiontitleArray = @[@"招聘墙",@"我要将岗位外包给青网"];
    NSArray *sectionHeaderArray = @[@"更多",@"现在就申请"];

    //热门推荐label
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, (YGScreenWidth)/2-20, 20)];
    titleLabel.textColor = colorWithBlack;
    titleLabel.text = sectiontitleArray[section];
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [headerView addSubview:titleLabel];


    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(YGScreenWidth-30, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"steward_more_green"];
    [imageView sizeToFit];
    [headerView addSubview:imageView];
    imageView.centery = titleLabel.centery;
    
    //热门推荐label
    UILabel *moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.x-120, 10, 115, 20)];
    moreLabel.textColor = colorWithMainColor;
    moreLabel.text = sectionHeaderArray[section];
    moreLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    moreLabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:moreLabel];
    moreLabel.centery = titleLabel.centery;

    //大button
    UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth/2,0,YGScreenWidth/2,40)];
    coverButton.tag = 10000+section;
    [coverButton addTarget:self action:@selector(moreCoverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:coverButton];

    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 90;

    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView* bottomHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0, YGScreenWidth, 80)];
        bottomHeaderView.backgroundColor = colorWithYGWhite;
        
        NSArray *arry = @[@"我要找工作",@"我要招人"];
        for (int i = 0; i<2; i++) {
            UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(10+((YGScreenWidth-40)/2+10)*i,30,(YGScreenWidth-40)/2,40)];
            coverButton.layer.borderColor = colorWithMainColor.CGColor;
            coverButton.layer.borderWidth = 1;
            coverButton.layer.cornerRadius = 20;
            coverButton.clipsToBounds = YES;
            coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            [coverButton setTitle:arry[i] forState:UIControlStateNormal];
            [coverButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            coverButton.tag = 1000+i;
            [coverButton addTarget:self action:@selector(chooseInvoiceTypeAction:) forControlEvents:UIControlEventTouchUpInside];
            [bottomHeaderView addSubview:coverButton];
            
        }
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0,89, YGScreenWidth, 1)];
        lineView.backgroundColor = colorWithLine;
        [bottomHeaderView addSubview:lineView];
        
        return bottomHeaderView;
    }
    return nil;
}

- (void)chooseInvoiceTypeAction:(UIButton *)btn
{
    if (![self loginOrNot])
    {
        return;
    }
    if (btn.tag == 1000)
    {
        AdvertisesForStaffViewController *vc = [[AdvertisesForStaffViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else
    {
        //房租缴纳审核
        [YGNetService YGPOST:REQUEST_HouserAudit parameters:@{@"userid":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:nil success:^(id responseObject)
         {
             //返回值state ==0是请提交审核材料 ==1待审核 ==2审核通过直接跳到房租缴纳首页 ==3审核不通过跳到传身份证页面并提示请重新上传资料审核
             
             AdvertisesForEnterpriseViewController *vc = [[AdvertisesForEnterpriseViewController alloc] init];
             vc.state = responseObject[@"state"];
             [self.navigationController pushViewController:vc animated:YES];
             
         } failure:^(NSError *error) {
             
         }];
        

    }
    
}

- (void)moreCoverButtonClick:(UIButton *)btn
{
    if (btn.tag - 10000 == 0)
    {
        AdvertisesForInfoViewController *vc = [[AdvertisesForInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else
    {
        if (![self loginOrNot])
        {
            return;
        }
        //岗位外包申请
        JobOutsourceViewController *vc = [[JobOutsourceViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
