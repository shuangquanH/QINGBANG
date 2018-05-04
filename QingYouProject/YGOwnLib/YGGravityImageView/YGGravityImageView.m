//
//  YGGravityImageView.m
//  zhonggantest
//
//  Created by zhangkaifeng on 16/6/23.
//  Copyright © 2016年 张楷枫. All rights reserved.
//

#import "YGGravityImageView.h"
#import "YGGravity.h"

#define SPEED 50

@implementation YGGravityImageView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configUI];
    }
    return self;
}


- (void)configUI
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _imageViewArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<3; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.clipsToBounds = YES;
        [_scrollView addSubview:imageView];
        [_imageViewArray addObject:imageView];
    }
    
    _myImageView = _imageViewArray[1];
}


-(void)setImage:(UIImage *)image
{
    _image = image;
    
    for (int i = 0; i<3; i++)
    {
        UIImageView *imageView = _imageViewArray[i];
        imageView.image = image;
        [imageView sizeToFit];
        imageView.width = self.height *(imageView.width / imageView.height);
        imageView.height = self.frame.size.height;
        imageView.y = 0;
        imageView.x = imageView.width * (i - 1);
    }
    
    _scrollView.contentSize = CGSizeMake(_myImageView.width, _myImageView.height);
    _scrollView.contentOffset = CGPointMake(_myImageView.width/2 - self.width/2, _scrollView.contentOffset.y);
    
}

-(void)startAnimate
{
    float scrollSpeed = 10;
    [YGGravity sharedGravity].timeInterval = 0.02;
    
    [[YGGravity sharedGravity]startDeviceMotionUpdatesBlock:^(float x, float y, float z) {
        
        [UIView animateWithDuration:0.02 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
            
            if (_scrollView.contentOffset.x < CGRectGetMaxX(((UIImageView *)_imageViewArray[0]).frame))
            {
                UIImageView *tempImageView = _imageViewArray[2];
                [_imageViewArray removeObjectAtIndex:2];
                [_imageViewArray insertObject:tempImageView atIndex:0];
                tempImageView.x = ((UIImageView *)_imageViewArray[1]).x - tempImageView.width;
                _myImageView = _imageViewArray[1];
            }
            
            if (_scrollView.contentOffset.x + self.width > ((UIImageView *)_imageViewArray[2]).x)
            {
                UIImageView *tempImageView = _imageViewArray[0];
                [_imageViewArray removeObjectAtIndex:0];
                [_imageViewArray addObject:tempImageView];
                tempImageView.x = ((UIImageView *)_imageViewArray[1]).x + tempImageView.width;
                _myImageView = _imageViewArray[1];
            }

                float invertedYRotationRate = y * -1.0;
                float interpretedXOffset = _scrollView.contentOffset.x + invertedYRotationRate * (_myImageView.width/ self.width) * scrollSpeed + _myImageView.width/2;
                //                _myImageView.center = CGPointMake(interpretedXOffset, _myImageView.center.y);
                _scrollView.contentOffset = CGPointMake(interpretedXOffset - _myImageView.width/2, _scrollView.contentOffset.y);
        } completion:nil];
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    [self stopAnimate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    [self startAnimate];
}

-(void)stopAnimate
{
    [[YGGravity sharedGravity] stop];
}

@end
