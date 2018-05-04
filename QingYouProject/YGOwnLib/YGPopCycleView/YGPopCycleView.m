//
//  YGPopCycleView.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/29.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGPopCycleView.h"
#import "UIView+Genie.h"

@implementation YGPopCycleView
{
    UIButton *_dismissButton;
    UIVisualEffectView *_effectView;
}
- (instancetype)initWithImageArray:(NSArray *)imageArray
{
    self = [super init];
    if (self) {
        _dataSource = imageArray;
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    self.frame = [UIScreen mainScreen].bounds;
    
    //  毛玻璃view 视图
    _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    //添加到要有毛玻璃特效的控件中
    _effectView.frame = self.bounds;
    _effectView.alpha = 1;
    [self addSubview:_effectView];
    
    UIButton *bigButton = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [bigButton addTarget:self action:@selector(dismissButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bigButton];
    
    _dismissButton = [[UIButton alloc]initWithFrame:CGRectMake(0, YGScreenHeight - 17 - 49, 53, 53)];
    _dismissButton.centerx = YGScreenWidth/2;
    [_dismissButton setBackgroundImage:[UIImage imageNamed:@"shouye_gongneng"] forState:UIControlStateNormal];
    [_dismissButton addTarget:self action:@selector(dismissButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0; i<_dataSource.count; i++)
    {
        UIButton *imgButton = [[UIButton alloc]init];
        imgButton.tag = 100 + i;
        imgButton.hidden = YES;
        [imgButton setBackgroundImage:[UIImage imageNamed:_dataSource[i]] forState:UIControlStateNormal];
        [imgButton sizeToFit];
        imgButton.frame = CGRectMake(0, YGScreenHeight - 49 - 56 - imgButton.height, imgButton.width,imgButton.height);
        imgButton.centerx = self.width/(_dataSource.count+1) * (i+1);
        [imgButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imgButton];
    }
    [self addSubview:_dismissButton];
    
}

-(void)show
{
    [YGAppDelegate.window addSubview:self];
    _effectView.alpha = 0;
    
    //模糊背景变成0并旋转45度
    [UIView animateWithDuration:0.25 animations:^{
        _effectView.alpha = 1;
        _dismissButton.transform = CGAffineTransformRotate(_dismissButton.transform, M_PI_2/2);
    } completion:^(BOOL finished) {
        //弹出三个
        
        for (int i = 0; i<_dataSource.count; i++)
        {
            UIButton *imgButton = [self viewWithTag:100 + i];
            imgButton.hidden = NO;
            [imgButton genieOutTransitionWithDuration:0.3 startRect:CGRectMake(_dismissButton.x + _dismissButton.width/2, _dismissButton.y, 1, 1) startEdge:BCRectEdgeTop completion:nil];
        }
    }];
}

-(void)dismissButtonClick
{
    [self dismissWithBlock:nil];
}

-(void)dismissWithBlock:(void(^)())block
{
    [UIView animateWithDuration:0.25 animations:^{
        _dismissButton.transform = CGAffineTransformRotate(_dismissButton.transform, -M_PI_2/2);
    } completion:^(BOOL finished) {
        for (int i = 0; i<_dataSource.count; i++)
        {
            UIButton *imgButton = [self viewWithTag:100 + i];
            [imgButton genieInTransitionWithDuration:0.3 destinationRect:CGRectMake(_dismissButton.x + _dismissButton.width/2, _dismissButton.y, 1, 1) destinationEdge:BCRectEdgeTop completion:^{
                
            }];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (block)
            {
                block();
            }
        }];
    }];
}

-(void)imageButtonClick:(UIButton *)button
{
    [self dismissWithBlock:^{
        [_delegate YGPopCycleView:self didClickButtonWithIndex:button.tag - 100];
    }];
}

@end
