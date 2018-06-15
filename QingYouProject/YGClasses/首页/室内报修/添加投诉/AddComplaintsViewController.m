//
//  AddComplaintsViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AddComplaintsViewController.h"
#import "LDTextView.h"//换行TextView
#import "PlaceholderAndNoticeTextView.h"
#import "YGActionSheetView.h"

@interface AddComplaintsViewController ()
/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;


/** 所在园区  */
@property (nonatomic,strong) UITextField * parkLabelName;
@property (nonatomic,strong) NSString * parkLabelValue;

/** 联系人  */
@property (nonatomic,strong) UITextField * contactName;
/** 联系电话  */
@property (nonatomic,strong) UITextField * contactPhone;
/** 企业/个人名称  */
@property (nonatomic,strong) LDTextView * comName;
/** 企业地址  */
@property (nonatomic,strong) LDTextView * comPlace;
/** 添加留言  */
@property (nonatomic,strong) PlaceholderAndNoticeTextView * addMessage;
@property (nonatomic, strong)  UIButton * parkLabelNameCoverButton;
@end

@implementation AddComplaintsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"添加投诉";
    
    //设置导航栏
    [self setupNav];
    //设置UI视图
    [self setupUI];
//    //网络请求
//    [self sendRequest];
}
#pragma mark - 设置导航栏
- (void)setupNav{
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem backItemWithimage:nil highImage:nil target:self action:@selector(rightBarButtonClick:) title:@"发布" normalColor:LDMainColor highColor:LDMainColor titleFont:LDFont(14)];
}


#pragma mark - 导航栏右侧按钮点击
- (void)rightBarButtonClick:(UIButton *)rightBarButton{
    
        if(!self.parkLabelName.text.length)
        {
            [YGAppTool showToastWithText:@"请选择所在园区"];
            return;
        }
    
       if (!self.contactName.text.length) {
            [YGAppTool showToastWithText:@"请输入联系人姓名"];
            return;
        }

       if (!self.contactPhone.text.length) {
            [YGAppTool showToastWithText:@"请输入真实电话"];
            return;
       }
        if ([YGAppTool isNotPhoneNumber:self.contactPhone.text])
      {
            [YGAppTool showToastWithText:@"请输入正确的电话号码！"];
            return;
       }
    
        if (!self.comName.text.length) {
            [YGAppTool showToastWithText:@"请选择输入企业名称"];
            return;
        }
        if (!self.comPlace.text.length) {
            [YGAppTool showToastWithText:@"请输入准确地址"];
            return;
        }

        if (!self.addMessage.text.length) {
            [YGAppTool showToastWithText:@"请输入留言描述"];
            return;
        }

        if (self.addMessage.text.length >200) {
            [YGAppTool showToastWithText:@"留言描述最多可输入200字"];
           return;
       }
    
    [YGNetService YGPOST:@"AddComplain" parameters:@{@"userId":YGSingletonMarco.user.userId,@"firmName":self.comName.text,@"garden":self.parkLabelValue,@"name":self.contactName.text,@"phone":self.contactPhone.text,@"message":self.addMessage.text,@"repairAddress":self.comPlace.text} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        [YGAppTool showToastWithText:@"您的投诉已成功提交"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        WaitReplyModel * model = [[WaitReplyModel alloc]init];
        model.ID = responseObject[@"id"];
        model.message = self.addMessage.text;
        model.createDate = responseObject[@"createDate"];

        [self.delegate addComplaintsViewController:self didClickSaveButtonWithModel:model];

            } failure:^(NSError *error) {
                NSLog(@"提交失败");
            }];
    
}

