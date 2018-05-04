//
//  SecondhandReplacementSubstitutionWaitToDelivergoodsViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplacementSubstitutionWaitToDelivergoodsViewController.h"
#import "SecondhandReplacementSubstitutionWaitToGoodsTableViewCell.h"
#import "SecondhandReplacementAddExpressViewController.h"
#import "SecondhandReplacementIBoughtModel.h"

@interface SecondhandReplacementSubstitutionWaitToDelivergoodsViewController ()<UITableViewDelegate,UITableViewDataSource,SecondhandReplacementSubstitutionWaitToGoodsTableViewCellDelegate,SecondhandReplacementAddExpressViewControllerDelegate>
{
    UITableView *_tableView;
    UITableView *_otherTableView;
    
    NSMutableArray * _dataArray;
    NSMutableArray * _otherDataArray;
    
    UISegmentedControl *_segmentedControl;
    BOOL _isOther;
    UIView * _addressbackView;
    UIView *_bgView;
     BOOL _isFirst;
    NSInteger _myCount;
    NSInteger _otherCount;

}
@end

@implementation SecondhandReplacementSubstitutionWaitToDelivergoodsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectFromString(_controllFrame);
    
    _isOther = NO;
    _isFirst = YES;
    _myCount =0 ;
    _otherCount =0;
    
    _dataArray= [[NSMutableArray alloc]init];
    _otherDataArray= [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 5)];
    line.backgroundColor = colorWithLine;
    [self.view addSubview:line];
    
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"待我发货",@"待对方发货"]];
    
    _segmentedControl.frame = CGRectMake(15, 5 + LDHPadding, YGScreenWidth -30, 4*LDHPadding);
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.layer.cornerRadius = 8;
    _segmentedControl.tintColor = colorWithMainColor;
    [_segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_segmentedControl];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.otherTableView];
    
    //网络请求
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    

}
-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    switch (Index) {
        case 0:
        {
            _isOther = NO;
            _otherTableView.hidden = !_isOther;
            _tableView.hidden = _isOther;
            if(_dataArray.count ==0)
            {
                [_tableView.mj_header beginRefreshing];
            }
        }
            break;
        case 1:
        {
            _isOther = YES;
            _otherTableView.hidden = !_isOther;
            _tableView.hidden = _isOther;
            if(_otherDataArray.count==0)
            {
                if(_isFirst ==YES)
                {
                    _isFirst =NO;
                    [self createRefreshWithScrollView:_otherTableView containFooter:YES];
                }
              
                [_otherTableView.mj_header beginRefreshing];
            }

        }
            break;
        default:
            break;
    }
}
#pragma mark - 网络请求
//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    if(_isOther)
    {
        if (headerAction)
        {
            _otherCount =0;
        }
        //如果是加载
        else
        {
            _otherCount ++;
        }
        NSDictionary *parameters = @{
                                     @"uid":YGSingletonMarco.user.userId,
                                     @"roleType":@"2",
                                     @"status":@"2",
                                     @"count":self.countString,
                                     @"total":[NSString stringWithFormat:@"%ld",(long)_otherCount]
                                     };
        NSString *url = @"myReplacementByRes";
        
        //如果不是加载过缓存
//        if (!self.isAlreadyLoadCache)
//        {
//            //加载缓存数据
//            NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
//            [_otherDataArray addObjectsFromArray:[SecondhandReplacementIBoughtModel mj_objectArrayWithKeyValuesArray:cacheDic[@"rList"]]];
//            [_otherTableView reloadData];
//            self.isAlreadyLoadCache = YES;
//        }
        
        [YGNetService YGPOST:url
                  parameters:parameters
             showLoadingView:NO
                  scrollView:_otherTableView
                     success:^( id responseObject) {
                         //如果是刷新
                         if (headerAction)
                         {
                             //先移除数据源所有数据
                             [_otherDataArray removeAllObjects];
                         }
                         //如果是加载
                         else
                         {
                             //判断服务器返回的数组是不是没数据了，如果没数据
                             if ([responseObject[@"rList"] count] == 0)
                             {
                                 //调用一下没数据的方法，告诉用户没有更多
                                 [self noMoreDataFormatWithScrollView:_otherTableView];
                                 return;
                             }
                         }
                         //将字典数组转化为模型数组，再加入到数据源
                      [_otherDataArray addObjectsFromArray:[SecondhandReplacementIBoughtModel mj_objectArrayWithKeyValuesArray:responseObject[@"rList"]]];
                         //调用加载无数据图的方法
                         [self addNoDataImageViewWithArray:_otherDataArray shouldAddToView:_otherTableView headerAction:headerAction];
                         [_otherTableView reloadData];
                     } failure:^(NSError *error)
         {
             [self addNoNetRetryButtonWithFrame:_otherTableView.frame listArray:_otherDataArray];
         }];
    }
    else
    {
        if (headerAction)
        {
            _myCount =0;
        }
        //如果是加载
        else
        {
            _myCount ++;
        }
        NSDictionary *parameters = @{
                                     @"uid":YGSingletonMarco.user.userId,
                                     @"roleType":@"1",
                                     @"status":@"2",
                                     @"count":self.countString,
                                     @"total":[NSString stringWithFormat:@"%ld",(long)_myCount]
                                     };
        NSString *url = @"myReplacementByRes";
        
        //如果不是加载过缓存
//        if (!self.isAlreadyLoadCache)
//        {
//            //加载缓存数据
//            NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
//            [_dataArray addObjectsFromArray:[SecondhandReplacementIBoughtModel mj_objectArrayWithKeyValuesArray:cacheDic[@"rList"]]];
//            [_tableView reloadData];
//            self.isAlreadyLoadCache = YES;
//        }
        
        [YGNetService YGPOST:url
                  parameters:parameters
             showLoadingView:NO
                  scrollView:_tableView
                     success:^( id responseObject) {
                         //如果是刷新
                         if (headerAction)
                         {
                             _myCount = 0;
                             //先移除数据源所有数据
                             [_dataArray removeAllObjects];
                             _myCount = 1;
                         }
                         //如果是加载
                         else
                         {
                             _myCount ++;
                             //判断服务器返回的数组是不是没数据了，如果没数据
                             if ([responseObject[@"rList"] count] == 0)
                             {
                                 //调用一下没数据的方法，告诉用户没有更多
                                 [self noMoreDataFormatWithScrollView:_tableView];
                                 return;
                             }
                         }
                         //将字典数组转化为模型数组，再加入到数据源
                    [_dataArray addObjectsFromArray:[SecondhandReplacementIBoughtModel mj_objectArrayWithKeyValuesArray:responseObject[@"rList"]]];
                         //调用加载无数据图的方法
                         [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:headerAction];
                         [_tableView reloadData];
                     } failure:^(NSError *error)
         {
             [self addNoNetRetryButtonWithFrame:_tableView.frame listArray:_dataArray];
         }];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag ==100)
        return _dataArray.count;
    else
        return _otherDataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag ==100)
    {
        SecondhandReplacementSubstitutionWaitToGoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SecondhandReplacementSubstitutionWaitToGoodsTableViewCellID];
        cell.row = indexPath.row;  
        cell.delegate = self;
        cell.relopType =@"1";
        [cell setModel:(SecondhandReplacementIBoughtModel *)_dataArray[indexPath.row]];
        return cell;
    }
    else
    {
        SecondhandReplacementSubstitutionWaitToGoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SecondhandReplacementSubstitutionWaitToGoodsTableViewCellID];
        cell.row = indexPath.row;
        cell.delegate = self;
        cell.relopType =@"2";
        [cell setModel:(SecondhandReplacementIBoughtModel *)_otherDataArray[indexPath.row]];
        return cell;
    }
    
}

