//
//  OrderDetailListViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/27.
//  Copyright © 2017年 ccyouge. All rights reserved.


#import "OrderDetailListViewController.h"
#import "LDTextView.h"//换行TextView
#import "OrderDeatilBottomPictureView.h"//底部图片展示CollectionView
#import "OrderDetailModel.h"


//刷新LDTextView数据
#define  ReloadLDTextViewData @"ReloadLDTextViewData"
#define LDManagerBannerImage @"1" //轮播图占位图
#define Banner_W_H_Scale 2   //轮播图比例
#define LDHPadding  10.0
#define LDVPadding  10.0
#define kScreenWidthRatio  (kScreenW / 414.0)
#define kScreenHeightRatio (kScreenH / 736.0)
#define AdaptedWidth(x)  floorf((x) * kScreenWidthRatio)
#define AdaptedHeight(x) floorf((x) * kScreenHeightRatio)
#define AdaptedFont(x)     [UIFont systemFontOfSize:AdaptedWidth(x)]




@interface OrderDetailListViewController ()<UITextViewDelegate>
/** 图片底部CollectionView  */
@property (nonatomic,strong) OrderDeatilBottomPictureView * bottomPictureView;
/** 图片描述  */
@property (nonatomic,strong) UIView * pictureView;
/** 留言描述  */
@property (nonatomic,strong) UILabel * messageDetailLabel;
/** 服务工单状态  */
@property (nonatomic,strong) UILabel * orderStatus;
@property (nonatomic,strong) UILabel * orderStatusDetailOne;
@property (nonatomic,strong) LDTextView * orderStatusDetailTwo;

/** 服务工单号  */
@property (nonatomic,strong) UILabel * orderNumber;
/** 下单时间  */
@property (nonatomic,strong) UILabel * orderTime;
/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** 所在园区  */
@property (nonatomic,strong) UITextField * parkLabelName;
/** 联系人  */
@property (nonatomic,strong) UITextField * contactName;
/** 联系电话  */
@property (nonatomic,strong) UITextField * contactPhone;
/** 企业/个人名称  */
@property (nonatomic,strong) LDTextView * comName;
/** 企业地址  */
@property (nonatomic,strong) LDTextView * comPlace;
/** 底部悬浮视图 : 处理中,已处理  */
@property (nonatomic,strong) UIView * bottomBaseView;

@property (nonatomic,strong) OrderDetailModel * model;


@property (nonatomic, strong) UIView * bgView;//背景
@property (nonatomic, strong) UIView * baseView;//白色背景
@property (nonatomic, strong) UITextView * reasonTextView;//白色背景
@property (nonatomic, strong) NSMutableArray *indoorPicture;
@end

@implementation OrderDetailListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviTitle = @"我的工单";
    if([self.isPush isEqualToString:@"My"])
       self.naviTitle = @"维修单";

    //设置导航栏
    //[self setupNav];
    //设置UI视图
//    [self setupUI];
    //网络请求
    [self sendRequest];
    
}
#pragma mark - 设置导航栏
- (void)setupNav{
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [self createBarbuttonWithNormalTitleString:@"提交" selectedTitleString:@"提交" selector:@selector(rightBarButtonClick:)];
    
}
#pragma mark - 导航栏右侧按钮点击
- (void)rightBarButtonClick:(UIButton *)rightBarButton{
    
    [YGAppTool showToastWithText:@"提交"];
}

