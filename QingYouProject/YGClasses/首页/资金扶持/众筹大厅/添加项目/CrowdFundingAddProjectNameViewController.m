//
//  CrowdFundingAddProjectNameViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CrowdFundingAddProjectNameViewController.h"

@interface CrowdFundingAddProjectNameViewController ()<UITextViewDelegate>

@end

@implementation CrowdFundingAddProjectNameViewController
{
    UITextView *_textView;
    UILabel *_placeHolderLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.companyNameOrProjectName == 0)
    {
        self.naviTitle = @"项目名称";
    }else
    {
        self.naviTitle = @"公司名称";
    }
    self.view.backgroundColor = colorWithTable;
    UIBarButtonItem *rightItem = [self createBarbuttonWithNormalTitleString:@"完成" selectedTitleString:@"完成" selector:@selector(finishImputAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self createSubviews];
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_textView resignFirstResponder];
}
- (void)createSubviews
{
    UIView *baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(10, 10, YGScreenWidth-20, 65);
    baseView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:baseView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, YGScreenWidth-30, 50)];
    _textView.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _textView.textColor = colorWithBlack;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
    [baseView addSubview:_textView];
    
    _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 8, _textView.width, 20)];
    _placeHolderLabel.textColor = colorWithLightGray;
    _placeHolderLabel.font = _textView.font;
    _placeHolderLabel.tag = 998;
    [_textView addSubview:_placeHolderLabel];
    
    if (self.companyNameOrProjectName == 0)
    {
        _placeHolderLabel.text = @"请输入项目名称";
        
    }else
    {
        _placeHolderLabel.text = @"请输入公司名称";
        
    }
    if (![self.content isEqualToString:@"请填写"]) {
        _textView.text = self.content;
        _placeHolderLabel.hidden = YES;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        _placeHolderLabel.hidden = NO;
        
    }else
    {
        _placeHolderLabel.hidden = YES;
    }
}
- (void)finishImputAction
{
    if (_textView.text.length == 0 || [_textView.text isEqualToString:@" "]) {
        if (self.companyNameOrProjectName == 0)
        {
            [YGAppTool showToastWithText:@"请输入项目名称！"];
            
        }else
        {
            [YGAppTool showToastWithText:@"请输入公司名称！"];

        }
        
    }else
    {
        if (_textView.text.length>30)
        {
            [YGAppTool showToastWithText:@"您没有输入任何内容"];
            return;
        }
        [self.delegate takeProjectNameValueBackWithValue:_textView.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)back
{
    if (_textView.text.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else
    {
        if (![_textView.text isEqualToString:self.content] && _textView.text.length !=0) {
            [YGAlertView  showAlertWithTitle:@"是否保存输入的内容" buttonTitlesArray:@[@"是",@"否"] buttonColorsArray:@[colorWithDeepGray,colorWithMainColor] handler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [self finishImputAction];
                }else
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
}

@end
