//
//  AskForInvoiceInputEmailAddressView.m
//  QingYouProject
//
//  Created by 王丹 on 2017/12/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AskForInvoiceInputEmailAddressView.h"

@implementation AskForInvoiceInputEmailAddressView
{
    UIView *_baseView;
    
    void(^_handler)(NSInteger buttonIndex ,NSString *emailAddress);
    
    UITextField *_emailTextField;
}

- (instancetype)initWithTitle:(NSString *)titleString buttonTitlesArray:(NSArray *)buttonTitlesArray buttonColorsArray:(NSArray *)buttonColorsArray handler:(void (^)(NSInteger ,NSString *emailAddress))handler
{
    self = [super init];
    if (self)
    {
        _buttonColorsArray = buttonColorsArray;
        _buttonTitlesArray = buttonTitlesArray;
        _titleString = titleString;
        _handler = handler;
        [self configUI];
        
    }
    return self;
}

+ (void)showAlertWithTitle:(NSString *)titleString buttonTitlesArray:(NSArray *)buttonTitlesArray buttonColorsArray:(NSArray *)buttonColorsArray handler:(void (^)(NSInteger ,NSString *emailAddress))handler
{
    [[self alloc] initWithTitle:titleString buttonTitlesArray:buttonTitlesArray buttonColorsArray:buttonColorsArray handler:handler];
}

- (void)configUI
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    //白色
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth - 80, 0)];
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.clipsToBounds = YES;
    [self addSubview:_baseView];
    
    
    //提示文字
    _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, _baseView.width - 40, 25)];
    _emailTextField.textColor = colorWithBlack;
    _emailTextField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _emailTextField.text = _titleString;
    _emailTextField.placeholder = @"请填写邮箱";
    _emailTextField.textAlignment = NSTextAlignmentCenter;
    [_baseView addSubview:_emailTextField];
    if (_titleString.length >0) {
        _emailTextField.userInteractionEnabled = NO;
        _emailTextField.frame = CGRectMake(20, 20, _baseView.width - 70,25);
        //按钮
        UIButton *changeButton = [[UIButton alloc] initWithFrame:CGRectMake(_emailTextField.x+_emailTextField.width,15,40,35)];
        [changeButton setTitle:@"修改" forState:UIControlStateNormal];
        [changeButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
//        changeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:YGFontSizeNormal];
        [changeButton addTarget:self action:@selector(changeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_baseView addSubview:changeButton];

    }
    
    //按钮
    for (int i = 0; i < _buttonTitlesArray.count; i++)
    {
        //按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_baseView.width / _buttonTitlesArray.count * i, _emailTextField.y + _emailTextField.height + 20, _baseView.width / _buttonTitlesArray.count, 40)];
        [button setTitle:_buttonTitlesArray[i] forState:UIControlStateNormal];
        [button setTitleColor:_buttonColorsArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:YGFontSizeNormal];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_baseView addSubview:button];
        
        //如果是最后一个
        if (i == _buttonTitlesArray.count - 1)
        {
            //更新frame
            _baseView.frame = CGRectMake(0, 0, _baseView.width, button.y + button.height);
            _baseView.center = self.center;
            _baseView.layer.cornerRadius = _baseView.height * 0.03;
            
            //阴影
            UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_baseView.bounds];
            _baseView.layer.masksToBounds = NO;
            _baseView.layer.shadowColor = [UIColor blackColor].CGColor;
            _baseView.layer.shadowOffset = CGSizeMake(16.0f, 16.0f);
            _baseView.layer.shadowOpacity = 0.4f;
            _baseView.layer.shadowRadius = 16;
            _baseView.layer.shadowPath = shadowPath.CGPath;
            if (i == 1) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_baseView.width / _buttonTitlesArray.count * i, _emailTextField.y + _emailTextField.height + 20, 1, 40)];
                lineView.backgroundColor = colorWithLine;
                [_baseView addSubview:lineView];
            }
            
        }
        
    }
    UIView *baseLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _baseView.height-40, _baseView.width, 1)];
    baseLineView.backgroundColor = colorWithLine;
    [_baseView addSubview:baseLineView];
    
    [self show];
    
}

- (void)show
{
    [YGAppDelegate.window addSubview:self];
    
    self.alpha = 0;
    //    _baseView.frame = CGRectMake(_baseView.x, _baseView.y, _baseView.width, _baseView.height / 10);
    _baseView.frame = CGRectMake(_baseView.x, _baseView.y, _baseView.width, _baseView.height);
    
    [UIView animateWithDuration:0.4 animations:^
     {
         self.alpha = 1;
     }];
    
    
    //    [UIView animateWithDuration:1 // 动画时长
    //                          delay:0.0 // 动画延迟
    //         usingSpringWithDamping:0.2 // 类似弹簧振动效果 0~1
    //          initialSpringVelocity:0 // 初始速度
    //                        options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
    //                     animations:^
    //                     {
    //                         _baseView.frame = CGRectMake(_baseView.x, _baseView.y, _baseView.width, _baseView.height * 10);
    //                     } completion:nil];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.4 animations:^
     {
         self.alpha = 0;
         //        _baseView.frame = CGRectMake(_baseView.x, _baseView.y, _baseView.width, 0);
     }];
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4];
    
}

- (void)buttonClick:(UIButton *)button
{
   
    if (_handler)
    {
        
        _handler(button.tag - 100,_emailTextField.text);
        _handler = nil;
    }
    [self dismiss];
}

- (void)changeButtonClick
{
    _emailTextField.userInteractionEnabled = YES;
    [_emailTextField becomeFirstResponder];
}
@end
