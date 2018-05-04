//
//  FinacialAccountPopView.m
//  QingYouProject
//
//  Created by nefertari on 2017/9/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "FinacialAccountPopView.h"
#import "TextViewAjustHeight.h"
#define YEARCOUNT   10

@implementation FinacialAccountPopView
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

    UILabel  *_describeLabel;
    UILabel  *_yearLabel;
    BOOL    _isSelectYearBtn; //是否选择了年限按钮
    UIImageView *_leftImageView;
    NSArray *_categoryArry;
    UILabel *_titleLabel;
    NSArray *_typeArray;
    UIScrollView *_backScrollView;
    UIView * _baseView;
    UIView * _titleBaseView;
    NSInteger  _selectNum;
    NSString * _pageType;
}
- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight);
        self.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.5];
    }
    return self;
}
- (void)createFrame:(CGRect)frame withInfoArray:(NSArray *)infoArray andPageType:(NSString *)pageType
{
    UIView *selfView = [[UIView alloc] initWithFrame:frame];
    selfView.backgroundColor = colorWithTable;
    [self addSubview:selfView];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    titleView.backgroundColor = colorWithYGWhite;
    [selfView addSubview:titleView];
    
    if (![pageType isEqualToString:@""])
    {
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10,0,40,40)];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:colorWithLightGray forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        backButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [titleView addSubview:backButton];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, YGScreenWidth-200, 40)];
    label.text = @"填写信息";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = colorWithYGWhite;
    label.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    label.textColor = colorWithBlack;
    [titleView addSubview:label];
    
    UIButton *cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-55,0,40,40)];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:colorWithLightGray forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleInputViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [titleView addSubview:cancleButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithLine;
    [titleView addSubview:lineView];
    
    NSArray *titleArray = @[@"联系人",@"手机"];
    NSArray *placehoderArray = @[@"请输入姓名",@"请输入联系电话"];
    
    float labelBottom = 40;
    for (int i = 0; i<2; i++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, labelBottom+(45*i), YGScreenWidth, 45)];
        baseView.backgroundColor = colorWithYGWhite;
        [selfView addSubview:baseView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 100, 45)];
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
        _thirdLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _thirdLabel.textColor = colorWithBlack;
        [_thirdbaseView addSubview:_thirdLabel];
        
        _thirdView = [[TextViewAjustHeight alloc]initWithFrame:CGRectMake(_thirdLabel.x+_thirdLabel.width+10, 5, YGScreenWidth-(_thirdLabel.x+_thirdLabel.width+10)-10, 30)];
        _thirdView.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _thirdView.textColor = colorWithBlack;
        _thirdView.textAlignment = NSTextAlignmentRight;
        _thirdView.returnKeyType = UIReturnKeyDone;
        _thirdView.backgroundColor = [UIColor clearColor];
        _thirdView.placeholder = @"请输入企业/个人名称";
        _thirdView.cornerRadius = 4;
        _thirdView.placeholderColor = colorWithLightGray;
        _thirdView.placeholderFont = [UIFont systemFontOfSize:YGFontSizeSmallOne];
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
        _fourthLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _fourthLabel.textColor = colorWithBlack;
        [_fourthbaseView addSubview:_fourthLabel];
        
        _fourthView = [[TextViewAjustHeight alloc]initWithFrame:CGRectMake(_thirdLabel.x+_thirdLabel.width+10, 5, YGScreenWidth-(_thirdLabel.x+_thirdLabel.width+10)-10, 30)];
        _fourthView.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _fourthView.textColor = colorWithBlack;
        _fourthView.textAlignment = NSTextAlignmentRight;
        _fourthView.returnKeyType = UIReturnKeyDone;
        _fourthView.backgroundColor = [UIColor clearColor];
        _fourthView.placeholder = @"请输入地址";
        _fourthView.placeholderColor = colorWithLightGray;
        _fourthView.placeholderFont = [UIFont systemFontOfSize:YGFontSizeSmallOne];
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
    
    UIButton *confirmPayButton = [[UIButton alloc]initWithFrame:CGRectMake(0,selfView.height-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
    [confirmPayButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [confirmPayButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [confirmPayButton addTarget:self action:@selector(confirmPayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    confirmPayButton.backgroundColor = colorWithMainColor;
    confirmPayButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [selfView addSubview:confirmPayButton];
    if ([pageType isEqualToString:@"joboutsource"])
    {
        [confirmPayButton setTitle:@"立即申请" forState:UIControlStateNormal];
    }
}

- (void)createFrame:(CGRect)frame withInfoNSArry:(NSArray *)arry andPageType:(NSString *)pageType

//- (void)createFrame:(CGRect)frame withInfoDict:(NSDictionary *)infoDict andPageType:(NSString *)pageType
{
    _selectNum = 0;
    _categoryArry = arry;
    _pageType = pageType;
    
    UIView *selfView = [[UIView alloc] initWithFrame:frame];
    selfView.backgroundColor = colorWithYGWhite;
    [self addSubview:selfView];
    
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, selfView.height-45-YGBottomMargin)];
    [selfView addSubview:_backScrollView];
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 180)];
    _baseView.backgroundColor = colorWithYGWhite;
    [_backScrollView addSubview:_baseView];
    
    UIButton *cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-55,0,40,40)];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:colorWithLightGray forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleChooseTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_backScrollView addSubview:cancleButton];
    
    //左线
     _leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_tool1.png"]];
    _leftImageView.frame = CGRectMake(10, 20, 60, 60);