#pragma mark - 网络请求数据
- (void)sendRequest{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"id"] = [NSString stringWithFormat:@"%@",self.IndoorId];

    [YGNetService YGPOST:@"SearchIndoorDetail" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        //字典转模型
        self.model = [OrderDetailModel mj_objectWithKeyValues:responseObject[@"snapshotData"]];
        
        self.indoorPicture = responseObject[@"indoorPicture"];
        
         [self setupUI];
        
        self.bottomPictureView.dataArray = responseObject[@"indoorPicture"];
    
        if(self.model.cause.length >0)
        {
            self.orderStatusDetailOne.text = [NSString stringWithFormat:@"您的工单未处理！%@",self.model.completedTime];
            self.orderStatusDetailTwo.text = [NSString stringWithFormat:@"未处理原因：%@",self.model.cause];
        }
        else
        {
            self.orderStatusDetailOne.text = [NSString stringWithFormat:@"您的工单正在处理中！%@",self.model.processTime];
            self.orderStatusDetailTwo.text = [NSString stringWithFormat:@"您的工单已经处理完！：%@",self.model.completedTime];
        }
        
        self.messageDetailLabel.text = self.model.indoorMessage;
        NSString * workState = [NSString stringWithFormat:@"%@",self.model.workState];
        self.orderStatus.text = @"服务工单状态: 待处理";
        if([workState isEqualToString:@"3"] ||[workState isEqualToString:@"4"] )
        {
            if(self.model.cause.length >0)
                self.orderStatus.text = @"服务工单状态: 未处理";
            else
                self.orderStatus.text = @"服务工单状态: 已处理";
        }

        self.orderNumber.text = [NSString stringWithFormat:@"服务工单号: %@",self.model.workNumber];
        self.orderTime.text =[NSString stringWithFormat:@"下单时间: %@",self.model.createDate];
        self.parkLabelName.text = [NSString stringWithFormat:@" %@",self.model.garden];
        self.contactName.text = self.model.indoorName;
        self.contactPhone.text = self.model.indoorPhone;
        self.comName.text = self.model.firmName;
        self.comPlace.text = self.model.repairAddress;        
        
        [YGNetService dissmissLoadingView];
    } failure:^(NSError *error) {
        
        LDLog(@"%@",error);
    }];
}

#pragma mark - 设置UI视图
- (void)setupUI{
    
    //背景scrollowView
    UIScrollView * backScrollowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - YGNaviBarHeight - YGStatusBarHeight - 45)];
    [self.view addSubview:backScrollowView];
    self.backScrollowView = backScrollowView;
    
    //容器视图
    UIView * container = [[UIView alloc] init];
    [self.backScrollowView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
        make.width.equalTo(backScrollowView);
    }];
    
    
    //订单状态
    self.orderStatusDetailOne = [UILabel labelWithFont:13 textColor:LD9ATextColor textAlignment:NSTextAlignmentLeft];
    [container addSubview:self.orderStatusDetailOne];
    
    [self.orderStatusDetailOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(-LDHPadding);
        make.top.offset(15);
        make.height.offset(15);
    }];
    
//    self.comPlace = [[LDTextView alloc] initWithFrame:CGRectMake(comLabelW + LDHPadding + 5, 295 + 12, kScreenW - (comLabelW + 2 * LDHPadding + 5), 3 * LDVPadding)];

    
    self.orderStatusDetailTwo = [[LDTextView alloc] initWithFrame:CGRectMake(LDHPadding , self.orderStatusDetailOne.y + self.orderStatusDetailOne.height, kScreenW - 2 * LDHPadding, 32)];
    self.orderStatusDetailTwo.font = LDFont(13);
    self.orderStatusDetailTwo.maxNumberOfLines = 40;

    self.orderStatusDetailTwo.textAlignment = NSTextAlignmentLeft;
    [container addSubview:self.orderStatusDetailTwo];
    
    
    [self.orderStatusDetailTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.orderStatusDetailTwo.width);
        make.left.offset(LDHPadding -5);
