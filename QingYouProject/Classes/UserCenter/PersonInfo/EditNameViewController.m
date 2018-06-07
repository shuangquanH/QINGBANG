//
//  EditNameViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/9.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "EditNameViewController.h"

@interface EditNameViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    UITextField *_textField;
    UITextView *_textView;
    UILabel *_textViewPlaceLabel;
}

@end

@implementation EditNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = self.titleString;
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 0, 35, 35);
    [submitButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [submitButton setTitle:@"提交" forState:normal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [submitButton addTarget:self action:@selector(submitInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    if ([self.titleString isEqualToString:@"简介"] || [self.titleString isEqualToString:@"公司名称"])
    {
        [self configTextView];
    }
    else
    {
        [self configTextField];
    }
}

-(void)configTextField
{
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 60)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, YGScreenWidth - 20, 60)];
    _textField.placeholder = @"标题10字以内";
    _textField.text = YGSingletonMarco.user.userName;
    _textField.delegate = self;
    _textField.backgroundColor = [UIColor whiteColor];
    [whiteView addSubview:_textField];
}
-(void)configTextView
{
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 150)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    //输入框
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, YGScreenWidth - 20, 150)];
    _textView.delegate = self;
    _textView.bounces = NO;
    _textView.tag = 100;
    _textView.font = [UIFont systemFontOfSize:14.0];
    _textView.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [whiteView addSubview:_textView];
    
    //  placeLabel
    _textViewPlaceLabel = [[UILabel alloc]init];
    _textViewPlaceLabel.numberOfLines = 2;
    _textViewPlaceLabel.font = [UIFont systemFontOfSize:14.0];
    _textViewPlaceLabel.textColor = colorWithLightGray;
    _textViewPlaceLabel.frame = CGRectMake(10, 10, YGScreenWidth - 20, 30);
    if ([self.titleString isEqualToString:@"简介"])
    {
        _textView.text = YGSingletonMarco.user.description;
        _textViewPlaceLabel.text = @"  写点什么介绍自己吧(30字以内哦)";
    }
    if ([self.titleString isEqualToString:@"公司名称"])
    {
        _textView.text = YGSingletonMarco.user.company;
        _textViewPlaceLabel.text = @"  请输入公司全称(30字以内哦)";
        
    }
    [_textViewPlaceLabel sizeToFit];
    if (_textView.text.length) {
        _textViewPlaceLabel.hidden = YES;
    }
    [whiteView addSubview:_textViewPlaceLabel];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    //    countLabel.text = [NSString stringWithFormat:@"%lu/50", (unsigned long)textView.text.length];
    if (textView.text.length == 0)
    {
        _textViewPlaceLabel.hidden = NO;
    }
    else
    {
        _textViewPlaceLabel.hidden = YES;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
}

//提交
-(void)submitInfo:(UIButton *)button
{
    NSString *typeString;
    NSString *valueString;
    if ([self.titleString isEqualToString:@"昵称"]) {
        typeString = @"2";
        valueString = _textField.text;
        if ([YGAppTool isTooLong:_textField.text maxLength:10 name:@"昵称"]) {
            return;
        }
        if ([YGAppTool isTooShort:_textField.text minLength:0 name:@"昵称"]) {
            return;
        }
    }
    if ([self.titleString isEqualToString:@"公司名称"]) {
        typeString = @"3";
        valueString = _textView.text;
    }
    
    if ([self.titleString isEqualToString:@"简介"]) {
        typeString = @"5";
        valueString = _textView.text;
    }
    if (_textView.text.length > 30) {
        [YGAppTool showToastWithText:@"不能超过30个字哦!"];
        return;
    }
    
    [YGNetService YGPOST:@"UpdateMyBase" parameters:@{@"userId":YGSingletonMarco.user.userId,@"type":typeString,@"value":valueString} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        [YGAppTool showToastWithText:@"修改成功"];
        if ([self.titleString isEqualToString:@"昵称"]) {
            YGSingletonMarco.user.userName = valueString;
        }
        if ([self.titleString isEqualToString:@"公司名称"]) {
            YGSingletonMarco.user.company = valueString;
        }
        if ([self.titleString isEqualToString:@"简介"]) {
            YGSingletonMarco.user.description = valueString;
        }
        [YGSingletonMarco archiveUser];
        [self.navigationController popViewControllerAnimated:YES];
       
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
