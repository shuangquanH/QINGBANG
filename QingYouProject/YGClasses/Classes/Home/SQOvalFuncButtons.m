//
//  SQOvalFuncButtons.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/21.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQOvalFuncButtons.h"

@implementation SQOvalFuncButtons {
    CGSize theSize;
}
- (instancetype)initWithFrame:(CGRect)frame centBtnSize:(CGSize)centerSize backImage:(UIImage   *)image {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:backImage];
        backImage.image = image;
        theSize = centerSize;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
#pragma mark 触发代理方法:
- (void)didselectWithDistance:(CGFloat)distance rads:(CGFloat)rads {
    CGFloat minCenterDis = (theSize.width>theSize.height)?theSize.height:theSize.width;
    CGFloat maxSelfDis = (self.width<self.height)?self.height:self.width;
    if (!self.delegate) {
        return;
    }
    if (distance<minCenterDis) {//中心
        [self.delegate didselectWithClicktype:SQCenterFunc];
    } else if (distance<maxSelfDis/2.0) {
        if (rads>M_PI_4&&rads<M_PI_4*3) {
            [self.delegate didselectWithClicktype:SQBottomFunc];
        } else if (rads>M_PI_4*3&&rads<M_PI_4*5) {
            [self.delegate didselectWithClicktype:SQLeftFunc];
        } else if (rads>M_PI_4*5&&rads<M_PI_4*7) {
            [self.delegate didselectWithClicktype:SQTopFunc];
        } else {
            [self.delegate didselectWithClicktype:SQRightFunc];
        }
    }
}

#pragma mark 点击方法
- (void)tapAction:(UITapGestureRecognizer   *)sender {
    CGPoint point = [sender locationInView:self];
    
    CGPoint centerPoint = CGPointMake(self.width/2.0, self.height/2.0);
    CGFloat distance = [self distanceFromPointX:point distanceToPointY:centerPoint];
    
    CGPoint startPoint = CGPointMake(self.width, self.height/2.0);
    CGFloat rads = [self radiansToDegreesFromPointX:point ToPointY:startPoint ToCenter:centerPoint];
    [self didselectWithDistance:distance rads:rads];
}

#pragma mark - 计算触点和中心点的弧度
-(float)radiansToDegreesFromPointX:(CGPoint)start ToPointY:(CGPoint)end ToCenter:(CGPoint)center{
    float rads;
    CGFloat a = (end.x - center.x);
    CGFloat b = (end.y - center.y);
    CGFloat c = (start.x- center.x);
    CGFloat d = (start.y- center.y);
    rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    if (start.y < center.y) {
        rads = 2*M_PI - rads;
    }
    return rads;
}

#pragma mark - 计算触点到中心点的距离
-(float)distanceFromPointX:(CGPoint)start distanceToPointY:(CGPoint)end{
    float distance;
    CGFloat xDist = (end.x - start.x);
    CGFloat yDist = (end.y - start.y);
    distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}



@end
