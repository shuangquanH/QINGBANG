//
//  CertifyBaseProfileViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CertifyBaseProfileViewController.h"
#import "RealNameCertifyViewController.h"

@interface CertifyBaseProfileViewController ()

@end

@implementation CertifyBaseProfileViewController
{
    UIButton *_button;
    UIButton *_confirmRealButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)configUI
{

    NSArray *titleArray = @[@"姓名",@"身份证号码",@"联系电话",@"验证码"];
    NSArray *placehoderArray = @[@"请输入姓名",@"请输入身份证号码",@"请输入联系电话",@"请输入验证码"];
    
    for (int i = 0; i<4; i++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 1+(46*i), YGScreenWidth, 45)];
        baseView.backgroundColor = colorWithYGWhite;
        [self.view addSubview:baseView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 75, 45)];
        nameLabel.text = titleArray[i];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        nameLabel.textColor = colorWithBlack;
        [baseView addSubview:nameLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width+10, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-10, nameLabel.height)];
        textField.tag = 100+i;
        textField.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        textField.textColor = colorWithDeepGray;
        textField.placeholder = placehoderArray[i];
        textField.textAlignment = NSTextAlignmentRight;
        [baseView addSubview:textField];
        [textField setValue:colorWithLightGray forKeyPath:@"_placeholderLabel.textColor"];
        
        if (i == 3) {
            
            //发送验证码
            
            _button = [UIButton buttonWithType:UIButtonTypeCustom];
            [_button setTitle:@"发送验证码" forState:UIControlStateNormal];
            [_button setTitleColor:colorWithMainColor forState:UIControlStateNormal];
            _button.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            _button.frame = CGRectMake(YGScreenWidth-_button.width-10, 10, _button.width, _button.height);
            _button.layer.cornerRadius = 5;
            _button.layer.borderColor = colorWithMainColor.CGColor;
            _button.layer.borderWidth = 1;
            [_button addTarget:self action:@selector(verifyButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [baseView addSubview:_button];
            
            textField.textAlignment = NSTextAlignmentLeft;
            textField.frame = CGRectMake(nameLabel.x+nameLabel.width+10, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-_button.width-20, nameLabel.height);
        }
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, baseView.height-1, YGScreenWidth-10, 1)];
        lineView.backgroundColor = colorWithTable;
        [baseView addSubview:lineView];
        
    }
    
    _confirmRealButton = [[UIButton alloc]initWithFrame:CGRectMake(10,YGScreenHeight-45-YGBottomMargin-50-64,100,25)];
    [_confirmRealButton setImage:[UIImage imageNamed:@"nochoice_btn_gray"] forState:UIControlStateNormal];
    [_confirmRealButton setImage:[UIImage imageNamed:@"order_choice_btn_green"] forState:UIControlStateSelected];
    [_confirmRealButton setTitle:@"本人保证所填写的内容属实" forState:UIControlStateNormal];
    [_confirmRealButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_confirmRealButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_confirmRealButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    [_confirmRealButton addTarget:self action:@selector(defultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _confirmRealButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [_confirmRealButton sizeToFit];
    [self.view addSubview:_confirmRealButton];
}
- (void)defultButtonAction:(UIButton *)btn
{
    if (btn.selected == YES) {
        btn.selected = NO;
        return;
    }
    btn.selected = YES;
}
- (void)verifyButtonAction
{
    if (_confirmRealButton.selected != YES) {
        [YGAppTool showToastWithText:@"请确认并勾选“本人保证所填写的内容属实”按钮"];
        return;
    }
    [YGNetService showLoadingViewWithSuperView:self.view];
    _button.enabled = NO;
    UITextField *phoneTextField = [self.view viewWithTag:102];
    
    //验证手机号合法性
    if ([YGAppTool isNotPhoneNumber:phoneTextField.text])
    {
        return;
    }
    _button.enabled = NO;
    [self startPostWithURLString:REQUEST_sendSMS parameters:@{@"phone":phoneTextField.text} showLoadingView:NO scrollView:nil];
    
}

- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    [YGNetService dissmissLoadingView];
    
    if ([URLString isEqualToString:REQUEST_sendSMS])
    {
        [[YGSingleton sharedManager] startTimerWithTime:60];
        [YGAppTool showToastWithText:@"验证码发送成功，请注意查收"];
        [_button becomeFirstResponder];
    }
}
-(void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{
    [YGNetService dissmissLoadingView];
    _button.enabled = YES;
    
}
- (void)commonTimerCountingDownWithLeftSeconds:(NSInteger)seconds
{
    [_button setTitleColor:colorWithPlaceholder forState:UIControlStateNormal];
    _button.layer.borderColor = colorWithPlaceholder.CGColor;
    [_button setTitle:[NSString stringWithFormat:@"重新获取(%lu)", (unsigned long) seconds] forState:UIControlStateNormal];
}

- (void)commonTimerDidFinishCountDown
{
    _button.enabled = YES;
    [_button setTitleColor:colorWithPlaceholder forState:UIControlStateNormal];
    _button.layer.borderColor = colorWithPlaceholder.CGColor;
    [_button setTitle:@"发送验证码" forState:UIControlStateNormal];
}
//提交
- (void)submitButton
{
    UITextField *nameTextField = [self.view viewWithTag:100];
    UITextField *identifyTextField = [self.view viewWithTag:101];
    UITextField *phoneTextField = [self.view viewWithTag:102];
    UITextField *verifiyCodeTextField = [self.view viewWithTag:103];
    
    //此处先对验证码进行验证

    if (nameTextField.text.length == 0)
    {
        [YGAppTool showToastWithText:@"请输入姓名"];
        return ;
    }
    if (identifyTextField.text.length == 0 || [YGAppTool isNotIDCard:identifyTextField.text])
    {
        [YGAppTool showToastWithText:@"请输入正确的身份证号码"];
        return ;
    }
    if ([YGAppTool isNotPhoneNumber:phoneTextField.text])
    {
        [YGAppTool showToastWithText:@"请输入正确的手机号"];
        return ;
    }
    if ([verifiyCodeTextField.text isEqualToString:@""]) {
        [YGAppTool showToastWithText:@"请填写验证码"];
        return ;
    }
//    [self startPostWithURLString:REQUEST_ValidationHouserPay parameters:@{@"mobileCode":verifiyCodeTextField.text,@"park":_parkIndex,@"name":nameTextField.text,@"phone":phoneTextField.text} showLoadingView:YES scrollView:nil];
    RealNameCertifyViewController *vc  = [[RealNameCertifyViewController alloc] init];
    vc.pageType = @"done";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