#pragma mark - 设置UI视图
- (void)setupUI{
    
    //背景scrollowView
    UIScrollView * backScrollowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - YGNaviBarHeight - YGStatusBarHeight)];
    [self.view addSubview:backScrollowView];
    self.backScrollowView = backScrollowView;
    self.backScrollowView.backgroundColor = LDEFPaddingColor;
    
    //容器视图
    UIView * container = [[UIView alloc] init];
    [self.backScrollowView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
        make.width.equalTo(backScrollowView);
    }];
    
    
    //申请信息
    UIView * applyView = [UIView new];
    [container addSubview:applyView];
    [applyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(0);
        make.bottom.equalTo(container.mas_bottom).offset(0);
        
    }];
    
    
    UILabel * applyInfo = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding, 0, kScreenW - 2 * LDHPadding, LDVPadding)];
    [applyView addSubview:applyInfo];
    
    //所在园区
    UILabel * parkLabel = [UILabel new];
    [applyView addSubview:parkLabel];
    CGFloat parkLabelW = [UILabel calculateWidthWithString:@"所在园区" textFont:leftFont numerOfLines:1].width;
    parkLabel.font = leftFont;
    [parkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(parkLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(applyInfo.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
    
    self.parkLabelName = [UITextField new];
    
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 17, 17)];
    UIImageView * image = [[UIImageView alloc] initWithFrame:rightView.frame];
    [rightView addSubview:image];
    image.image = LDImage(@"go_gray");
    self.parkLabelName.rightView = rightView;
    self.parkLabelName.rightViewMode = UITextFieldViewModeAlways;
    self.parkLabelName.userInteractionEnabled = NO;
    self.parkLabelName.textAlignment = NSTextAlignmentRight;
    [applyView addSubview:self.parkLabelName];
    [self.parkLabelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parkLabel.mas_right).offset(5);
        make.top.bottom.equalTo(parkLabel);
        make.right.offset(-LDHPadding);
    }];
    
    //所在园区点击事件
    self.parkLabelNameCoverButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:nil selectedTitle:nil normalTitleColor:nil selectedTitleColor:nil backGroundColor:kClearColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:0];
    
    self.parkLabelNameCoverButton.frame = CGRectMake(parkLabelW + 5 + LDHPadding, parkLabel.ld_y + 10, kScreenW - (CGRectGetMaxX(parkLabel.frame) + 5 + LDHPadding), 50);
    [applyView addSubview:self.parkLabelNameCoverButton];
    [self.parkLabelNameCoverButton addTarget:self action:@selector(parkLabelNameCoverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * lineOne = [UIView new];
    [applyView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(parkLabel.mas_bottom);
        
    }];
    
    //联系人
    UILabel * contactLabel = [UILabel new];
    [applyView addSubview:contactLabel];
    CGFloat contactLabelW = [UILabel calculateWidthWithString:@"联系人" textFont:leftFont numerOfLines:1].width;
    contactLabel.font = leftFont;
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(contactLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineOne.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
    
    self.contactName = [UITextField new];
    self.contactName.textAlignment = NSTextAlignmentRight;
    [applyView addSubview:self.contactName];
    [self.contactName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactLabel.mas_right).offset(5);
        make.top.bottom.equalTo(contactLabel);
        make.right.offset(-LDHPadding);
    }];
    UIView * lineThree = [UIView new];
    [applyView addSubview:lineThree];
    [lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(contactLabel.mas_bottom);
    }];
    
    //联系电话
    UILabel * contactPhoneLabel = [UILabel new];
    [applyView addSubview:contactPhoneLabel];
    CGFloat contactPhoneLabelW = [UILabel calculateWidthWithString:@"联系电话" textFont:leftFont numerOfLines:1].width;
    contactPhoneLabel.font = leftFont;
    [contactPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(contactPhoneLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineThree.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
    
    self.contactPhone = [UITextField new];
    self.contactPhone.textAlignment = NSTextAlignmentRight;
    [applyView addSubview:self.contactPhone];
    [self.contactPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactLabel.mas_right).offset(5);
        make.top.bottom.equalTo(contactPhoneLabel);
        make.right.offset(-LDHPadding);
    }];
    
    UIView * lineFour = [UIView new];
    [applyView addSubview:lineFour];
    [lineFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(contactPhoneLabel.mas_bottom);
    }];
    
    //企业/个人名称
    UILabel * comLabel = [UILabel new];
    [applyView addSubview:comLabel];
    CGFloat comLabelW = [UILabel calculateWidthWithString:@"企业/个人名称" textFont:leftFont numerOfLines:1].width;
    comLabel.font = leftFont;
    
    [comLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(comLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineFour.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
    
    self.comName = [[LDTextView alloc] initWithFrame:CGRectMake(comLabelW + LDHPadding + 5, 244 + 7, kScreenW - (comLabelW + 2 * LDHPadding + 5), 50)];
    self.comName.maxNumberOfLines = 40;
    
    self.comName.textAlignment = NSTextAlignmentRight;
    [applyView addSubview:self.comName];
    
    
    [self.comName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.comName.ld_width);
        make.right.offset(-LDHPadding);
        make.top.equalTo(comLabel.mas_top).offset(8);
        make.height.offset(self.comName.ld_height -16 );
    }];
    
    __weak typeof(self) weakSelf = self;
    
    [self.comName textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        
        CGRect frame = weakSelf.comName.frame;
        frame.size.height = textHeight;
        
        [weakSelf.comName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(textHeight);
            
        }];
        [weakSelf.view layoutIfNeeded];
        
    }];
    
    
    
    UIView * lineFive = [UIView new];
    [applyView addSubview:lineFive];
    [lineFive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(self.comName.mas_bottom).offset(8);
    }];
    
    //企业地址
    UILabel * comPlaceLabel = [UILabel new];
    [container addSubview:comPlaceLabel];
    CGFloat comPlaceLabelW = [UILabel calculateWidthWithString:@"企业地址" textFont:leftFont numerOfLines:1].width;
    comPlaceLabel.font = leftFont;
    
    [comPlaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(comPlaceLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineFive.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
    
    self.comPlace = [[LDTextView alloc] initWithFrame:CGRectMake(comLabelW + LDHPadding + 5, 295 + 12, kScreenW - (comLabelW + 2 * LDHPadding + 5), 50)];
    self.comPlace.textAlignment = NSTextAlignmentRight;
    self.comPlace.maxNumberOfLines = 4;
    [applyView addSubview:self.comPlace];
    
    [self.comPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.comPlace.ld_width);
        make.right.offset(-LDHPadding);
        make.top.equalTo(comPlaceLabel.mas_top).offset(8);
        make.height.offset(self.comName.ld_height -16);
    }];
    
    
    [self.comPlace textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        
        CGRect frame = weakSelf.comPlace.frame;
        frame.size.height = textHeight;
        [weakSelf.comPlace mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(textHeight);
            
        }];
        [weakSelf.view layoutIfNeeded];
    }];
    
 
    UIView * lineSix = [UIView new];
    [applyView addSubview:lineSix];
    [lineSix mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(LDVPadding / 2);
        make.top.equalTo(self.comPlace.mas_bottom).offset(8);
    }];
    
    //添加留言
    self.addMessage = [[PlaceholderAndNoticeTextView alloc] initWithFrame:CGRectMake(0, 295 + 12 + 5, kScreenW, 150)];
    self.addMessage.font = [UIFont systemFontOfSize:16];
    self.addMessage.textAlignment = NSTextAlignmentLeft;
    [applyView addSubview:self.addMessage];
    
    [self.addMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScreenW);
        make.right.offset(0);
     make.left.offset(0); make.top.equalTo(lineSix.mas_bottom).offset(0);
        make.height.offset(100);
