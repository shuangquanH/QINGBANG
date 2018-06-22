//
//  SQSaveWebImage.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/21.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQSaveWebImage.h"

@implementation SQSaveWebImage




+ (void)saveImageWithUrl:(NSString *)urlString {
    
    NSURL *url = [NSURL URLWithString: urlString];
    [[SDWebImageManager sharedManager] loadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        NSLog(@"%ld",receivedSize);
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        // 保存图片到相册中
        UIImageWriteToSavedPhotosAlbum(image,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    }];
}

//保存图片完成之后的回调
+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    // Was there an error?
    if (error != NULL) {
        // Show error message…
        NSLog(@"图片保存失败");
    } else {
        // Show message image successfully saved
        NSLog(@"图片保存成功");
    }
}



@end
