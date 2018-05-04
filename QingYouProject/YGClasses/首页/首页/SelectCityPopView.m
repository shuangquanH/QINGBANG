//
//  SelectCityPopView.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/2/6.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SelectCityPopView.h"
@implementation SelectCityPopView
{
    UIView *_baseView;
    void(^_handler)(NSInteger buttonIndex);
}

+(void)showPopViewWithTitleArray:(NSArray *)titleArray selectedTitleString:(NSString *)selectedTitleString handler:(void (^)(NSInteger buttonIndex))handler
{
    YGAlertView *alertView;
    alertView = [[self alloc]initWithTitleArray:titleArray selectedTitleString:selectedTitleString handler:handler];
}

- (instancetype)initWithTitleArray:(NSArray *)titleArray selectedTitleString:(NSString *)selectedTitleString handler:(void (^)(NSInteger buttonIndex))handler
{
    self = [super init];
    if (self) {
        _titleArray = titleArray;
        _selectTitleString = selectedTitleString;
        _handler = handler;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    self.layer.cornerRadius = 5;
    
    UIButton *bigButton = [[UIButton alloc]initWithFrame:self.frame];
    [bigButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bigButton];
    
    //白色view
    _baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth - 50, 0)];
    _baseView.centerx = YGScreenWidth/2;
    _baseView.backgroundColor = colorWithTable;
    _baseView.clipsToBounds = YES;
    _baseView.layer.cornerRadius = 5;
    [self addSubview:_baseView];
    
    //提示文字
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, _baseView.width - 40, 0)];
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    titleLabel.text = @"选择城市";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(titleLabel.x, titleLabel.y, _baseView.width - 40, titleLabel.height);
    [_baseView addSubview:titleLabel];
    
    //按钮
    for (int i = 0; i<_titleArray.count; i++)
    {
        int x = i%2;
        int y = i/2;
        //按钮
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((_baseView.width - 20 - 110 * 2)/2 + (110 + 20) * x, titleLabel.y+titleLabel.height + 30 + (42 + 15) * y, 110, 42)];
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
        [button setTitleColor:colorWithMainColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        button.layer.cornerRadius = button.height/2;
        button.layer.borderWidth = 1;
        button.backgroundColor = colorWithYGWhite;
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_baseView addSubview:button];
        
        if ([_titleArray[i] isEqualToString:_selectTitleString])
        {
            button.selected = YES;
            button.layer.borderColor = colorWithMainColor.CGColor;
            [button setImage:[UIImage imageNamed:@"home_location.png"] forState:UIControlStateSelected];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, -11, 0.0, 0.0)];
        }
        else
        {
            button.selected = NO;
            button.layer.borderColor = colorWithLine.CGColor;
        }
        
        //如果是最后一个
        if (i == _titleArray.count - 1)
        {
            //更新frame
            _baseView.frame = CGRectMake(0, 0, _baseView.width, button.y+button.height + 31);
            _baseView.center = self.center;
            
            //阴影
            UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_baseView.bounds];
            _baseView.layer.masksToBounds = NO;
            _baseView.layer.shadowColor = [UIColor blackColor].CGColor;
            _baseView.layer.shadowOffset = CGSizeMake(16.0f, 16.0f);
            _baseView.layer.shadowOpacity = 0.4f;
            _baseView.layer.shadowRadius = 16;
            _baseView.layer.shadowPath = shadowPath.CGPath;
        }
    }
    [self show];
    
}


-(void)show
{
    [YGAppDelegate.window addSubview:self];
    
    self.alpha = 0;
    _baseView.frame = CGRectMake(_baseView.x, _baseView.y, _baseView.width, _baseView.height/10);
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1;
    }];
    
    
    [UIView animateWithDuration:1 // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:0.2 // 类似弹簧振动效果 0~1
          initialSpringVelocity:0 // 初始速度
                        options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                     animations:^{
                         _baseView.frame = CGRectMake(_baseView.x, _baseView.y, _baseView.width, _baseView.height*10);
                     } completion:nil];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)buttonClick:(UIButton *)button
{
    if (_handler)
    {
        _handler(button.tag - 100);
    }
    [self dismiss];
}

@end
