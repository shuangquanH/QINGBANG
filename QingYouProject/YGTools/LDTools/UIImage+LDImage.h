//
//  UIImage+LDImage.h
//  OC_Project2017
//
//  Created by LDSmallCat on 17/2/7.
//  Copyright © 2017年 曹来东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LDImage)

//生成不被渲染的图片
+ (UIImage *)ld_imageOriginalWithName:(NSString *)imageName;
- (instancetype)ld_circleImage;

+ (instancetype)ld_circleImageNamed:(NSString *)name;
/**用颜色生成图片*/
+ (UIImage *)ld_imageWithColor:(UIColor *)color;

@end