//    _leftImageView.layer.borderColor = colorWithLine.CGColor;
//    _leftImageView.layer.borderWidth = 0.5;
    _leftImageView.layer.masksToBounds = YES;
    _leftImageView.layer.cornerRadius = 5;
    _leftImageView.backgroundColor = colorWithMainColor;
//    _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_baseView addSubview:_leftImageView];
    
    //新鲜事标题label
     _titleLabel= [[UILabel alloc]init];
    _titleLabel.textColor = colorWithRedColor;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
   
    _titleLabel.frame = CGRectMake(_leftImageView.x+_leftImageView.width+10, _leftImageView.y+15,YGScreenWidth-100-15, 20);
    [_baseView addSubview:_titleLabel];
    
    
    //新鲜事内容label
    _describeLabel = [[UILabel alloc]init];
    _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height+5 , YGScreenWidth-100, 20);
    _describeLabel.textColor = colorWithLightGray;
    _describeLabel.text = @"请选择对应的服务类别";
    _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    _describeLabel.numberOfLines = 1;
    _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_describeLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-100];
    _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height+5 , YGScreenWidth-100, _describeLabel.height);
    [_baseView addSubview:_describeLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, _leftImageView.y+_leftImageView.height+20, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithTable;
    [_baseView addSubview:lineView];
    
    UILabel *typeTitleLabel = [[UILabel alloc]init];
    typeTitleLabel.textColor = colorWithBlack;
    typeTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    typeTitleLabel.text = @"类别   ";
    typeTitleLabel.frame = CGRectMake(_leftImageView.x, lineView.y+lineView.height+20,100, 20);
    [_baseView addSubview:typeTitleLabel];

    NSMutableArray *typeArray = [[NSMutableArray alloc]init];
    //工商一体化选择的是纳税人类型  纳税人选的是年限
    if ([pageType containsString:@"IntegrationIndustryCommerceController"])
    {
        if(arry.count)
        {
            _titleLabel.text = [NSString stringWithFormat:@"¥%@",arry[0][@"price"]];
            _describeLabel.text = [NSString stringWithFormat:@"%@",arry[0][@"name"]];
            [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",arry[0][@"img"]]] placeholderImage:YGDefaultImgSquare];
        }
        
        typeTitleLabel.text = @"类别   ";
        for(int i =0;i<arry.count;i++)
        {
            [typeArray addObject:arry[i][@"name"]];
        }
        _typeArray = typeArray;
    }else
    {
        typeTitleLabel.text = @"选择年限   ";
        [typeArray addObject:@"半年"];
//        typeArray = @[@"半年",@"一年"];
      
        
        _titleLabel.text = [NSString stringWithFormat:@"¥%@",self.selectYearDict[@"price"]];
        _describeLabel.text = [NSString stringWithFormat:@"%@",self.selectYearDict[@"detail"]];
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.selectYearDict[@"imageUrl"]]] placeholderImage:YGDefaultImgSquare];
        _typeArray = typeArray;

    }
 
    _titleBaseView = [[UIView alloc] initWithFrame:CGRectMake(10, typeTitleLabel.y+typeTitleLabel.height+10, YGScreenWidth-20, 30)];
    [_baseView addSubview:_titleBaseView];
    
    CGSize size = CGSizeMake(YGScreenWidth, 180);
    if (typeArray.count>0 && ((NSString *)typeArray[0]).length>0) {
        
        size = [self createLabelsWithbaseView:_titleBaseView];
        _titleBaseView.frame = CGRectMake(_titleBaseView.x, _titleBaseView.y, _titleBaseView.width, size.height);
    }
    
    _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _titleBaseView.y+_titleBaseView.height + 40 + 2*LDHPadding);
    
    if (![pageType containsString:@"IntegrationIndustryCommerceController"])
    {
        //年限加减视图添加
        UIView *addView = [self createAddView];
        addView.y = typeTitleLabel.y+typeTitleLabel.height+5;
        [_baseView addSubview:addView];
    }

    _backScrollView.contentSize = CGSizeMake(0, _titleBaseView.y+_titleBaseView.height + 40 + 2*LDHPadding);

