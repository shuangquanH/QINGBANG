//
//  SQBaseTableViewCell.m
//  SQAPPSTART
//
//  Created by qwuser on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SQBaseTableViewCell.h"

@implementation SQBaseTableViewCell

- (UITableView *)tableView {
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0) {
        return  (UITableView *)self.superview.superview;
    } else {
        return (UITableView *)self.superview;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    if (tableView == nil) {
        return [[self alloc] init];
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [classname stringByAppendingString:@"CellID"];
    [tableView registerClass:[self class] forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier];
}

+ (instancetype)nibCellWithTableView:(UITableView *)tableView {
    if (tableView == nil) {
        return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [classname stringByAppendingString:@"nibCellID"];
    UINib *nib = [UINib nibWithNibName:classname bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier];
}

- (UIViewController *)getCellViewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


/** 滑动动画  */
- (void)startScrollAnimation {
//    [self animations1];
    [self animations2];
}

- (void)animations1 {
    //设置anchorPoint
    self.layer.anchorPoint =CGPointMake(0,0.5);
    //为了防止cell视图移动，重新把cell放回原来的位置
    self.layer.position =CGPointMake(0, self.layer.position.y);
    
    //设置cell按照z轴旋转90度，注意是弧度
    self.layer.transform =CATransform3DMakeRotation(M_PI_4, 0, 0, 1.0);
    
    self.alpha =0.6;
    [UIView animateWithDuration:0.4 animations:^{
        self.layer.transform =CATransform3DIdentity;
        self.alpha =1.0;
    }];
}

- (void)animations2 {
    CATransform3D rotation;//3D旋转
    rotation = CATransform3DMakeTranslation(0 ,50 ,20);
    //    rotation = CATransform3DRotate(rotation,M_PI, 0, 0.5, 0.0);
    //    rotation = CATransform3DMakeRotation(M_PI, 0, 0.5, 0.0);
    //逆时针旋转
    //rotation =CATransform3DScale(rotation,0.9,0.9,1);
    
    //由远及近
    rotation.m34 =1.0/ -600;
    
    self.layer.transform = rotation;
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset =CGSizeMake(10,10);
    self.alpha =0.8;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.layer.transform =CATransform3DIdentity;
        self.alpha =1;
        self.layer.shadowOffset =CGSizeMake(0,0);
    }];
}


//cell子控件增加动画
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat viewHeight = scrollView.height + scrollView.contentInset.top;
//    for (SQBaseTableViewCell *cell in [self.tableview visibleCells]) {
//        CGFloat y = cell.centery - scrollView.contentOffset.y;
//        CGFloat p = y - viewHeight /2;
//        CGFloat scale =cos(p / viewHeight * 0.9);
//        cell.contentView.transform =CGAffineTransformMakeScale(scale, scale);
//    }
//}

@end
