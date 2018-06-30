//
//  ServiceHallBaseProfileViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ServiceHallBaseProfileViewController.h"
#import "TextViewAjustHeight.h"
#define YEARCOUNT   10

@interface ServiceHallBaseProfileViewController ()

@end

@implementation ServiceHallBaseProfileViewController
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

    [self   createFrame:CGRectMake(0, 0, YGScreenWidth, 300) withInfoArray:@[@"联系人",@"手机",@"地址",@"企业/个人名称",] andPageType:@""];
}

- (void)createFrame:(CGRect)frame withInfoArray:(NSArray *)infoArray andPageType:(NSString *)pageType
{
        UIView *selfView = [[UIView alloc] initWithFrame:frame];
        selfView.backgroundColor = colorWithTable;
        [self.view addSubview:selfView];

        NSArray *titleArray = @[@"联系人",@"手机"];
        NSArray *placehoderArray = @[@"请输入姓名",@"请输入联系电话"];
        
        float labelBottom = 0;
        for (int i = 0; i<2; i++) {
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
            lineView.backgroundColor = colorWithTable;
            [baseView addSubview:lineView];
        }
        
        if (infoArray.count > 3) {
            _thirdbaseView = [[UIView alloc] initWithFrame:CGRectMake(0, labelBottom+(45*2), YGScreenWidth, 45)];
            _thirdbaseView.backgroundColor = colorWithYGWhite;
            [selfView addSubview:_thirdbaseView];
            
            _thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,12 , 100, 20)];
            _thirdLabel.text = infoArray[2];
            _thirdLabel.textAlignment = NSTextAlignmentLeft;
            _thirdLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
            _thirdLabel.textColor = colorWithBlack;
            [_thirdbaseView addSubview:_thirdLabel];
            
            _thirdView = [[TextViewAjustHeight alloc]initWithFrame:CGRectMake(_thirdLabel.x+_thirdLabel.width+10, 5, YGScreenWidth-(_thirdLabel.x+_thirdLabel.width+10)-10, 30)];
            _thirdView.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
            _thirdView.textColor = colorWithBlack;
            _thirdView.textAlignment = NSTextAlignmentRight;
            _thirdView.returnKeyType = UIReturnKeyDone;
            _thirdView.backgroundColor = [UIColor clearColor];
            _thirdView.placeholder = @"请输入地址";
            _thirdView.cornerRadius = 4;
            _thirdView.placeholderColor = colorWithLightGray;
            _thirdView.placeholderFont = [UIFont systemFontOfSize:YGFontSizeNormal];
            _thirdView.maxNumberOfLines = 4;
            [_thirdbaseView addSubview:_thirdView];
            
            _thirdLineView = [[UIView alloc] initWithFrame:CGRectMake(10, _thirdbaseView.height-1, YGScreenWidth-10, 1)];
            _thirdLineView.backgroundColor = colorWithTable;
            [_thirdbaseView addSubview:_thirdLineView];
            
            
            
            
        }
        if (infoArray.count == 4) {
            
            _fourthbaseView = [[UIView alloc] initWithFrame:CGRectMake(0, labelBottom+(45*3), YGScreenWidth, 45)];
            _fourthbaseView.backgroundColor = colorWithYGWhite;
            [selfView addSubview:_fourthbaseView];
            
            _fourthLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,12 , 100, 20)];
            _fourthLabel.text = infoArray[3];
            _fourthLabel.textAlignment = NSTextAlignmentLeft;
            _fourthLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
            _fourthLabel.textColor = colorWithBlack;
            [_fourthbaseView addSubview:_fourthLabel];
            
            _fourthView = [[TextViewAjustHeight alloc]initWithFrame:CGRectMake(_thirdLabel.x+_thirdLabel.width+10, 5, YGScreenWidth-(_thirdLabel.x+_thirdLabel.width+10)-10, 30)];
            _fourthView.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
            _fourthView.textColor = colorWithBlack;
            _fourthView.textAlignment = NSTextAlignmentRight;
            _fourthView.returnKeyType = UIReturnKeyDone;
            _fourthView.backgroundColor = [UIColor clearColor];
            _fourthView.placeholder = @"请输入企业/个人名称";
            _fourthView.placeholderColor = colorWithLightGray;
            _fourthView.placeholderFont = [UIFont systemFontOfSize:YGFontSizeNormal];
            _fourthView.maxNumberOfLines = 4;
            [_fourthbaseView addSubview:_fourthView];
            
            
        }
        
        __weak TextViewAjustHeight *weakThirdView = _thirdView;
        __weak UIView *weakFourthbaseView = _fourthbaseView;
        __weak UIView *weakThirdbaseView = _thirdbaseView;
        __weak UIView *weakThirdLineView = _thirdLineView;
        // 设置文本框最大行数
        [_thirdView textValueDidChanged:^(NSString *text, CGFloat textHeight) {
            CGRect frame = weakThirdView.frame;
            frame.size.height = textHeight;
            weakThirdView.frame = frame;
            if ((textHeight+10)>45)
            {
                weakThirdbaseView.frame = CGRectMake(weakThirdbaseView.x, weakThirdbaseView.y, weakThirdbaseView.width, 5+textHeight+5);
                weakThirdLineView.frame = CGRectMake(10, weakThirdbaseView.height-1, weakThirdLineView.width, 1);
                weakFourthbaseView.frame = CGRectMake(weakThirdbaseView.x, weakThirdbaseView.y+weakThirdbaseView.height, weakThirdbaseView.width, weakFourthbaseView.height);
            }
            
        }];
        
        __weak TextViewAjustHeight *weakFourthView = _fourthView;
        
        // 设置文本框最大行数
        [_fourthView textValueDidChanged:^(NSString *text, CGFloat textHeight) {
            CGRect frame = weakFourthView.frame;
            frame.size.height = textHeight;
            weakFourthView.frame = frame;
            
            weakFourthbaseView.frame = CGRectMake(weakThirdbaseView.x, weakFourthbaseView.y, weakThirdbaseView.width, 5+weakFourthView.height+5);
            
        }];
        
        _confirmRealButton = [[UIButton alloc]initWithFrame:CGRectMake(10,YGScreenHeight-45-YGBottomMargin-50-64,100,25)];
        [_confirmRealButton setImage:[UIImage imageNamed:@"nochoice_btn_gray"] forState:UIControlStateNormal];
        [_confirmRealButton setImage:[UIImage imageNamed:@"order_choice_btn_green"] forState:UIControlStateSelected];
        [_confirmRealButton setTitle:@"本人保证所填写的内容属实" forState:UIControlStateNormal];
        [_confirmRealButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_confirmRealButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -20)];
        [_confirmRealButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
        [_confirmRealButton addTarget:self action:@selector(defultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _confirmRealButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        [_confirmRealButton sizeToFit];
        [self.view addSubview:_confirmRealButton];
        _confirmRealButton.frame = CGRectMake(10,_confirmRealButton.y,_confirmRealButton.width+20,30);
        _confirmRealButton.selected = NO;
        
        
        UIButton *confirmPayButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-45-YGBottomMargin-64,YGScreenWidth,45+YGBottomMargin)];
        [confirmPayButton setTitle:@"提交" forState:UIControlStateNormal];
        [confirmPayButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
        [confirmPayButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        confirmPayButton.backgroundColor = colorWithMainColor;
        confirmPayButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        [self.view addSubview:confirmPayButton];
        

}

- (void)defultButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
}
- (void)submitButtonAction:(UIButton *)btn
{

    UITextField *nameTextField = [self.view  viewWithTag:100];
    UITextField *phoneTextField = [self.view  viewWithTag:101];
    if (phoneTextField.text.length == 0 || _thirdView.text.length == 0 || _fourthView.text.length == 0) {
        [YGAppTool showToastWithText:@"请将信息填写完整"];
        return;
    }
    
    if (![YGAppTool isVerifiedWithText:nameTextField.text name:@"联系人姓名" maxLength:20 minLength:2 shouldEmpty:NO]) {
        return;
    }
    
    if ([YGAppTool isNotPhoneNumber:phoneTextField.text]) {
        return;
    }
    if (_confirmRealButton.selected != YES) {
        [YGAppTool showToastWithText:@"请确认并勾选“本人保证所填写的内容属实”按钮"];
        return;
    }
    [self startPostWithURLString:REQUEST_Application parameters:@{@"firmName":_fourthView.text,@"name":nameTextField.text,@"contactPhone":phoneTextField.text,@"address":_thirdView.text,@"userId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil];

}

- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    [YGAppTool showToastWithText:@"申请成功"];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
