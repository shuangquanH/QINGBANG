//
//  PasswordSetValidateController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PasswordSetValidateController.h"
#import "PasswordModifilyViewController.h"

@interface PasswordSetValidateController ()
{
    UIView *_verifyBaseView;
}
@property(nonatomic,strong)UITextField *verifyTextField;
@property(nonatomic,strong) UIButton *verifyButton;
@end

@implementation PasswordSetValidateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"密码设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self registerTimerNotification];
    [self configUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

-(void)configUI
{
    //提示文字
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, YGScreenWidth, 20)];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = colorWithLightGray;
    tipLabel.font = [UIFont systemFontOfSize:14.0];
    tipLabel.text = [NSString stringWithFormat:@"设置密码需要验证您的手机号%@****%@",[YGSingletonMarco.user.phone substringWithRange:NSMakeRange(0, 3)],[YGSingletonMarco.user.phone substringWithRange:NSMakeRange(7, 4)]];
    [self.view addSubview:tipLabel];
    
    [self createVerifyCodeViewWithBaseView];
}

#pragma 验证码
- (void)createVerifyCodeViewWithBaseView
{
    //baseview
    _verifyBaseView = [[UIView alloc] initWithFrame:CGRectMake(15, 100, YGScreenWidth - 30, 50)];
    [self.view addSubview:_verifyBaseView];
    //验证码图
    UIImageView *verifyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_captcha_icon_black"]];
    [verifyImageView sizeToFit];
    verifyImageView.frame = CGRectMake(10, 10, verifyImageView.width, verifyImageView.height);
    //    verifyImageView.centery = _verifyBaseView.centery;
    [_verifyBaseView addSubview:verifyImageView];
    
    //手机号text
    _verifyTextField = [[UITextField alloc] initWithFrame:CGRectMake(verifyImageView.x + verifyImageView.width + 15, 10, _verifyBaseView.width - verifyImageView.x - verifyImageView.width - 130, 30)];
    _verifyTextField.centery = verifyImageView.centery;
    _verifyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verifyTextField.font =  [UIFont systemFontOfSize:YGFontSizeBigOne];
    _verifyTextField.textColor = colorWithBlack;
    _verifyTextField.placeholder = @"验证码";
    [_verifyTextField setValue:colorWithPlaceholder forKeyPath:@"_placeholderLabel.textColor"];
    _verifyTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_verifyBaseView addSubview:_verifyTextField];
    
    //发送验证码
    _verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verifyButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_verifyButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    _verifyButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _verifyButton.frame = CGRectMake(_verifyBaseView.width -110, 0, 100, 35);
    _verifyButton.layer.cornerRadius = 17;
    _verifyButton.layer.borderColor = colorWithMainColor.CGColor;
    _verifyButton.layer.borderWidth = 1;
    [_verifyButton addTarget:self action:@selector(verifyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_verifyBaseView addSubview:_verifyButton];
    
    //线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _verifyTextField.y + _verifyTextField.height + 10, _verifyBaseView.width, 0.5)];
    lineView1.backgroundColor = KCOLOR_LINE;
    [_verifyBaseView addSubview:lineView1];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(15, 200, YGScreenWidth - 30, 40);
    nextButton.backgroundColor = colorWithMainColor;
    nextButton.layer.cornerRadius = 20;
    nextButton.clipsToBounds = YES;
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}
-(void)verifyButtonAction
{
    self.verifyButton.enabled = NO;
    [YGNetService showLoadingViewWithSuperView:self.view];
    [self startPostWithURLString:REQUEST_sendSMS parameters:@{@"phone":YGSingletonMarco.user.phone,@"type":@"1"} showLoadingView:NO scrollView:nil];

}
- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    [YGNetService dissmissLoadingView];
    [[YGSingleton sharedManager] startTimerWithTime:60];
    [YGAppTool showToastWithText:@"验证码发送成功，请注意查收"];
    [self.verifyTextField becomeFirstResponder];
}
- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{
    [YGNetService dissmissLoadingView];
    self.verifyButton.enabled = YES;
}
- (void)commonTimerCountingDownWithLeftSeconds:(NSInteger)seconds
{
    [self.verifyButton setTitleColor:colorWithPlaceholder forState:UIControlStateNormal];
    self.verifyButton.layer.borderColor = colorWithPlaceholder.CGColor;
    [self.verifyButton setTitle:[NSString stringWithFormat:@"重新获取(%lu)", (unsigned long) seconds] forState:UIControlStateNormal];
}

- (void)commonTimerDidFinishCountDown
{
    self.verifyButton.enabled = YES;
    [self.verifyButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    self.verifyButton.layer.borderColor = colorWithMainColor.CGColor;
    [self.verifyButton setTitle:@"发送验证码" forState:UIControlStateNormal];
}

-(void)nextClick:(UIButton *)button
{
    if (!_verifyTextField.text.length) {
        [YGAppTool showToastWithText:@"请输入验证码哦"];
        return;
    }

    [YGNetService YGPOST:REQUEST_checkSMS parameters:@{@"phone":YGSingletonMarco.user.phone,@"type":@"1",@"code":self.verifyTextField.text} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        PasswordModifilyViewController *vc = [[PasswordModifilyViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError *error) {
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
