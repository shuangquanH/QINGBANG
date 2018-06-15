//
//  RepairOrderJudgeViewController.m
//  QingYouProject
//
//  Created by apple on 2017/11/9.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RepairOrderJudgeViewController.h"

@interface RepairOrderJudgeViewController ()<UITextViewDelegate>

@end

@implementation RepairOrderJudgeViewController

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
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem backItemWithimage:nil highImage:nil target:self action:@selector(rightBarButtonClick:) title:@"提交" normalColor:LDMainColor highColor:LDMainColor titleFont:LDFont(14)];
    
    
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
    textViewPlaceLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
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
    if (textView.text.length >140)
    {
        [textView resignFirstResponder];
        [YGAppTool showToastWithText:@"输入文字不能多于140字哦！"];
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
    if (myTextView.text.length >140)
    {
        [myTextView resignFirstResponder];
        [YGAppTool showToastWithText:@"输入文字不能多于140字哦！"];
        return ;
    }
    //意见反馈
    [YGNetService YGPOST:@"OrderEvaluation" parameters:@{@"userId":YGSingletonMarco.user.userId,@"evaluate":myTextView.text,@"workNumber":self.workNumber} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        [YGAppTool showToastWithText:@"评价成功！"];
        
        [self.delegate judgeRow:self.row];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        
    }];
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
