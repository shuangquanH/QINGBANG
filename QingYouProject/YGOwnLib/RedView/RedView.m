//
//  RedView.m
//  原点
//
//  Created by 管宏刚 on 16/12/9.
//  Copyright © 2016年 管宏刚. All rights reserved.
//

#import "RedView.h"

@implementation RedView

- (instancetype)initWithFrame:(CGRect)frame badge:(int)badge
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _badge = badge;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.width/2;
    self.backgroundColor = [UIColor redColor];
    
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _numberLabel.center = CGPointMake(self.width/2, self.height/2);
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.textColor = colorWithYGWhite;
    _numberLabel.text = [NSString stringWithFormat:@"%d",_badge];
    _numberLabel.font = [UIFont systemFontOfSize:self.width - 3 - 3];
    [self addSubview:_numberLabel];
    
    if (_badge == 0)
    {
        self.hidden = YES;
    }
    else
    {
        self.hidden =NO;
    }
}

-(void)setBadge:(int)badge
{
    _badge = badge;
    _numberLabel.text = [NSString stringWithFormat:@"%d",_badge];
    if (_badge == 0)
    {
        self.hidden = YES;
    }
    else
    {
        self.hidden =NO;
    }
}

@end