//    float width = 0.0f;
    //选择年限按钮
//    for (int i = 0; i<typeArray.count; i++) {
//        UIButton *typeButton = [[UIButton alloc]initWithFrame:CGRectMake(10+width+20,typeTitleLabel.y+typeTitleLabel.height+10,70,35)];
//        [typeButton setTitle:typeArray[i] forState:UIControlStateNormal];
//        [typeButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
//        [typeButton setTitleColor:colorWithMainColor forState:UIControlStateSelected];
//        typeButton.tag = 1000+i;
//        [typeButton addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        typeButton.layer.borderColor = colorWithLine.CGColor;
//        typeButton.layer.borderWidth = 1;
//        typeButton.layer.cornerRadius = 16;
//        typeButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
//        [typeButton sizeToFit];
//        [_baseView addSubview:typeButton];
//        typeButton.frame = CGRectMake(width+20,typeTitleLabel.y+typeTitleLabel.height+10,typeButton.width+20,typeButton.height);
//        
//        if(i==0)
//        {
//            typeButton.selected = YES;
//            typeButton.layer.borderColor = colorWithMainColor.CGColor;
//
//            typeButton.frame = CGRectMake(width+30,typeTitleLabel.y+typeTitleLabel.height+10,typeButton.width+20,typeButton.height);
//        }
//        width = typeButton.x + typeButton.width;
//
//         if (![pageType containsString:@"IntegrationIndustryCommerceController"])
//             typeButton.userInteractionEnabled = NO;
//    }
    
    UIButton *confirmPayButton = [[UIButton alloc]initWithFrame:CGRectMake(0,selfView.height-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
    [confirmPayButton setTitle:@"下一步" forState:UIControlStateNormal];
    [confirmPayButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    confirmPayButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [confirmPayButton addTarget:self action:@selector(nextStepButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    confirmPayButton.backgroundColor = colorWithMainColor;
    confirmPayButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [selfView addSubview:confirmPayButton];
    
}

- (CGSize)createLabelsWithbaseView:(UIView *)baseView
{
    int k = 0;
    CGFloat widthCount = 0.0f;
    int j = 0;

    for (int i = 0;i<_typeArray.count;i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_typeArray[i] forState:UIControlStateNormal];
       
        button.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [button.titleLabel sizeToFit];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 10000+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 25)];
        label.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        label.text = _typeArray[i];
        [label sizeToFit];
        
        CGFloat labeWidth = label.width+25;
        //        widthCount = widthCount +labeWidth;
        
        button.frame = CGRectMake(10+widthCount+k*10, 30*j, labeWidth, 25) ;
        
        widthCount = widthCount +labeWidth;
        
        if (widthCount>(baseView.width-20-k*10)) {
            j=j+1;
            k=0;
            widthCount = 0.0f;
            button.frame = CGRectMake(10+widthCount+k*10,30*j, labeWidth, 25) ;
            widthCount = widthCount +labeWidth;
        }
        button.layer.borderColor = colorWithLine.CGColor;
        [button setTitleColor:colorWithBlack forState:UIControlStateNormal];
        [button setTitleColor:colorWithMainColor forState:UIControlStateSelected];
        
        button.layer.cornerRadius = 12;
        button.layer.borderWidth = 1;
        k++;
        if(i==0)
        {
            button.selected = YES;
            button.layer.borderColor = colorWithMainColor.CGColor;
        }
        [baseView addSubview:button];
        
        if (![_pageType containsString:@"IntegrationIndustryCommerceController"])
        {
            button.userInteractionEnabled = NO;
        }
        
    }
    return CGSizeMake(YGScreenWidth, (j+1)*30);
}
- (void)buttonClick:(UIButton *)btn{
    
    //首先把原来按钮的选中效果消除
    
    for (int i=0;i<[_categoryArry count];i++) {
        
        UIButton *btn = (UIButton*)[_titleBaseView viewWithTag:i +10000];
        
        btn.selected = NO;
        btn.layer.borderColor = colorWithLine.CGColor;
        
    }
    
    btn.selected = YES;//sender.selected = !sender.selected;
    btn.layer.borderColor = colorWithMainColor.CGColor;
    
    _selectNum = btn.tag -10000;
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_categoryArry[_selectNum][@"img"]]] placeholderImage:YGDefaultImgSquare];
    _titleLabel.text = [NSString stringWithFormat:@"¥%@",_categoryArry[_selectNum][@"price"]];
    _describeLabel.text = [NSString stringWithFormat:@"%@",_categoryArry[_selectNum][@"name"]];

}
- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(_baseView.width, _baseView.height);
}

