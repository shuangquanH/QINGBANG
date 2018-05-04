//
//  OrderCheckHouseSubmitViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderCheckHouseSubmitViewController.h"
#import "YGDatePickerView.h"

@interface OrderCheckHouseSubmitViewController ()<UITextViewDelegate>

@end

@implementation OrderCheckHouseSubmitViewController
{
    UIScrollView * _mainScrollView;
    UIImageView *_projectVideoImageView; //广告轮播
    UIView          *_baseView;
    UITextView *_textView;
    UILabel *_placehodlerLabel;
//    YGDatePickerView *_datePickerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}
- (void)configAttribute
{
    self.naviTitle = @"预约单";
//    _datePickerView = [[YGDatePickerView alloc] init];
}
#pragma mark ---- 配置UI
-(void)configUI
{
    
    /********************* _scrollView ***************/
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight -YGStatusBarHeight -45-YGBottomMargin)];
    _mainScrollView.contentSize = CGSizeMake(YGScreenWidth, _mainScrollView.height);
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.bounces = NO;
//    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    
    /********************** 头视图两个按钮 *****************/
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth*0.74)];
    _baseView.backgroundColor = colorWithYGWhite;
    [_mainScrollView addSubview:_baseView];
    //广告滚动
    _projectVideoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth*0.74)];
    [_projectVideoImageView sd_setImageWithURL:[NSURL URLWithString:[_model.imgs componentsSeparatedByString:@","][0]] placeholderImage:YGDefaultImgFour_Three];
    _projectVideoImageView.contentMode = UIViewContentModeScaleAspectFit;
    _projectVideoImageView.clipsToBounds = YES;
    [_baseView addSubview:_projectVideoImageView];
    
    NSArray *titleArray = @[@"联系人",@"手机",@"预约时间",@"备注"];
    NSArray *placehoderArray = @[@"请输入姓名",@"请填写真实电话",@"",@""];
    
    float labelBottom = YGScreenWidth*0.74+10;
    for (int i = 0; i<titleArray.count; i++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, labelBottom+(45*i), YGScreenWidth, 45)];
        baseView.backgroundColor = colorWithYGWhite;
        [_mainScrollView addSubview:baseView];
        
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
        
        if (i == 2) {
            
            UIImageView *arrowImageView = [[UIImageView alloc] init];
            arrowImageView.frame = CGRectMake(YGScreenWidth-27, 14, 17, 17);
            arrowImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
            [arrowImageView sizeToFit];
            arrowImageView.userInteractionEnabled = YES;
            [baseView addSubview:arrowImageView];
            
            textField.frame = CGRectMake(nameLabel.x+nameLabel.width+10, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-10-30, nameLabel.height);
            
            UIButton *orderTimeBtn = [[UIButton alloc] init];
            orderTimeBtn.frame = CGRectMake(0, 0, YGScreenWidth, baseView.height);
            [baseView addSubview:orderTimeBtn];
            [orderTimeBtn addTarget:self action:@selector(chooseOrderTimeAction) forControlEvents:UIControlEventTouchUpInside];
            
        }
        if (i == 3) {
            lineView.hidden = YES;
        }

    }
    
    UIView *textViewBaseView = [[UIView alloc] initWithFrame:CGRectMake(0,_projectVideoImageView.y+_projectVideoImageView.height+10+45*3, YGScreenWidth, 200)];
    textViewBaseView.backgroundColor = colorWithYGWhite;
    [_mainScrollView addSubview:textViewBaseView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, YGScreenWidth-20, 200)];
    _textView.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _textView.textColor = colorWithBlack;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.scrollEnabled = NO;
    _textView.delegate = self;
    [textViewBaseView addSubview:_textView];
    
    _placehodlerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,5 , 100, 20)];
    _placehodlerLabel.text = @"备注信息可选填";
    _placehodlerLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _placehodlerLabel.textColor = colorWithPlaceholder;
    [_textView addSubview:_placehodlerLabel];
    
    _mainScrollView.contentSize = CGSizeMake(YGScreenWidth, textViewBaseView.y+textViewBaseView.height+20);

    UIButton *applyButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
    applyButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
    [applyButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    applyButton.backgroundColor = colorWithMainColor;
    applyButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [self.view addSubview:applyButton];
    [applyButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [applyButton setTitle:@"提交" forState:UIControlStateNormal];
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
- (void)saveButtonAction
{
    UITextField *textFieldName = [self.view viewWithTag:100];
    UITextField *textFieldPhone = [self.view viewWithTag:101];
    UITextField *textFieldDate = [self.view viewWithTag:102];
    UITextField *textViewContent = [self.view viewWithTag:103];

    if ([textFieldName.text isEqualToString:@""] ||  textFieldName.text == nil) {
        [YGAppTool showToastWithText:@"请填写联系人姓名"];
        return;
    }
    if ([textFieldPhone.text isEqualToString:@""] ||  textFieldPhone.text == nil) {
        [YGAppTool showToastWithText:@"请填写联系人手机号码"];
        return;
    }
    if ([YGAppTool isNotPhoneNumber:textFieldPhone.text]) {
        return;
    }
    if ([textFieldDate.text isEqualToString:@""] ||  textFieldDate.text == nil) {
        [YGAppTool showToastWithText:@"请选择预约时间"];
        return;
    }
    if ([textViewContent.text isEqualToString:@""] ||  textViewContent.text == nil) {
        textViewContent.text = @"";
    }
    [YGNetService YGPOST:REQUEST_OtSaveReservation parameters:@{@"userid":YGSingletonMarco.user.userId,@"id":_model.id,@"contacts":textFieldName.text,@"contact":textFieldPhone.text,@"time":textFieldDate.text,@"remarks":textViewContent.text} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        [YGNetService dissmissLoadingView];
        [YGAppTool showToastWithText:@"预约成功"];
        [self back];
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];

    }];
}

- (void)chooseOrderTimeAction
{

    NSDateFormatter *selectedFormat = [[NSDateFormatter alloc] init];
    selectedFormat.dateFormat = @"yyyy-MM-dd";
    UITextField *textFieldDate = [self.view viewWithTag:102];
    NSString *lastValue = textFieldDate.text;

    YGDatePickerView *datePickerView = [YGDatePickerView showWithStartDate:[NSDate date] endDate:nil titleString:@"请选择" datePickerMode:UIDatePickerModeDate handler:^(NSDate *selectedDate)
                                        {
                                            textFieldDate.text = [NSString stringWithFormat:@"%@",[selectedFormat stringFromDate:selectedDate]];
                                        }];
    [datePickerView selectWithDate:[selectedFormat dateFromString:lastValue]];

}
@end
