//
//  EvaluateViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "WKSettingEvaluateViewController.h"

@interface WKSettingEvaluateViewController ()<UITextViewDelegate>
{
    UIView *_whiteView;
    UIScrollView *_scrollView;
    UITextView *_detailTextView;
}

@end

@implementation WKSettingEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"意见反馈";
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 0, 50, 35);
    [submitButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [submitButton setTitle:@"提交" forState:normal];
    [submitButton addTarget:self action:@selector(submitInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self configUI];
}
//绘制UI
-(void)configUI
{
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 10, YGScreenWidth, 130)];
    _detailTextView.tag = 1994;
    _detailTextView.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _detailTextView.delegate = self;
    [_scrollView addSubview:_detailTextView];
    
    UILabel *placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 8, _detailTextView.width, 14)];
    placeHolderLabel.text = @"  欢迎反馈";
    placeHolderLabel.textColor = colorWithLightGray;
    //    placeHolderLabel.textColor = countLabel.textColor;
    placeHolderLabel.font = _detailTextView.font;
    placeHolderLabel.tag = 998;
    [_detailTextView addSubview:placeHolderLabel];
    
//    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, detailTextView.height-14,detailTextView.width, 14)];
//    countLabel.text = @"0/50";
//    countLabel.textAlignment = NSTextAlignmentRight;
//    countLabel.tag = 999;
//    countLabel.textColor = colorWithLightGray;
//    countLabel.font = detailTextView.font;
//    [detailTextView addSubview:countLabel];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
//    UILabel *countLabel = [self.view viewWithTag:999];
    UILabel *placeHolderLabel = [self.view viewWithTag:998];
//    countLabel.text = [NSString stringWithFormat:@"%lu/50", (unsigned long)textView.text.length];
    if (textView.text.length == 0)
    {
        placeHolderLabel.hidden = NO;
    }
    else
    {
        placeHolderLabel.hidden = YES;
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

-(void)submitInfo:(UIButton *)button
{
    [_detailTextView resignFirstResponder];
    if (_detailTextView.text.length <10)
    {
        [YGAppTool showToastWithText:@"输入文字少于10个字"];
        return ;
    }
    if (_detailTextView.text.length >140)
    {
        [_detailTextView resignFirstResponder];
        [YGAppTool showToastWithText:@"输入文字不能多于140字哦！"];
        return ;
    }
    NSLog(@"%@",YGSingletonMarco.user.userId);
    //意见反馈
    [YGNetService YGPOST:@"Feedback" parameters:@{@"userId":YGSingletonMarco.user.userid,@"text":_detailTextView.text} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        [YGAppTool showToastWithText:@"提交成功!"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
