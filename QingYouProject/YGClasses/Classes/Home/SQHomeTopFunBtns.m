//
//  SQHomeTopFunBtns.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/19.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQHomeTopFunBtns.h"


@implementation SQHomeTopFunBtn
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();//设置一个画布:
    CGContextSetStrokeColorWithColor(context, self.contentColor.CGColor);/** 设置描边颜色  */
    CGContextSetFillColorWithColor(context, self.contentColor.CGColor);//填充颜色
    CGContextMoveToPoint(context, self.width/2.0, self.height);//设置圆心
    CGContextAddArc(context, self.width/2.0, self.height, self.height, -3*M_PI_4, -M_PI_4, 0);//设置绘画规则
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
}
@end

@implementation SQHomeLeftFunBtn
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();//设置一个画布:
    CGContextSetStrokeColorWithColor(context, self.contentColor.CGColor);/** 设置描边颜色  */
    CGContextSetFillColorWithColor(context, self.contentColor.CGColor);//填充颜色
    CGContextMoveToPoint(context, self.width, self.height/2.0);//设置圆心
    CGContextAddArc(context, self.width, self.height/2.0, self.width, -5*M_PI_4, -3*M_PI_4, 0);//设置绘画规则
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
}
@end

@implementation SQHomeBottomFunBtn
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();//设置一个画布:
    CGContextSetStrokeColorWithColor(context, self.contentColor.CGColor);/** 设置描边颜色  */
    CGContextSetFillColorWithColor(context, self.contentColor.CGColor);//填充颜色
    CGContextMoveToPoint(context, self.width/2.0, 0);//设置圆心
    CGContextAddArc(context, self.width/2.0, 0, self.height, M_PI_4, M_PI_4*3, 0);//设置绘画规则
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
}
@end

@implementation SQHomeRightFunBtn
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();//设置一个画布:
    CGContextSetStrokeColorWithColor(context, self.contentColor.CGColor);/** 设置描边颜色  */
    CGContextSetFillColorWithColor(context, self.contentColor.CGColor);//填充颜色
    CGContextMoveToPoint(context, 0, self.height/2.0);//设置圆心
    CGContextAddArc(context, 0, self.height/2.0, self.width, -M_PI_4, M_PI_4, 0);//设置绘画规则
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
}
@end

@implementation SQHomeCenterFunBtn
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();//设置一个画布:
    CGContextSetStrokeColorWithColor(context, self.contentColor.CGColor);/** 设置描边颜色  */
    CGContextSetFillColorWithColor(context, self.contentColor.CGColor);//填充颜色
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, self.width, self.height));
    CGContextDrawPath(context, kCGPathFillStroke);//画椭圆
}
@end












@implementation SQHomeTopFunBtns
- (instancetype)initWithFrame:(CGRect)frame withCenterSize:(CGSize)thesize
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        
        SQHomeTopFunBtn *top = [SQHomeTopFunBtn buttonWithType:UIButtonTypeCustom];
        top.frame = CGRectMake(0, 0, frame.size.width, frame.size.height/2.0);
        top.contentColor = colorWithMainColor;
        [self addSubview:top];
        [top addTarget:self action:@selector(buttonaction) forControlEvents:UIControlEventTouchUpInside];
        
        SQHomeLeftFunBtn *left = [SQHomeLeftFunBtn buttonWithType:UIButtonTypeCustom];
        left.frame = CGRectMake(0, 0, frame.size.width/2.0, frame.size.height);
        left.contentColor = [UIColor redColor];
        [self addSubview:left];
        [left addTarget:self action:@selector(buttonaction) forControlEvents:UIControlEventTouchUpInside];
        
        SQHomeBottomFunBtn *bottom = [SQHomeBottomFunBtn buttonWithType:UIButtonTypeCustom];
        bottom.frame = CGRectMake(0, frame.size.height/2.0, frame.size.width, frame.size.height/2.0);
        bottom.contentColor = [UIColor greenColor];
        [self addSubview:bottom];
        [bottom addTarget:self action:@selector(buttonaction) forControlEvents:UIControlEventTouchUpInside];
        
        SQHomeRightFunBtn   *right = [SQHomeRightFunBtn buttonWithType:UIButtonTypeCustom];
        right.frame = CGRectMake(frame.size.width/2.0, 0, frame.size.width/2.0, frame.size.height);
        right.contentColor = [UIColor yellowColor];
        [self addSubview:right];
        [right addTarget:self action:@selector(buttonaction) forControlEvents:UIControlEventTouchUpInside];
        
        SQHomeCenterFunBtn  *center = [SQHomeCenterFunBtn buttonWithType:UIButtonTypeCustom];
        center.contentColor = [UIColor whiteColor];
        CGFloat thex = (frame.size.width-thesize.width)/2.0;
        CGFloat they = (frame.size.height-thesize.height)/2.0;
        center.frame = CGRectMake(thex, they, thesize.width, thesize.height);
        [self addSubview:center];
        [center addTarget:self action:@selector(buttonaction) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
    }
    return self;
}

- (void)buttonaction {
    NSLog(@"gaagggaa");
    
}


@end
