//
//  AdvertisesForinfoPopView.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AdvertisesForinfoPopView.h"

@implementation AdvertisesForinfoPopView
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    UITableView *_leftTableView;
    NSMutableArray *_leftDataArray;
    NSMutableArray  *_rightTabelArray;
    UIView *_tableBaseView;
    NSIndexPath *_indexPath;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0,40, YGScreenWidth, YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-40);
        self.backgroundColor = [colorWithBlack colorWithAlphaComponent:0];
        UITapGestureRecognizer *  recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
        [recognizerTap setNumberOfTapsRequired:1];
        recognizerTap.cancelsTouchesInView = NO;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:recognizerTap];
        
    }
    return self;
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        
        if (![_tableView pointInside:[_tableView convertPoint:location fromView:_tableView.window] withEvent:nil])
        {
            [_tableView.window removeGestureRecognizer:sender];
            if (_advertisesPageTypeChoos == pageTypeChoosePosition)
            {
                if (![_leftTableView pointInside:[_leftTableView convertPoint:location fromView:_leftTableView.window] withEvent:nil])
                {
                    [_leftTableView.window removeGestureRecognizer:sender];
                    [self dismiss];
                }
                
            }else
            {
                [self dismiss];
                
            }
        }
    }
}

- (void)createPopChooseViewWithDataSorce:(NSArray *)dataSource andLeftDataArray:(NSMutableArray *)dataArray withType:(AdvertisesPageTypeChoos)advertisesPageTypeChoos   withLeftIndex:(int)leftIndex withRightIndex:(int)rightIndex
{
    _advertisesPageTypeChoos = advertisesPageTypeChoos;
    _leftDataArray = [[NSMutableArray alloc] init];
    _dataSource = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight*0.6) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight*0.6)];
    _tableBaseView.backgroundColor = colorWithYGWhite;
    [_tableBaseView addSubview:_tableView];
    [self addSubview:_tableBaseView];
    
    if (dataSource.count*45 >= (YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight)*0.6) {
        _tableBaseView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight*0.6);
    }else
    {
        _tableBaseView.frame = CGRectMake(0, 0, YGScreenWidth, dataSource.count*45);
    }
    
    switch (advertisesPageTypeChoos)
    {
        case pageTypeChooseBusinessPark:
        {
            [_dataSource addObjectsFromArray:[AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:dataSource]];
            
            break;
            
        }
        case pageTypeChoosePosition:
        {
            _tableView.backgroundColor = colorWithPlateSpacedColor;
            _rightTabelArray = [[NSMutableArray alloc] init];
            [_rightTabelArray addObjectsFromArray:[AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:dataSource]];
            [_dataSource addObjectsFromArray:_rightTabelArray[leftIndex]];
            [_leftDataArray addObjectsFromArray:[AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:dataArray]];
            if (_dataSource.count*45>= YGScreenHeight*0.7) {
                _tableBaseView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight*0.7);
            }else
            {
                _tableBaseView.frame = CGRectMake(0, 0, YGScreenWidth, dataSource.count*45);
            }
            _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth/2, _tableBaseView.height) style:UITableViewStyleGrouped];
            _leftTableView.backgroundColor = colorWithYGWhite;
            _leftTableView.showsVerticalScrollIndicator = NO;
            _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _leftTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
            _leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
            _leftTableView.delegate = self;
            _leftTableView.dataSource = self;
            [_tableBaseView addSubview:_leftTableView];
            _tableView.frame = CGRectMake(YGScreenWidth/2, 0, YGScreenWidth/2, _tableBaseView.height);
            [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:rightIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            
            [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:leftIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];

            
            break;
            
        }
        case pageTypeChooseSalary:
        {
            [_dataSource addObjectsFromArray:[AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:dataSource]];
            
            
            break;
            
        }
        case pageTypeChooseWellbeing:
        {
//            _tableBaseView.backgroundColor = [UIColor clearColor];
            [_dataSource addObjectsFromArray:[AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:dataSource]];
            
            
            
            break;
            
        }
            
    }

    [_tableView reloadData];
    
    [self show];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
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
            [cell.contentView addSubview:chooseBtn];
            chooseBtn.hidden = YES;
            
        }
//        UIView *linview = [[UIView alloc] initWithFrame:CGRectMake(10, 40, YGScreenWidth-10, 1)];
//        linview.backgroundColor = colorWithTable;
//        [cell addSubview:linview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    cell.textLabel.textColor = colorWithBlack;
    AdvertisesForInfoModel *model;
    if (tableView == _tableView) {
        model = _dataSource[indexPath.row];
        UIButton *btn = [cell.contentView viewWithTag:1000+indexPath.row];
        //右边的选中时按钮出现 字颜色变为主题色
        btn.hidden = !model.isSelect;
        cell.backgroundColor = colorWithYGWhite;
        //该列表是右边列表时背景是板块颜色
        if (_advertisesPageTypeChoos == pageTypeChoosePosition) {
            cell.backgroundColor = colorWithPlateSpacedColor;
            
        }
        
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
    if (model.isSelect ) {
        cell.backgroundColor = _advertisesPageTypeChoos == pageTypeChoosePosition ?colorWithPlateSpacedColor:colorWithYGWhite;
        cell.textLabel.textColor = colorWithMainColor;
    }
    
    cell.textLabel.text = model.name;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        for (AdvertisesForInfoModel *model in _dataSource) {
            model.isSelect = NO;
            model.fatherIndexPath = _indexPath;
        }
        AdvertisesForInfoModel *model = _dataSource[indexPath.row];
        model.isSelect = YES;
        [self.delegate siftDataWithKeyModel:model];
        [_tableView reloadData];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.2];
    }
    if (tableView == _leftTableView) {
        
        for (AdvertisesForInfoModel *model in _leftDataArray) {
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

- (void)show
{
    //    [YGAppDelegate.window addSubview:self];
    
    self.backgroundColor = [colorWithBlack colorWithAlphaComponent:0];

    [UIView animateWithDuration:0.25 animations:^
     {
         self.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.5];
             CGRect rect = _tableBaseView.frame;
             rect.origin.y = 0;
             _tableBaseView.frame = rect;
             
     }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^
     {
             CGRect rect = _tableBaseView.frame;
         rect.size.height = 0;
             _tableBaseView.frame = rect;
         self.backgroundColor = [colorWithBlack colorWithAlphaComponent:0];
         for (UIView *view in _tableBaseView.subviews)
         {
             view.hidden = YES;
         }
         [self.delegate dismissChangeColor];
         
     }                completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
    
    
}


//- (void)dismissSelf
//{
//    [self dismiss];
//}
@end
