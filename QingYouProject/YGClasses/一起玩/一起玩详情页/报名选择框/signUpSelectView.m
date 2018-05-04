//
//  SignUpSelectView.m
//  QingYouProject
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SignUpSelectView.h"
@interface SignUpSelectView ()<UITextFieldDelegate>
/** 移除遮盖Button  */
@property (nonatomic,strong) UIButton * coverButton;
/** 遮盖视图  */
@property (nonatomic,strong) UIView * coverView;
/** 头部视图  */
@property (nonatomic,strong) UIView * headerBackView;
@property (nonatomic,strong) UIView * addInformationHeaderView;

/** 数量 */
@property (nonatomic,strong) UILabel * selectCountLabel;
@property (nonatomic,strong) UILabel * surplusCountLabel;
@property (nonatomic,strong) UILabel * allPriceLabel;
@property (nonatomic,strong) UILabel * promptLabel;//提示
@property (nonatomic,strong) UIButton * nextButton;//下一步
@property (nonatomic,strong) UILabel * payallPriceLabel;
@property (nonatomic,strong) UIButton * payButton;//下一步


/** 商品价格  */
@property (nonatomic,strong) UILabel * goodsPriceLabel;

/** 商品数量加  */
@property (nonatomic,strong) UIButton * addbutton;
/** 商品数量减  */
@property (nonatomic,strong) UIButton * subtractionButton;

/** 单价  */
@property (nonatomic,strong) NSString * price;

@property (nonatomic,strong) UITextField * nameField;
@property (nonatomic,strong) UITextField * phoneField;

@property (nonatomic, assign) NSInteger beleftCount;
@property (nonatomic, assign) BOOL isFree;

@property (nonatomic, strong) NSArray *infoArray;
@end
@implementation SignUpSelectView

#pragma mark - 刷新商品信息,价格 名称,图片等信息
- (void)reloadHeaderDataPrice:(NSString *)price Image:(NSString *)imageName detailTitle:(NSString *)detailTitle{
    
    //修改数量
    NSString * countString = self.selectCountLabel.text;
    NSInteger countInteger = [countString integerValue];
    
    self.price = price;
    NSString * goodsPrice = [NSString stringWithFormat:@"合计 ￥%.2f",[self.price floatValue] * countInteger];
    self.allPriceLabel.attributedText = [goodsPrice ld_attributedStringFromNSString:goodsPrice startLocation:3 forwardFont:LDFont(13) backFont:LDFont(15) forwardColor:colorWithBlack backColor:kRedColor];
    //    self.goodsTitleLabel.text = detailTitle;
    
}

#pragma mark - 刷新 商品规格 数据
//- (void)reloadChooseGoodsFatherView:(NSArray *)titleArray tagArray:(NSArray *)tagArray withCommodityModel:(OfficePurchaseDetailCommodityModel *)Commoditymodel{
- (void)reloadChooseGoodsFatherView:(NSArray *)titleArray tagArray:(NSArray *)tagArray {
    
}
#pragma mark - 数量减 1 操作
- (void)subtractionButtonClick:(UIButton *)subtractionButton{
    
    NSString * countString = self.selectCountLabel.text;
    NSInteger countInteger = [countString integerValue];
    if (countInteger == 1) {
        [YGAppTool showToastWithText:@"至少选择一张"];
    }else{
        //修改价格 和 数量
        [self changePriceAdd:NO];
    }
}
#pragma mark - 数量加 1 操作

- (void)changePriceAdd:(BOOL)isAdd{
    
    //修改价格
    NSString * subString = [self.allPriceLabel.text substringFromIndex:4];

    CGFloat price = [subString floatValue];
    
    //修改数量
    NSString * countString = self.selectCountLabel.text;
    NSInteger countInteger = [countString integerValue];
    
    if (isAdd) {
        price = price + [self.price floatValue];
        
        countInteger += 1;
        
    }else{
        countInteger -= 1;
        
        price = price - [self.price floatValue];
    }
    NSString * goodsPrice = [NSString stringWithFormat:@"合计 ￥%.2f",price];
    self.allPriceLabel.attributedText = [goodsPrice ld_attributedStringFromNSString:goodsPrice startLocation:3 forwardFont:LDFont(13) backFont:LDFont(15) forwardColor:colorWithBlack backColor:kRedColor];
    
    
    self.selectCountLabel.text = [NSString stringWithFormat:@"%ld",(long)countInteger];
}
#pragma mark - 数量加 1 操作
- (void)addButtonClick:(UIButton *)addButton{
    
    NSString * countString = self.selectCountLabel.text;
    NSInteger countInteger = [countString integerValue];
    if (countInteger == self.beleftCount) {
         [YGAppTool showToastWithText:@"没有更多张数"];
    }else{
    //修改价格 和 数量
    [self changePriceAdd:YES];
    }
}


