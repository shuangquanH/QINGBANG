//
//  AddAddressViewController.m
//  NiXiSchool
//
//  Created by 郭松阳的Mac on 2016/12/12.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "AddAddressViewController.h"
#import "YGCityPikerView.h"

@interface AddAddressViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,YGCityPikerViewDelegate>
@property (nonatomic, retain) UIScrollView *scrollView;

@end

@implementation AddAddressViewController
{
    NSArray *_textFieldPlaceHolderArray;
    NSArray *_textFieldContentArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)configAttribute
{
    

    
    _textFieldPlaceHolderArray = @[@"请输入手机号码",@"请选择",@"请填写详细地址，街道及门牌号"];
//    _textFieldContentArray = @[_model.phone,_model.firstaddress,_model.secondaddress];

    if ([_state isEqualToString:@"修改"])
    {
        _textFieldContentArray = @[_model.phone,[NSString stringWithFormat:@"%@ %@ %@",_model.prov,_model.city,_model.dist],_model.address];
        self.naviTitle = @"编辑地址";

    }
    else
    {
        self.naviTitle = @"新增地址";

    }
    
    [self configUI];
}
-(void)configUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight)];
    self.scrollView.backgroundColor = colorWithTable;
    self.scrollView.contentSize = CGSizeMake(YGScreenWidth, YGScreenHeight);
    self.scrollView.alwaysBounceVertical = YES;
    //取消边界反弹效果(默认是开启)
    self.scrollView.bounces = YES;
    //快速回到顶部
    self.scrollView.scrollsToTop = YES;
    //是否显示水平滑动条
    self.scrollView.showsHorizontalScrollIndicator = YES;
    //是否显示垂直滑动条
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    //姓名baseView
    UIView *nameBaseView = [[UIView alloc]init];
    nameBaseView.backgroundColor = colorWithYGWhite;
    [self.scrollView addSubview:nameBaseView];
    [nameBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.mas_offset(15);
        make.width.mas_equalTo(YGScreenWidth);
        make.height.mas_equalTo(45);
    }];
    
    //线
    UIView *nameTopLineView = [[UIView alloc]init];
    nameTopLineView.backgroundColor = colorWithLine;
    [nameBaseView addSubview:nameTopLineView];
    [nameTopLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.mas_offset(0);
        make.width.mas_equalTo(YGScreenWidth);
        make.height.mas_equalTo(0.5);
    }];
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = colorWithBlack;
    nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    nameLabel.text = @"姓名";
    [nameLabel sizeToFitHorizontal];
    [nameBaseView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.width.mas_equalTo(nameLabel.width*3);
        make.centerY.mas_equalTo(nameBaseView.mas_centerY);
        
    }];
    
    //输入姓名textField
    self.nameTextField = [[UITextField alloc]init];
    if ([self.state isEqualToString: @"添加"])
    {
        self.nameTextField.placeholder = @"请输入姓名";
        
    }else
    {
        self.nameTextField.text = self.model.name;
        
    }
    self.nameTextField.borderStyle = UITextBorderStyleNone;
    self.nameTextField.returnKeyType = UIReturnKeyDone;
    self.nameTextField.delegate = self;
    self.nameTextField.tag = 10;
    self.nameTextField.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    self.nameTextField.textColor = colorWithBlack;
    self.nameTextField.textAlignment = NSTextAlignmentRight;
    [_nameTextField setValue:colorWithPlaceholder forKeyPath:@"_placeholderLabel.textColor"];
    [nameBaseView addSubview: self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel.mas_centerY);
        make.height.mas_equalTo(nameBaseView.mas_height);
        make.width.mas_equalTo(YGScreenWidth-nameLabel.width-20);
        make.right.mas_equalTo(nameBaseView.mas_right).offset(-10);

    }];
    
    //线
    UIView *nameBottomLineView = [[UIView alloc]init];
    nameBottomLineView.backgroundColor = colorWithLine;
    [nameBaseView addSubview:nameBottomLineView];
    [nameBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.bottom.mas_equalTo(nameBaseView);
        make.width.mas_equalTo(YGScreenWidth);
        make.height.mas_equalTo(0.5);
    }];
    

    for (int i = 0; i<3; i++) {
        
        UIView *baseView = [[UIView alloc]init];
        baseView.backgroundColor = colorWithYGWhite;
        [self.scrollView addSubview:baseView];
        [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(0);
            make.top.mas_equalTo(nameBaseView.mas_bottom).offset(45*i);
            make.width.mas_equalTo(YGScreenWidth);
            make.height.mas_equalTo(45);
            
        }];
        
        if (i<2)
        {
            UILabel *titleLabel = [[UILabel alloc]init];
            if (i == 0)
            {
                titleLabel.text = @"手机号";
            }
            else
            {
                titleLabel.text = @"所在地区";
            }
            titleLabel.font = nameLabel.font;
            titleLabel.textColor = nameLabel.textColor;
            [baseView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(nameLabel.mas_left);
                make.centerY.mas_equalTo(baseView.mas_centerY);
            }];
            
        }
        if (i<=1) {
            UITextField *contentTextField = [[UITextField alloc]init];
            if ([self.state isEqualToString: @"添加"])
            {
                contentTextField.placeholder = _textFieldPlaceHolderArray[i];
                
            }else
            {
                contentTextField.text = _textFieldContentArray[i];
            }
            
            contentTextField.borderStyle = UITextBorderStyleNone;
            contentTextField.returnKeyType = UIReturnKeyDone;
            contentTextField.delegate = self;
            contentTextField.tag = 500+i;
            [contentTextField setValue:colorWithPlaceholder forKeyPath:@"_placeholderLabel.textColor"];
            contentTextField.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            contentTextField.textColor = colorWithBlack;
            contentTextField.textAlignment = NSTextAlignmentRight;
            [baseView addSubview: contentTextField];
            [contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(baseView.mas_centerY);
                make.height.mas_equalTo(baseView.mas_height);
                make.left.mas_equalTo(_nameTextField.mas_left);
                make.right.mas_equalTo(baseView.mas_right).mas_offset(-10);
            }];
            
            if (i == 1)
            {
                [contentTextField setEnabled:NO];
                UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [clearButton addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
                clearButton.backgroundColor = [UIColor clearColor];
                [baseView addSubview:clearButton];
                [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.mas_equalTo(contentTextField);
                    
                }];
            }
        }else
        {
            _addressTextView = [[UITextView alloc] init];
            _addressTextView.backgroundColor = colorWithYGWhite;
            _addressTextView.textColor = colorWithBlack;
            _addressTextView.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            _addressTextView.delegate = self;
            _addressTextView.text = _textFieldContentArray[i];
            [baseView addSubview:_addressTextView];
            [_addressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(baseView.mas_centerY);
                make.height.mas_equalTo(50);
                make.left.mas_equalTo(baseView.mas_left).mas_offset(10);
                make.right.mas_equalTo(baseView.mas_right).mas_offset(-10);
            }];
            
            
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 200, 20)];
            _placeHolderLabel.textColor = colorWithDeepGray;
            _placeHolderLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
            _placeHolderLabel.text = _textFieldPlaceHolderArray[i];
            [_placeHolderLabel sizeToFit];
            [_addressTextView addSubview:_placeHolderLabel];
            if ((![_textFieldContentArray[i] isEqualToString:@""] || _textFieldContentArray[i]) && _textFieldContentArray != nil) {
                _placeHolderLabel.hidden = YES;
            }
        }
   

        

        UIView *bottomLineView = [[UIView alloc]init];
        bottomLineView.backgroundColor = colorWithLine;
        [baseView addSubview:bottomLineView];
        if (i<2)
        {
            [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(nameLabel.mas_left);
                make.width.mas_equalTo(YGScreenWidth);
                make.height.mas_equalTo(0.5);
                make.bottom.mas_equalTo(baseView.mas_bottom);
                
            }];
            
        }
        else
        {
            
            [baseView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(90);
            }];
            [baseView layoutIfNeeded];
            [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(0);
                make.width.mas_equalTo(YGScreenWidth);
                make.height.mas_equalTo(0.5);
                make.bottom.mas_equalTo(baseView.mas_bottom);
                
            }];
        }
        
    }
    
    //确认按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [confirmButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    confirmButton.backgroundColor = colorWithMainColor;
    confirmButton.layer.cornerRadius = 22.5;
    [self.scrollView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(YGScreenWidth-30);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(nameBaseView.mas_top).offset(295);
        make.left.mas_offset(15);
        
    }];
    
}
-(void)confirmButtonClick
{
    
    UITextField *phoneTextField = [self.view viewWithTag:500];
    UITextField *firstTextField = [self.view viewWithTag:501];
//    UITextField *secondTextField = [self.view viewWithTag:502];
    
    if (_nameTextField.text.length >6)
    {
        [YGAppTool showToastWithText:@"名字过长"];
        return;
    }
    if ([YGAppTool isNotPhoneNumber:phoneTextField.text] == YES)
    {
        return;
    }
    if ([firstTextField.text isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"收货地址为空"];
        return;
    }
    if ([_addressTextView.text isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"详细地址有误"];
        return;
    }
    if (_addressTextView.text.length>16 )
    {
        [YGAppTool showToastWithText:@"详细地址过长"];
        return;
    }
    if ([_nameTextField.text isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请填写姓名"];
        return;
    }
    
    [self dismiss];

    NSArray *cityArray = [firstTextField.text componentsSeparatedByString:@" "];
    if ([_state isEqualToString:@"修改"])
    {
            NSDictionary *dict = @{@"id":_model.ID,@"type":@"0",@"name":_nameTextField.text,@"phone":phoneTextField.text,@"prov":cityArray[0],@"city":cityArray[1],@"dist":cityArray[2],@"address":_addressTextView.text,@"defAddress":_model.defAddress};
        [self startPostWithURLString:REQUEST_AddressEdit parameters:dict showLoadingView:NO scrollView:nil];
    }
    else
    {
        NSDictionary *dict = @{@"userId":YGSingletonMarco.user.userId,@"type":@"0",@"name":_nameTextField.text,@"phone":phoneTextField.text,@"prov":cityArray[0],@"city":cityArray[1],@"dist":cityArray[2],@"address":_addressTextView.text,@"defAddress":@"0"};
        [self startPostWithURLString:REQUEST_AddAddress parameters:dict showLoadingView:NO scrollView:nil];
    }

}
-(void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject{
    if ([URLString isEqualToString:REQUEST_AddressEdit]) {
        [YGAppTool showToastWithText:@"修改地址成功"];
        
        [self.navigationController popViewControllerAnimated:YES];

    }else
    {
        [YGAppTool showToastWithText:@"添加地址成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)clearClick
{
    [self dismiss];
    [self loadCity];
}
-(void)dismiss
{
    [self.view endEditing:YES];
}

-(void)loadCity
{
    //取出之前的
    NSArray *cityArray = [YGSingletonMarco.user.detailAddress componentsSeparatedByString:@" "];
    YGCityPikerView *cityPickerView = [[YGCityPikerView alloc]init];
    [cityPickerView setSelectProvince:cityArray[0] city:cityArray[1] district:cityArray[2]];
    cityPickerView.delegate = self;
    [cityPickerView show];
}

//省市代理

- (void)selectedProvince:(NSString *)province city:(NSString *)city district:(NSString *)district
{
    UITextField *firstTextField = [self.view viewWithTag:501];
    
    [firstTextField resignFirstResponder];
    
    firstTextField.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)back
{

    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismiss];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0)
    {
        _placeHolderLabel.hidden = YES;
        
    }else
    {
        _placeHolderLabel.hidden = NO;
        
    }
}
@end
