//
//  AskBPViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AskBPViewController.h"
#import "TextViewAjustHeight.h"
#define YEARCOUNT   10

@interface AskBPViewController ()

@end

@implementation AskBPViewController
{
    UILabel *_thirdLabel;
    UILabel *_fourthLabel;
    UIView *_thirdbaseView;
    UIView *_fourthbaseView;
    TextViewAjustHeight *_thirdView;
    TextViewAjustHeight *_fourthView;
    UIView *_thirdLineView;
    UILabel *_thirdPlacehoderLabel;
    UILabel *_fourthPlacehoderLabel;
    
    UIButton *_confirmRealButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)configAttribute
{
    self.naviTitle = @"基本资料";
    
    [self   createFrame:CGRectMake(0, 0, YGScreenWidth, 300) withInfoArray:@[@"姓名",@"电话",@"邮箱"] andPageType:@""];
}

- (void)createFrame:(CGRect)frame withInfoArray:(NSArray *)infoArray andPageType:(NSString *)pageType
{
    UIView *selfView = [[UIView alloc] initWithFrame:frame];
    selfView.backgroundColor = colorWithTable;
    [self.view addSubview:selfView];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , YGScreenWidth-20, 45)];
    headerLabel.text = @"留下联系方式，方便项目发起人发送BP";
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    headerLabel.textColor = colorWithDeepGray;
    [selfView addSubview:headerLabel];
    
    
    NSArray *titleArray = @[@"姓名",@"电话",@"邮箱"];
    NSArray *placehoderArray = @[@"请输入姓名",@"请输入联系电话",@"请输入邮箱地址"];
    
    float labelBottom = 45;
    for (int i = 0; i<3; i++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, labelBottom+(45*i), YGScreenWidth, 45)];
        baseView.backgroundColor = colorWithYGWhite;
        [selfView addSubview:baseView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 100, 45)];
        nameLabel.text = titleArray[i];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        nameLabel.textColor = colorWithBlack;
        [baseView addSubview:nameLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width+10, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-10, nameLabel.height)];
        textField.tag = 100+i;
        textField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        textField.textColor = colorWithBlack;
        textField.placeholder = placehoderArray[i];
        textField.textAlignment = NSTextAlignmentRight;
        [baseView addSubview:textField];
        [textField setValue:colorWithLightGray forKeyPath:@"_placeholderLabel.textColor"];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, baseView.height-1, YGScreenWidth-10, 1)];
        lineView.backgroundColor = colorWithLine;
        [baseView addSubview:lineView];
    }
    
    
    UIButton *confirmPayButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-45-YGBottomMargin-64,YGScreenWidth,45+YGBottomMargin)];
    [confirmPayButton setTitle:@"提交" forState:UIControlStateNormal];
    [confirmPayButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [confirmPayButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    confirmPayButton.backgroundColor = colorWithMainColor;
    confirmPayButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [self.view addSubview:confirmPayButton];
    
    
}


- (void)submitButtonAction:(UIButton *)btn
{

    UITextField *nameTextField = [self.view  viewWithTag:100];
    UITextField *phoneTextField = [self.view  viewWithTag:101];
    UITextField *emailTextField = [self.view  viewWithTag:102];

    if (nameTextField.text.length == 0) {
        [YGAppTool showToastWithText:@"请填写姓名"];
        return;
    }
    if ([YGAppTool isNotPhoneNumber:phoneTextField.text]) {
        return;
    }
    if (emailTextField.text.length == 0) {
        [YGAppTool showToastWithText:@"请填写邮箱地址"];
        return;
    }
    if ([YGAppTool isNotEmail:emailTextField.text]) {
        return;
    }
    [self startPostWithURLString:REQUEST_bpWanted parameters:@{@"name":nameTextField.text,@"phone":phoneTextField.text,@"email":emailTextField.text,@"usmuserId":YGSingletonMarco.user.userId,@"roadshowId":self.roadshowId} showLoadingView:NO scrollView:nil];
    
}

- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    [YGAppTool showToastWithText:@"提交信息成功，请等待工作人员与您联系"];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