#pragma mark - UI搭建
- (void)setupUI{
    
    //注册键盘消失的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
    
    CGFloat H = YGNaviBarHeight + YGBottomMargin ;
    CGFloat headerBackViewY = kScreenH - 199 - H;
//    CGFloat headerBackViewY = kScreenH - 250  - YGNaviBarHeight - YGStatusBarHeight;

    //遮盖
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.coverView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
    [self addSubview:self.coverView];
    self.coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.coverButton.frame = CGRectMake(0, 0, kScreenW, headerBackViewY);
    [self.coverButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.coverButton];
    
    
    //头部视图
    self.headerBackView = [[UIView alloc] init];
    self.headerBackView.backgroundColor = kWhiteColor;
    [self addSubview:self.headerBackView];
    [self.headerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(headerBackViewY);
    }];
    
    UILabel  * select =[[UILabel alloc]init];
    select.text =@"请选择";
    select.font = [UIFont systemFontOfSize:18];
    select.textAlignment = NSTextAlignmentCenter;
    [self.headerBackView addSubview:select];
    [select mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(35);
        make.right.offset(-35);

        make.top.offset(5);
        make.height.offset(35);
    }];

    UIButton * deletBtn =[[UIButton alloc]init];
    [deletBtn setImage:[UIImage imageNamed:@"home_playtogrther_cancel"] forState:UIControlStateNormal];
    [deletBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];

    [self.headerBackView addSubview:deletBtn];
    [deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(0);
        make.top.offset(5);
        make.height.width.offset(35);
    }];
    
    UIView * gbView =[[UIView alloc]init];
    gbView.backgroundColor = colorWithTable;
    gbView.layer.masksToBounds = YES;
    gbView.layer.cornerRadius = 3;
    gbView.layer.borderWidth  = 1.0f;
    gbView.layer.borderColor  = colorWithLine.CGColor;
    [self.headerBackView addSubview:gbView];
    [gbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(-LDHPadding);
        make.top.equalTo(select.mas_bottom).offset(5);
        make.height.width.offset(40);

    }];
    
    UILabel * signup  =[UILabel new];
    signup.text =@"报名费";
    signup.textColor =colorWithBlack;
    signup.font =[UIFont systemFontOfSize:15];
    [gbView addSubview:signup];

    [signup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.top.bottom.offset(0);
        make.width.offset(140);
        
    }];
    
    
    self.goodsPriceLabel = [UILabel new];
    self.goodsPriceLabel.textAlignment =NSTextAlignmentRight;
    [gbView addSubview:self.goodsPriceLabel];
    [self.goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-LDHPadding);
        make.top.bottom.offset(0);
        make.left.equalTo(signup.mas_right).offset(LDHPadding);
    }];
    
    
    
        UILabel * countLabel  = [UILabel new];
        countLabel.text =@"选择数量";
        countLabel.font = LDFont(13);
        [self.headerBackView addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(LDHPadding);
            make.right.offset(-LDHPadding);
            make.top.equalTo(gbView.mas_bottom).offset(2*LDVPadding);
        }];
    
        UIButton * subtractionButton = [[UIButton alloc]init];
       [subtractionButton setImage:[UIImage imageNamed:@"popup_subtract_btn"] forState:UIControlStateNormal];
        [self.headerBackView addSubview:subtractionButton];
        [subtractionButton addTarget:self action:@selector(subtractionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [subtractionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(LDHPadding);
            make.height.width.offset(22);
            make.top.equalTo(countLabel.mas_bottom).offset(LDHPadding);

        }];
    
    self.selectCountLabel = [UILabel new];
    self.selectCountLabel.font = LDFont(15);
    self.selectCountLabel.textAlignment =NSTextAlignmentCenter;
    
    [self.headerBackView addSubview:self.selectCountLabel];
    [self.selectCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(subtractionButton.mas_right);
        make.width.offset(6*LDHPadding);
        make.top.equalTo(countLabel.mas_bottom).offset(LDVPadding +2);
    }];
    UIButton * plusButton = [[UIButton alloc]init];
    [plusButton setImage:[UIImage imageNamed:@"popup_plus_btn"] forState:UIControlStateNormal];
    [self.headerBackView addSubview:plusButton];
    [plusButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectCountLabel.mas_right).offset(0);
        make.height.width.offset(22);
        make.top.equalTo(countLabel.mas_bottom).offset(LDVPadding);

    }];
    
    self.surplusCountLabel = [UILabel new];
    self.surplusCountLabel.font = LDFont(13);
    self.surplusCountLabel.textAlignment = NSTextAlignmentLeft;
    self.surplusCountLabel.textColor = colorWithDeepGray;
    [self.headerBackView addSubview:self.surplusCountLabel];
    
    [self.surplusCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(plusButton.mas_right) .offset(LDHPadding);
        make.right.offset( -LDHPadding);
        make.bottom.equalTo(plusButton.mas_bottom).offset(-3);
    }];
    
    
    self.promptLabel = [UILabel new];
    self.promptLabel.font = LDFont(13);
    self.promptLabel.textColor = colorWithDeepGray;
    [self.headerBackView addSubview:self.promptLabel];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset( -LDHPadding);
        make.top.equalTo(self.selectCountLabel.mas_bottom).offset(2.5 * LDVPadding);
    }];
    
    UILabel * line =[UILabel new];
    line.backgroundColor = colorWithLine;
    [self.headerBackView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(self.promptLabel.mas_bottom).offset( LDVPadding);
    }];
    
    self.allPriceLabel = [UILabel new];
    self.allPriceLabel.font = LDFont(15);
    self.allPriceLabel.textAlignment = NSTextAlignmentLeft;
    self.allPriceLabel.textColor = colorWithDeepGray;
    [self.headerBackView addSubview:self.allPriceLabel];
    
    [self.allPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.width.offset( YGScreenWidth/2 - LDHPadding);
        make.height.offset(H);
        make.top.equalTo(line.mas_bottom).offset(0);
    }];
    
    self.nextButton = [[UIButton alloc]init];
    self.nextButton.backgroundColor = colorWithMainColor;
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.headerBackView addSubview:self.nextButton];
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.width.offset( YGScreenWidth/2);
        make.height.offset(H);
        make.top.equalTo(line.mas_bottom).offset(0);
        make.left.equalTo(self.allPriceLabel.mas_right).offset(0);
        make.bottom.equalTo(self.headerBackView.mas_bottom).offset(0);
    }];
    
}
-(void)reloadViewWithPrice:(NSString *)price withHour:(NSString *)hour withCount:(NSString *)count
{
    self.price = price;
    self.goodsPriceLabel.attributedText = [[NSString stringWithFormat:@"¥%@",price] ld_attributedStringFromNSString:[NSString stringWithFormat:@"¥%@",price] startLocation:1 forwardFont:LDFont(13) backFont:LDFont(17) forwardColor:colorWithOrangeColor backColor:colorWithOrangeColor];
    
    self.promptLabel.attributedText = [[NSString stringWithFormat:@"须知：活动开始前%@小时内不退报名费",hour] ld_attributedStringFromNSString:[NSString stringWithFormat:@"须知：活动开始前%@小时内不退报名费",hour] startLocation:[NSString stringWithFormat:@"须知：活动开始前%@小时内",hour].length forwardFont:LDFont(12) backFont:LDFont(12) forwardColor:colorWithDeepGray backColor:colorWithOrangeColor];
    
    self.beleftCount = [count integerValue];
    self.surplusCountLabel.text =[NSString stringWithFormat:@"剩余%ld张",(long)self.beleftCount];
    
    self.selectCountLabel.text =@"1";
    
    self.allPriceLabel.attributedText = [[NSString stringWithFormat:@"合计 ¥%@",price] ld_attributedStringFromNSString:[NSString stringWithFormat:@"合计 ¥%@",price] startLocation:3 forwardFont:LDFont(15) backFont:LDFont(16) forwardColor:colorWithBlack backColor:colorWithOrangeColor];
    
    //是否免费
    self.isFree = NO;
    
    if([price floatValue] <=0)
    {
         self.isFree = YES;
        self.promptLabel.hidden =YES;
    }
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self setupUI];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tagButtonClick:) name:@"" object:nil];
        
    }
    return self;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - 选择商品规格 确认按钮点击
