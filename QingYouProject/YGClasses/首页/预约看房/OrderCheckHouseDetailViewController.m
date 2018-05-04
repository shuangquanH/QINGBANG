//
//  OrderCheckHouseDetailViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderCheckHouseDetailViewController.h"
#import "OrderCheckHouseTableViewCell.h"
#import "OrderCheckHouseModel.h"
#import "OrderCheckHouseDetailTableViewCell.h"

#import "OrderCheckHouseSubmitViewController.h"

@interface OrderCheckHouseDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@end

@implementation OrderCheckHouseDetailViewController
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    OrderCheckHouseModel *_mainModel;
    SDCycleScrollView *_adScrollview; //广告轮播
    UIView          *_baseView;
    UILabel *_titleLabel;
    UILabel *_newPriceLabel;
    UILabel  *_oldPriceLabel;
    NSString *_urlString;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    [self loadData];
}

- (void)loadData
{
    [self startPostWithURLString:REQUEST_OtDetails parameters:@{@"id":self.sourceId} showLoadingView:NO scrollView:nil];
}
- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    _urlString = responseObject[@"url"];
    NSDictionary *dict = responseObject[@"ordeTable"];
    [_mainModel setValuesForKeysWithDictionary:dict];
    [_adScrollview removeFromSuperview];
    //广告滚动
    _adScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, YGScreenWidth-0, YGScreenWidth*0.74) delegate:self placeholderImage:YGDefaultImgFour_Three];
    NSArray *imgArray =  [[NSString stringWithFormat:@"%@",_mainModel.imgs] componentsSeparatedByString:@","];
    _adScrollview.imageURLStringsGroup = imgArray;
    _adScrollview.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _adScrollview.autoScroll = YES;
    _adScrollview.infiniteLoop = YES;
    [_baseView addSubview:_adScrollview];
    
    _titleLabel.text = _mainModel.name;
    [_titleLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-30];
    _titleLabel.frame = CGRectMake(15, _adScrollview.height+10,YGScreenWidth-30, _titleLabel.height+10);
    
    _newPriceLabel.text = [NSString stringWithFormat:@"%@",_mainModel.price];
    [_newPriceLabel sizeToFit];
    _newPriceLabel.frame = CGRectMake(_newPriceLabel.x,_titleLabel.y+_titleLabel.height , _newPriceLabel.width, 25);
    _oldPriceLabel.frame = CGRectMake(_newPriceLabel.x+_newPriceLabel.width,_newPriceLabel.y+3, _oldPriceLabel.width, 20);

    NSArray *info =  @[_mainModel.floor,_mainModel.proportion,_mainModel.remarks,_mainModel.payway,_mainModel.contacts,_mainModel.contact];
    for (int i = 0; i<6; i++) {
        UILabel *contentLabel = [_baseView viewWithTag:100000+i];
        contentLabel.text = [NSString stringWithFormat:@"%@",info[i]];
    }
    _listArray = [OrderCheckHouseModel  mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
    [_tableView reloadData];
}
- (void)configAttribute
{
    self.naviTitle = @"房源详情";
   UIBarButtonItem *barButtonItem = [self createBarbuttonWithNormalImageName:@"share_black" selectedImageName:@"share_black" selector:@selector(shareAction)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    _mainModel = [[OrderCheckHouseModel alloc] init];
    _listArray = [[NSMutableArray alloc] init];
}
- (void)createTabelHeaderView
{
    /********************** 头视图两个按钮 *****************/
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth*0.74+75+100)];
    _baseView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:_baseView];
    //广告滚动
    _adScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, YGScreenWidth-0, YGScreenWidth*0.74) delegate:self placeholderImage:YGDefaultImgFour_Three];
