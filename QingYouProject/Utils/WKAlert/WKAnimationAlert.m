//
//  YZLDriverMeUserInfoAlertView.m
//  knight
//
//  Created by YZLDriver on 17/2/22.
//  Copyright © 2017年 hongdongjie. All rights reserved.
//

#import "WKAnimationAlert.h"
#import "AnimationUtils.h"

#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

@interface WKAnimationAlert()

@property (nonatomic, assign) BOOL canTouchDissmiss;

@property (nonatomic, assign) WKAlertAnimationType animationType;

@property (nonatomic, copy  ) void (^ dismissBlock)(UIView *insideView);

@end

static WKAnimationAlert *instance = nil;
static UIView *_insideView = nil;

@implementation WKAnimationAlert

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kScreenW, kScreenH);
        self.backgroundColor = COLOR(0, 0, 0, 0);
    }
    return self;
}

+ (instancetype)instance {
    if (!instance) {
        instance = [[self alloc] init];
    }
    return instance;
}

+ (void)dismissComplete:(void(^)(void))complete {
    [UIView animateWithDuration:0.2 animations:^{
        instance.backgroundColor = COLOR(0, 0, 0, 0);
        if (instance.animationType == WKAlertAnimationTypeScale) {
            [AnimationUtils dismissOpacityAnimatedWithView:_insideView];
        } else if (instance.animationType == WKAlertAnimationTypeCurve) {
            [AnimationUtils dismissCurveAnimatedWithView:_insideView withOptions:UIViewAnimationOptionCurveEaseInOut];
        } else {
            [AnimationUtils dismissPositionAnimatedWithView:_insideView];
        }
    } completion:^(BOOL finished) {
        [instance removeFromSuperview];
        instance = nil;
        complete();
    }];
}

+ (void)dismiss {
 
    [UIView animateWithDuration:0.2 animations:^{
        instance.backgroundColor = COLOR(0, 0, 0, 0);
        if (instance.animationType == WKAlertAnimationTypeScale) {
            [AnimationUtils dismissOpacityAnimatedWithView:_insideView];
        } else if (instance.animationType == WKAlertAnimationTypeCurve) {
            [AnimationUtils dismissCurveAnimatedWithView:_insideView withOptions:UIViewAnimationOptionCurveEaseInOut];
        } else {
            [AnimationUtils dismissPositionAnimatedWithView:_insideView];
        }
    } completion:^(BOOL finished) {
        [_insideView removeFromSuperview];
        _insideView = nil;
        [instance removeFromSuperview];
        instance = nil;
    }];
}

+ (void)showAlertWithInsideView:(UIView *)insideView animation:(WKAlertAnimationType)animation {
    [self showAlertWithInsideView:insideView animation:animation canTouchDissmiss:NO superView:nil offset:0];
}

+ (void)showAlertWithInsideView:(UIView *)insideView animation:(WKAlertAnimationType)animation canTouchDissmiss:(BOOL)canTouchDissmiss {
    [self showAlertWithInsideView:insideView animation:animation canTouchDissmiss:canTouchDissmiss superView:nil offset:0];
}

+ (void)showAlertWithInsideView:(UIView *)insideView animation:(WKAlertAnimationType)animation canTouchDissmiss:(BOOL)canTouchDissmiss offset:(CGFloat)offset {
    [self showAlertWithInsideView:insideView animation:animation canTouchDissmiss:canTouchDissmiss superView:nil offset:offset];
}

+ (void)showAlertWithInsideView:(UIView *)insideView animation:(WKAlertAnimationType)animation canTouchDissmiss:(BOOL)canTouchDissmiss superView:(UIView *)superView offset:(CGFloat)offset {

    if (_insideView == insideView) return;
    if (!superView) superView = [[UIApplication sharedApplication].windows firstObject];
    
    if (_insideView) {
        if (instance.animationType == WKAlertAnimationTypeCustom && instance.dismissBlock) {
            [UIView animateWithDuration:0.2 animations:^{
                instance.backgroundColor = COLOR(0, 0, 0, 0);
                instance.dismissBlock(_insideView);
                [instance layoutIfNeeded];
            } completion:^(BOOL finished) {
                instance.dismissBlock = nil;
                [_insideView removeFromSuperview];
                _insideView = nil;
                [instance removeFromSuperview];
                instance = nil;
                [self showAlertWithInsideView:insideView animation:animation canTouchDissmiss:canTouchDissmiss superView:superView offset:offset];
            }];
            return;
        }
        
        [self dismissComplete:^{
            [self wk_showAlertWithInsideView:insideView animation:animation canTouchDissmiss:canTouchDissmiss superView:superView offset:offset];
        }];
        return;
    }
    
    [self wk_showAlertWithInsideView:insideView animation:animation canTouchDissmiss:canTouchDissmiss superView:superView offset:offset];
   
}

