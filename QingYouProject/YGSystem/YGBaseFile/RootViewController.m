//
//  RootViewController.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/7/27.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import <UMMobClick/MobClick.h>
#import "LoginViewController.h"
#import "SQChooseGardenVC.h"
#import "SQCallPhoneFunction.h"


@interface RootViewController () {
    SEL _superCmd;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = colorWithTable;
    [self configAttribute];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];//友盟统计
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];//友盟统计
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

/** 设置属性  */
- (void)configAttribute {
}
//状态栏颜色
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle animated:YES];
}
//一键创建普通navigation
- (void)setNaviTitle:(NSString *)naviTitle {
    self.naviTitleLabel.text = naviTitle;
}
- (UILabel *)naviTitleLabel {
    if (!_naviTitleLabel) {
        _naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, YGScreenWidth - 100, 20)];
        _naviTitleLabel.textColor = KCOLOR_WHITE;
        _naviTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = _naviTitleLabel;
    }
    return _naviTitleLabel;
}

- (void)startPostWithURLString:(NSString *)URLString
                    parameters:(id)parameters
               showLoadingView:(BOOL)flag
                    scrollView:(UIScrollView *)scrollView {
    [YGNetService YGPOST:URLString parameters:parameters showLoadingView:flag scrollView:scrollView success:^(id responseObject) {
        [self didReceiveSuccessResponeseWithURLString:URLString parameters:parameters responeseObject:responseObject];
    }   failure:^(NSError *error) {
        [self didReceiveFailureResponeseWithURLString:URLString parameters:parameters error:error];
    }];
}
- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject {
}
- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error {
}