//        make.bottom.equalTo(applyView.mas_bottom);

    }];
    
    //底部提示条
    UIView * bottomView = [[UIView alloc] init];
//    bottomView.backgroundColor = kBlueColor;
    [applyView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.addMessage.mas_bottom).offset(0);
        make.height.offset(40);
    }];

    UILabel * noticeLabel = [UILabel ld_labelWithTextColor:LD9ATextColor textAlignment:NSTextAlignmentRight font:LDFont(12) numberOfLines:1];
    
    noticeLabel.frame = CGRectMake(0, 0, kScreenW - LDVPadding, 40);
    noticeLabel.text = @"在此留言";
    [bottomView addSubview:noticeLabel];
    noticeLabel.hidden = YES;
    
    
    if (iphoneX) {
        
        if (@available(iOS 11.0, *)) {
            
            backScrollowView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
        } else {
            // Fallback on earlier versions
        }

    }

    lineThree.backgroundColor = LDEEPaddingColor;
    lineFour.backgroundColor = LDEEPaddingColor;
    lineOne.backgroundColor = LDEEPaddingColor;
    lineFive.backgroundColor = LDEEPaddingColor;
    lineSix.backgroundColor = LDEEPaddingColor;
    
    self.comPlace.font = leftFont;
    self.comName.font = leftFont;
//    self.comName.placeholderColor = LD9ATextColor;
//    self.comPlace.placeholderColor = LD9ATextColor;
    self.addMessage.placeholder = @"在此留言";
    
    parkLabel.text = @"所在园区";
    contactLabel.text = @"联系人";
    contactPhoneLabel.text = @"联系电话";
    comLabel.text = @"企业/个人名称";
    comPlaceLabel.text = @"企业地址";
    
    applyInfo.textColor = LD16TextColor;
    backScrollowView.backgroundColor = LDEFPaddingColor;
    container.backgroundColor = kWhiteColor;
    
    parkLabel.textColor = colorWithDeepGray;
    contactLabel.textColor = colorWithDeepGray;
    contactPhoneLabel.textColor = colorWithDeepGray;
    comLabel.textColor = colorWithDeepGray;
    comPlaceLabel.textColor = colorWithDeepGray;

    applyInfo.font = LD15Font;
    self.parkLabelName.font = leftFont;
    self.contactName.font = leftFont;
    self.contactPhone.font = leftFont;
    
    self.parkLabelName.placeholder = @"请选择";
    self.contactName.placeholder = @"请输入名字";
    self.contactPhone.placeholder = @"请填写真实电话";
    self.comName.placeholder = @"请填写企业/个人名称";
    self.comPlace.placeholder = @"请填写详细地址";
    
    
    
}
#pragma mark - 所在园区点击事件
- (void)parkLabelNameCoverButtonClick:(UIButton *)parkLabelNameCoverButton{
    
    [self.parkLabelNameCoverButton setEnabled:NO];
    [YGNetService YGPOST:@"ChooseGarden" parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        NSArray *listArray = [NSArray array];
        listArray = [responseObject valueForKey:@"list"];
        NSMutableArray *showMutableArray = [NSMutableArray array];
        for (int i = 0; i < listArray.count; i++) {
            [showMutableArray addObject:[listArray[i] valueForKey:@"label"]];
        }
        
        [YGActionSheetView showAlertWithTitlesArray:showMutableArray handler:^(NSInteger selectedIndex, NSString *selectedString) {
            self.parkLabelName.text = selectedString;
            self.parkLabelValue = listArray[selectedIndex][@"value"];
        }];
        [self.parkLabelNameCoverButton setEnabled:YES];

    } failure:^(NSError *error) {
        [self.parkLabelNameCoverButton setEnabled:YES];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    
    LDLogFunc
}
@end
