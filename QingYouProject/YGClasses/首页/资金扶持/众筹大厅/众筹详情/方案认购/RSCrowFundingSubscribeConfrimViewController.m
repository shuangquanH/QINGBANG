//
//  RSCrowFundingSubscribeConfrimViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RSCrowFundingSubscribeConfrimViewController.h"
#import "YGCityPikerView1.h"
#import "ManageMailPostViewController.h"
#import "RoadShowHallCrowdFundingViewController.h"

@interface RSCrowFundingSubscribeConfrimViewController ()<ManageMailPostViewControllerDelegate>

@end

@implementation RSCrowFundingSubscribeConfrimViewController
{
    UIScrollView  *_mainScrollView;
    UILabel  *_countLabel;
    UITextField *_emailTextfield;
    UILabel *_addressShowLabel;
    NSString *_addressId;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}
- (void)configAttribute
{
    self.naviTitle = @"方案认购";
}
- (void)configUI
{
    self.view.backgroundColor = colorWithYGWhite;
    /********************* _scrollView ***************/
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - 64 - 45-YGBottomMargin)];
    _mainScrollView.backgroundColor = colorWithTable;
    _mainScrollView.contentSize = CGSizeMake(YGScreenWidth, _mainScrollView.height);
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.bounces = NO;
    [self.view addSubview:_mainScrollView];
    
    /********************* 上部分 ***************/

    UIView *headerTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
    headerTopView.backgroundColor = colorWithYGWhite;
    [_mainScrollView addSubview:headerTopView];
    
    UIView *headerLineTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, YGScreenWidth, 1)];
    headerLineTopView.backgroundColor = colorWithLine;
    [headerTopView addSubview:headerLineTopView];
    //收益权
    UILabel *incomesLabel = [[UILabel alloc] init];
    incomesLabel.textColor = colorWithBlack;
    incomesLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    incomesLabel.text = [NSString stringWithFormat:@"%@",_model.power];
    incomesLabel.frame = CGRectMake(10, 10, YGScreenWidth/2, 40);
    [headerTopView addSubview:incomesLabel];
    
      //价格
    UILabel *pricesLabel = [[UILabel alloc] init];
    pricesLabel.textColor = colorWithMainColor;
    pricesLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    pricesLabel.text = [NSString stringWithFormat:@"¥%@/份",_model.power];
    pricesLabel.textAlignment = NSTextAlignmentRight;
    pricesLabel.frame = CGRectMake(YGScreenWidth/2, 10, YGScreenWidth/2-10, 40);
    [headerTopView addSubview:pricesLabel];
      //收益权

    UILabel *limitPurchaseLabel = [[UILabel alloc] init];
    limitPurchaseLabel.textColor = colorWithDeepGray;
    limitPurchaseLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    limitPurchaseLabel.text = [NSString stringWithFormat:@"选择认购份数（限购%@份）",_model.forPurchasing];
    limitPurchaseLabel.frame = CGRectMake(10, headerLineTopView.y+10, YGScreenWidth/2, 40);
    [headerTopView addSubview:limitPurchaseLabel];
    
      //收益权
    UIView *addSubscribeCountView = [self createAddView];
    [headerTopView addSubview:addSubscribeCountView];
    addSubscribeCountView.centery = limitPurchaseLabel.centery;
    
    /********************* 中间部分 ***************/

    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.textColor = colorWithDeepGray;
    infoLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    infoLabel.text = @"联系信息";
    infoLabel.frame = CGRectMake(10, headerTopView.height, YGScreenWidth/2, 35);
    [_mainScrollView addSubview:infoLabel];
    
    UIView *headerMiddleView = [[UIView alloc] initWithFrame:CGRectMake(0,headerTopView.y+headerTopView.height+35, YGScreenWidth, 100)];
    headerMiddleView.backgroundColor = colorWithYGWhite;
    [_mainScrollView addSubview:headerMiddleView];
    
    UIView *headerLineMiddleView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, YGScreenWidth, 1)];
    headerLineMiddleView.backgroundColor = colorWithLine;
    [headerMiddleView addSubview:headerLineMiddleView];
    
     //地址
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.textColor = colorWithDeepGray;
    addressLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    addressLabel.text = @"地址";
    addressLabel.frame = CGRectMake(10, 10, 60, 40);
    [headerMiddleView addSubview:addressLabel];
    
    
    //地址
    _addressShowLabel = [[UILabel alloc] init];
    _addressShowLabel.textColor = colorWithDeepGray;
    _addressShowLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _addressShowLabel.text = @"请选择";
    _addressShowLabel.textAlignment = NSTextAlignmentRight;
    _addressShowLabel.frame = CGRectMake(YGScreenWidth-200, 10, 165, 40);
    [headerMiddleView addSubview:_addressShowLabel];
    
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YGScreenWidth-27, 10, 17, 17)];
    arrowImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    arrowImageView.clipsToBounds = YES;
    [arrowImageView sizeToFit];
    [headerMiddleView addSubview:arrowImageView];
    arrowImageView.centery = addressLabel.centery;
    
    UIButton *addressCoverButton = [[UIButton alloc]initWithFrame:CGRectMake(0,addressLabel.y,YGScreenWidth,40)];
    [addressCoverButton addTarget:self action:@selector(addressButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [headerMiddleView addSubview:addressCoverButton];
    
    
    //邮箱
    UILabel *emailLabel = [[UILabel alloc] init];
    emailLabel.textColor = colorWithDeepGray;
    emailLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    emailLabel.text = @"邮箱";
    emailLabel.frame = CGRectMake(addressLabel.x,headerLineMiddleView.y+10, 60, 40);
    [headerMiddleView addSubview:emailLabel];
    
    _emailTextfield = [[UITextField alloc] initWithFrame:CGRectMake(70, emailLabel.y, YGScreenWidth-90, 40)];
    _emailTextfield.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _emailTextfield.textColor = colorWithDeepGray;
    _emailTextfield.placeholder = @"请正确填写邮箱";
    _emailTextfield.textAlignment = NSTextAlignmentRight;
    [headerMiddleView addSubview:_emailTextfield];
    [_emailTextfield setValue:colorWithLightGray forKeyPath:@"_placeholderLabel.textColor"];
    /********************* 下面部分 ***************/

    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.textColor = colorWithDeepGray;
    noticeLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    noticeLabel.frame = CGRectMake(10, headerMiddleView.y+headerMiddleView.height, YGScreenWidth-20, 50);
    noticeLabel.numberOfLines = 0;
    [_mainScrollView addSubview:noticeLabel];
    NSMutableAttributedString *beleftAttributedText =  [[NSMutableAttributedString alloc] initWithString:@""];
    NSTextAttachment *beleftAttatchment = [[NSTextAttachment alloc] init];
    beleftAttatchment.image = [UIImage imageNamed:@"steward_capital_prompt"];
    beleftAttatchment.bounds = CGRectMake(-2, -3, beleftAttatchment.image.size.width, beleftAttatchment.image.size.height);
    [beleftAttributedText appendAttributedString:[NSAttributedString attributedStringWithAttachment:beleftAttatchment]];
    //字体颜色
    [beleftAttributedText appendAttributedString:[[NSAttributedString alloc]initWithString:@" 请正确填写收件人信息，以便给您发送投资协议等文件。" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:YGFontSizeSmallOne],NSForegroundColorAttributeName:colorWithDeepGray}]];
    noticeLabel.attributedText = beleftAttributedText;
  CGSize size = [noticeLabel.text boundingRectWithSize:CGSizeMake(YGScreenWidth -20, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:YGFontSizeSmallOne],NSForegroundColorAttributeName:colorWithDeepGray} context:nil].size;
    noticeLabel.frame = CGRectMake(10, headerMiddleView.y+headerMiddleView.height, YGScreenWidth-20, size.height+30);

    
    UIView *headerBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, headerMiddleView.y+headerMiddleView.height+50, YGScreenWidth, 50)];
    headerBottomView.backgroundColor = colorWithYGWhite;
    [_mainScrollView addSubview:headerBottomView];
    
    
    //冷静期说明
    UILabel *coolDescriptiontitleLabel = [[UILabel alloc] init];
    coolDescriptiontitleLabel.textColor = colorWithBlack;
    coolDescriptiontitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    coolDescriptiontitleLabel.text = @"冷静期说明";
    coolDescriptiontitleLabel.frame = CGRectMake(10, 10, YGScreenWidth-20, 40);
    [headerBottomView addSubview:coolDescriptiontitleLabel];
    
    //冷静期说明内容
    UILabel *coolDescriptionLabel = [[UILabel alloc] init];
    coolDescriptionLabel.textColor = colorWithDeepGray;
    coolDescriptionLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    coolDescriptionLabel.text = [NSString stringWithFormat:@"温馨提示：%@",self.coolTimeDescription];