//        make.right.offset(-LDHPadding);
        make.top.equalTo(self.orderStatusDetailOne.mas_bottom).offset(5);
        make.height.offset(32);
    }];
    
    __weak typeof(self) weakSelf = self;
    
    [self.orderStatusDetailTwo textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        
        CGRect frame = weakSelf.orderStatusDetailTwo.frame;
        frame.size.height = textHeight;
        
        [weakSelf.orderStatusDetailTwo mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(textHeight);
        }];
        [weakSelf.view layoutIfNeeded];
    }];
    UIView * lineStateTop = [UIView new];
    [container addSubview:lineStateTop];
    lineStateTop.backgroundColor = LDEFPaddingColor;


    
    self.orderStatusDetailOne.hidden = YES;
    self.orderStatusDetailTwo.hidden = YES;

    
    switch (self.state) {
        case 0://我的物业报修 - 待服务
            {
                //顶部分割线
                lineStateTop.hidden = YES;
                [lineStateTop mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.offset(0);
                    make.height.offset(1);
                }];
            }
            break;
        case 1://我的物业报修 - 处理中
        {
            self.orderStatusDetailOne.hidden = NO;

            //顶部分割线
            [lineStateTop mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.left.right.offset(0);
                 make.height.offset(1);
                 make.top.equalTo(self.orderStatusDetailOne.mas_bottom).offset(5);
            }];
        }
            break;
        case 2://我的物业报修 - 已结单
        {
            self.orderStatusDetailOne.hidden = NO;
            self.orderStatusDetailTwo.hidden = NO;
            //顶部分割线
            [lineStateTop mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.left.right.offset(0);
                 make.height.offset(1);
                 make.top.equalTo(self.orderStatusDetailTwo.mas_bottom).offset(5);
            }];
        }
            break;
        case 3://我的工单 - 待处理
        {
            //顶部分割线
            lineStateTop.hidden = YES;
            [lineStateTop mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.offset(0);
                make.height.offset(1);
            }];
        }
            break;
        case 4://我的工单 - 已处理
        {
            if([self.noDeal isEqualToString:@"noDeal"])
            {
                self.orderStatusDetailOne.hidden = NO;
                self.orderStatusDetailTwo.hidden = NO;
                //顶部分割线
                [lineStateTop mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.offset(0);
                    make.height.offset(1);
                    make.top.equalTo(self.orderStatusDetailTwo.mas_bottom).offset(5);
                }];
                break;
            }
            //顶部分割线
            lineStateTop.hidden = YES;
            [lineStateTop mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.offset(0);
                make.height.offset(1);
            }];
        }
            break;
        default:
            break;
    }

    self.orderStatusDetailOne.textColor = colorWithLightGray;
    self.orderStatusDetailTwo.textColor = colorWithLightGray;

    //订单状态
    self.orderStatus = [UILabel labelWithFont:14 textColor:LD9ATextColor textAlignment:NSTextAlignmentLeft];
    [container addSubview:self.orderStatus];
    
    [self.orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(-LDHPadding);
//        make.top.offset(15);
        make.top.equalTo(lineStateTop.mas_bottom).offset(15);
        make.height.offset(15);
    }];
    //订单号
    self.orderNumber = [UILabel labelWithFont:14 textColor:LD9ATextColor textAlignment:NSTextAlignmentLeft];
    [container addSubview:self.orderNumber];
    [self.orderNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(-LDHPadding);
        make.top.equalTo(self.orderStatus.mas_bottom).offset(LDVPadding);
        make.height.offset(15);
    }];
    //订单时间
    self.orderTime = [UILabel labelWithFont:14 textColor:LD9ATextColor textAlignment:NSTextAlignmentLeft];
    [container addSubview:self.orderTime];
    
    [self.orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(-LDHPadding);
   make.top.equalTo(self.orderNumber.mas_bottom).offset(LDVPadding);
        
        make.height.offset(15);
    }];
    
    
    //顶部分割线
    UIView * lineTop = [UIView new];
    lineTop.backgroundColor = LDEFPaddingColor;
    [container addSubview:lineTop];
    [lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(self.orderTime.mas_bottom).offset(15);
    }];
    
    //申请信息
    UIView * applyView = [UIView new];
    [container addSubview:applyView];
    [applyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(lineTop.mas_bottom).offset(0);
        make.bottom.equalTo(container.mas_bottom).offset(0);
        
    }];
    
    