- (UIView *)createAddView
{
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(YGScreenWidth-10-120, 0, 120, 40)];
    
    //加
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(addView.width-40,0,40,40)];
    [addButton setImage:[UIImage imageNamed:@"popup_plus_btn"] forState:UIControlStateNormal];
    addButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    addButton.imageView.clipsToBounds = YES;
    [addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    addButton.backgroundColor = colorWithMainColor;
    [addView addSubview:addButton];
    
    //减
    UIButton *subButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [subButton setImage:[UIImage imageNamed:@"popup_subtract_btn"] forState:UIControlStateNormal];
    subButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    subButton.imageView.clipsToBounds = YES;
    [subButton addTarget:self action:@selector(subButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    subButton.backgroundColor = colorWithMainColor;
    [addView addSubview:subButton];
    
    //新鲜事标题label
    _yearLabel = [[UILabel alloc]init];
    _yearLabel.textColor = colorWithBlack;
    _yearLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    _yearLabel.text = @"1";
    _yearLabel.textAlignment = NSTextAlignmentCenter;
    _yearLabel.frame = CGRectMake(subButton.width, 10,40, 20);
    [addView addSubview:_yearLabel];
    
    return addView;
}
//移除自己
- (void)selfDisappear
{
    [self removeFromSuperview];
}
//选择类型取消按钮
- (void)cancleChooseTypeButtonAction:(UIButton *)btn
{
    [self selfDisappear];
}
//选择类型
- (void)typeButtonAction:(UIButton *)btn
{
    _isSelectYearBtn = YES;
    for (int i = 0; i<_categoryArry.count; i++)       
    {
        UIButton *btnFirst = [self viewWithTag:1000+i];
        btnFirst.selected = NO;
        btnFirst.layer.borderColor = colorWithLine.CGColor;
    }
    btn.selected = YES;
    btn.layer.borderColor = colorWithMainColor.CGColor;
    NSInteger selectNum = btn.tag -1000;
    
   
    _describeLabel.text = btn.titleLabel.text;
    _describeLabel.text = [NSString stringWithFormat:@"%@",_categoryArry[selectNum][@"name"]];
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_categoryArry[selectNum][@"img"]]] placeholderImage:YGDefaultImgSquare];
    _titleLabel.text = [NSString stringWithFormat:@"¥%@",_categoryArry[selectNum][@"price"]];

}

