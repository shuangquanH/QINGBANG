//
//  YGSpreadView.m
//  FindingSomething
//
//  Created by zhangkaifeng on 16/5/27.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YGSpreadView.h"

#define BOTTOM_ARROW_HEIGHT 35

@implementation YGSpreadView
{
    CAGradientLayer *_gradientLayer;
}
- (instancetype)initWithOrigin:(CGPoint)origin inView:(UIView *)inView startHeight:(float)startHeight
{
    self = [super init];
    if (self)
    {
        _origin = origin;
        _startHeight = startHeight;
        _inView = inView;
        self.frame = CGRectMake(_origin.x, _origin.y, inView.width, startHeight + BOTTOM_ARROW_HEIGHT);
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    _inView.frame = CGRectMake(0, 0, _inView.width, _inView.height);
    [self addSubview:_inView];
    
    UIView *bottomBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, _startHeight, self.width, BOTTOM_ARROW_HEIGHT)];
    bottomBaseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomBaseView];
    _bottomBaseView = bottomBaseView;
    
    UIView *subBaseView = [[UIView alloc]init];
    [_bottomBaseView addSubview:subBaseView];
    
    /**
     文字
     */
    
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.text = @"全部";
    textLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    textLabel.textColor = colorWithBlack;
    textLabel.numberOfLines = 1;
    [textLabel sizeToFit];
    textLabel.frame = CGRectMake(0, 0, textLabel.width, textLabel.height);
    [subBaseView addSubview:textLabel];
    _textLabel = textLabel;

    /**
     小箭头
     */
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(textLabel.x + textLabel.width +5, 0, 15, 15)];
    arrowImageView.image = [UIImage imageNamed:@"xianzhi_down.png"];
    [subBaseView addSubview:arrowImageView];
    _arrowImageView = arrowImageView;
    
    subBaseView.frame = CGRectMake(0, 0, arrowImageView.x+arrowImageView.width, 15);
    subBaseView.center = CGPointMake(bottomBaseView.width/2, bottomBaseView.height/2);
    
    /**
     *  button
     */
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, bottomBaseView.width,bottomBaseView.height)];
    button.selected = NO;
    [button addTarget:self action:@selector(arrowClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBaseView addSubview:button];
    _arrowButton = button;
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.backgroundColor = [UIColor clearColor].CGColor;
    _gradientLayer.colors = [NSArray arrayWithObjects:(id)[colorWithYGWhite colorWithAlphaComponent:0].CGColor, (id)colorWithYGWhite.CGColor,nil];
    _gradientLayer.frame = CGRectMake(0, self.height - bottomBaseView.height - 40, self.width, 40);
    [self.layer addSublayer:_gradientLayer];
}

- (void)reloadData
{
    
}

- (void)arrowClick:(UIButton *)button
{
    button.selected = !button.selected;
    
    float selfHeight = self.height;
    
    if (button.selected)
    {
        [UIView animateWithDuration:1.0 // 动画时长
                              delay:0.0 // 动画延迟
             usingSpringWithDamping:0.2 // 类似弹簧振动效果 0~1
              initialSpringVelocity:0 // 初始速度
                            options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                         animations:^{
                             self.frame = CGRectMake(self.x, self.y, _inView.width, _inView.height + BOTTOM_ARROW_HEIGHT);
                             _bottomBaseView.frame = CGRectMake(_bottomBaseView.x, _inView.y+_inView.height, _bottomBaseView.width, _bottomBaseView.height);
                             _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
                             [_delegate YGSpreadView:self willChangeHeight:self.height-selfHeight down:button.selected];
                             _textLabel.text = @"收起";
                             _gradientLayer.hidden = YES;
                         } completion:nil];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(self.x, self.y, _inView.width, _startHeight + BOTTOM_ARROW_HEIGHT);
            _bottomBaseView.frame = CGRectMake(_bottomBaseView.x, _startHeight, _bottomBaseView.width, _bottomBaseView.height);
            _arrowImageView.transform = CGAffineTransformMakeRotation(0);
            [_delegate YGSpreadView:self willChangeHeight:self.height-selfHeight down:button.selected];
            _textLabel.text = @"全部";
            _gradientLayer.hidden = NO;
        }];
    }

}

@end
