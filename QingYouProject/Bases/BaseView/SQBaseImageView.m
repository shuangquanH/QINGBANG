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
    //    placeholderfigure_rectangle_214x284_3_4   = 0.86
    //    placeholderfigure_square_750x750          = 1
    //    placeholderfigure_rectangle_750x560       = 1.34
    //    placeholderfigure_rectangle_750x504       = 1.5
    //    placeholderfigure_rectangle_336x200       = 1.68
    //    placeholderfigure_rectangle_698x392_16_9  = 1.8
    //    placeholderfigure_rectangle_750x375_2_1   = 2
    //    placeholderfigure_rectangle_698x300       = 2.32
    //    placeholderfigure_rectangle_698x110       = 6.35
    
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    CGFloat scale = imageWidth/imageHeight;
    
    UIImage *placeImage;
    if (scale<=0.9) {
        placeImage = [UIImage imageNamed:@"placeholderfigure_rectangle_214x284_3_4"];
    } else if (scale<=1.2) {
        placeImage = [UIImage imageNamed:@"placeholderfigure_square_750x750"];
    } else if (scale<=1.4) {
        placeImage = [UIImage imageNamed:@"placeholderfigure_rectangle_750x560"];
    } else if (scale<=1.6) {
        placeImage = [UIImage imageNamed:@"placeholderfigure_rectangle_750x504"];
    } else if (scale<=1.75) {
        placeImage = [UIImage imageNamed:@"placeholderfigure_rectangle_336x200"];
    } else if (scale<=1.9) {
        placeImage = [UIImage imageNamed:@"placeholderfigure_rectangle_698x392_16_9"];
    } else if (scale<2.1) {
        placeImage = [UIImage imageNamed:@"placeholderfigure_rectangle_750x375_2_1"];
    } else if (scale<5) {
        placeImage = [UIImage imageNamed:@"placeholderfigure_rectangle_698x300"];
    } else {
        placeImage = [UIImage imageNamed:@"placeholderfigure_rectangle_698x110"];
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
