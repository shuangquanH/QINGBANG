//
//  YGBadgeImageView.m
//  FindingSomething
//
//  Created by zhangkaifeng on 16/6/30.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YGBadgeImageView.h"

@implementation YGBadgeImageView

{
    UIImageView *_subImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _subImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _subImageView.layer.cornerRadius = _subImageView.width/2;
        _subImageView.clipsToBounds = YES;
        [self addSubview:_subImageView];
    }
    return self;
}

- (void)setClipsToBounds:(BOOL)clipsToBounds
{
    self.clipsToBounds = NO;
}

-(void)setImage:(UIImage *)image
{
    _subImageView.image = image;
}

-(void)setBadgeValue:(NSString *)badgeValue
{
    
    _badgeValue = badgeValue;
    
    //如果是0，直接隐藏
    if (_badgeValue.intValue == 0)
    {
        self.badgeView.hidden = YES;
    } else {
        self.badgeView.hidden = NO;
    }
    
    //如果>99,是...
    if (_badgeValue.intValue > 99)
    {
        _badgeValue = @"…";
    }
    
    
    //如果没给frame 给默认
    if (_badgeFrame.origin.x == 0)
    {
        self.badgeView.frame = CGRectMake(0, 0, 20, 20);
        self.badgeView.center = CGPointMake((self.width + 1.414*(self.width/2))/2, self.width - (self.width + 1.414*(self.width/2))/2);
    }
    self.badgeView.layer.cornerRadius = self.badgeView.width/2;
    
    self.badgeLabel.font = [UIFont systemFontOfSize:self.badgeView.width/2];
    self.badgeLabel.text = _badgeValue;
    self.badgeLabel.textAlignment = NSTextAlignmentCenter;
    [self.badgeLabel sizeToFit];
    if ([_badgeValue isEqual:@"红点"]) {
        self.badgeView.hidden = NO;
        self.badgeView.frame = CGRectMake(0, 0, 10, 10);
        self.badgeLabel.text = @" ";
        
        self.badgeView.center = CGPointMake((self.width + 1.414*(self.width/2))/2, self.width - (self.width + 1.414*(self.width/2))/2);
        self.badgeView.layer.cornerRadius = self.badgeView.width/2;
    }
    _badgeLabel.center = CGPointMake(_badgeView.width/2, _badgeView.height/2);
}

-(void)setBadgeFrame:(CGRect)badgeFrame
{
    _badgeFrame = badgeFrame;
    self.badgeView.frame = _badgeFrame;
    self.badgeView.layer.cornerRadius = self.badgeView.width/2;
    self.badgeLabel.font = [UIFont systemFontOfSize:self.badgeView.width/2];
    self.badgeLabel.text = _badgeValue;
    [self.badgeLabel sizeToFit];
    _badgeLabel.center = CGPointMake(_badgeView.width/2, _badgeView.height/2);
}

-(UIView *)badgeView
{
    if (!_badgeView)
    {
        _badgeView = [[UIView alloc]init];
        _badgeView.backgroundColor = [UIColor redColor];
        [self addSubview:_badgeView];
    }
    return _badgeView;
}

-(UILabel *)badgeLabel
{
    if (!_badgeLabel)
    {
        _badgeLabel = [[UILabel alloc]init];
        _badgeLabel.textColor = [UIColor whiteColor];
        [self.badgeView addSubview:_badgeLabel];
    }
    return _badgeLabel;
}

@end
