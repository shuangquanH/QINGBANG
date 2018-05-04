//
//  UIImage+LDImage.m
//  OC_Project2017
//
//  Created by LDSmallCat on 17/2/7.
//  Copyright © 2017年 曹来东. All rights reserved.
//

#import "UIImage+LDImage.h"

@implementation UIImage (LDImage)
+ (UIImage *)ld_imageWithColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 5.0f, 5.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;

}
+ (UIImage *)ld_imageOriginalWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

}
- (instancetype)ld_circleImage{

    // 1.开启图形上下文
    // 比例因素:当前点与像素比例
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 2.描述裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 3.设置裁剪区域;
    [path addClip];
    // 4.画图片
    [self drawAtPoint:CGPointZero];
    // 5.取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)ld_circleImageNamed:(NSString *)name{
    
    return [[self imageNamed:name] ld_circleImage];

}
/*
 
 - (void)ld_setHeader:(NSString *)headerUrl;
 
 - (void)ld_setHeader:(NSString *)headerUrl{
 
 UIImage *placeholder = [UIImage xmg_circleImageNamed:@"defaultUserIcon"];
 [self sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
 // 图片下载失败，直接返回，按照它的默认做法
 if (!image) return;
 
 self.image = [image xmg_circleImage];
 }];
 
 //    [self sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
 }
 */
@end