//    UILabel * applyInfo = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding, 0, kScreenW - 2 * LDHPadding, LDVPadding)];
    UILabel * applyInfo = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding, 0, kScreenW - 2 * LDHPadding, 1)];
    [applyView addSubview:applyInfo];
    
    //所在园区
    UILabel * parkLabel = [UILabel new];
    [applyView addSubview:parkLabel];
    CGFloat parkLabelW = [UILabel calculateWidthWithString:@"所在园区:" textFont:leftFont numerOfLines:1].width;
    parkLabel.font = leftFont;
    [parkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(parkLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(applyInfo.mas_bottom);
        make.height.offset(3 * LDVPadding);
    }];
    
    self.parkLabelName = [UITextField new];
    
    self.parkLabelName.userInteractionEnabled = NO;
    self.parkLabelName.textAlignment = NSTextAlignmentLeft;
    [applyView addSubview:self.parkLabelName];
    [self.parkLabelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parkLabel.mas_right).offset(5);
        make.top.bottom.equalTo(parkLabel);
        make.right.offset(-LDHPadding);
    }];
    
    UIView * lineOne = [UIView new];
    [applyView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(parkLabel.mas_bottom);
    }];
    lineOne.hidden =YES;
    
    
    //企业/个人名称
    UILabel * comLabel = [UILabel new];
    [applyView addSubview:comLabel];
    CGFloat comLabelW = [UILabel calculateWidthWithString:@"企业名称:" textFont:leftFont numerOfLines:1].width;
    comLabel.font = leftFont;
    
    [comLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(comLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineOne.mas_bottom);
        make.height.offset(3 * LDVPadding);
    }];
    
    self.comName = [[LDTextView alloc] initWithFrame:CGRectMake(comLabelW + LDHPadding + 5, 244 + 7, kScreenW - (comLabelW + 2 * LDHPadding + 5), 3 * LDVPadding)];
    self.comName.maxNumberOfLines = 40;
    
    self.comName.textAlignment = NSTextAlignmentLeft;
    [applyView addSubview:self.comName];
    
    
    [self.comName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.comName.width);
        make.right.offset(-LDHPadding);
        make.top.equalTo(comLabel.mas_top).offset(0);
        make.height.offset(self.comName.height);
    }];
    
//    __weak typeof(self) weakSelf = self;
    
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
        make.top.equalTo(self.comName.mas_bottom);
    }];
    lineFive.hidden =YES;
    //企业地址
    UILabel * comPlaceLabel = [UILabel new];
    [container addSubview:comPlaceLabel];
    CGFloat comPlaceLabelW = [UILabel calculateWidthWithString:@"报修地址:" textFont:leftFont numerOfLines:1].width;
    comPlaceLabel.font = leftFont;
//    comPlaceLabel.backgroundColor =[UIColor cyanColor];
    [comPlaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(comPlaceLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineFive.mas_bottom);
        make.height.offset(3 * LDVPadding);
    }];
    
    self.comPlace = [[LDTextView alloc] initWithFrame:CGRectMake(comLabelW + LDHPadding + 5, 295 + 12, kScreenW - (comLabelW + 2 * LDHPadding + 5), 3 * LDVPadding)];
    self.comPlace.textAlignment = NSTextAlignmentLeft;
    self.comPlace.maxNumberOfLines = 4;
    [applyView addSubview:self.comPlace];
    
