//
//  AddSubscribeSumOfMoneyViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AddSubscribeSumOfMoneyViewController.h"

@interface AddSubscribeSumOfMoneyViewController ()<UITextViewDelegate>

@end

@implementation AddSubscribeSumOfMoneyViewController
{
    UITextView * _textView;
    UILabel *_placehodlerLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)configAttribute
{
    self.naviTitle = @"添加认购金额";
    
    [self   createFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGBottomMargin-45)];
}

- (void)createFrame:(CGRect)frame
{
    UIView *selfView = [[UIView alloc] initWithFrame:frame];
    selfView.backgroundColor = colorWithTable;
    [self.view addSubview:selfView];
    
    NSArray *titleArray = @[@"数额",@"份额",@"限购量"];
    NSArray *placehoderArray = @[@"请输入数额",@"请输入份额",@"请输入限购量"];
    
    for (int i = 0; i<titleArray.count; i++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 45*i, YGScreenWidth, 45)];
        baseView.backgroundColor = colorWithYGWhite;
        [selfView addSubview:baseView];
   
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 75, 45)];
        nameLabel.text = titleArray[i];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        nameLabel.textColor = colorWithBlack;
        [baseView addSubview:nameLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width+10, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-10, nameLabel.height)];
        textField.tag = 100+i;
        textField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        textField.textColor = colorWithDeepGray;
        textField.placeholder = placehoderArray[i];
        textField.textAlignment = NSTextAlignmentRight;
        [baseView addSubview:textField];
        [textField setValue:colorWithLightGray forKeyPath:@"_placeholderLabel.textColor"];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, baseView.height-1, YGScreenWidth-10, 1)];
        lineView.backgroundColor = colorWithTable;
        [baseView addSubview:lineView];
        
    }
    UIView *textViewBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 45*3, YGScreenWidth, 200)];
    textViewBaseView.backgroundColor = colorWithYGWhite;
    [selfView addSubview:textViewBaseView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, YGScreenWidth-20, 200)];
    _textView.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _textView.textColor = colorWithBlack;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.scrollEnabled = NO;
    _textView.delegate = self;
    [textViewBaseView addSubview:_textView];
  
    _placehodlerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,5 , 100, 20)];
    _placehodlerLabel.text = @"请添加认购描述";
    _placehodlerLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _placehodlerLabel.textColor = colorWithPlaceholder;
    [_textView addSubview:_placehodlerLabel];
    
    UIButton *applyButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
    applyButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
    [applyButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    applyButton.backgroundColor = colorWithMainColor;
    applyButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [self.view addSubview:applyButton];
    [applyButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [applyButton setTitle:@"保存" forState:UIControlStateNormal];
}
//提交
- (void)saveButtonAction
{
    UITextField *businessParkTextField = [self.view viewWithTag:100]; //数额
    UITextField *nameTextField = [self.view viewWithTag:101]; //份额
    UITextField *phoneTextField = [self.view viewWithTag:102]; //限购量
    
    //此处填入项是否填写验证
    if (businessParkTextField.text.length == 0 || nameTextField.text.length == 0 || phoneTextField.text.length == 0 || _textView.text.length == 0) {
        [YGAppTool showToastWithText:@"请将信息填写完整后提交"];
        return ;
    }
    
    if (![YGAppTool isPureInt:businessParkTextField.text]) {
        [YGAppTool showToastWithText:@"请填写整数数额"];
        return ;
    }
    
    if (![YGAppTool isPureInt:nameTextField.text]) {
        [YGAppTool showToastWithText:@"请填写整数份额"];
        return ;
    }
    
    if (![YGAppTool isPureInt:phoneTextField.text]) {
        [YGAppTool showToastWithText:@"请填写整数限购量"];
        return ;
    }
    
    if ([phoneTextField.text intValue]>[nameTextField.text intValue]) {
        [YGAppTool showToastWithText:@"限购量不得大于份额"];
        return ;
    }
    
    if (_textView.text.length == 0) {
        [YGAppTool showToastWithText:@"请填写认购描述"];
        return ;
    }
    SubscribeSumOfMoneyModel *model = [[SubscribeSumOfMoneyModel alloc] init];
    model.amount = businessParkTextField.text;
    model.copies = nameTextField.text;
    model.forPurchasing = phoneTextField.text;
    model.describe = _textView.text;
    [self.delegate takeTypeValueBackWithModel:model];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _placehodlerLabel.hidden = NO;

    }else
    {
        _placehodlerLabel.hidden = YES;
    }
}



@end