- (void)nextButtonClick:(UIButton *)sureButton{
    NSString * countString = self.selectCountLabel.text;
    NSInteger countInteger = [countString integerValue];
    if (countInteger == 1) {
        [self.delegate SignUpSelectViewNextWay:sureButton withPersonNum:countInteger];
    }
    else
    {
        [self.delegate SignUpSelectViewNextWay:sureButton withPersonNum:countInteger];
    }

}
- (void)sureButtonClick:(UIButton *)sureButton{    
    
    UITextField *nameTextfield = [self viewWithTag:100];
    if(!nameTextfield.text.length)
    {
        [YGAppTool showToastWithText:@"姓名为必填项"];
        return;
    }
    
    if([YGAppTool isTooLong:nameTextfield.text maxLength:12 name:@"姓名"] ){
        return ;
    }
    
    UITextField *phoneTextfield = [self viewWithTag:101];
    if ([YGAppTool isNotPhoneNumber:phoneTextfield.text]) {
        return;
    }
    NSMutableArray * dataArray = [[NSMutableArray alloc]init];
   
    for(int i=2;i<self.infoArray.count;i++)
    {
        
        UITextField *textfield = [self viewWithTag:100 +i];
        
        NSString * isCheck = self.infoArray[i][@"isCheck"];
        if([isCheck isEqualToString:@"1"] && !textfield.text.length)
        {
            [YGAppTool showToastWithText:[NSString stringWithFormat:@"%@为必填项",self.infoArray[i][@"customName"]]];
            return;
        }
        NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
        [dataDict setObject:self.infoArray[i][@"customName"] forKey:@"name"];
        [dataDict setObject:textfield.text forKey:@"content"];

        [dataArray addObject:dataDict];
    }
    
    [self removeFromSuperview];

    //看后台需要传入什么类型 的值 ，再选择传过去的方式
    [self.delegate signUpSelectViewSurePayWay:sureButton withIsFree:self.isFree withName:nameTextfield.text withPhone:phoneTextfield.text withArray:dataArray];
}
-(void)pushOtherView
{
    [self removeFromSuperview];
}
-(void)signupInformationWithInfoArray:(NSArray *)infoArray
{
    self.infoArray =infoArray;
    
    self.headerBackView.hidden = YES;
    self.addInformationHeaderView.hidden = NO;
    if(self.addInformationHeaderView)
    {
        self.payallPriceLabel.attributedText =  self.allPriceLabel.attributedText;
        return;
    }

    CGFloat H = YGNaviBarHeight + YGBottomMargin ;
    CGFloat headerBackViewY = kScreenH - 235 - H;
    self.coverButton.frame = CGRectMake(0, 0, kScreenW, headerBackViewY);

    self.headerBackView.hidden = YES;
    
    //头部视图
    self.addInformationHeaderView = [[UIView alloc] init];
    self.addInformationHeaderView.backgroundColor = kWhiteColor;
    [self addSubview:self.addInformationHeaderView];
    [self.addInformationHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(headerBackViewY);
        make.height.offset(235 + H);
    }];
    
    UIButton * backBtn =[[UIButton alloc]init];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"back_black"]  forState:UIControlStateNormal];
    [self.addInformationHeaderView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.height.width.offset(45);
    }];
    
    UILabel  * select =[[UILabel alloc]init];
    select.text =@"填写报名信息";
    select.textAlignment = NSTextAlignmentCenter;
    [self.addInformationHeaderView addSubview:select];
    [select mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(45 );
        make.right.offset(-45);
        make.top.offset(0);
        make.height.offset(45);
    }];
    
    UIButton * deletBtn =[[UIButton alloc]init];
    [deletBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [deletBtn setTitle:@"取消" forState:UIControlStateNormal];
    [deletBtn setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    deletBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.addInformationHeaderView addSubview:deletBtn];
    [deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(0);
        make.top.offset(0);
        make.height.width.offset(45);
    }];
  
    for(int i=0;i< infoArray.count ;i++)
    {
        UILabel * lineOne = [[UILabel alloc]initWithFrame:CGRectMake(0, 45 + i*45, YGScreenWidth, 1)];
        lineOne.backgroundColor =colorWithLine;
        [self.addInformationHeaderView addSubview:lineOne];
        
        CGFloat comPlaceLabelW = [UILabel calculateWidthWithString:infoArray[i][@"customName"] textFont:leftFont numerOfLines:1].width;
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDHPadding, lineOne.y + lineOne.height, comPlaceLabelW, 45)];
        
        nameLabel.textColor =colorWithBlack;
        nameLabel.font =[UIFont systemFontOfSize:15];
        nameLabel.text = infoArray[i][@"customName"];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.addInformationHeaderView addSubview:nameLabel];
        
        self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.x + nameLabel.width, lineOne.y + lineOne.height, YGScreenWidth - comPlaceLabelW - 2*LDHPadding, 45)];
        self.nameField.textColor =colorWithBlack;
        self.nameField.font =[UIFont systemFontOfSize:15];
        self.nameField.placeholder = [NSString stringWithFormat:@"请输入%@",infoArray[i][@"customName"]];
        self.nameField.textAlignment = NSTextAlignmentRight;
        self.nameField.returnKeyType = UIReturnKeyDone;
        [self.addInformationHeaderView addSubview:self.nameField];
        self.nameField.delegate = self;
        self.nameField.tag = i +100;
        
    }
    
   
    UILabel * lineThree = [[UILabel alloc]initWithFrame:CGRectMake(0, self.nameField.y + self.nameField.height, YGScreenWidth, LDHPadding)];
    lineThree.backgroundColor =colorWithLine;
    [self.addInformationHeaderView addSubview:lineThree];

     if(infoArray.count < 4)
     {
         lineThree.height =1;
     }

    self.payallPriceLabel = [UILabel new];
    self.payallPriceLabel.font = LDFont(13);
    self.payallPriceLabel.textAlignment = NSTextAlignmentLeft;
    self.payallPriceLabel.textColor = colorWithDeepGray;
    [self.addInformationHeaderView addSubview:self.payallPriceLabel];
    
    [self.payallPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.width.offset( YGScreenWidth/2 - LDHPadding);
        make.height.offset(H);
        make.bottom.equalTo(self.addInformationHeaderView.mas_bottom).offset(0);

    }];
    
    self.payallPriceLabel.attributedText =  self.allPriceLabel.attributedText;
    
    self.payButton = [[UIButton alloc]init];
    self.payButton.backgroundColor = colorWithMainColor;
    [self.payButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [self.payButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addInformationHeaderView addSubview:self.payButton];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.width.offset( YGScreenWidth/2);
        make.height.offset(H);
        make.left.equalTo(self.allPriceLabel.mas_right).offset(0);
        make.bottom.equalTo(self.addInformationHeaderView.mas_bottom).offset(0);
    }];
    
    if(self.isFree)
        [self.payButton setTitle:@"立即报名" forState:UIControlStateNormal];
}

