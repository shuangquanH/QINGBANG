//
//  CheckUserInfoViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CheckUserInfoViewController.h"
#import "JKCountDownButton.h"
#import "YGActionSheetView.h"
#import "PayRentViewController.h"
#import "MyHouseRentPayViewController.h"

@interface CheckUserInfoViewController ()

@end

@implementation CheckUserInfoViewController
{
    UILabel *_thirdLabel;
    UILabel *_fourthLabel;
    UIView *_thirdbaseView;
    UIView *_fourthbaseView;
    UITextField *_thirdTextfield;
    UITextField *_fourthTextfield;
    UIView *_thirdLineView;
    UILabel *_thirdPlacehoderLabel;
    UILabel *_fourthPlacehoderLabel;
    
    UIButton *_button;
    NSMutableArray *_gardenArray;
    NSString *_parkIndex;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registerTimerNotification];

}
- (void)configAttribute
{
    self.naviTitle = @"查询";
    UIBarButtonItem *item = [self createBarbuttonWithNormalTitleString:@"提交" selectedTitleString:@"" selector:@selector(submitButton)];
    self.navigationItem.rightBarButtonItem = item;
    _gardenArray = [[NSMutableArray alloc] init];
    [self   createFrame:CGRectMake(0, 0, YGScreenWidth, 320)];
}

- (void)createFrame:(CGRect)frame
{
    UIView *selfView = [[UIView alloc] initWithFrame:frame];
    selfView.backgroundColor = colorWithTable;
    [self.view addSubview:selfView];
    
    UIView *baseTopView = [[UIView alloc] initWithFrame:CGRectMake(0,0, YGScreenWidth, 60)];
    baseTopView.backgroundColor = colorWithYGWhite;
    [selfView addSubview:baseTopView];
    
    //红星
    UILabel * starLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 5, 30)];
    starLabel.text = @"*";
    starLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    starLabel.textColor = [UIColor redColor];
    [selfView addSubview:starLabel];
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(starLabel.x+starLabel.width,0 , YGScreenWidth-20, 60)];
    noticeLabel.textAlignment = NSTextAlignmentLeft;
    noticeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    noticeLabel.textColor = colorWithDeepGray;
    noticeLabel.numberOfLines = 0;
    [baseTopView addSubview:noticeLabel];
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：企业房租信息查询仅对企业用户开放，如需了解请按照租赁合同信息输入查询。"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [@"温馨提示：企业房租信息查询仅对企业用户开放，如需了解请按照租赁合同信息输入查询。" length])];
    //attributedText设置后之前设置的都失效
    noticeLabel.attributedText = attributedString;
    
    NSArray *titleArray = @[@"所在园区",@"姓名",@"预留手机号",@"验证码"];
    NSArray *placehoderArray = @[@"请选择所在园区",@"请输入姓名",@"请输入手机号码",@"请输入验证码"];
    
    float labelBottom = 70;
    for (int i = 0; i<4; i++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, labelBottom+(45*i), YGScreenWidth, 45)];
        baseView.backgroundColor = colorWithYGWhite;
        [selfView addSubview:baseView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 75, 45)];
        nameLabel.text = titleArray[i];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        nameLabel.textColor = colorWithBlack;
        [baseView addSubview:nameLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width+10, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-10, nameLabel.height)];
        textField.tag = 100+i;
        textField.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        textField.textColor = colorWithBlack;
        textField.placeholder = placehoderArray[i];
        textField.textAlignment = NSTextAlignmentRight;
        [baseView addSubview:textField];
        [textField setValue:colorWithLightGray forKeyPath:@"_placeholderLabel.textColor"];
        
        if (i == 0) {
            textField.frame = CGRectMake(nameLabel.x+nameLabel.width+10, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-30, nameLabel.height);
            [textField setEnabled:NO];
            
            UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YGScreenWidth-25, 15, 20, 20)];
            arrowImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
            [arrowImageView sizeToFit];
            [baseView addSubview:arrowImageView];
            arrowImageView.centery = textField.centery;
            
            UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
            coverButton.frame = CGRectMake(nameLabel.x+nameLabel.width+10, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-10, nameLabel.height);
            [coverButton addTarget:self action:@selector(chooseBusinessParkAction:) forControlEvents:UIControlEventTouchUpInside];
            [baseView addSubview:coverButton];
        }
        if (i == 3) {
         
   
            //发送验证码
            
            _button = [UIButton buttonWithType:UIButtonTypeCustom];
            [_button setTitle:@"发送验证码" forState:UIControlStateNormal];
            [_button setTitleColor:colorWithMainColor forState:UIControlStateNormal];
            _button.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            _button.frame = CGRectMake(YGScreenWidth -110, 5, 100, 35);
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
   
}

