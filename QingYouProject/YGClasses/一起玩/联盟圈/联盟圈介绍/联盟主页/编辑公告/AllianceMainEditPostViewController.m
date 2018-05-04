//
//  AllianceMainEditPostViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/30.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceMainEditPostViewController.h"

@interface AllianceMainEditPostViewController ()<UITextViewDelegate>

@end

@implementation AllianceMainEditPostViewController
{
    UITextView *_textView;
    UILabel *_placeHolderLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
        self.naviTitle = @"编辑公告";
    
    self.view.backgroundColor = colorWithTable;
    UIBarButtonItem *rightItem = [self createBarbuttonWithNormalTitleString:@"确定" selectedTitleString:@"确定" selector:@selector(finishImputAction)];
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
    baseView.frame = CGRectMake(10, 10, YGScreenWidth-20, 70);
    baseView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:baseView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, YGScreenWidth-30, 60)];
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

        _placeHolderLabel.text = @"盟圈公告（限30字）";
    
}


- (void)finishImputAction
{
    if (_textView.text.length == 0 || [_textView.text isEqualToString:@" "]) {
      
            [YGAppTool showToastWithText:@"您没有输入任何内容"];
        return;

    }else
    {
        if (_textView.text.length>30)
        {
            [YGAppTool showToastWithText:@"公告不能多于30个字哦~"];
            return;
        }
        
        [YGNetService YGPOST:REQUEST_updateAllianceNotice parameters:@{@"allianceID":_allianceID,@"allianceNotice":_textView.text} showLoadingView:NO scrollView:nil success:^(id responseObject) {
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            
        }];
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

//正在改变
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

@end