- (void)secondhandReplacementSubstitutionWaitToGoodsTableViewCellPayButton:(UIButton *)paybtn withRow:(NSInteger)row
{
    SecondhandReplacementAddExpressViewController * addExpressView =[[SecondhandReplacementAddExpressViewController alloc]init];
    addExpressView.delegate =self;
    addExpressView.row = row;
    addExpressView.orderNum =((SecondhandReplacementIBoughtModel *)_dataArray[row]).orderNum;
    [self.navigationController pushViewController:addExpressView animated:YES];
    
}
-(void)secondhandReplacementAddExpressViewControllerDelegateReturnReloadViewWithRow:(NSInteger )row;
{
    [_dataArray removeObjectAtIndex:row];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}
-(void)secondhandReplacementSubstitutionWaitToGoodsTableViewCelladdressButton:(UIButton *)btn withRow:(NSInteger)row
{
    [self createAddressViewwithTitle:btn.titleLabel.text withRow:row];
}
-(void)createAddressViewwithTitle:(NSString *)title withRow:(NSInteger )row
{
    _bgView= [UIView new];
    _bgView.frame = [UIScreen mainScreen].bounds;
    
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [YGAppDelegate.window addSubview:_bgView];
    
    _addressbackView =[[UIView alloc]initWithFrame:CGRectMake(LDHPadding *2, 0, YGScreenWidth - 4*LDHPadding, 100)];
    _addressbackView.layer.masksToBounds = YES;
    _addressbackView.layer.cornerRadius = 8;
    _addressbackView.backgroundColor =[UIColor whiteColor];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, LDHPadding, _addressbackView.width, 30)];
    titleLabel.text = title;
    titleLabel.textColor = colorWithBlack;
    titleLabel.textAlignment =NSTextAlignmentCenter;
    titleLabel.font =[UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_addressbackView addSubview:titleLabel];
    [_bgView addSubview:_addressbackView];
    
    SecondhandReplacementIBoughtModel * model = _dataArray[row];

    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDHPadding *2, titleLabel.y + titleLabel.height, _addressbackView.width - LDHPadding *4, 0)];
    detailLabel.numberOfLines =0;
    detailLabel.font =[UIFont systemFontOfSize:YGFontSizeSmallOne];
    detailLabel.textColor = colorWithBlack;
    detailLabel.text = [NSString stringWithFormat:@"%@\n收件人：%@\n联系电话：%@",model.address,model.linkman,model.linkphone];
    [_addressbackView addSubview:detailLabel];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:detailLabel.text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:5];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailLabel.text length])];
    
    detailLabel.attributedText = attributedString;
    
    [detailLabel sizeToFit];

    CGSize detailLabelSize = [detailLabel sizeThatFits:CGSizeMake(_addressbackView.width - LDHPadding *4, 1000)];
    detailLabel.frame = CGRectMake(LDHPadding *2, titleLabel.y + titleLabel.height, _addressbackView.width - LDHPadding *4,  detailLabelSize.height);
    
    UIButton * sureBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, detailLabel.y + detailLabel.height + 30, _addressbackView.width, 40)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_addressbackView addSubview:sureBtn];
    _addressbackView.centery = _bgView.centery;
    _addressbackView.height =  sureBtn.height + sureBtn.y  ;
    
}

