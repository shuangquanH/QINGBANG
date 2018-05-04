
//
//  YGLevelView.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/31.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGLevelView.h"

@implementation YGLevelView
{
    UIImageView *_levelImageView;
    UILabel *_levelLabel;
    float _levelImageViewWidth;
}
- (instancetype)initWithFrame:(CGRect)frame levelString:(NSString *)levelString
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _levelString = levelString;
        [self configUI];
        
    }
    return self;
}

-(void)configUI
{
    _levelImageView = [[UIImageView alloc]init];
    _levelImageView.image = [UIImage imageNamed:@"anchorpage_intermedrate"];
    [_levelImageView sizeToFit];
    [self addSubview:_levelImageView];
    
    _levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _levelImageView.width-2, _levelImageView.height)];
    _levelLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:_levelImageView.height - 2];
    _levelLabel.textColor = [UIColor whiteColor];
    _levelLabel.text = _levelString;
    _levelLabel.textAlignment = NSTextAlignmentRight;
    [_levelImageView addSubview:_levelLabel];
    
    if (_levelString.intValue<33)
    {
        _levelImageView.image = [UIImage imageNamed:@"anchorpage_intermedrate"];
    }
    else if (_levelString.intValue>=33 && _levelString.intValue<66)
    {
        _levelImageView.image = [UIImage imageNamed:@"anchorpage_primary"];
    }
    else
    {
        _levelImageView.image = [UIImage imageNamed:@"anchorpage_senior"];
    }
    
    
    _levelImageViewWidth = _levelImageView.width;
    
    self.frame = CGRectMake(self.x, self.y, _levelImageView.width, _levelImageView.height);
    
}

-(void)setLevelString:(NSString *)levelString
{
    _levelString = levelString;
    _levelLabel.text = _levelString;
    
    if (_levelString.intValue<33)
    {
        _levelImageView.image = [UIImage imageNamed:@"anchorpage_intermedrate"];
    }
    else if (_levelString.intValue>=33 && _levelString.intValue<66)
    {
        _levelImageView.image = [UIImage imageNamed:@"anchorpage_primary"];
    }
    else
    {
        _levelImageView.image = [UIImage imageNamed:@"anchorpage_senior"];
    }
}

@end
