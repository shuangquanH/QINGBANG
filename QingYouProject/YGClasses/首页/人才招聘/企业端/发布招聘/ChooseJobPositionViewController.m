//
//  ChooseJobPositionViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ChooseJobPositionViewController.h"
#import "AdvertisesForInfoModel.h"

@interface ChooseJobPositionViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ChooseJobPositionViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    UITableView *_leftTableView;
    NSMutableArray *_leftDataArray;
    NSMutableArray  *_rightTabelArray;
    NSIndexPath *_indexPath;
    AdvertisesForInfoModel *_chooseModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)setModel:(AdvertisesForInfoModel *)model
{
    _model = model;
}
- (void)configAttribute
{
    _dataSource = [[NSMutableArray alloc] init];
    _leftDataArray = [[NSMutableArray alloc] init];
    _rightTabelArray = [[NSMutableArray alloc] init];

    if ([self.pageType isEqualToString:@"introduce"]) {
        self.naviTitle = @"职位类别";

    }else
    {
        self.naviTitle = @"招聘职位";
    }
    
    UIButton *barButton = [[UIButton alloc] init];
    [barButton setTitle:@"确定" forState:UIControlStateNormal];
    [barButton setTitle:@"确定" forState:UIControlStateSelected];
    barButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [barButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [barButton sizeToFit];
    [barButton addTarget:self action:@selector(confirmToBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)loadData
{
   
    
    [YGNetService YGPOST:REQUEST_FindJobList parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        NSMutableArray  *dataSource = [[NSMutableArray alloc] init];
        for (NSDictionary  *listDict in responseObject[@"JobList"]) {
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            AdvertisesForInfoModel *model = [[AdvertisesForInfoModel alloc] init];
            model.id = listDict[@"id"];
            model.name = listDict[@"name"];
            [dataSource addObject:model];
            for (NSDictionary *rightListDict in listDict[@"list"])
            {
                AdvertisesForInfoModel *modelRight = [[AdvertisesForInfoModel alloc] init];
                modelRight.id = rightListDict[@"id"];
                modelRight.name = rightListDict[@"name"];
                [dataArray addObject:modelRight];
            }
            [_rightTabelArray addObject:dataArray];
        }
        [_dataSource addObjectsFromArray:_rightTabelArray[0]];
        [_leftDataArray addObjectsFromArray:dataSource];

        //判断id是不是相同，找到之后赋值选中
        NSIndexPath *leftIndexPath;
        int rightIndex = 0;
        if (_model != nil) {
            leftIndexPath = _model.fatherIndexPath;
            AdvertisesForInfoModel *model = _leftDataArray[_model.fatherIndexPath.row];
            model.isSelect = YES;
            [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray:_rightTabelArray[_model.fatherIndexPath.row]];
            
            for (AdvertisesForInfoModel *model in _rightTabelArray[_model.fatherIndexPath.row])
            {
                if ([model.id isEqualToString:_model.id])
                {
                    model.isSelect = YES;
                    _chooseModel = model;
                    break;
                }
                rightIndex ++;
            }
        }
//        else
//        {
//            AdvertisesForInfoModel *model = _leftDataArray[0];
//            model.isSelect = YES;
//            AdvertisesForInfoModel *modelInner = _rightTabelArray[0][0];
//            modelInner.isSelect = YES;
//            _chooseModel = modelInner;
//
//        }

        [_tableView reloadData];
        [_leftTableView reloadData];
        [_leftTableView scrollToRowAtIndexPath:leftIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rightIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } failure:^(NSError *error) {

    }];
}
- (void)configUI
{
    
 
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(YGScreenWidth/2, 0, YGScreenWidth/2, YGScreenHeight-YGNaviBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = colorWithPlateSpacedColor;
    
   
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth/2, _tableView.height) style:UITableViewStyleGrouped];
    _leftTableView.backgroundColor = colorWithYGWhite;
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    [self.view addSubview:_leftTableView];
    

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_leftTableView])
    {
        return _leftDataArray.count;
    }
    return _dataSource.count;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellpop"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellpop"];
        if (tableView == _tableView) {
            UIButton *chooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(tableView.width-50,0,40,40)];
            [chooseBtn setImage:[UIImage imageNamed:@"order_choice_btn_green"] forState:UIControlStateNormal];
            chooseBtn.tag = 1000+indexPath.row;
            chooseBtn.contentMode = UIViewContentModeCenter;
            [cell.contentView addSubview:chooseBtn];
            chooseBtn.hidden = YES;
            
        }
        UIView *linview = [[UIView alloc] initWithFrame:CGRectMake(10, 40, YGScreenWidth-10, 1)];
        linview.backgroundColor = colorWithLine;
        [cell addSubview:linview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    cell.textLabel.textColor = colorWithBlack;
    AdvertisesForInfoModel *model;
    
    if (tableView == _tableView) {
        model = _dataSource[indexPath.row];
        UIButton *btn = [cell.contentView viewWithTag:1000+indexPath.row];
        //右边的选中时按钮出现 字颜色变为主题色
        btn.hidden = !model.isSelect;
        cell.backgroundColor = colorWithPlateSpacedColor;

    }else
    {
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.frame = CGRectMake(0, 0, 17, 17);
        arrowImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
        [arrowImageView sizeToFit];
        cell.accessoryView = arrowImageView;
        model = _leftDataArray[indexPath.row];
        cell.backgroundColor = colorWithYGWhite;
        
    }
    //左边的列表选中的话背景色变 字的颜色也变为主题色
    if (model.isSelect) {
        cell.backgroundColor = colorWithPlateSpacedColor;
        cell.textLabel.textColor = colorWithMainColor;
    }
    
    cell.textLabel.text = model.name;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView)
    {
        _chooseModel.isSelect = NO;
        for (AdvertisesForInfoModel *model in _dataSource)
        {
            model.isSelect = NO;
            model.fatherIndexPath = _indexPath;
        }
        AdvertisesForInfoModel *model = _dataSource[indexPath.row];
        model.isSelect = YES;
        _chooseModel = model;
        [_tableView reloadData];
    }
    if (tableView == _leftTableView)
    {
        
        for (AdvertisesForInfoModel *model in _leftDataArray)
        {
            model.isSelect = NO;
        }
    
        AdvertisesForInfoModel *model = _leftDataArray[indexPath.row];
        model.isSelect = YES;
        
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:_rightTabelArray[indexPath.row]];
        _indexPath = indexPath;
        [_tableView reloadData];
        [_leftTableView reloadData];
    }
}
- (void)confirmToBack
{
    [self.delegate takePositionModel:_chooseModel];
    [self back];
}
@end