-(void)backClick
{
    self.headerBackView.hidden = NO;
    self.addInformationHeaderView.hidden = YES;

    for(int i=0;i<self.infoArray.count;i++)
    {
        UITextField * textField = [self  viewWithTag:100+i];
        [textField resignFirstResponder];
    }
//    [self keyboardWillBeHidden];
}

//-(void)keyboardWillBeHidden:(NSNotification*)aNotification
//{
//     [self.phoneField resignFirstResponder];
//     [self.nameField resignFirstResponder];
//    [self keyboardWillBeHidden];
//}
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
////    [self keyboardWasShown];
//    return YES;
//}
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
////    [self keyboardWillBeHidden];
//    return YES;
//}


//-(void)keyboardWasShown
//{
//    CGFloat H = YGNaviBarHeight + YGBottomMargin ;
//    CGFloat headerBackViewY = kScreenH - 235 - H;
//
//    [UIView animateWithDuration:0.2 animations:^{
//        [self.addInformationHeaderView  mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.offset(headerBackViewY - 400);
//        }];
//        [self layoutIfNeeded];
//
//    } completion:^(BOOL finished) {
//
//    }];
//}
//
//-(void)keyboardWillBeHidden
//{
//    CGFloat H = YGNaviBarHeight + YGBottomMargin ;
//    CGFloat headerBackViewY = kScreenH - 235 - H;
//
//    [UIView animateWithDuration:0.2 animations:^{
//        [self.addInformationHeaderView  mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.offset(headerBackViewY);
//        }];
//        [self layoutIfNeeded];
//    } completion:^(BOOL finished) {
//
//    }];
//}

@end