- (UIBarButtonItem *)createBarbuttonWithNormalImageName:(NSString *)imageName selectedImageName:(NSString *)selectImageName selector:(SEL)selector
{

    UIButton *barButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    barButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [barButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [barButton setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    [barButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    return barButtonItem;
}

- (UIBarButtonItem *)createBarbuttonWithNormalTitleString:(NSString *)titleString selectedTitleString:(NSString *)selectedTitleString selector:(SEL)selector
{
    UIButton *barButton = [[UIButton alloc] init];
    [barButton setTitle:titleString forState:UIControlStateNormal];
    [barButton setTitle:selectedTitleString forState:UIControlStateSelected];
    barButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [barButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [barButton sizeToFit];
    [barButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    return barButtonItem;
}

//一键刷新加载
- (void)createRefreshWithScrollView:(UITableView *)tableView containFooter:(BOOL)containFooter {
    tableView.mj_header = [CYGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderAction)];
//    tableView.mj_header = [CYNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderAction)];
    if (containFooter) {
        tableView.mj_footer = [CYNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooterAction)];
        tableView.mj_footer.automaticallyHidden = YES;
    }

    //一次请求条数（默认10）
    _countString = YGPageSize;
    //记录条数
    _totalString = @"0";
}

//下拉方法（无需重写）
- (void)refreshHeaderAction {
    [_noNetBaseView removeFromSuperview];
    //记录条数
    _totalString = @"0";
    [self refreshActionWithIsRefreshHeaderAction:YES];
}

//上拉方法（无需重写）
- (void)refreshFooterAction {
    //记录条数
    _totalString = [NSString stringWithFormat:@"%d", _totalString.intValue + _countString.intValue];
    [self refreshActionWithIsRefreshHeaderAction:NO];
}

//上拉下拉都走的方法，headerAction为YES时为下拉，否则为上拉。上拉加载时total和count直接传self.total和self.count
- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {
    if (headerAction) {
        _totalString = @"0";
    }
}

//停止刷新
- (void)endRefreshWithScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_header endRefreshing];
    [scrollView.mj_footer endRefreshing];
}

//如果刷新数据为空搞一下事情
- (void)noMoreDataFormatWithScrollView:(UITableView *)scrollView {
    if (_totalString.intValue >10) {
        _totalString = [NSString stringWithFormat:@"%d", _totalString.intValue - YGPageSize.intValue];
    }
    [scrollView.mj_footer endRefreshingWithNoMoreData];
}

//自动加未加载图片
- (void)addNoDataImageViewWithArray:(NSArray *)array shouldAddToView:(UIView *)view headerAction:(BOOL)headerAction {
    if (headerAction) {
        if (array.count == 0) {
            [_noDataImageView removeFromSuperview];
            _noDataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodata"]];
            [_noDataImageView sizeToFit];
            [view addSubview:_noDataImageView];

            _noDataImageView.centerx = view.width / 2;
            _noDataImageView.centery = view.width / 2;
        } else {
            [_noDataImageView removeFromSuperview];
        }
    }
}

- (void)addNoNetRetryButtonWithFrame:(CGRect)frame listArray:(NSArray *)listArray {
    [_noNetBaseView removeFromSuperview];
    if (listArray.count != 0) {
        return;
    }
    _noNetBaseView = [[UIView alloc] init];
    _noNetBaseView.backgroundColor = self.view.backgroundColor;;
    UIButton *noNetButton = [[UIButton alloc] init];
    [noNetButton setImage:[UIImage imageNamed:@"ico_nonetwork"] forState:UIControlStateNormal];
    [noNetButton sizeToFit];
    [_noNetBaseView addSubview:noNetButton];

    _noNetBaseView.frame = frame;
    [self.view addSubview:_noNetBaseView];

    if (listArray) {
        [noNetButton addTarget:self action:@selector(refreshHeaderAction) forControlEvents:UIControlEventTouchUpInside];
    } else {
        NSString *sourceString = [NSThread callStackSymbols][1];
        NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString componentsSeparatedByCharactersInSet:separatorSet]];
        [array removeObject:@""];
        _superCmd = NSSelectorFromString(array[5]);
        [noNetButton addTarget:self action:@selector(noNetAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    noNetButton.center = CGPointMake(_noNetBaseView.width / 2, _noNetBaseView.height / 2);
}

- (void)noNetAction:(UIButton *)button {
    [_noNetBaseView removeFromSuperview];
    [self performSelector:_superCmd];
}

- (BOOL)loginOrNot {
    if (![[NSFileManager defaultManager] fileExistsAtPath:USERFILEPATH]) {
        LoginViewController *controller = [[LoginViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        return NO;
    }
    return YES;
}
- (BOOL)isLoginWithParam:(id)param {
    if (![[NSFileManager defaultManager] fileExistsAtPath:USERFILEPATH]) {
        LoginViewController *controller = [[LoginViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        if ([param isKindOfClass:[SQChooseGardenVC class]]) {
            controller.chooseGardenVC = param;
        }
        [self.navigationController pushViewController:controller animated:YES];
        return NO;
    }
    return YES;
}

- (void)registerTimerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerCountingDown:) name:NC_TIMER_COUNT_DOWN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commonTimerDidFinishCountDown) name:NC_TIMER_FINISH object:nil];
}

- (void)timerCountingDown:(NSNotification *)notification {
    NSString *key = NC_TIMER_COUNT_DOWN;
    [self commonTimerCountingDownWithLeftSeconds:[notification.userInfo[key] integerValue]];
}

- (void)commonTimerCountingDownWithLeftSeconds:(NSInteger)seconds {
}

- (void)commonTimerDidFinishCountDown {
}

//没dealloc就有内存泄露了需注意
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}
























- (void)contactWithCustomerServerWithType:(ContactWithServerType)type button:(UIButton *)btn {
    btn.userInteractionEnabled = NO;
    if (type==SQContactServerCallAction) {
        [SQCallPhoneFunction callServicePhoneWithPopver];
        return;
    }
    [YGNetService YGPOST:@"IndoorCall" parameters:@{@"rank":[NSString stringWithFormat:@"%ld",type]} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        btn.userInteractionEnabled = YES;
        [YGAlertView showAlertWithTitle:@"是否拨打客服电话？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                return ;
            } else {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[NSString stringWithFormat:@"%@",responseObject[@"callNum"]]];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }
        }];
    } failure:^(NSError *error) {
        btn.userInteractionEnabled = YES;
        [YGAppTool showToastWithText:@"电话号码获取失败"];
    }];
}




@end