//    @"温馨提示：根据青邦资金扶持规则，一旦提交当前您认购的投资份额，系统将自动启动认购冷静期，为期48小时，您可以在此时间内随时取消您的认购计划。若超过48小时后，您未作出任何异议操作，系统将默认您的投资计划生效，敬请知悉！";
    coolDescriptionLabel.frame = CGRectMake(10, coolDescriptiontitleLabel.y+coolDescriptiontitleLabel.height, YGScreenWidth-20, 40);
    coolDescriptionLabel.numberOfLines = 0;
    [headerBottomView addSubview:coolDescriptionLabel];
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:coolDescriptionLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [coolDescriptionLabel.text length])];
    NSDictionary *attribute =@{NSFontAttributeName:coolDescriptionLabel.font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:colorWithDeepGray};
    //attributedText设置后之前设置的都失效
    CGSize size1 = [coolDescriptionLabel.text boundingRectWithSize:CGSizeMake(YGScreenWidth -20, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    coolDescriptionLabel.frame = CGRectMake(10, coolDescriptiontitleLabel.y+coolDescriptiontitleLabel.height, YGScreenWidth -20, size1.height+20);
    coolDescriptionLabel.attributedText = attributedString;
    
    headerBottomView.frame = CGRectMake(0, headerMiddleView.y+headerMiddleView.height+50, YGScreenWidth, 50+coolDescriptionLabel.height);
    
    _mainScrollView.contentSize = CGSizeMake(YGScreenWidth, headerBottomView.height+headerBottomView.y);

    /****************************** 按钮 **************************/
    UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
    coverButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
    [coverButton addTarget:self action:@selector(confirmToSuscribeAction:) forControlEvents:UIControlEventTouchUpInside];
    coverButton.backgroundColor = colorWithMainColor;
    coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [self.view addSubview:coverButton];
    [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [coverButton setTitle:@"认购" forState:UIControlStateNormal];
    
}
- (UIView *)createAddView
{
    
    UIImage *image = [UIImage imageNamed:@"popup_plus_btn"];
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(YGScreenWidth-120, 0, 120, 40)];
//    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(YGScreenWidth+(40-image.size.width)/2-120, 0, 120, 40)];

    //加
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(addView.width-40,0,40,40)];
    [addButton setImage:[UIImage imageNamed:@"popup_plus_btn"] forState:UIControlStateNormal];
    addButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    addButton.imageView.clipsToBounds = YES;
    [addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:addButton];
    
    //减
    UIButton *subButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [subButton setImage:[UIImage imageNamed:@"popup_subtract_btn"] forState:UIControlStateNormal];
    subButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    subButton.imageView.clipsToBounds = YES;
    [subButton addTarget:self action:@selector(subButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:subButton];
    
    //新鲜事标题label
    _countLabel = [[UILabel alloc]init];
    _countLabel.textColor = colorWithBlack;
    _countLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    _countLabel.text = @"1";
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.frame = CGRectMake(subButton.width, 10,40, 20);
    [addView addSubview:_countLabel];
    
    return addView;
}

//加
- (void)addButtonAction:(UIButton *)btn
{
    //判断是否选择了按钮 不用每次都初始一遍按钮

    if ([_countLabel.text intValue] == [_model.forPurchasing intValue]) {
        [YGAppTool showToastWithText:@"可选份数达到上限"];
        return ;
    }
    if ([_countLabel.text intValue] == [_model.leftCopies intValue]) {
        [YGAppTool showToastWithText:@"剩余份数达到上限"];
        return ;
    }
    _countLabel.text = [NSString stringWithFormat:@"%d",[_countLabel.text intValue]+1];
}

//减
- (void)subButtonAction:(UIButton *)btn
{
   
    if ([_countLabel.text intValue] == 1) {
        [YGAppTool showToastWithText:@"最少认购一份"];
        return ;
    }
    _countLabel.text = [NSString stringWithFormat:@"%d",[_countLabel.text intValue]-1];
    
}
- (void)confirmToSuscribeAction:(UIButton *)btn
{
    if ([_countLabel.text intValue] > [_model.leftCopies intValue])
    {
        [YGAppTool showToastWithText:@"剩余的份数不够选了"];
        return;
    }
    if ([_addressShowLabel.text isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请选择地址"];
        return;
    }
    
    if ([YGAppTool isNotEmail:_emailTextfield.text]) {
        return;
    }
    [self startPostWithURLString:REQUEST_gaddSubscribeScheme parameters:@{@"subCount":_countLabel.text,@"uId":YGSingletonMarco.user.userId,@"address":_addressId,@"email":_emailTextfield.text,@"projectId":self.projectID,@"subId":_model.id,} showLoadingView:NO scrollView:nil];

}

- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    [YGAppTool showToastWithText:@"认购成功"];
    UINavigationController *navc = self.navigationController;
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (UIViewController *vc in [navc viewControllers]) {
        [viewControllers addObject:vc];
        if ([vc isKindOfClass:[RoadShowHallCrowdFundingViewController class]]) {
            ((RoadShowHallCrowdFundingViewController *)vc).IsSubscribed = YES;
            break;
        }
    }
    [navc setViewControllers:viewControllers];
    
//    NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
}

- (void)addressButtonAction
{
//    //城市选择
//    YGCityPikerView1 *cityPikerView1 = [YGCityPikerView1 showWithHandler:^(NSString *province, NSString *city)
//                                        {
//                                            _addressShowLabel.text = [NSString stringWithFormat:@"%@ %@", province, city];
//                                        }];
//    if (_addressShowLabel.text == nil)
//    {
//        [cityPikerView1 selectProvince:[_addressShowLabel.text componentsSeparatedByString:@" "][0] city:[_addressShowLabel.text componentsSeparatedByString:@" "][1]];
//
//    }
    ManageMailPostViewController *vc = [[ManageMailPostViewController alloc] init];
    vc.shippingAddressViewControllerdelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)passModel:(ManageMailPostModel *)model
{
    _addressShowLabel.text = [NSString stringWithFormat:@"%@ %@",model.prov,model.city];
    _addressId = model.ID;
    
}
@end
