//
//  IntegrationtryJudgeViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//


#import "IntegrationtryJudgeViewController.h"

@interface IntegrationtryJudgeViewController ()<UITextViewDelegate>

@end

@implementation IntegrationtryJudgeViewController

{
    UITextView *myTextView;
    UILabel *textViewPlaceLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configAttribute];
}

-(void)configAttribute
{
    self.view.backgroundColor = colorWithTable;
    self.naviTitle = @"立即评价";
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [self createBarbuttonWithNormalTitleString:@"提交" selectedTitleString:@"提交" selector:@selector(rightBarButtonClick:)];
    
    
    //    绘制UI
    [self configUI];
}
-(void)configUI
{
    //输入框
    myTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, YGScreenWidth-20, 200)];
    myTextView.delegate = self;
    myTextView.backgroundColor = [UIColor whiteColor];
    myTextView.bounces = NO;
    myTextView.tag = 100;
    myTextView.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    myTextView.textColor = colorWithBlack;
    [self.view addSubview:myTextView];
    
    //  placeLabel
    textViewPlaceLabel = [[UILabel alloc]init];
    textViewPlaceLabel.text = @"  对此次服务简单评价一下吧...";
    textViewPlaceLabel.numberOfLines = 2;
    textViewPlaceLabel.textColor = colorWithLightGray;
    textViewPlaceLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    textViewPlaceLabel.frame = CGRectMake(20, 20, YGScreenWidth-50, 30);
    [textViewPlaceLabel sizeToFit];
    [self.view addSubview:textViewPlaceLabel];
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    [textView becomeFirstResponder];
    if (textView.text.length > 0)
    {
        textViewPlaceLabel.hidden = YES;
    }else
    {
        textViewPlaceLabel.hidden = NO;
    }
    if (textView.text.length >50)
    {
        [textView resignFirstResponder];
        [YGAppTool showToastWithText:@"输入文字不能多于50字哦！"];
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

-(void)rightBarButtonClick:(UIButton *)btn
{
    if (myTextView.text.length <1)
    {
        [YGAppTool showToastWithText:@"请输入评价文字"];
        return ;
    }
    if (myTextView.text.length >50)
    {
        [myTextView resignFirstResponder];
        [YGAppTool showToastWithText:@"输入文字不能多于50字哦！"];
        return ;
    }
    if([self.isPush isEqualToString:@"MyIntegrationIndustryFinishedController"])
    {
        //意见反馈
        [YGNetService YGPOST:@"CommerceOrderComment" parameters:@{@"userID":YGSingletonMarco.user.userId,@"context":myTextView.text,@"orderID":self.orderID,@"commerceID":self.commerceID} showLoadingView:YES scrollView:nil success:^(id responseObject) {
            
            [YGAppTool showToastWithText:@"评价成功！"];
            
            [self.delegate integrationtryJudgeWithRow:self.row];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
            
        }];
    }
    else
    {
        //意见反馈
        [YGNetService YGPOST:@"FinanceOrderComment" parameters:@{@"userID":YGSingletonMarco.user.userId,@"context":myTextView.text,@"orderID":self.orderID,@"financeID":self.commerceID} showLoadingView:YES scrollView:nil success:^(id responseObject) {
            
            [YGAppTool showToastWithText:@"评价成功！"];
            
            [self.delegate integrationtryJudgeWithRow:self.row];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
            
        }];
    }
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

