//
//  SQMacroFile.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/23.
//  Copyright © 2018年 ccyouge. All rights reserved.
//


#ifndef SQMacroFile_h
#define SQMacroFile_h

#import "UIColor+Extension.h"
//所有的宏定义 放在该文件

#ifndef SQMacroFile_h
#define SQMacroFile_h
#endif /* SQMacroFile_h */

/** 打印方法（只会在Debug环境下会打印） */
#ifndef __OPTIMIZE__
#define SQLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif

/** 通知中心单利  */
#define KNOTI_CENTER        [NSNotificationCenter defaultCenter]

/** 屏幕宽度 */
#define KAPP_WIDTH          ([SQIphonePx shareInstance].phoneWidth)
/** 屏幕高度 */
#define KAPP_HEIGHT         ([SQIphonePx shareInstance].phoneHeight)
/** 导航栏高度 */
#define KNAV_HEIGHT         ([SQIphonePx shareInstance].navHeight)
/** Tabbar高度 */
#define KTAB_HEIGHT         ([SQIphonePx shareInstance].tabHeight)
/** 状态栏高度 */
#define KSTATU_HEIGHT       ([SQIphonePx shareInstance].statuHeight)
/** 是否是iPhoneX */
#define KISX                ([SQIphonePx shareInstance].isiPhoneX)
/** ui缩放比例 */
#define KSCAL(a)            ([SQIphonePx shareInstance].uiScaling*a)
/** 字体大小 */
#define KFONT(a)            [UIFont systemFontOfSize:KSCAL(a)]


/** app主色调 */
#define KCOLOR_MAIN         [UIColor hexStringToColor:@"f39700"]
/** 白色 */
#define KCOLOR_WHITE         [UIColor hexStringToColor:@"ffffff"]

/** 333黑色  */
#define kCOLOR_333          [UIColor hexStringToColor:@"333333"]
/** 666灰色  */
#define kCOLOR_666          [UIColor hexStringToColor:@"666666"]
/** 999灰色  */
#define kCOLOR_999          [UIColor hexStringToColor:@"999999"]
/** 浅灰背景颜色  */
#define KCOLOR_LIGHTBACK    [UIColor hexStringToColor:@"F0F0F0"]

/** 颜色(传string格式) */
#define KCOLOR(a)           [UIColor hexStringToColor:a]

/** 颜色和透明度(颜色为string格式，透明度为float格式) */
#define KCOLOR_ALPHA(a,b)   [UIColor hexStringToColor:a andAlpha:b]


/** 系统版本 */
#define KiOS9_1Later        ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
#define KiOS11Later         ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)



#endif /* SQMacroFile_h */
