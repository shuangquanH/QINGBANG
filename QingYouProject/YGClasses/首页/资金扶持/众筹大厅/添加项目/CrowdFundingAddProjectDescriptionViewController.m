//
//  CrowdFundingAddProjectDescriptionViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CrowdFundingAddProjectDescriptionViewController.h"
#import "TextViewAjustHeight.h"

@interface CrowdFundingAddProjectDescriptionViewController ()

@end

@implementation CrowdFundingAddProjectDescriptionViewController
{
    TextViewAjustHeight *_textView;
    NSArray  *_typeArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = colorWithTable;
    UIBarButtonItem *rightItem = [self createBarbuttonWithNormalTitleString:@"完成" selectedTitleString:@"完成" selector:@selector(finishImputAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self createSubviews];
    
    
}
- (void)configAttribute
{
    _typeArr = @[
                 @{
                     @"title":@"项目描述",
                     @"placehoder":@"用精炼的语言为您的项目写个简介"
                     },
                 @{
                     @"title":@"项目发起人介绍",
                     @"placehoder":@"项目发起人介绍.."
                     },
                 @{
                     @"title":@"项目方案",
                     @"placehoder":@"项目方案"
                     },
                 @{
                     @"title":@"项目介绍",
                     @"placehoder":@"项目介绍"
                     },
                 @{
                     @"title":@"竞争优势",
                     @"placehoder":@"竞争优势"
                     }
                 ];
    
    self.naviTitle = self.placehoder;

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_textView resignFirstResponder];
}
- (void)createSubviews
{
    UIView *baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(10, 10, YGScreenWidth-20, YGScreenHeight/2+20);
    baseView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:baseView];
    _textView = [[TextViewAjustHeight alloc]initWithFrame:CGRectMake(5, 5, YGScreenWidth-30, YGScreenHeight/2)];
    _textView.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _textView.textColor = colorWithBlack;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.placeholderColor = colorWithLightGray;
    _textView.placehoderAligment = NSTextAlignmentLeft;
    _textView.placeholderFont = [UIFont systemFontOfSize:YGFontSizeNormal];
    _textView.maxNumberOfLines = 50;
    [baseView addSubview:_textView];
    
    
    _textView.placeholder = self.placehoder;
    if ([self.placehoder isEqualToString:@"项目描述"]) {
        _textView.placeholder = @"用精炼的语言为您的项目写个简介";
    }
    if (![self.content isEqualToString:@"请填写"] && self.content != nil) {
        _textView.text = self.content;
        _textView.placeholder = @"";
    }
    if (self.iputTypeOfPage == iputTypeOfDescriptionType) {
        baseView.frame = CGRectMake(10, 10, YGScreenWidth-20, 220);
        _textView.frame = CGRectMake(10, 5, YGScreenWidth-20, 200);
        _textView.maxNumberOfLines = 10;

    }
    __weak TextViewAjustHeight *weakThirdView = _textView;
    __weak UIView *weakBaseView = baseView;
    // 设置文本框最大行数
    [_textView textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        CGRect frame = weakThirdView.frame;
        frame.size.height = textHeight;
        
        if (textHeight>200) {
            weakThirdView.frame = frame;
            weakBaseView.frame = CGRectMake(weakBaseView.x, weakBaseView.y, weakBaseView.width, 5+textHeight+5);

        }
        
    }];
}


- (void)finishImputAction
{
    if (_textView.text.length == 0 || [_textView.text isEqualToString:@" "]) {
        [YGAppTool showToastWithText:@"您没有输入任何内容"];
        return ;
    }else
    {
        [self.delegate takeProjectdesOrIntroduceValueBackWithValue:_textView.text withInputType:self.iputTypeOfPage];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)back
{
    if (_textView.text.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        if (![_textView.text isEqualToString:self.content]) {
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
