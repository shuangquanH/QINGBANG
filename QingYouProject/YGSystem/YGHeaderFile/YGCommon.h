//
//  YGCommon.h
//  YGToolProject
//
//  Created by 韩伟 on 15/8/31.
//  Copyright (c) 2015年 韩伟. All rights reserved.
//

#ifndef YGToolProject_YGCommon_h
#define YGToolProject_YGCommon_h

/**弱引用weakself*/
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;


/*************************** 常用的 IPHONE 属性 *******************************************/
#define YGScreenWidth   ([[UIScreen mainScreen] bounds].size.width) // 屏幕宽度
#define YGScreenHeight  ([[UIScreen mainScreen] bounds].size.height)// 屏幕高度

#define YGAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])   // 系统的AppleDelegate

#define YGSingletonMarco [YGSingleton sharedManager]
#define YGNetService [YGConnectionService sharedConnectionService]
#define YGUserDefaults [NSUserDefaults standardUserDefaults]

#define YGStatusBarHeight               [UIApplication sharedApplication].statusBarFrame.size.height    // 状态栏高度
#define YGNaviBarHeight                   44                                                            // 工具栏高度 
#define YGBottomMargin                   ((KTAB_HEIGHT - 49)/2)

#define USERFILEPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"user.data"]

////去版本警告
//#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


/**
 *                          NotificationCenter Key
 */
#define NC_TIMER_FINISH                     @"NC_TIMER_FINISH"                                                      // 倒计时完成
#define NC_TIMER_COUNT_DOWN                 @"NC_TIMER_COUNT_DOWN"                                                  // 正在倒计时
/***************************   SDK各种key  **********************************************/
#define APPKEY_UMENG                                    @"5a00ff3bf43e480ae800063f"
#define APPKEY_UMENG_WXAPPID                            @"wx84ca153aa536ac9b"
#define APPKEY_UMENG_WXAPPSECRET                        @"c33a2d97edd2c5bba9ff0d86b2f0fad5"
#define APPKEY_UMENG_WXURL                              @"http://www.huobanchina.com"
#define APPKEY_UMENG_QQAPPID                            @"1106446191"
#define APPKEY_UMENG_QQAPPKEY                           @"8VIXImbukJU2CzZd"
#define APPKEY_UMENG_QQURL                              @"http://www.huobanchina.com"
#define APPKEY_UMENG_SINAAPPID                          @"3373427159"
#define APPKEY_UMENG_SINAAPPKEY                         @"1e1bee3ffee765259bce5e97a4ee216f"
#define APPKEY_UMENG_SINAURL                            @"http://sns.whalecloud.com/sina/callback"

#define APPKEY_BAIDUMAP                                 @"3on3q0U6E9FQ1j7maqyTbSi1Eu8q0WnF"

/***************************    提示文字   **********************************************/
#define NOTICE_NOMORE                                   @"没有更多了哦"

/***************************   RGB 颜色生成器  *******************************************/
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//16进制color 使用方法：HEXCOLOR(0xffffff)
#define HEXCOLOR(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



// 生成RGB颜色值
#define YGUIColorFromRGB(rgbValue, rgbAlpha) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:rgbAlpha]


// 主色调
#define colorWithMainColor YGUIColorFromRGB(0xf39700, 1)

// 黑色字体颜色
#define colorWithBlack YGUIColorFromRGB(0x161c16, 1)
// 深灰字体颜色
#define colorWithDeepGray YGUIColorFromRGB(0x737773, 1)
// 浅灰字体颜色
#define colorWithLightGray YGUIColorFromRGB(0x9a9a9a, 1)
//橙红色金额
#define colorWithOrangeColor YGUIColorFromRGB(0xff6130, 1)
//红色金额
#define colorWithRedColor YGUIColorFromRGB(0xff2020, 1)
// placeholder
#define colorWithPlaceholder YGUIColorFromRGB(0xaaaaaa, 1)
// placeholder2
#define colorWithTextPlaceholder YGUIColorFromRGB(0xc7c7cd, 1)