- (void)verifyButtonAction
{
    [YGNetService showLoadingViewWithSuperView:self.view];
    
    _button.enabled = NO;
    UITextField *phoneTextField = [self.view viewWithTag:102];
    
    //验证手机号合法性
    if ([YGAppTool isNotPhoneNumber:phoneTextField.text])
    {
        return;
    }
    _button.enabled = NO;
    [self startPostWithURLString:REQUEST_userCheck parameters:@{@"phone":phoneTextField.text,@"type":@""} showLoadingView:NO scrollView:nil];
    
}

- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    [YGNetService dissmissLoadingView];
    if ([URLString isEqualToString:REQUEST_userCheck])
    {
        UITextField *phoneTextField = [self.view viewWithTag:102];
        [self startPostWithURLString:REQUEST_sendSMS parameters:@{@"phone":phoneTextField.text,@"type":@"3"} showLoadingView:NO scrollView:nil];
        
    }
    if ([URLString isEqualToString:REQUEST_sendSMS])
    {
        [[YGSingleton sharedManager] startTimerWithTime:60];
        [YGAppTool showToastWithText:@"验证码发送成功，请注意查收"];
        [self.view endEditing:YES];
        UITextField *verifiyCodeTextField = [self.view viewWithTag:103];
        verifiyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [verifiyCodeTextField becomeFirstResponder];
        
    }
    if ([URLString isEqualToString:REQUEST_ValidationHouserPay])
    {
        if ([responseObject[@"state"] isEqualToString:@"1"]) {
            UITextField *phoneTextField = [self.view viewWithTag:102];
            if ([self.pageType isEqualToString:@"myHousePay"]) {
                MyHouseRentPayViewController *controller = [[MyHouseRentPayViewController alloc]init];
                YGSingletonMarco.user.myContractPhoneNumber = phoneTextField.text;
                [self.navigationController pushViewController:controller animated:YES];
            }else
            {
                PayRentViewController *controller = [[PayRentViewController alloc]init];
                YGSingletonMarco.user.myContractPhoneNumber = phoneTextField.text;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else{
            [YGAppTool showToastWithText:@"查询失败"];
            return ;
        }
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
    [_button setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    _button.layer.borderColor = colorWithMainColor.CGColor;
    [_button setTitle:@"发送验证码" forState:UIControlStateNormal];
}
//提交
- (void)submitButton
{
    UITextField *businessParkTextField = [self.view viewWithTag:100];
    UITextField *nameTextField = [self.view viewWithTag:101];
    UITextField *phoneTextField = [self.view viewWithTag:102];
    UITextField *verifiyCodeTextField = [self.view viewWithTag:103];

    //此处先对验证码进行验证
    if (businessParkTextField.text.length == 0 || nameTextField.text.length == 0 || phoneTextField.text.length == 0 || verifiyCodeTextField.text.length == 0) {
        [YGAppTool showToastWithText:@"请将信息填写完整后提交"];
        return ;
    }
    if ([YGAppTool isNotPhoneNumber:phoneTextField.text])
    {
        [YGAppTool showToastWithText:@"请输入正确的手机号"];
        return ;
    }
    if ([businessParkTextField.text isEqualToString:@""]) {
        [YGAppTool showToastWithText:@"请选择园区"];
        return ;
    }
    [self startPostWithURLString:REQUEST_ValidationHouserPay parameters:@{@"mobileCode":verifiyCodeTextField.text,@"park":_parkIndex,@"name":nameTextField.text,@"phone":phoneTextField.text} showLoadingView:YES scrollView:nil];
  
}


- (void)chooseBusinessParkAction:(UIButton *)btn
{
    btn.userInteractionEnabled = NO;
    if (_gardenArray.count == 0) {
        [YGNetService YGPOST:REQUEST_ChooseGarden parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
            btn.userInteractionEnabled = YES;

            [_gardenArray addObjectsFromArray: responseObject[@"list"]];
            NSMutableArray *gardenArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in _gardenArray) {
                [gardenArray addObject:dict[@"label"]];
            }
            [YGActionSheetView showAlertWithTitlesArray:gardenArray handler:^(NSInteger selectedIndex, NSString *selectedString) {
                UITextField *textField = [self.view viewWithTag:100];
                textField.text = selectedString;
                _parkIndex = [NSString stringWithFormat:@"%ld",selectedIndex+1];
            }];
            
        } failure:^(NSError *error) {
            btn.userInteractionEnabled = YES;

        }];
    }else
    {
        btn.userInteractionEnabled = YES;

        NSMutableArray *gardenArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in _gardenArray) {
            [gardenArray addObject:dict[@"label"]];
        }
        [YGActionSheetView showAlertWithTitlesArray:gardenArray handler:^(NSInteger selectedIndex, NSString *selectedString) {
            UITextField *textField = [self.view viewWithTag:100];
            textField.text = selectedString;
            _parkIndex = [NSString stringWithFormat:@"%ld",selectedIndex+1];

        }];
       
    }

}


@end