//    self.comPlace.backgroundColor =[UIColor cyanColor];
    
    [self.comPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.comPlace.width);
        make.right.offset(-LDHPadding);
        make.top.equalTo(comPlaceLabel.mas_top).offset(0);
        make.height.offset(self.comName.height);
    }];
    
    
    [self.comPlace textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        
        CGRect frame = weakSelf.comPlace.frame;
        frame.size.height = textHeight;
        [weakSelf.comPlace mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(textHeight);
            
        }];
        [weakSelf.view layoutIfNeeded];
    }];

    UIView * lineFour = [UIView new];
    [applyView addSubview:lineFour];
    [lineFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(self.comPlace.mas_bottom);
    }];
    lineFour.hidden =YES;

    //联系人
    UILabel * contactLabel = [UILabel new];
    [applyView addSubview:contactLabel];
    CGFloat contactLabelW = [UILabel calculateWidthWithString:@"联系人:" textFont:leftFont numerOfLines:1].width;
    contactLabel.font = leftFont;
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(contactLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineFour.mas_bottom);
        make.height.offset(3 * LDVPadding);
    }];
    
    self.contactName = [UITextField new];
    self.contactName.textAlignment = NSTextAlignmentLeft;
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
    lineThree.hidden =YES;
    
    //联系电话
    UILabel * contactPhoneLabel = [UILabel new];
    [applyView addSubview:contactPhoneLabel];
    CGFloat contactPhoneLabelW = [UILabel calculateWidthWithString:@"联系人电话:" textFont:leftFont numerOfLines:1].width;
    contactPhoneLabel.font = leftFont;
    [contactPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(contactPhoneLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineThree.mas_bottom);
        make.height.offset(3 * LDVPadding);
    }];
    
    self.contactPhone = [UITextField new];
    self.contactPhone.textAlignment = NSTextAlignmentLeft;
    [applyView addSubview:self.contactPhone];
    [self.contactPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactPhoneLabel.mas_right).offset(5);
        make.top.bottom.equalTo(contactPhoneLabel);
        make.right.offset(-LDHPadding);
    }];
    
    UIView * lineSix = [UIView new];
    [applyView addSubview:lineSix];
    [lineSix mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(self.contactPhone.mas_bottom);
    }];
    
    //留言描述
    UILabel * messageLabel = [UILabel labelWithFont:14 textColor:LD9ATextColor textAlignment:NSTextAlignmentLeft];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.top.equalTo(lineSix.mas_bottom).offset(LDVPadding);
        make.right.offset(-LDHPadding);
        make.height.offset(15);
        //make.bottom.equalTo(applyView.mas_bottom);

    }];
    
    //留言具体内容
    
    self.messageDetailLabel = [UILabel labelWithFont:14 textColor:kBlackColor textAlignment:NSTextAlignmentLeft];
    
    [applyView addSubview:self.messageDetailLabel];
    [self.messageDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.top.equalTo(messageLabel.mas_bottom).offset(LDVPadding);
        make.right.offset(-LDHPadding);
        
    }];
    

    int height= 0;
    if (self.indoorPicture.count >2)
    {
        int count = (self.indoorPicture.count <= 3)?1:((self.indoorPicture.count <=6)?2:3);
        height = 30 + 105 * count +  (count -1)*10;
    }
    else
    {
        height = 155;
    }
    
    //图片描述
    self.bottomPictureView = [[OrderDeatilBottomPictureView alloc] initWithFrame:CGRectMake(0, 200, kScreenW, height)];

    [applyView addSubview:self.bottomPictureView];
    [self.bottomPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.messageDetailLabel.mas_bottom).offset(0);
        make.height.offset(height);
        make.bottom.equalTo(applyView.mas_bottom).offset(-100);

    }];
    

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
    
    messageLabel.text = @"留言描述: ";
    parkLabel.text = @"所在园区:";
    contactLabel.text = @"联系人:";
    contactPhoneLabel.text = @"联系人电话:";
    comLabel.text = @"企业名称:";
    comPlaceLabel.text = @"报修地址:";
    
    applyInfo.textColor = LD16TextColor;
    backScrollowView.backgroundColor = kWhiteColor;
    container.backgroundColor = kWhiteColor;
    
    applyInfo.font = LD15Font;
    self.parkLabelName.font = leftFont;
    self.contactName.font = leftFont;
    self.contactPhone.font = leftFont;
    