// table背景色
#define colorWithTable YGUIColorFromRGB(0xf0f0f0, 1)
// 白色
#define colorWithYGWhite [UIColor whiteColor]
// 亮色table
#define colorWithLightTable [UIColor colorWithRed:0.97 green:0.98 blue:0.99 alpha:1.00]
// 浅色线
#define colorWithLine YGUIColorFromRGB(0xeeeeee, 1)
//导航栏线线
#define colorWithTabNaviLine YGUIColorFromRGB(0xe0e0e0, 1)
//板块间隔色
#define colorWithPlateSpacedColor YGUIColorFromRGB(0xefeff4, 1)

/*************************** 常用的 IPHONE 字体 *******************************************/
// 字体大小
#define YGFontSizeBigSuper           ([UIFont systemFontSize] + 10)// 超级大
#define YGFontSizeBigFour           ([UIFont systemFontSize] + 6) // 大大
#define YGFontSizeBigThree           ([UIFont systemFontSize] + 4) // 大大
#define YGFontSizeBigTwo             ([UIFont systemFontSize] + 2) // 大
#define YGFontSizeBigOne             ([UIFont systemFontSize] + 1) // 中大
#define YGFontSizeNormal             ([UIFont systemFontSize])     // 普通
#define YGFontSizeSmallOne           ([UIFont systemFontSize] - 1) // 中小
#define YGFontSizeSmallTwo           ([UIFont systemFontSize] - 2) // 小
#define YGFontSizeSmallThree         ([UIFont systemFontSize] - 4) // 小小



/*************NSLog*******************/
#ifdef DEBUG //调试
#define LDLog(...) NSLog(__VA_ARGS__);
#else //发布
#define LDLog(...)
#endif
#define LDLogFunc LDLog(@"%s", __func__);
/*************NSLog*******************/

//本地存
#define LDUserToken @"userToken"
#define LDUserId @"userId"
#define LDWriteForLocation(OBJECT,KEY) \
[[NSUserDefaults standardUserDefaults] setObject:OBJECT forKey:KEY];\
[[NSUserDefaults standardUserDefaults] synchronize];
//字体

#define LDFont(x)      [UIFont systemFontOfSize:x]
#define LD14Font      [UIFont systemFontOfSize:14]
#define LD13Font      [UIFont systemFontOfSize:13]
#define LD15Font      [UIFont systemFontOfSize:15]

#define LDBoldFont(x)  [UIFont boldSystemFontOfSize:x]
#define  leftFont LDFont(15)

//本地取
#define LDReadForLocation(KEY)         [[NSUserDefaults standardUserDefaults] objectForKey:KEY]
//imageNamed
#define LDImage(imageName) [UIImage imageNamed:imageName]

#define LDRGBColor(r,g,b) [UIColor colorWithRed:(r) / 256.0 green:(g) / 256.0 blue:(b) / 256.0 alpha:1]

#define LDRandomColor LDRGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
#define kScreenW   [UIScreen mainScreen].bounds.size.width
#define kScreenH   [UIScreen mainScreen].bounds.size.height
#define iphoneX (kScreenH == 812)
#define iphone6P (kScreenH == 736)
#define iphone6 (kScreenH == 667)//375
#define iphone5 (kScreenH == 568)
#define iphone4 (kScreenH == 480)

