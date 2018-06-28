
//
//  YGAppTool.m
//  FindingSomething
//0
//  Created by 韩伟 on 15/10/7.
//  Copyright © 2015年 韩伟. All rights reserved.
//

#import "YGAppTool.h"
//#import "FCUUID.h"
#import <MBProgressHUD.h>
#import "YGShareView.h"


@interface YGAppTool ()


@end

@implementation YGAppTool

/**
 *  服务器地址
 *
 *  @return 服务器地址
 */
+ (NSString *)getServerUrl
{
    return YGMainServer;
}

/**
 *  得到app名称
 *
 *  @return app名称
 */
+ (NSString *)getAppName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleDisplayName"];
}

/**
 *  得到app版本
 *
 *  @return app版本
 */
+ (NSString *)getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

///**
// *  得到UUID（唯一）
// *
// *  @return 获得的UUID
// */
//+ (NSString *)getUUID
//{
//    NSLog(@"-------%@--------", [FCUUID uuidForDevice]);
//    return [FCUUID uuidForDevice];
//}

/**
 *  得到ios系统版本
 *
 *  @return ios系统版本
 */
+ (float)getIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

/**
 *  将给定string转成拼音
 *
 *  @param string 给定的string
 *
 *  @return 转换的拼音
 */
+ (NSString *)transformToPinyin:(NSString *)string
{
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef) mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *) [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return mutableString;
}

/**
 *  判断给定string是否为整数
 *
 *  @param string 给定的string
 *
 *  @return 整数返回真
 */
+ (BOOL)isPureInt:(NSString *)string
{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

/**
 *  判断给定string是否为浮点数
 *
 *  @param string 给定的string
 *
 *  @return 浮点数数返回真
 */
+ (BOOL)isPureFloat:(NSString *)string
{
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}


/**
 *  判断给定string是否为电话号
 *
 *  @param string 给定的string
 *
 *  @return 不是电话号返回真
 */
+ (BOOL)isNotPhoneNumber:(NSString *)string
{
    if (string.length != 11)
    {
        [self showToastWithText:@"手机号填写有误"];
        return YES;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:string] == YES)
        || ([regextestcm evaluateWithObject:string] == YES)
        || ([regextestct evaluateWithObject:string] == YES)
        || ([regextestcu evaluateWithObject:string] == YES))
    {
        return NO;
    }
    else
    {
        [self showToastWithText:@"手机号填写有误"];
        
        return YES;
    }
    
}

//判断是否有中文
+ (BOOL)isNotName:(NSString *)string
{
    for (int i = 0; i < [string length]; i++)
    {
        int a = [string characterAtIndex:i];
        //有英文
        if (a <= 0x4e00 || a >= 0x9fff)
        {
            [YGAppTool showToastWithText:@"请输入正确的姓名"];
            return YES;
        }
    }
    if (string.length < 2 || string.length > 8)
    {
        [YGAppTool showToastWithText:@"请输入正确的姓名"];
        return YES;
    }
    return NO;
    
}

/**
 *  判断给定string是否为身份证
 *
 *  @param string 给定的string
 *
 *  @return 不是身份证返回真
 */
+ (BOOL)isNotIDCard:(NSString *)string
{
    if (string.length <= 0)
    {
        [YGAppTool showToastWithText:@"身份证号填写有误"];
        return YES;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    if ([identityCardPredicate evaluateWithObject:string])
    {
        return NO;
    }
    [YGAppTool showToastWithText:@"身份证号填写有误"];
    return YES;
}

/**
 *  判断给定string是否为邮箱
 *
 *  @param string 给定的string
 *
 *  @return 不是邮箱返回真
 */
+ (BOOL) isNotEmail:(NSString *)string
{
    NSString *emailRegex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if ([emailTest evaluateWithObject:string])
    {
        return NO;
    }
    else
    {
        [YGAppTool showToastWithText:@"邮箱填写有误"];
        return YES;
    }
}

/**
 *  判断给定string是否为空
 *
 *  @param string 给定的string
 *  @param name 判断的名字
 *
 *  @return 是空返回真
 */
+ (BOOL)isEmpty:(NSString *)string name:(NSString *)name
{
    if ([[string stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])
    {
        [self showToastWithText:[NSString stringWithFormat:@"%@不能为空哦", name]];
        return YES;
    }
    return NO;
}

/**
 *  判断给定string是否过长
 *
 *  @param string    给定的string
 *  @param maxLength 最大长度
 *  @param name      判断的名字
 *
 *  @return 过长返回真
 */
+ (BOOL)isTooLong:(NSString *)string maxLength:(NSInteger)maxLength name:(NSString *)name
{
    if (string.length > maxLength)
    {
        [self showToastWithText:[NSString stringWithFormat:@"%@最多%ld个字哦", name, (long) maxLength]];
        return YES;
    }
    return NO;
}

/**
 *  判断给定string是否过短
 *
 *  @param string    给定的string
 *  @param maxLength 最小长度
 *  @param name      判断的名字
 *
 *  @return 过短返回真
 */
+ (BOOL)isTooShort:(NSString *)string minLength:(NSInteger)minLength name:(NSString *)name
{
    if (string.length < minLength)
    {
        [self showToastWithText:[NSString stringWithFormat:@"%@最少%ld个字哦", name, (long) minLength]];
        return YES;
    }
    return NO;
}

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
+ (BOOL)isVerifiedWithText:(NSString *)string name:(NSString *)name maxLength:(NSInteger)maxLength minLength:(NSInteger)minLength shouldEmpty:(BOOL)empty
{
    if (!empty)
    {
        if ([YGAppTool isEmpty:string name:name])
        {
            return NO;
        }
    }
    
    if ([YGAppTool isTooLong:string maxLength:maxLength name:name])
    {
        return NO;
    }
    
    if ([YGAppTool isTooShort:string minLength:minLength name:name])
    {
        return NO;
    }
    return YES;
}

/**
 *  快速创建友盟分享（无界面）
 *
 *  @param shareUrl        分享链接
 *  @param shareDetail     分享详情
 *  @param shareImageUrl   分享图片url
 *  @param shareController 调用的vc
 *  @param platform        平台
 */
+ (void)shareWithShareUrl:(NSString *)shareUrl shareTitle:(NSString *)shareTitle shareDetail:(NSString *)shareDetail shareImageUrl:(NSString *)shareImageUrl shareController:(UIViewController *)shareController sharePlatform:(UMSocialPlatformType)platform
{
    
    
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:shareImageUrl];
    if (cachedImage == nil)
    {
        cachedImage = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:shareImageUrl]]];
    }
    
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareTitle descr:shareDetail thumImage:cachedImage];
    //设置网页地址
    shareObject.webpageUrl = shareUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:shareController completion:^(id data, NSError *error)
     {
         if (error)
         {
             NSLog(@"************Share fail with error %@*********", error);
         }
         else
         {
             [YGAppTool showToastWithText:@"分享成功"];
             NSLog(@"response data is %@", data);
         }
     }];
}

