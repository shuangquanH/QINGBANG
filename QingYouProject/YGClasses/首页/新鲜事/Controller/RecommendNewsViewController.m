//
//  RecommendNewsViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RecommendNewsViewController.h"
#import "TextTopPictureBottomCell.h"
#import "TextOnlyCell.h"
#import "PictureLeftTextRightCell.h"
#import "NewThingsDetailController.h"
#import "TakePicturesEasyController.h"
#import "NewThingsModel.h"

@interface RecommendNewsViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)UITableView *tabView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation RecommendNewsViewController

-(UITableView *)tabView
{
    if (_tabView == nil) {
        _tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight) style:UITableViewStyleGrouped];
        [self.view addSubview:_tabView];
    }
    return _tabView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray array];
    
    [self configUI];
}

-(void)configUI
{
    [self.tabView registerNib:[UINib nibWithNibName:@"TextTopPictureBottomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TextTopPictureBottomCell"];
    [self.tabView registerNib:[UINib nibWithNibName:@"TextOnlyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TextOnlyCell"];
    [self.tabView registerNib:[UINib nibWithNibName:@"PictureLeftTextRightCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PictureLeftTextRightCell"];
    self.tabView.sectionHeaderHeight = 0.0001;
    self.tabView.sectionFooterHeight = 0.0001;
    self.tabView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.0001)];
    self.tabView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.0001)];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.estimatedRowHeight = YGScreenWidth * 0.43;
    
    [self createRefreshWithScrollView:self.tabView containFooter:YES];
    [self.tabView.mj_header beginRefreshing];
}

//加载数据
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:@"FreshNewsList" parameters:@{@"total":self.totalString,@"count":self.countString,@"type":[_dict valueForKey:@"value"]} showLoadingView:NO scrollView:self.tabView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if (((NSArray *)responseObject[@"list"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:self.tabView];
        }
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[NewThingsModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:self.tabView headerAction:YES];
        [self.tabView reloadData];
    } failure:^(NSError *error) {

    }];
}




#pragma mark - tableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.dataArray[indexPath.row] valueForKey:@"type"] isEqualToString:@"0"])
    {
        TextOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextOnlyCell" forIndexPath:indexPath];
        cell.nameLabel.text = [self.dataArray[indexPath.row] valueForKey:@"name"];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@",[self.dataArray[indexPath.row] valueForKey:@"source"],[self.dataArray[indexPath.row] valueForKey:@"time"]];
        return cell;
    }
    if ([[self.dataArray[indexPath.row] valueForKey:@"type"] isEqualToString:@"1"])
    {
        PictureLeftTextRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureLeftTextRightCell" forIndexPath:indexPath];
        cell.nameLabel.text = [self.dataArray[indexPath.row] valueForKey:@"name"];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@",[self.dataArray[indexPath.row] valueForKey:@"source"],[self.dataArray[indexPath.row] valueForKey:@"time"]];
//        [cell.leftimageView sd_setImageWithURL:[NSURL URLWithString:[self.dataArray[indexPath.row] valueForKey:@"imgs"]]];
        NSString *imgString = [self.dataArray[indexPath.row] valueForKey:@"imgs"];
        NSArray * imgsArray = [imgString componentsSeparatedByString:@","];
        [cell.leftimageView sd_setImageWithURL:[NSURL URLWithString:imgsArray[0]] placeholderImage:YGDefaultImgFour_Three];
        return cell;
    }
    if ([[self.dataArray[indexPath.row] valueForKey:@"type"] isEqualToString:@"2"])
    {
        TextTopPictureBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextTopPictureBottomCell" forIndexPath:indexPath];
        cell.nameLabel.text = [self.dataArray[indexPath.row] valueForKey:@"name"];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@",[self.dataArray[indexPath.row] valueForKey:@"source"],[self.dataArray[indexPath.row] valueForKey:@"time"]];
        NSString *imgString = [self.dataArray[indexPath.row] valueForKey:@"imgs"];
        NSArray * imgsArray = [imgString componentsSeparatedByString:@","];
        [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:imgsArray[0]] placeholderImage:YGDefaultImgFour_Three];
        [cell.middleImageView sd_setImageWithURL:[NSURL URLWithString:imgsArray[1]] placeholderImage:YGDefaultImgFour_Three];
//        if (imgsArray.count >= 3) {
        [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:imgsArray[2]] placeholderImage:YGDefaultImgFour_Three];
//        }
        return cell;
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.dataArray[indexPath.row] valueForKey:@"type"] isEqualToString:@"0"]){
//        return YGScreenWidth * 0.17;
        return [tableView fd_heightForCellWithIdentifier:@"TextOnlyCell" configuration:^(TextOnlyCell *cell) {
           cell.nameLabel.text = [self.dataArray[indexPath.row] valueForKey:@"name"];
         }];
    }
    if ([[self.dataArray[indexPath.row] valueForKey:@"type"] isEqualToString:@"1"]) {
        return YGScreenWidth * 0.30;
    }
//    return YGScreenWidth * 0.43;
    return [tableView fd_heightForCellWithIdentifier:@"TextTopPictureBottomCell" configuration:^(TextTopPictureBottomCell *cell) {
        cell.nameLabel.text = [self.dataArray[indexPath.row] valueForKey:@"name"];
    }];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewThingsDetailController *vc = [[NewThingsDetailController alloc] init];
    vc.idString = [self.dataArray[indexPath.row] valueForKey:@"ID"];
//    [self addSearchRecord:_historyListArray[indexPath.row]];
//    [_blackView removeFromSuperview];
    [self.navigationController pushViewController:vc animated:YES];

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
