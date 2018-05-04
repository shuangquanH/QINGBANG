//
//  AddressAskSubViewController.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/9/27.
//  Copyright © 2017 ccyouge. All rights reserved.
//

#import "AddressAskSubViewController.h"
#import "AddressAskModel.h"
#import "AddressAskTableViewCell.h"


@interface AddressAskSubViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    NSDictionary *_infoDic;
}
@end

@implementation AddressAskSubViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)configAttribute
{
    _listArray = [[NSMutableArray alloc] init];
    _infoDic = [AddressAskConfig infoDicWithPageType:_pageType subPageType:_subPageType target:self];
}

- (void)configUI
{
    self.view.frame = _controlFrame;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, self.view.height) style:UITableViewStyleGrouped];
    _tableView.sectionHeaderHeight = 10;
    _tableView.backgroundColor = colorWithTable;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 5)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.estimatedRowHeight = 80;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    [_tableView registerClass:[AddressAskTableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long) _pageType]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressAskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long) _pageType] forIndexPath:indexPath];
    [cell performSelector:NSSelectorFromString(_infoDic[@"setModel"]) withObject:_listArray[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long) _pageType] cacheByIndexPath:indexPath configuration:^(AddressAskTableViewCell *cell)
    {
        [cell performSelector:NSSelectorFromString(_infoDic[@"setModel"]) withObject:_listArray[indexPath.section]];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    SectionFooterHeightBlock sectionFooterHeightBlock = _infoDic[@"footerHeightBlock"];
    return sectionFooterHeightBlock(section, _listArray);
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    SectionFooterViewBlock sectionFooterViewBlock = _infoDic[@"footerViewBlock"];
    return sectionFooterViewBlock(section, _listArray);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    /*
     * 
     * 
     * 
     * 
     * 接口来了把我打开
     */
//    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:_infoDic[@"requestParam"]];
//    paramDic[@"total"] = self.totalString;
//    paramDic[@"count"] = self.countString;
//    [YGNetService YGPOST:_infoDic[@"requestUrl"] parameters:paramDic showLoadingView:NO scrollView:_tableView  success:^(id responseObject)
//    {
//        if(headerAction)
//        {
//            [_listArray removeAllObjects];
//        }
//        else
//        {
//            if([responseObject[@"list"] count] < YGPageSize)
//            {
//                [self noMoreDataFormatWithScrollView:_tableView];
//                return;
//            }
//        }
//        [_listArray addObjectsFromArray:[_infoDic[@"modelClass"] mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
//        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
//        [_tableView reloadData];
//        
//    } failure:^(NSError *error)
//    {
//        [self addNoNetRetryButtonWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) listArray:_listArray];
//    }];
    
    
    [self endRefreshWithScrollView:_tableView];
    NSArray *tempArray =
            @[
                    @{
                            @"orderId"         : @"1923791283213",              //订单号
                            @"orderTitle"      : @"21个页面合1",                 //标题
                            @"orderSubTitle"   : @"这就牛逼了",                  //子标题（广告管家）
                            @"orderDate"       : @"2017-09-28 10:42",           //创建时间
                            @"orderName"       : @"张楷枫",                      //人名
                            @"orderPhone"      : @"13894741585",                //手机号
                            @"orderPay"        : @"299",                        //支付钱数
                            @"orderYear"       : @"半年付",                      //年限
                            @"orderKind"       : @"小额融资贷款",                 //类别
                            @"orderAddress"    : @"经开区东环城路与浦东路交汇",     //地址
                            @"orderFixName"    : @"服务器维护",                   //类别（网络管家）
                            @"orderProcessDate": @"2017-19-19 2:20",            //订单处理中的日期
                            @"orderVIPType"    : @"VIP月卡",                      //类别（VIP）
                    },
                    @{
                            @"orderId"         : @"1923791283213",
                            @"orderTitle"      : @"21个页面合1",
                            @"orderSubTitle"   : @"这就牛逼了",
                            @"orderDate"       : @"2017-09-28 10:42",
                            @"orderName"       : @"张楷枫",
                            @"orderPhone"      : @"13894741585",
                            @"orderPay"        : @"299",
                            @"orderYear"       : @"半年付",
                            @"orderKind"       : @"小额融资贷款",
                            @"orderAddress"    : @"经开区东环城路与浦东路交汇",
                            @"orderFixName"    : @"服务器维护",
                            @"orderProcessDate": @"2017-19-19 2:20",
                            @"orderVIPType"    : @"VIP月卡",
                    },
                    @{
                            @"orderId"         : @"1923791283213",
                            @"orderTitle"      : @"21个页面合1",
                            @"orderSubTitle"   : @"这就牛逼了",
                            @"orderDate"       : @"2017-09-28 10:42",
                            @"orderName"       : @"张楷枫",
                            @"orderPhone"      : @"13894741585",
                            @"orderPay"        : @"299",
                            @"orderYear"       : @"半年付",
                            @"orderKind"       : @"小额融资贷款",
                            @"orderAddress"    : @"经开区东环城路与浦东路交汇",
                            @"orderFixName"    : @"服务器维护",
                            @"orderProcessDate": @"2017-19-19 2:20",
                            @"orderVIPType"    : @"VIP月卡",
                    },
                    @{
                            @"orderId"         : @"1923791283213",
                            @"orderTitle"      : @"21个页面合1",
                            @"orderSubTitle"   : @"这就牛逼了",
                            @"orderDate"       : @"2017-09-28 10:42",
                            @"orderName"       : @"张楷枫",
                            @"orderPhone"      : @"13894741585",
                            @"orderPay"        : @"299",
                            @"orderYear"       : @"半年付",
                            @"orderKind"       : @"小额融资贷款",
                            @"orderAddress"    : @"经开区东环城路与浦东路交汇",
                            @"orderFixName"    : @"服务器维护",
                            @"orderProcessDate": @"2017-19-19 2:20",
                            @"orderVIPType"    : @"VIP月卡",
                    }


            ];
    if (headerAction)
    {
        [_listArray removeAllObjects];
        [_listArray addObjectsFromArray:[_infoDic[@"modelClass"] mj_objectArrayWithKeyValuesArray:tempArray]];
        [_tableView reloadData];
    }
    else
    {
        [self noMoreDataFormatWithScrollView:_tableView];
        return;
    }

}

//退款按钮点击
- (void)giveMoneyButtonClick:(UIButton *)button
{
    AddressAskModel *model = _listArray[button.tag - 100];
    [YGAppTool showToastWithText:[NSString stringWithFormat:@"%@", model.orderId]];
}

//删除订单按钮点击
- (void)deleteOrderButtonClick:(UIButton *)button
{

    AddressAskModel *model = _listArray[button.tag - 100];
    [YGAppTool showToastWithText:[NSString stringWithFormat:@"%@", model.orderId]];
}

//立即评价按钮点击
- (void)evaluateButtonClick:(UIButton *)button
{
    AddressAskModel *model = _listArray[button.tag - 200];
    [YGAppTool showToastWithText:[NSString stringWithFormat:@"%@", model.orderId]];
}


@end
