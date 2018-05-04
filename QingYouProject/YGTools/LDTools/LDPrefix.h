//
//  LDPrefix.h
//  GoldSalePartner
//
//  Created by LDSmallCat on 17/6/19.
//  Copyright © 2017年 曹来东. All rights reserved.
//

#ifndef LDPrefix_h
#define LDPrefix_h
#import "UIView+LDFrame.h"
#import "UIBarButtonItem+LDItem.h"
#import "LDNetWorkTools.h"
#import "UIImage+LDImage.h"
#import "UISearchBar+LDSesrchBar.h"
#import "LDBaseViewCell.h"
#import "LDBaseCollectionViewCell.h"
#import "NSString+LDAttributedString.h"
#import "UIButton+LDButton.h"
#import "UILabel+LDLabel.h"
#import "LDExchangeButton.h"
#import "LDVerticalButton.h"
/*************NSLog*******************/
#ifdef DEBUG //调试
#define LDLog(...) NSLog(__VA_ARGS__);
#else //发布
#define LDLog(...) 
#endif
#define LDLogFunc LDLog(@"%s", __func__);
/*************NSLog*******************/
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

/***********************判断***********************/
//字符串是否为空
#define LDStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

//数组是否为空
#define LDArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//字典是否为空
#define LDDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

//是否是空对象
#define LDObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

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


#endif /* LDPrefix_h */