//    _adScrollview.imageURLStringsGroup = @[@"http://i4.eiimg.com/567571/c6639be3ed7ea595.png",@"http://i4.eiimg.com/567571/c6639be3ed7ea595.png"];
    _adScrollview.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _adScrollview.autoScroll = YES;
    _adScrollview.infiniteLoop = YES;
    //    _adScrollview.localizationImageNamesGroup = @[@"home_tool1.png",@"home_tool1.png"];
    [_baseView addSubview:_adScrollview];
    
    //热门推荐label
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    _titleLabel.text = @"青网科技";
    _titleLabel.frame = CGRectMake(15, _adScrollview.height+10,YGScreenWidth-30, 35);
    [_titleLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-30];
    _titleLabel.frame = CGRectMake(15, _adScrollview.height+10,YGScreenWidth-30, _titleLabel.height+10);
    [_baseView addSubview:_titleLabel];
    
    //时间label
    _newPriceLabel = [[UILabel alloc]init];
    _newPriceLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height , 100, 20);
    _newPriceLabel.textColor = colorWithOrangeColor;
    _newPriceLabel.text = @"¥299";
    _newPriceLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    _newPriceLabel.numberOfLines = 0;
    [_newPriceLabel sizeToFit];
    _newPriceLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height , _newPriceLabel.width, 20);
    [_baseView addSubview:_newPriceLabel];
    
    //热门推荐label
    _oldPriceLabel = [[UILabel alloc]init];
    _oldPriceLabel.frame = CGRectMake(_newPriceLabel.x+_newPriceLabel.width,_newPriceLabel.y+4, 100, 15);
    _oldPriceLabel.textColor = colorWithOrangeColor;
    _oldPriceLabel.text = @"元/月/㎡";
    _oldPriceLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    [_oldPriceLabel sizeToFit];
    _oldPriceLabel.frame = CGRectMake(_newPriceLabel.x+_newPriceLabel.width,_newPriceLabel.y+5, _oldPriceLabel.width, 15);
    [_baseView addSubview:_oldPriceLabel];
    
    UIView *oldLineView = [[UIView alloc] initWithFrame:CGRectMake(0,_newPriceLabel.y+_newPriceLabel.height+10, YGScreenWidth, 1)];
    oldLineView.backgroundColor = colorWithLine;
    [_baseView addSubview:oldLineView];
    
    NSArray *infoArray = @[@"楼层信息：",@"面积(㎡)：",@"装修程度：",@"付款方式：",@"联系人：",@"联系方式："];
    NSString *info = @"楼层信息,面积(㎡),装修程度,付款方式,联系人,联系方式,";

    NSArray *array = [NSArray arrayWithArray:[info componentsSeparatedByString:@","]];
    int k = 0;
    for (int i = 0; i<infoArray.count; i++) {
        int x = i%2;
        int y = i/2;
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(10+(YGScreenWidth-20)/2*x,oldLineView.y+ 10+(30*y), (YGScreenWidth-20)/2, 25)];
        baseView.backgroundColor = colorWithYGWhite;
        [_baseView addSubview:baseView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , 70, 25)];
        nameLabel.text = infoArray[i];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        nameLabel.textColor = colorWithLightGray;
//        [nameLabel sizeToFit];
//        nameLabel.frame = CGRectMake(nameLabel.x,nameLabel.y , nameLabel.width, 25);
        [baseView addSubview:nameLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width,nameLabel.y , 100, 25)];
        contentLabel.text = array[i];
        contentLabel.tag = 100000+i;
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        contentLabel.textColor = colorWithBlack;
        [baseView addSubview:contentLabel];
        
        k = y;
    }
    
    
}
- (void)configUI
{
    [self createTabelHeaderView];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.tableHeaderView = _baseView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[OrderCheckHouseTableViewCell class] forCellReuseIdentifier:@"OrderCheckHouseTableViewCell"];
    [_tableView registerClass:[OrderCheckHouseDetailTableViewCell class] forCellReuseIdentifier:@"OrderCheckHouseDetailTableViewCell"];
    
    [self.view addSubview:_tableView];