//加
- (void)addButtonAction:(UIButton *)btn
{
    //判断是否选择了按钮 不用每次都初始一遍按钮
    if (_isSelectYearBtn == YES) {
        for (int i = 0; i<2; i++)
        {
            UIButton *btnFirst = [self viewWithTag:1000+i];
            btnFirst.selected = NO;
            btnFirst.layer.borderColor = colorWithLine.CGColor;
        }
        _isSelectYearBtn = NO;
    }

//    NSString *year = [_yearLabel.text componentsSeparatedByString:@"年"][0];
//    if ([year intValue] == 10) {
//        [YGAppTool showToastWithText:@"可选年数达到上限"];
//        return ;
//    }
    _yearLabel.text = [NSString stringWithFormat:@"%d",[_yearLabel.text intValue]+1];
}

//减
- (void)subButtonAction:(UIButton *)btn
{
    if (_isSelectYearBtn == YES) {
        for (int i = 0; i<2; i++)
        {
            UIButton *btnFirst = [self viewWithTag:1000+i];
            btnFirst.selected = NO;
            btnFirst.layer.borderColor = colorWithLine.CGColor;
        }
        _isSelectYearBtn = NO;
    }
    
//    NSString *year = [_yearLabel.text componentsSeparatedByString:@"年"][0];
    if ([_yearLabel.text intValue] == 1) {
        [YGAppTool showToastWithText:@"不能再减了"];
        return ;
    }
    _yearLabel.text = [NSString stringWithFormat:@"%d",[_yearLabel.text intValue]-1];
    
}

//下一步按钮
- (void)nextStepButtonAction:(UIButton *)btn
{
    
    if (_yearLabel != nil ) //如果当前是选择年限的弹出框 创建了年限显示标签
    {
        NSMutableDictionary * dict  = [[NSMutableDictionary alloc]init];
        [dict setObject:_yearLabel.text forKey:@"count"];
        
        if ( [_yearLabel.text isEqualToString:@"1"]) //默认加减显示1年 就是没有使用加减按钮选择
        {
//            int yearOption = 2; //默认给2 如果是选了第一个 就是（半年） 0  选第二个就是（一年） 1
//            //判断半年和一年的按钮有没有选中的
//            for (int i = 0; i<2; i++)
//            {
//                UIButton *btnFirst = [self viewWithTag:1000+i];
//                if (btnFirst.selected == YES)
//                {
//                    yearOption = i;
//                    break;
//                }
//            }
//            if (yearOption == 2)
//            {
//                [YGAppTool showToastWithText:@"请选择年限"];
//                return ;
//            }
           
            //选了半年或者一年的传值
            [self.finacialAccountPopViewDelegate nextStepWithInfoDict:dict];

        }else
        {
            //用加减按钮选的值
            [self.finacialAccountPopViewDelegate nextStepWithInfoDict:dict];
        }

    }else
    {

        if ([_typeArray indexOfObject:_describeLabel.text] != NSNotFound) {
            
            NSInteger inde =[_typeArray indexOfObject:_describeLabel.text] ;
            NSMutableDictionary * dict =  _categoryArry[inde] ;
            [self.finacialAccountPopViewDelegate nextStepWithInfoDict:dict];
            
        }else{
            [YGAppTool showToastWithText:@"请选择对应的服务类别"];
            return ;
        }
    }

}
//输入信息取消按钮
- (void)cancleInputViewButtonAction:(UIButton *)btn
{
    [self.finacialAccountPopViewDelegate cancleAllPopViews];
}
//输入信息返回按钮
- (void)backButtonAction:(UIButton *)btn
{
    [self selfDisappear];   
}
//确认支付按钮
- (void)confirmPayButtonAction:(UIButton *)btn
{
    
    UITextField *nameTextfield = [self viewWithTag:100];
    UITextField *phoneTextfield = [self viewWithTag:101];
   
    if (nameTextfield.text.length == 0 || phoneTextfield.text.length == 0 ||_thirdView.text.length == 0 || _fourthView.text.length == 0) {
        [YGAppTool showToastWithText:@"请填写完整信息"];
        return ;
    }
    if ([YGAppTool isNotPhoneNumber:phoneTextfield.text]) {
        return;
    }
     
    [self.finacialAccountPopViewDelegate confirmPayWithInfoDict:@{@"userid":YGSingletonMarco.user.userId,@"contract":nameTextfield.text,@"phone":phoneTextfield.text,@"name":_thirdView.text,@"address":_fourthView.text}];
}


-(void)dealloc
{
    
}

@end
