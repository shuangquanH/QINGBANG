//
//  UIView+LDFrame.m
//  OC_Project2017
//
//  Created by LDSmallCat on 17/2/8.
//  Copyright © 2017年 曹来东. All rights reserved.
//

#import "UIView+LDFrame.h"

@implementation UIView (LDFrame)
+ (instancetype)ld_viewFromXib{
return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;

}

#pragma mark - < set >
- (void)setLd_size:(CGSize)ld_size{

    CGRect frame = self.frame;
    frame.size = ld_size;
    self.frame = frame;

}
-(void)setLd_width:(CGFloat)ld_width{

    CGRect frame = self.frame;
    
    frame.size.width = ld_width;
    
    self.frame = frame;
}
-(void)setLd_height:(CGFloat)ld_height{
    CGRect frame = self.frame;
    frame.size.height = ld_height;
    self.frame = frame;

}
-(void)setLd_x:(CGFloat)ld_x{

    CGRect frame = self.frame;
    frame.origin.x = ld_x;
    self.frame = frame;

}

-(void)setLd_y:(CGFloat)ld_y{
    CGRect frame = self.frame;
    frame.origin.y = ld_y;
    self.frame = frame;

}

- (void)setLd_centerX:(CGFloat)ld_centerX{
    CGPoint center = self.center;
    center.x = ld_centerX;
    self.center = center;

}

- (void)setLd_centerY:(CGFloat)ld_centerY{
    CGPoint center = self.center;
    center.y = ld_centerY;
    self.center = center;

}
- (void)setLd_right:(CGFloat)ld_right{
    self.ld_x = ld_right - self.ld_width;

}
- (void)setLd_bottom:(CGFloat)ld_bottom{
    self.ld_y = ld_bottom - self.ld_height;


}
#pragma mark - < GET >
-(CGFloat)ld_x{

    return self.frame.origin.x;

}
- (CGFloat)ld_y{
    return self.frame.origin.y;

}
- (CGFloat)ld_width{


    return self.frame.size.width;
}
- (CGFloat)ld_height{
    return self.frame.size.height;

}
- (CGFloat)ld_right{
    return CGRectGetMaxX(self.frame);

}
-(CGFloat)ld_bottom{
    return CGRectGetMaxY(self.frame);

}
-(CGSize)ld_size{

    return self.frame.size;

}
-(CGFloat)ld_centerX{
    return self.center.x;

}

-(CGFloat)ld_centerY{
    return self.center.y;

}


@end
