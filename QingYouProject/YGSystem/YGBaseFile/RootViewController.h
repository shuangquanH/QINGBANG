//
//  RootViewController.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/7/27.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGConnectionService.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "CYNormalHeader.h"
#import "CYNormalFooter.h"


typedef enum : NSUInteger {
    ContactServerPropertyRepair = 1, //物业报修
    ContactServerRushPurchase, //抢购
    ContactServerOfficePurchase,//办公采购
    ContactServerFinacialAccount,// 
    ContactServerIntegrationIndustry,//
    ContactServerAdvertisement,//
    ContactServerPlayTogether,//
    ContactServerNetManager,//
    ContactServerOrderMeetingRoom,//
    ContactServerDecorationCar,//
    ContactServerOrderCheckHouse,//
    ContactServerTakePicturesEasy,
    ContactServerNetManagerVIP,//网络管家电话VIP
    ContactServerMine, //我的页面
    ContactServerIndoorCall, //法律客服
    ContactServerIndoorCommonCall //法律客服

} ContactWithServerType;
@interface RootViewController : UIViewController

@property (nonatomic, strong) NSString *countString;
@property (nonatomic, strong) NSString *totalString;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, strong) UIImageView *noDataImageView;
@property (nonatomic, strong) UIView *noNetBaseView;
@property (nonatomic, strong) UILabel *naviTitleLabel;
//是否已经加载过缓存
@property (nonatomic, assign) BOOL isAlreadyLoadCache;
//用我设置导航栏标题
@property (nonatomic, strong) NSString *naviTitle;

@property (nonatomic, strong) NSMutableAttributedString       *attriTitle;

/**
 网络请求方法，根据自己的喜好选择用此方法还是YGNetService

 @param URLString 请求的url
 @param parameters 参数
 @param flag 是否显示loadingview
 @param scrollView 想要自动停止刷新就传，否则传nil
 */
- (void)startPostWithURLString:(NSString *)URLString
                    parameters:(id)parameters
               showLoadingView:(BOOL)flag
                    scrollView:(UIScrollView *)scrollView;

/**
 网络请求成功回调，直接重写即可

 @param URLString 请求的url
 @param parameters 参数
 @param responseObject 服务器返回的字段
 */
- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject;

/**
 网络请求失败回调，直接重写即可

 @param URLString 请求的url
 @param parameters 参数
 @param error 错误对象
 */
- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error;

/**
 快速创建barbutton（图片）

 @param imageName normal状态下图片名
 @param selectImageName selected状态下图片名
 @param selector 相应方法
 @return UIBarButtonItem
 */
- (UIBarButtonItem *)createBarbuttonWithNormalImageName:(NSString *)imageName selectedImageName:(NSString *)selectImageName selector:(SEL)selector;

/**
 快速创建barbutton（文字）
 
 @param titleString normal状态下文字
 @param selectedTitleString selected状态下文字
 @param selector 相应方法
 @return UIBarButtonItem
 */
- (UIBarButtonItem *)createBarbuttonWithNormalTitleString:(NSString *)titleString selectedTitleString:(NSString *)selectedTitleString selector:(SEL)selector;

/**
 快速创建刷新加载控件

 @param scrollView 要刷新加载的scrollview
 @param containFooter 是否包含footer
 */
- (void)createRefreshWithScrollView:(UIScrollView *)scrollView containFooter:(BOOL)containFooter;


/**
 刷新加载的响应方法（需重写）

 @param headerAction 为yes表示是header的事件，否则为footer
 */
- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction;

/**
 自动创建无图片图

 @param array 数据源array
 @param view 要加到的view
 @param frameY y坐标
 @param headerAction 是否是header的事件
 */
- (void)addNoDataImageViewWithArray:(NSArray *)array shouldAddToView:(UIView *)view headerAction:(BOOL)headerAction;

/**
 * 自动创建无网络重试button
 * @param frame 遮罩view的frame(为了挡住后面难看的view，不是button的frame)
 * @param listArray 数据源，是tableView样式传数据源，否则传nil
 */
- (void)addNoNetRetryButtonWithFrame:(CGRect)frame listArray:(NSArray *)listArray;

/**
 停止刷新加载的方法
 */
- (void)endRefreshWithScrollView:(UIScrollView *)scrollView;

/**
 当上拉没有更多数据的时候调用
 */
- (void)noMoreDataFormatWithScrollView:(UITableView *)scrollView;

/**
 设置属性（需重写）
 */
- (void)configAttribute;

/**
 返回
 */
- (void)back;

/**
 判断是否登录方法（未登录返回NO，自动跳转登录页）
 */
- (BOOL)loginOrNot;

/** 判断是否登录带参数,（未登录返回NO，自动跳转登录页）  */
- (BOOL)isLoginWithParam:(id)param;

#pragma 计时器 倒计时

/**
 *接收timer变化的通知
 */
- (void)registerTimerNotification;

/**
 * 倒计时回调（需要重写）
 * @param seconds 剩余的秒数
 */
- (void)commonTimerCountingDownWithLeftSeconds:(NSInteger)seconds;

/**
 * 倒计时完成回调（需要重写）
 */
- (void)commonTimerDidFinishCountDown;

//电话
- (void)contactWithCustomerServerWithType:(ContactWithServerType)type button:(UIButton *)btn;

@end
