//
//  SQBaseImageView.m
//  SQAPPSTART
//
//  Created by qwuser on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SQBaseImageView.h"
#import "YYWebImage.h"

@implementation SQBaseImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}
- (void)setImageWithUrl:(NSString *)url {
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    CGFloat scale = imageWidth/imageHeight;
    
//    0.5 300*600
//    1   300*300
//    1.2 360*300
//    1.4 420*300
//    1.6 480*300
//    1.8 540*300
//    2.0 600*300
//    4.0 800*200
    
    
    UIImage *placeImage;
    if (scale<=0.75) {
        placeImage = [UIImage imageNamed:@"placeholderfigure_rectangle_300x600"];
    } else if (scale<=1.1) {
        placeImage = [UIImage imageNamed:@"placeholderfigure_rectangle_300x300"];
    } else if (scale<=1.3) {
        placeImage = [UIImage imageNamed:@"placeholderfigure_rectangle_360x300"];
    } else if (scale<=1.5) {
        placeImage = [UIImage imageNamed:@"placeholderfigure_rectangle_420x300"];
    } else if (scale<=1.7) {
        placeImage = [UIImage imageNamed:@"placeholderfigure_rectangle_480x300"];
    } else if (scale<=1.9) {
        placeImage = [UIImage imageNamed:@"placeholderfigure_rectangle_540x300"];
    } else if (scale<2.1) {
        placeImage = [UIImage imageNamed:@"placeholderfigure_rectangle_600x300"];
    } else {
        placeImage = [UIImage imageNamed:@"placeholderfigure_rectangle_800x200"];
    }
    
    [self setImageWithUrl:url placeHolder:placeImage];
}
- (void)setImageWithURL:(NSURL *)URL {
    [self setImageWithURL:URL placeHolder:nil];
}

- (void)setImageWithUrl:(NSString *)url placeHolder:(UIImage *)image {
    [self setImageWithUrl:url placeHolder:image finishHandle:nil];
}
- (void)setImageWithURL:(NSURL *)URL placeHolder:(UIImage *)image {
    [self setImageWithURL:URL placeHolder:image finishHandle:nil];
}

- (void)setImageWithUrl:(NSString *)url placeHolder:(UIImage *)image finishHandle:(void(^)(BOOL finished, UIImage *image))finishHandle {
    [self setImageWithUrl:url placeHolder:image progressHandle:nil finishHandle:finishHandle];
}
- (void)setImageWithURL:(NSURL *)URL placeHolder:(UIImage *)image finishHandle:(void (^)(BOOL, UIImage *))finishHandle {
    [self setImageWithURL:URL placeHolder:image progressHandle:nil finishHandle:finishHandle];
}

- (void)setImageWithUrl:(NSString *)url placeHolder:(UIImage *)image progressHandle:(void(^)(CGFloat progress))progressHandle finishHandle:(void(^)(BOOL finished, UIImage *image))finishHandle {
    [self setImageWithURL:[NSURL URLWithString:url] placeHolder:image progressHandle:progressHandle finishHandle:finishHandle];
}
- (void)setImageWithURL:(NSURL *)URL placeHolder:(UIImage *)image progressHandle:(void(^)(CGFloat progress))progressHandle finishHandle:(void(^)(BOOL finished, UIImage *image))finishHandle {
    [self yy_setImageWithURL:URL placeholder:image options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (progressHandle) {
            progressHandle(receivedSize * 1.0 / expectedSize);
        }
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (finishHandle) {
            finishHandle(error == nil, image);
        }
    }];
}
@end
