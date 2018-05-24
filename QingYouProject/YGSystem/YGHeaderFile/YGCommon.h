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
#define YGTabBarHeight                    YGSingletonMarco.tabBarHeight                                 // 底部工具栏高度 
#define YGBottomMargin                   ((YGTabBarHeight - 49)/2)

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
#define HEXCOLOR(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]                                //16进制color 使用方法：HEXCOLOR(0xffffff)


// 生成RGB颜色值
#define YGUIColorFromRGB(rgbValue, rgbAlpha) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:rgbAlpha]

// 黑色字体颜色
#define colorWithBlack YGUIColorFromRGB(0x161c16, 1)
// 深灰字体颜色
#define colorWithDeepGray YGUIColorFromRGB(0x737773, 1)
// 浅灰字体颜色
#define colorWithLightGray YGUIColorFromRGB(0x9a9a9a, 1)
// 主色调
#define colorWithMainColor YGUIColorFromRGB(0x2dbe50, 1)
//橙红色金额
#define colorWithOrangeColor YGUIColorFromRGB(0xff6130, 1)
//红色金额
#define colorWithRedColor YGUIColorFromRGB(0xff2020, 1)
// placeholder
#define colorWithPlaceholder YGUIColorFromRGB(0xaaaaaa, 1)

#define colorWithTextPlaceholder YGUIColorFromRGB(0xc7c7cd, 1)

// table背景色
#define colorWithTable YGUIColorFromRGB(0xf7f7f7, 1)
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


/*************************** 其它属性 *****************************************************/
#define YGPasswordLength 15// 密码长度

#define YGPageSize @"10" // Table每页数据的条数

// 默认头像
#define YGDefaultImgAvatar          [UIImage imageNamed:@"defaultavatar.png"]

#define YGDefaultImgSquare          [UIImage imageNamed:@"placeholderfigure_square_750x750"] //正方形

#define YGDefaultImgFour_Three      [UIImage imageNamed:@"placeholderfigure_rectangle_230x172_4_3"] //4：3

#define YGDefaultImgTwo_One         [UIImage imageNamed:@"placeholderfigure_rectangle_750x375_2_1"] //2：1

#define YGDefaultImgThree_Four      [UIImage imageNamed:@"placeholderfigure_rectangle_214x284_3_4"] //3：4

#define YGDefaultImgSixteen_Nine    [UIImage imageNamed:@"placeholderfigure_rectangle_698x392_16_9"] //16：9

#define YGDefaultImgHorizontal      [UIImage imageNamed:@"placeholderfigure_rectangle_698x110"] //横条




/*************************** NsuserDefaultKey名称 *****************************************************/

#define USERDEF_FIRSTOPENAPP                    @"firstOpen"                        //首次打开APP
#define USERDEF_SEARCHHISTORY                   @"searchHistory"                    //搜索历史
#define USERDEF_NOWCITY                         @"nowCity"                          //城市
#define USERDEF_NOWCITYINDEX                    @"nowCityIndex"                     //城市序号
#define USERDEF_LOGINPHONE                      @"phone"                            //电话号

#endif