// 定义通用颜色
#define kBlackColor         [UIColor blackColor]
#define kDarkGrayColor      [UIColor darkGrayColor]
#define kLightGrayColor     [UIColor lightGrayColor]
#define kWhiteColor         [UIColor whiteColor]
#define kLightTextColor         [UIColor lightTextColor]
#define kGrayColor          [UIColor grayColor]
#define kRedColor           [UIColor redColor]
#define kGreenColor         [UIColor greenColor]
#define kBlueColor          [UIColor blueColor]
#define kCyanColor          [UIColor cyanColor]
#define kYellowColor        [UIColor yellowColor]
#define kMagentaColor       [UIColor magentaColor]
#define kOrangeColor        [UIColor orangeColor]
#define kPurpleColor        [UIColor purpleColor]
#define kClearColor         [UIColor clearColor]
#define LDMainColor LDRGBColor(45, 190, 80)
#define LDMainBackColor  YGUIColorFromRGB(0xfff000, 1)
#define LDEFPaddingColor YGUIColorFromRGB(0xefeff4, 1)
#define LDEEPaddingColor YGUIColorFromRGB(0xeeeeee, 1)
#define LDE0PaddingColor YGUIColorFromRGB(0xe0e0e0, 1)
#define LD16TextColor YGUIColorFromRGB(0x161c16, 1)
#define LD73TextColor YGUIColorFromRGB(0x737773, 1)
#define LD9ATextColor YGUIColorFromRGB(0x9a9a9a, 1)
#define LDFFTextColor YGUIColorFromRGB(0xff6130, 1)


//刷新LDTextView数据
#define  ReloadLDTextViewData @"ReloadLDTextViewData"
#define LDManagerBannerImage @"1" //轮播图占位图
#define Banner_W_H_Scale 2   //轮播图比例
#define LDHPadding  10.0
#define LDVPadding  10.0
#define kScreenWidthRatio  (kScreenW / 414.0)
#define kScreenHeightRatio (kScreenH / 736.0)
#define AdaptedWidth(x)  floorf((x) * kScreenWidthRatio)
#define AdaptedHeight(x) floorf((x) * kScreenHeightRatio)
#define AdaptedFont(x)     [UIFont systemFontOfSize:AdaptedWidth(x)]




/*************************** 其它属性 *****************************************************/
#define YGPasswordLength 15// 密码长度

#define YGPageSize @"10" // Table每页数据的条数

// 默认头像
#define YGDefaultImgAvatar          [UIImage imageNamed:@"defaultavatar.png"]               //默认头像

#define YGDefaultImgSquare          [UIImage imageNamed:@"placeholderfigure_square_750x750"] //正方形

#define YGDefaultImgFour_Three      [UIImage imageNamed:@"placeholderfigure_rectangle_230x172_4_3"] //4：3

#define YGDefaultImgTwo_One         [UIImage imageNamed:@"placeholderfigure_rectangle_750x375_2_1"] //2：1

#define YGDefaultImgThree_Four      [UIImage imageNamed:@"placeholderfigure_rectangle_214x284_3_4"] //3：4

#define YGDefaultImgSixteen_Nine    [UIImage imageNamed:@"placeholderfigure_rectangle_698x392_16_9"] //16：9

#define YGDefaultImgHorizontal      [UIImage imageNamed:@"placeholderfigure_rectangle_698x110"]     //横条


/** 上面的define尽量不要用，以后全部删除掉  */

/*************************** NsuserDefaultKey名称 *****************************************************/

#define USERDEF_FIRSTOPENAPP                    @"firstOpen"                        //首次打开APP
#define USERDEF_SEARCHHISTORY                   @"searchHistory"                    //搜索历史
#define USERDEF_NOWCITY                         @"nowCity"                          //城市
#define USERDEF_NOWCITYINDEX                    @"nowCityIndex"                     //城市序号
#define USERDEF_LOGINPHONE                      @"phone"                            //电话号





/** 黄双全新增  */

/*************************** 通知中心key *****************************************************/

#define KNOTI_LASTLAUNCHPAGE        @"NOTIFICATION_LASTLAUNCHPAGE_KEY"//引导图最后一张
#define kNOTI_DIDICHOOSEINNER       @"kNOTIFICATION_DIDICHOOSEINNER_KEY"//选择是否是园区
#define KNOTI_FIRSTLAUNCHLOGINBACK  @"KNOTI_FIRSTLAUNCHLOGINBACK"//第一次打开app登录后返回




#endif