//    self.parkLabelName.placeholder = @"请选择";
//    self.contactName.placeholder = @"请输入名字";
//    self.contactPhone.placeholder = @"请填写真实电话";
//    self.comName.placeholder = @"请填写企业/个人名称";
//    self.comPlace.placeholder = @"请填写详细地址";
    
    //停止交互
    self.parkLabelName.userInteractionEnabled = NO;
    self.contactName.userInteractionEnabled = NO;
    self.contactPhone.userInteractionEnabled = NO;
    self.comName.userInteractionEnabled = NO;
    self.comPlace.userInteractionEnabled = NO;


    UIView * footerView =[[UIView alloc]initWithFrame:CGRectMake(0,kScreenH - YGNaviBarHeight - YGStatusBarHeight - 45, YGScreenWidth, 45)];
    [self.view addSubview:footerView];
    
    UIButton * handleIngBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, footerView.width/2, footerView.height)];
    [handleIngBtn setTitle:@"处理中" forState:UIControlStateNormal];
    [handleIngBtn setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [footerView addSubview:handleIngBtn];
    [handleIngBtn addTarget:self action:@selector(handleIngBtnClcik) forControlEvents:UIControlEventTouchUpInside];

    UIButton * AlreadyhandleBtn = [[UIButton alloc]initWithFrame:CGRectMake(footerView.width/2, 0, footerView.width/2, footerView.height)];
    [AlreadyhandleBtn setTitle:@"已处理" forState:UIControlStateNormal];
    [AlreadyhandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:AlreadyhandleBtn];
    AlreadyhandleBtn.backgroundColor = colorWithMainColor;
    [AlreadyhandleBtn addTarget:self action:@selector(AlreadyhandleBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.state != 3)
    {
        footerView.hidden =YES;
        backScrollowView.frame = CGRectMake(0, 0, kScreenW, kScreenH - YGNaviBarHeight - YGStatusBarHeight );
    }
    
}
//处理中
-(void)handleIngBtnClcik
{
    _bgView= [UIView new];
    _bgView.frame = [UIScreen mainScreen].bounds;
    
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [YGAppDelegate.window addSubview:_bgView];
    
    //白色
    _baseView= [[UIView alloc] initWithFrame:CGRectMake(30, (YGScreenHeight- 150)/2, YGScreenWidth - 60, 150)];
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.layer.masksToBounds = YES;
    _baseView.layer.cornerRadius = 5;
    _baseView.clipsToBounds = YES;
    [_bgView addSubview:_baseView];
    
    _reasonTextView =[[UITextView alloc]initWithFrame:CGRectMake(0, 0, _baseView.width, _baseView.height - 40)];
    [_baseView addSubview:_reasonTextView];
    _reasonTextView.scrollEnabled=YES;
    _reasonTextView.delegate=self;
    _reasonTextView.textColor=[UIColor lightGrayColor];//设置提示内容颜色
    _reasonTextView.text=NSLocalizedString(@"请填写未处理原因", nil);//提示语
    _reasonTextView.selectedRange=NSMakeRange(0,0) ;//光标起始位置
    _reasonTextView.keyboardType=UIKeyboardTypeDefault;
    
    
    UILabel * lineOne =[[UILabel alloc]initWithFrame:CGRectMake(0, _reasonTextView.y + _reasonTextView.height , _reasonTextView.width, 0.5)];
    lineOne.backgroundColor = colorWithLine;
    [_baseView addSubview:lineOne];
    
    NSArray * buttonTitlesArray = @[@"取消",@"确定"];
    NSArray * buttonColorsArray= @[colorWithBlack,colorWithMainColor];
    //按钮
    for (int i = 0; i < buttonTitlesArray.count; i++)
    {
        //按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_baseView.width / buttonTitlesArray.count * i, _reasonTextView.y + _reasonTextView.height, _baseView.width / buttonTitlesArray.count, 40)];
        [button setTitle:buttonTitlesArray[i] forState:UIControlStateNormal];
        [button setTitleColor:buttonColorsArray[i] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_baseView addSubview:button];
    }
    
    UILabel * lineTwo =[[UILabel alloc]initWithFrame:CGRectMake(_baseView.width /2  , _baseView.height - 40 , 0.5, 40)];
    lineTwo.backgroundColor = colorWithLine;
    [_baseView addSubview:lineTwo];
    
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (textView.textColor==[UIColor lightGrayColor])//如果是提示内容，光标放置开始位置
    {
        NSRange range;
        range.location = 0;
        range.length = 0;
        textView.selectedRange = range;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if (![text isEqualToString:@""]&&textView.textColor==[UIColor lightGrayColor])//如果不是delete响应,当前是提示信息，修改其属性
    {
        textView.text=@"";//置空
        textView.textColor=[UIColor blackColor];
    }
    
    if ([text isEqualToString:@"n"])//回车事件
    {
        if ([textView.text isEqualToString:@""])//如果直接回车，显示提示内容
        {
            textView.textColor=[UIColor lightGrayColor];
            textView.text=NSLocalizedString(@"请填写未处理原因", nil);
        }
        [textView resignFirstResponder];//隐藏键盘
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.textColor=[UIColor lightGrayColor];
        textView.text=NSLocalizedString(@"请填写未处理原因", nil);
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    [self keyboardWasShown];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
{
    [self keyboardWillBeHidden];
    [textView resignFirstResponder];
    return YES;
}
-(void)keyboardWasShown
{
    [UIView animateWithDuration:0.2 animations:^{
        _baseView.frame = CGRectMake(30,(YGScreenHeight- 150)/2 - 100, YGScreenWidth - 60, 150);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardWillBeHidden
{
    [UIView animateWithDuration:0.2 animations:^{
        _baseView.frame = CGRectMake(30,(YGScreenHeight- 150)/2, YGScreenWidth - 60, 150);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)buttonClick:(UIButton *)btn
{
    if(btn.tag == 101)
    {
        if (!_reasonTextView.text.length || [_reasonTextView.text isEqualToString:@"请填写未处理原因"]) {
            [YGAppTool showToastWithText:@"请填写未处理原因"];
            return;
        }
        
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        dict[@"workNumber"] = self.workNumber;
        dict[@"cause"] = _reasonTextView.text;
        dict[@"workId"] = YGSingletonMarco.user.userId;
        
        [YGNetService YGPOST:@"Acknowledgment" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
            
            [YGAppTool showToastWithText:@"提交成功"];
            [self.delegate orderDetailListViewControllerDealedWithRow:self.row];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            LDLog(@"%@",error);
            [YGAppTool showToastWithText:@"提交失败"];
        }];
        
    }
    [_bgView removeFromSuperview];
    
}
//已处理
-(void)AlreadyhandleBtnClcik
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"id"] = [NSString stringWithFormat:@"%@",self.IndoorId];

    [YGNetService YGPOST:@"CompleteOrder" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        [YGAppTool showToastWithText:@"已处理提交成功"];
        [self.delegate orderDetailListViewControllerDealedWithRow:self.row];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        LDLog(@"%@",error);
        [YGAppTool showToastWithText:@"已处理提交失败"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    
    LDLogFunc
}

- (UIView *)bottomBaseView{
    if (!_bottomBaseView) {
        
        CGFloat Y = kScreenH - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight - YGBottomMargin;

        CGRect rect = CGRectMake(0, Y, kScreenW, YGNaviBarHeight + YGBottomMargin);
        
        _bottomBaseView = [[UIView alloc] initWithFrame:rect];
    }
    return _bottomBaseView;
}

@end