//    [self createRefreshWithScrollView:_tableView containFooter:YES];
//    [_tableView.mj_header beginRefreshing];
    
    /****************************** 按钮 **************************/
    
    if (self.orderId == nil && self.cancle == YES) {
        _tableView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-45-YGBottomMargin);
        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
        coverButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
        coverButton.backgroundColor = colorWithPlateSpacedColor;
        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [coverButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
        [coverButton setTitle:@"已完成" forState:UIControlStateNormal];
        [self.view addSubview:coverButton];
        
    }else
    {
        _tableView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-45-YGBottomMargin);
        for (int i = 0; i<2; i++)
        {
            UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth/2*i,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth/2,45+YGBottomMargin)];
            coverButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
            coverButton.tag = 1000+i;
            [coverButton addTarget:self action:@selector(contanctOnlineServiceOrOrderAction:) forControlEvents:UIControlEventTouchUpInside];
            coverButton.backgroundColor = colorWithMainColor;
            coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
            [self.view addSubview:coverButton];
            
            if (i == 0)
            {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, coverButton.y-1, YGScreenWidth/2, 1)];
                lineView.backgroundColor = colorWithLine;
                [self.view addSubview:lineView];
                
                coverButton.backgroundColor = colorWithYGWhite;
                [coverButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
                [coverButton setTitle:@"联系客服" forState:UIControlStateNormal];
                [coverButton setImage:[UIImage imageNamed:@"service_black"] forState:UIControlStateNormal];
                coverButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
            }else
            {
                coverButton.backgroundColor = colorWithMainColor;
                [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
                if (self.cancle == YES)
                {
                    [coverButton setTitle:@"取消预约" forState:UIControlStateNormal];
                }else{
                    [coverButton setTitle:@"预约看房" forState:UIControlStateNormal];
                }
            }
        }
    }
   
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && _mainModel.description) {
        return 1;
    }

    return _listArray.count;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_mainModel.description) {
        return 2;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && _mainModel.description) {
        OrderCheckHouseDetailTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCheckHouseDetailTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setContent:_mainModel.description];
        return cell;
    }else
    {
        
        OrderCheckHouseTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCheckHouseTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        OrderCheckHouseModel *model = _listArray[indexPath.row];
        [cell setModel:model];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:@"OrderCheckHouseDetailTableViewCell" cacheByIndexPath:indexPath configuration:^(OrderCheckHouseDetailTableViewCell *cell) {
            cell.fd_enforceFrameLayout = YES;
            [cell setContent:_mainModel.description];
        }];
    }
    
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCheckHouseModel *model = _listArray[indexPath.row];
    OrderCheckHouseDetailViewController *vc = [[OrderCheckHouseDetailViewController alloc] init];
    vc.sourceId = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 50)];
    view.backgroundColor = colorWithYGWhite;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    lineView.backgroundColor = colorWithTable;
    [view addSubview:lineView];
    
     UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    titleLabel.text = @"为您推荐";
    titleLabel.frame = CGRectMake(10, lineView.height+5,YGScreenWidth-30, 35);
    [view addSubview:titleLabel];
    if (section == 0) {
        titleLabel.text = @"房源描述";

    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (void)shareAction
{
    NSArray *imgArray =  [[NSString stringWithFormat:@"%@",_mainModel.imgs] componentsSeparatedByString:@","];
    [YGAppTool shareWithShareUrl:_urlString shareTitle:_mainModel.name shareDetail:@"" shareImageUrl:imgArray[0] shareController:self];
}

- (void)contanctOnlineServiceOrOrderAction:(UIButton *)btn
{
    if (btn.tag == 1001)
    {
        if (self.cancle == YES) //取消预约
        {
            [YGAlertView showAlertWithTitle:@"确认取消预约吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    return ;
                }else
                {
                    [YGNetService YGPOST:REQUEST_CancelReservation parameters:@{@"id":_orderId} showLoadingView:YES scrollView:nil success:^(id responseObject) {
                        [YGAppTool showToastWithText:@"取消预约成功"];
                        [self back];
                    } failure:^(NSError *error) {
                        
                    }];
                    
                }
            }];
        }else
        {
            OrderCheckHouseSubmitViewController *vc = [[OrderCheckHouseSubmitViewController alloc] init];
            vc.model = _mainModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else
    {
        [self contactWithCustomerServerWithType:ContactServerOrderCheckHouse button:btn];
    }
        
}
@end
