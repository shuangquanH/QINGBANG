//
//  YGAppTool.h
//  FindingSomething
//
//  Created by 韩伟 on 15/10/7.
//  Copyright © 2015年 韩伟. All rights reserved.
//  万能工具类
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

@interface YGAppTool : NSObject


/**
 *  服务器地址
 *
 *  @return 服务器地址
 */
+ (NSString *)getServerUrl;

/**
 *  得到app名称
 *
 *  @return app名称
 */
+ (NSString *)getAppName;

/**
 *  得到app版本
 *
 *  @return app版本
 */
+ (NSString *)getAppVersion;

/**
 *  得到UUID（不唯一）
 *
 *  @return 获得的UUID
 */
+ (NSString *)getUUID;

/**
 *  得到ios系统版本
 *
 *  @return ios系统版本
 */
+ (float)getIOSVersion;

/**
 *  将给定string转成拼音
 *
 *  @param string 给定的string
 *
 *  @return 转换的拼音
 */
+ (NSString *)transformToPinyin:(NSString *)string;

/**
 *  判断给定string是否为整数
 *
 *  @param string 给定的string
 *
 *  @return 整数返回真
 */
+ (BOOL)isPureInt:(NSString *)string;

/**
 *  判断给定string是否为浮点数
 *
 *  @param string 给定的string
 *
 *  @return 浮点数数返回真
 */
+ (BOOL)isPureFloat:(NSString *)string;

/**
 *  判断给定string是否为电话号
 *
 *  @param string 给定的string
 *
 *  @return 不是电话号返回真
 */
+ (BOOL)isNotPhoneNumber:(NSString *)string;

+ (BOOL)isNotName:(NSString *)string;

/**
 *  判断给定string是否为身份证
 *
 *  @param string 给定的string
 *
 *  @return 不是身份证返回真
 */
+ (BOOL)isNotIDCard:(NSString *)string;

/**
 *  判断给定string是否为邮箱
 *
 *  @param string 给定的string
 *
 *  @return 不是邮箱返回真
 */
+ (BOOL)isNotEmail:(NSString *)string;

/**
 *  判断给定string是否为空
 *
 *  @param string 给定的string
 *  @param name 判断的名字
 *
 *  @return 是空返回真
 */
+ (BOOL)isEmpty:(NSString *)string name:(NSString *)name;

/**
 *  判断给定string是否过长
 *
 *  @param string    给定的string
 *  @param maxLength 最大长度
 *  @param name      判断的名字
 *
 *  @return 过长返回真
 */
+ (BOOL)isTooLong:(NSString *)string maxLength:(NSInteger)maxLength name:(NSString *)name;

/**
 *  判断给定string是否过短
 *
 *  @param string    给定的string
 *  @param maxLength 最小长度
 *  @param name      判断的名字
 *
 *  @return 过短返回真
 */
+ (BOOL)isTooShort:(NSString *)string minLength:(NSInteger)minLength name:(NSString *)name;

/**
 *  判断给定string是否合法
 *
 *  @param string    给定的string
 *  @param name      判断的名字
 *  @param maxLength 最大长度
 *  @param minLength 最小长度
 *  @param empty     是否可以为空
 *
 *  @return 合法返回真
 */
+ (BOOL)isVerifiedWithText:(NSString *)string name:(NSString *)name maxLength:(NSInteger)maxLength minLength:(NSInteger)minLength shouldEmpty:(BOOL)empty;

/**
 *  快速创建友盟分享（无界面）
 *
 *  @param shareUrl        分享链接
 *  @param shareDetail     分享详情
 *  @param shareImageUrl   分享图片url
 *  @param shareController 调用的vc
 *  @param platform        平台
 */
+ (void)shareWithShareUrl:(NSString *)shareUrl shareTitle:(NSString *)shareTitle shareDetail:(NSString *)shareDetail shareImageUrl:(NSString *)shareImageUrl shareController:(UIViewController *)shareController sharePlatform:(UMSocialPlatformType)platform;

/**
 *  快速创建友盟分享
 *
 *  @param shareUrl        分享链接
 *  @param shareTitle      分享标题
 *  @param shareDetail     分享详情
 *  @param shareImageUrl      分享图片
 *  @param shareController 调用的VC
 */
+ (void)shareWithShareUrl:(NSString *)shareUrl shareTitle:(NSString *)shareTitle shareDetail:(NSString *)shareDetail shareImageUrl:(NSString *)shareImageUrl shareController:(UIViewController *)shareController;

/**
 *  创建statusBar上的toast
 *
 *  @param text 要显示的文字
 */
+ (void)showToastWithText:(NSString *)text;

/**
 *  将int快速转为string
 *
 *  @param value 要转换的int
 *
 *  @return 返回的string
 */
+ (NSString *)stringValueWithInt:(int)value;

+ (BOOL)stringContainsEmoji:(NSString *)string;

+ (BOOL)hasEmoji:(NSString*)string;

+(BOOL)isNineKeyBoard:(NSString *)string;

+ (NSString *)disable_emoji:(NSString *)text;

/*
 周边加阴影，并且同时圆角
 */
+ (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius;
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
@end
