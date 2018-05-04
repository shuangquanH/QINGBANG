//
//  DecorationCarMainController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "DecorationCarMainController.h"
#import "CooperationCaseCell.h"
#import "DesignEffectViewController.h"
#import "DecorationCarQuestionViewController.h"
#import "DecorationMainModel.h"
#import "BudgetOrderdingViewController.h"
#import "CooperationCustomCaseCell.h"

@interface DecorationCarMainController () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_picArray;
    NSMutableArray *_dataArray;
}

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation DecorationCarMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"装修直通车";
    
    UIButton *intructButton = [UIButton buttonWithType:UIButtonTypeCustom];
    intructButton.frame = CGRectMake(0, 0, 20, 20);
    intructButton.titleLabel.text = @"";
    [intructButton setImage:[UIImage imageNamed:@"steward_question_green"] forState:UIControlStateNormal];
    [intructButton addTarget:self action:@selector(intruction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:intructButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _picArray = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    
    [self loadListData];
    
    [self configTableView];
    
}

-(void)loadPicData
{
    //请求首页图片
    [YGNetService YGPOST:@"SearchIndexPicture" parameters:@{} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSArray *pic = [responseObject valueForKey:@"flist"];
        
        for (int i = 0; i < pic.count; i++)
        {
            [_picArray addObject:[pic[i] valueForKey:@"picture"]];
        }
        NSLog(@"%@",_picArray);
        
        [self configHeaderView];
        [self configFooterView];
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)loadListData
{
    [YGNetService YGPOST:@"SearchCasePicture" parameters:@{} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        _dataArray = [DecorationMainModel mj_objectArrayWithKeyValuesArray:responseObject[@"flist"]];
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)configTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGStatusBarHeight - YGNaviBarHeight) style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
//    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self loadPicData];
}


-(void)configHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 2000)];
    UIImageView *firstImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
    [firstImageView sd_setImageWithURL:[NSURL URLWithString:_picArray[0]]];
    NSData *data0 = [NSData dataWithContentsOfURL:[NSURL URLWithString:_picArray[0]]];
    UIImage *image0 = [UIImage imageWithData:data0];
    firstImageView.frame = CGRectMake(0, 0, YGScreenWidth, image0.size.height/image0.size.width * YGScreenWidth);
    [headerView addSubview:firstImageView];
    
    UIImageView *secondImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, YGScreenWidth, 100)];
    [secondImageView sd_setImageWithURL:[NSURL URLWithString:_picArray[1]] placeholderImage:YGDefaultImgFour_Three];
    NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:_picArray[1]]];
    UIImage *image1 = [UIImage imageWithData:data1];
    secondImageView.frame = CGRectMake(0, firstImageView.size.height, YGScreenWidth, image1.size.height/image1.size.width * YGScreenWidth);
    [headerView addSubview:secondImageView];
    
    UIImageView *thirdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
    [thirdImageView sd_setImageWithURL:[NSURL URLWithString:_picArray[2]] placeholderImage:YGDefaultImgFour_Three];
    NSData *data2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:_picArray[2]]];
    UIImage *image2 = [UIImage imageWithData:data2];
    thirdImageView.frame = CGRectMake(0, firstImageView.size.height + secondImageView.size.height, YGScreenWidth, image2.size.height/image2.size.width * YGScreenWidth);
    [headerView addSubview:thirdImageView];
    
    UIImageView *forthImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
    [forthImageView sd_setImageWithURL:[NSURL URLWithString:_picArray[3]] placeholderImage:YGDefaultImgFour_Three];
    NSData *data3 = [NSData dataWithContentsOfURL:[NSURL URLWithString:_picArray[3]]];
    UIImage *image3 = [UIImage imageWithData:data3];
    forthImageView.frame = CGRectMake(0, firstImageView.size.height + secondImageView.size.height + thirdImageView.size.height + 10, YGScreenWidth, image3.size.height/image3.size.width * YGScreenWidth);
    [headerView addSubview:forthImageView];
    
    headerView.frame = CGRectMake(0, 0, YGScreenWidth, firstImageView.size.height + secondImageView.size.height + thirdImageView.size.height + forthImageView.size.height + 10);
    
    self.tableView.tableHeaderView = headerView;
    
}
-(void)configFooterView
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 200)];
    UIImageView *footerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 200)];
    [footerImageView sd_setImageWithURL:[NSURL URLWithString:_picArray[5]] placeholderImage:YGDefaultImgFour_Three];
    NSData *data5 = [NSData dataWithContentsOfURL:[NSURL URLWithString:_picArray[5]]];
    UIImage *image5 = [UIImage imageWithData:data5];
    footerImageView.frame = CGRectMake(0, 0, YGScreenWidth, image5.size.height/image5.size.width * YGScreenWidth);
    [footerView addSubview:footerImageView];
    
    UIImageView *telImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 200)];
    [telImageView sd_setImageWithURL:[NSURL URLWithString:_picArray[6]] placeholderImage:YGDefaultImgFour_Three];
    NSData *data6 = [NSData dataWithContentsOfURL:[NSURL URLWithString:_picArray[6]]];
    UIImage *image6 = [UIImage imageWithData:data6];
    telImageView.frame = CGRectMake(0, footerImageView.size.height, YGScreenWidth, image6.size.height/image6.size.width * YGScreenWidth);
    [footerView addSubview:telImageView];
    
    footerView.frame = CGRectMake(0, 0, YGScreenWidth, footerImageView.size.height + telImageView.size.height);
    self.tableView.tableFooterView = footerView;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _dataArray.count) {
        CooperationCustomCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CooperationCustomCaseCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CooperationCustomCaseCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        if (_picArray.count) {
            [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:_picArray[4]] placeholderImage:YGDefaultImgFour_Three];
            cell.baseView.layer.cornerRadius = cell.baseView.size.height / 2;
            cell.baseView.clipsToBounds = YES;
        }
        return cell;
    }
    CooperationCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CooperationCaseCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CooperationCaseCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
        cell.nameLabel.text = [NSString stringWithFormat:@"%@元左右/m²起",[_dataArray[indexPath.row] valueForKey:@"price"]];
        [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[_dataArray[indexPath.row] valueForKey:@"imgUrl"]] placeholderImage:YGDefaultImgFour_Three];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count + 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YGScreenWidth * 0.55;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == _dataArray.count)
    {
        BudgetOrderdingViewController *vc = [[BudgetOrderdingViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        DesignEffectViewController *vc = [[DesignEffectViewController alloc]init];
        vc.caseId = [_dataArray[indexPath.row] valueForKey:@"ID"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//Q&A
-(void)intruction:(UIButton *)button
{
    DecorationCarQuestionViewController *vc = [[DecorationCarQuestionViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