-(void)sureBtnClick:(UIButton *)btn
{
    [_bgView removeFromSuperview];
}
static NSString * const SecondhandReplacementSubstitutionWaitToGoodsTableViewCellID = @"SecondhandReplacementSubstitutionWaitToGoodsTableViewCellID";

- (UITableView *)tableView{
    
    if (!_tableView) {
        CGFloat H = kScreenH - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight - 6.5*LDHPadding ;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 6.5 *LDHPadding, kScreenW, H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 190;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tag =100;
//        _tableView.backgroundColor = colorWithTable;

        [_tableView registerClass:[SecondhandReplacementSubstitutionWaitToGoodsTableViewCell class] forCellReuseIdentifier:SecondhandReplacementSubstitutionWaitToGoodsTableViewCellID];
    }
    return _tableView;
}

- (UITableView *)otherTableView{
    
    if (!_otherTableView) {
        CGFloat H = kScreenH - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight - 6.5*LDHPadding ;
        _otherTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 6.5 *LDHPadding, kScreenW, H) style:UITableViewStyleGrouped];
        _otherTableView.delegate = self;
        _otherTableView.dataSource = self;
        _otherTableView.rowHeight = 160;
        _otherTableView.tag =101;
//        _otherTableView.backgroundColor = colorWithTable;
        _otherTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _otherTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _otherTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _otherTableView.hidden =YES;
        [_otherTableView registerClass:[SecondhandReplacementSubstitutionWaitToGoodsTableViewCell class] forCellReuseIdentifier:SecondhandReplacementSubstitutionWaitToGoodsTableViewCellID];
    }
    return _otherTableView;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
- (NSMutableArray *)otherDataArray{
    
    if (!_otherDataArray) {
        
        _otherDataArray = [NSMutableArray array];
        
    }
    return _otherDataArray;
}

@end








