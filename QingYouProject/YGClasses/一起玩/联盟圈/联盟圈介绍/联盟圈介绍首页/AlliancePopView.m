//
//  AlliancePopView.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/4.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AlliancePopView.h"

@implementation AlliancePopView
{
    UIView *_topView;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0,0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight);
        self.backgroundColor = [colorWithBlack colorWithAlphaComponent:0];
        UITapGestureRecognizer *  recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
        [recognizerTap setNumberOfTapsRequired:1];
        recognizerTap.cancelsTouchesInView = NO;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:recognizerTap];
        
    }
    return self;
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        
        if (![_topView pointInside:[_topView convertPoint:location fromView:_topView.window] withEvent:nil])
        {
            [_topView.window removeGestureRecognizer:sender];
            
            [self dismiss];
            
        }
    }
}
- (void)createAlliancePopViewWithContent:(NSString *)content withTitle:(NSString *)title
{
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, YGScreenWidth-40, 120)];
    _topView.backgroundColor = colorWithYGWhite;
    _topView.layer.cornerRadius = 5;
    _topView.clipsToBounds = YES;
    [self addSubview:_topView];
    
    UILabel *sexTitleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0,10 , _topView.width, 20)];
    sexTitleLabel.text = title;
    sexTitleLabel.textAlignment = NSTextAlignmentCenter;
    sexTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    sexTitleLabel.textColor = colorWithBlack;
    [_topView addSubview:sexTitleLabel];
    
    
    UILabel *educationTitleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(10,40 , _topView.width-20, 20)];
    educationTitleLabel.text = content;
    educationTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    educationTitleLabel.textColor = colorWithBlack;
    educationTitleLabel.numberOfLines = 0;
    [educationTitleLabel sizeToFit];
    [_topView addSubview:educationTitleLabel];
    educationTitleLabel.frame = CGRectMake(educationTitleLabel.x,educationTitleLabel.y , _topView.width-10, educationTitleLabel.height+10);

    //签到排行榜
    UIButton *cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(_topView.width/2-20, educationTitleLabel.y+educationTitleLabel.height, 40, 40)];
    [cancleButton setImage:[UIImage imageNamed:@"home_playtogrther_cancel"] forState:UIControlStateNormal];
    cancleButton.imageView.contentMode = UIViewContentModeCenter;
    [cancleButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:cancleButton];
    
    _topView.frame = CGRectMake(20, YGScreenHeight/2-65, YGScreenWidth-40, cancleButton.y+cancleButton.height+10);
    _topView.center = self.center;
    _topView.hidden = YES;
    [self show];
}
- (void)show
{
    
    [UIView animateWithDuration:0.25 animations:^
     {
         self.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.4];
         _topView.hidden = NO;

//         CGRect rect = _topView.frame;
//         rect.origin.y = 0;
//         _topView.frame = rect;
     }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^
     {

//         CGRect rect = _topView.frame;
//         rect.size.height = 0;
//         _topView.frame = rect;
         self.backgroundColor = [colorWithBlack colorWithAlphaComponent:0];
         for (UIView *view in _topView.subviews)
         {
             view.hidden = YES;
         }
         _topView.hidden = YES;

         
     }                completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
    
    
}

@end
