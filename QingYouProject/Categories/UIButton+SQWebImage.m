//
//  UIButton+SQWebImage.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/28.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "UIButton+SQWebImage.h"

@implementation UIButton (SQWebImage)

- (void)sq_setButtonImageWithUrl:(NSString *)imageUrl {
    NSURL * url = [NSURL URLWithString:imageUrl];
    // 根据图片的url下载图片数据
    dispatch_queue_t xrQueue = dispatch_queue_create("loadImage", NULL); // 创建GCD线程队列
    dispatch_async(xrQueue, ^{
        // 异步下载图片
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        // 主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:img forState:UIControlStateNormal];
        });
    });
}
- (void)sq_setSelectButtonImageWithUrl:(NSString *)imageUrl {
    NSURL * url = [NSURL URLWithString:imageUrl];
    // 根据图片的url下载图片数据
    dispatch_queue_t xrQueue = dispatch_queue_create("loadSelectImage", NULL); // 创建GCD线程队列
    dispatch_async(xrQueue, ^{
        // 异步下载图片
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        // 主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:img forState:UIControlStateSelected];
        });
    });
}
@end