/**
 *  快速创建友盟分享
 *
 *  @param shareUrl        分享链接
 *  @param shareTitle      分享标题
 *  @param shareDetail     分享详情
 *  @param shareImageUrl      分享图片
 *  @param shareController 调用的VC
 */
+ (void)shareWithShareUrl:(NSString *)shareUrl shareTitle:(NSString *)shareTitle shareDetail:(NSString *)shareDetail shareImageUrl:(NSString *)shareImageUrl shareController:(UIViewController *)shareController
{
    __weak typeof(self) weakSelf = self;
    //显示分享面板
    YGShareView *shareView = [[YGShareView alloc] init];
    [shareView show];
    if (shareDetail == nil || [shareDetail isEqualToString:@""]) {
        shareDetail = @"点击查看更多详情";
//        shareDetail = @"青邦应用满足不同人群的需求，构建造生活、工作、管理三位一体的“生态圈”，打造无所不在的服务提供能力。";
    }
    [shareView buttonClickBlock:^(NSInteger buttonIndex)
     {
         if (buttonIndex == 5) {
             [UIPasteboard generalPasteboard].string = shareUrl;
             return ;
         }

         UMSocialPlatformType platform = 0;
         switch (buttonIndex)
         {
             case 0:
             {
                 platform = UMSocialPlatformType_WechatSession;
             }
                 break;
             case 1:
             {
                 platform = UMSocialPlatformType_WechatTimeLine;
             }
                 break;
             case 2:
             {
                 platform = UMSocialPlatformType_QQ;
                 break;
             }
             case 3:
             {
                 platform = UMSocialPlatformType_Qzone;
             }
                 break;
             case 4:
             {
                 platform = UMSocialPlatformType_Sina;
             }
                 break;
         }
       
         [weakSelf shareWithShareUrl:shareUrl shareTitle:shareTitle shareDetail:shareDetail shareImageUrl:shareImageUrl shareController:shareController sharePlatform:platform];
     }];
}

/**
 *  创建statusBar上的toast
 *
 *  @param text 要显示的文字
 */


MBProgressHUD *hud;
+ (void)showToastWithText:(NSString *)text
{
    hud = [MBProgressHUD showHUDAddedTo:YGAppDelegate.window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.6];
    hud.label.text = text;
    hud.label.textColor = colorWithYGWhite;
    hud.label.numberOfLines = 0;
    hud.animationType = MBProgressHUDAnimationZoomIn;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    [hud hideAnimated:YES afterDelay:1.6];
}
+ (void)dismissToast {
    [hud hideAnimated:YES];
    [hud removeFromSuperview];
}

/**
 *  将int快速转为string
 *
 *  @param value 要转换的int
 *
 *  @return 返回的string
 */
+ (NSString *)stringValueWithInt:(int)value
{
    return [NSString stringWithFormat:@"%d", value];
}

/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
+ (BOOL)stringContainsEmoji:(NSString *)string {
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
+ (BOOL)hasEmoji:(NSString*)string
{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
+(BOOL)isNineKeyBoard:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}

//-----过滤字符串中的emoji
+ (NSString *)disable_emoji:(NSString *)text {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

/*
 周边加阴影，并且同时圆角
 */
+ (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius
{
    //////// shadow /////////
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = view.layer.frame;
    
    shadowLayer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = CGSizeMake(0, 0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    
    //////// cornerRadius /////////
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [view.superview.layer insertSublayer:shadowLayer below:view.layer];
}

/**
 * 开始到结束的时间差
 */
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int seconds = (int)value % 60;
    int minutes = (int)(value / 60) % 60;
    int hours = (int)value / 3600;
//    int d = (int)value/1000/60/60/24;
    int d = hours/24;
    
    hours = hours-24*d;
    if (d == 0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];

    }else
    {
        return [NSString stringWithFormat:@"%02d天  %02d:%02d:%02d",d,hours, minutes, seconds];
    }

}
@end
