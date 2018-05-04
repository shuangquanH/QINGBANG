//
//  YGVerticalPopView.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/17.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGVerticalPopView.h"

@implementation YGVerticalPopView
{
    UIButton *_mainButton;
    CGRect _lastFrame;
}

- (instancetype)initWithFrame:(CGRect)frame mainButtonImage:(UIImage *)mainButtonImage mainButtonSelectedImage:(UIImage *)mainButtonSelectedImage buttonImagesArray:(NSArray *)buttonImagesArray buttonSelectedImagesArray:(NSArray *)buttonSelectedImagesArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _lastFrame = frame;
        _mainButtonImage = mainButtonImage;
        _mainButtonSelectedImage = mainButtonSelectedImage;
        _buttonImagesArray = buttonImagesArray;
        _buttonSelectedImagesArray = buttonSelectedImagesArray;
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    self.clipsToBounds = YES;

    //主按钮
    _mainButton = [UIButton new];
    [_mainButton setBackgroundImage:_mainButtonImage forState:UIControlStateNormal];
    [_mainButton setBackgroundImage:_mainButtonSelectedImage forState:UIControlStateSelected];
    [_mainButton addTarget:self action:@selector(mainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_mainButton];
    
    [_mainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self).offset(0);
        make.width.height.mas_equalTo(_lastFrame.size.width);
    }];
   
    
    for (int i = 0; i<_buttonImagesArray.count; i++)
    {
        UIButton *subButton = [UIButton new];
        subButton.tag = 100 + i;
        [subButton setBackgroundImage:[UIImage imageNamed:_buttonImagesArray[i]] forState:UIControlStateNormal];
        [subButton setBackgroundImage:[UIImage imageNamed:_buttonSelectedImagesArray[i]] forState:UIControlStateSelected];
        [subButton addTarget:self action:@selector(subButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:subButton];
        [self sendSubviewToBack:subButton];
        subButton.hidden = YES;
        
        [subButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(_mainButton.mas_width);
            make.centerX.mas_equalTo(_mainButton.mas_centerX);
            make.bottom.mas_equalTo(_mainButton);
        }];
    }
}

-(void)mainButtonClick:(UIButton *)button
{
    button.selected = !button.isSelected;
    if (button.isSelected)
    {
        [self showSubButton];
    }
    else
    {
        [self dismissSubButton];
    }
}

-(void)subButtonClick:(UIButton *)button
{
    [_delegate YGVerticalPopViewDidClickWithIndex:button.tag - 100 button:button];
}

-(void)showSubButton
{
    //改变约束
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_lastFrame.size.height*(_buttonImagesArray.count+1) + 10*_buttonImagesArray.count);
    }];
    for (int i = 0; i<_buttonImagesArray.count; i++)
    {
        UIButton *subButton = [self viewWithTag:100 + i];
        subButton.hidden = NO;
        [subButton mas_remakeConstraints:^(MASConstraintMaker *make)
        {
            make.width.height.mas_equalTo(_mainButton.mas_width);
            make.centerX.mas_equalTo(_mainButton.mas_centerX);
            if (i==0)
            {
                make.bottom.mas_equalTo(_mainButton.mas_top).offset(-10);
            }
            else
            {
                make.bottom.mas_equalTo([self viewWithTag:subButton.tag-1].mas_top).offset(-10);
            }
        }];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        
    }];
}

-(void)dismissSubButton
{
    //改变约束
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_lastFrame.size.width);
    }];
    for (int i = 0; i<_buttonImagesArray.count; i++)
    {
        UIButton *subButton = [self viewWithTag:100 + i];
        
        [subButton mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.width.height.mas_equalTo(_mainButton.mas_width);
             make.centerX.mas_equalTo(_mainButton.mas_centerX);
             make.bottom.mas_equalTo(_mainButton);
         }];
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }completion:^(BOOL finished) {
            subButton.hidden = YES;
        }];
    }
}

@end