+ (void)wk_showAlertWithInsideView:(UIView *)insideView animation:(WKAlertAnimationType)animation canTouchDissmiss:(BOOL)canTouchDissmiss superView:(UIView *)superView offset:(CGFloat)offset {
    WKAnimationAlert *alert = [self instance];
    alert.canTouchDissmiss = canTouchDissmiss;
    _insideView = insideView;
    
    alert.frame = superView.bounds;
    [alert addSubview:_insideView];
    [superView addSubview:alert];
    
    alert.backgroundColor = COLOR(0, 0, 0, 0.3);
    alert.animationType = animation;
    
    switch (animation) {
        case WKAlertAnimationTypeCenter:
        {
            _insideView.center = CGPointMake(superView.frame.size.width / 2, superView.frame.size.height + _insideView.frame.size.height / 2);
            [AnimationUtils showPositionAnimatedWithView:_insideView offset: -(superView.frame.size.height + _insideView.frame.size.height) / 2 - offset];
        }
            break;
        case WKAlertAnimationTypeBottom:
        {
            _insideView.center = CGPointMake(superView.frame.size.width / 2, superView.frame.size.height + _insideView.frame.size.height * _insideView.layer.anchorPoint.y);
            [AnimationUtils showPositionAnimatedWithView:_insideView offset: -_insideView.frame.size.height - offset];
        }
            break;
        case WKAlertAnimationTypeScale:
        {
            _insideView.center = CGPointMake(superView.frame.size.width / 2, superView.frame.size.height / 2);
            [AnimationUtils showOpacityAnimatedWithView:_insideView];
        }
            break;
        case WKAlertAnimationTypeCurve:
        {
            [AnimationUtils showCurveAnimatedWithView:_insideView withOptions:UIViewAnimationOptionCurveEaseInOut];
        }
            break;
        default:
            break;
    }
}

+ (void)showAlertWithInsideView:(UIView *)insideView canTouchDissmiss:(BOOL)canTouchDissmiss superView:(UIView *)superView animation:(void (^)(UIView *))animation dismiss:(void (^)(UIView *))dismiss {
    
    if (_insideView == insideView) return;
    
    if (!superView) superView = [[UIApplication sharedApplication].windows firstObject];
    
    WKAnimationAlert *alert = [self instance];
    alert.canTouchDissmiss = canTouchDissmiss;
    alert.animationType = WKAlertAnimationTypeCustom;
    alert.dismissBlock = [dismiss copy];
    _insideView = insideView;
    
    alert.frame = superView.bounds;
    [alert addSubview:_insideView];
    [superView addSubview:alert];
    
    alert.backgroundColor = COLOR(0, 0, 0, 0.3);
    if (animation) {
        animation(insideView);
    }
}

+ (void)dismissAnimation:(void (^)(UIView *))animation {
    [UIView animateWithDuration:0.2 animations:^{
        instance.backgroundColor = COLOR(0, 0, 0, 0);
        if (animation) {
            animation(_insideView);
        }
    } completion:^(BOOL finished) {
        [_insideView removeFromSuperview];
        _insideView = nil;
        [instance removeFromSuperview];
        instance = nil;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!instance.canTouchDissmiss) {
        return;
    }
    CGPoint point = [[touches anyObject] locationInView:self];
    point = [_insideView.layer convertPoint:point fromLayer:instance.layer];
    if ([_insideView.layer containsPoint:point]) {
        return;
    }
    if (self.dismissBlock && self.animationType == WKAlertAnimationTypeCustom) {
        [UIView animateWithDuration:0.2 animations:^{
            instance.backgroundColor = COLOR(0, 0, 0, 0);
            self.dismissBlock(_insideView);
        } completion:^(BOOL finished) {
            [_insideView removeFromSuperview];
            _insideView = nil;
            [instance removeFromSuperview];
            instance = nil;
            self.dismissBlock = nil;
        }];
    }
    else {
        [WKAnimationAlert dismiss];
    }
}

@end
