//
//  ReplyView.m
//  FindingSomething
//
//  Created by zhangkaifeng on 16/3/26.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "ReplyView.h"
#import "AppDelegate.h"
#import "IQKeyboardManager.h"


@implementation ReplyView
{
    UIButton *_coverButton;
}
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self configUI];
    }
    return self;
}


-(void)configUI
{
    self.frame = CGRectMake(0, YGScreenHeight, YGScreenWidth, 49);
    self.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(8, 8, self.width - 16, self.height - 16)];
    whiteView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    whiteView.layer.cornerRadius = 5;
    whiteView.layer.borderWidth = 0.5;
    whiteView.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.85 alpha:1.00].CGColor;
    [self addSubview:whiteView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 1)];
    lineView.backgroundColor = colorWithLine;
    [self addSubview:lineView];
    
    UITextField * replyTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, whiteView.width-10, whiteView.height)];
    replyTextField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    replyTextField.returnKeyType = UIReturnKeySend;
    replyTextField.placeholder = @"想对主播说点什么";
    replyTextField.tag = 100;
    replyTextField.delegate = self;
    [whiteView addSubview:replyTextField];
    
    
}

-(void)show
{
    [_coverButton removeFromSuperview];
    _coverButton = [UIButton new];
    [_coverButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.superview addSubview:_coverButton];
    
    [_coverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_top).offset(0);
        make.height.mas_equalTo(YGScreenHeight);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[self viewWithTag:100] becomeFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate replyView:self willReturnWithTextfield:[self viewWithTag:100]];
    return YES;
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification
{
    
    CGFloat curkeyBoardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    self.keyboardHeight = curkeyBoardHeight;
    [UIView animateWithDuration:0.25 animations:^{
        self.y = YGScreenHeight - self.height - self.keyboardHeight;
        if ([_delegate respondsToSelector:@selector(replyView:willChangeLocationY:)])
        {
            [_delegate replyView:self willChangeLocationY:self.keyboardHeight];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 animations:^{
        self.y = YGScreenHeight;
        if ([_delegate respondsToSelector:@selector(replyView:willChangeLocationY:)])
        {
            [_delegate replyView:self willChangeLocationY:0];
        }
    }completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    }];
    
}

- (void)dismiss
{
    [self endEditing:YES];
    [_coverButton removeFromSuperview];
}

@end
