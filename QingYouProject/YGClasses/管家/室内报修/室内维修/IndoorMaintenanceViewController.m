//
//  IndoorMaintenanceViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//室内维修

#import "IndoorMaintenanceViewController.h"
#import "LDTextView.h"//换行TextView

#import "TZImagePickerController.h"//添加图片
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "FileMD5Hash.h"
#import "AESCrypt.h"
#import "QiniuSDK.h"
#import "UploadImageTool.h"
#import "YGActionSheetView.h"
#import "AreaSelectViewController.h"

#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PlaceholderAndNoticeTextView.h"

@interface IndoorMaintenanceViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,CLLocationManagerDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
//    UIScrollView *_scrollView;
    UIView *_whiteView;
    UILabel *_tipLabel; //图片最多9张哦
    
    CGFloat _itemWH;
    CGFloat _margin;
    CGFloat _whiteViewHeight;
    
    NSMutableArray *_tokenArray;
    UIButton * _parkLabelNameCoverButton;
    
}
@property (nonatomic, strong) UICollectionView *collectionView;

/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/**applyView  */
@property (nonatomic,strong) UIView * applyView;

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
/** 留言描述  */
@property (nonatomic,strong) PlaceholderAndNoticeTextView * leaveMessage;
/** 请在此留言  */
@property (nonatomic,strong) UILabel    * leaveMessageLabel;
@property (nonatomic,strong) UILabel    * companyCity;

@property (nonatomic,strong ) CLLocationManager *locationManager;//定位服务
@property (nonatomic,copy)    NSString *currentCity;//城市
@end

@implementation IndoorMaintenanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"室内维修";
    
    //设置导航栏
    [self setupNav];
    //设置UI视图
    [self setupUI];
    //网络请求
//    [self sendRequest];
    
    [self locatemap];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IndoorMaintenanceView:) name:@"IndoorMaintenanceView" object:nil];
    
}
- (void)IndoorMaintenanceView:(NSNotification *)notifit {
    NSString * addressStr =[notifit object];
    self.companyCity.text = addressStr;
}

#pragma mark - 设置导航栏
- (void)setupNav{
    
//    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem backItemWithimage:nil highImage:nil target:self action:@selector(rightBarButtonClick:) title:@"提交" normalColor:LDMainColor highColor:LDMainColor titleFont:LDFont(14)];
}
#pragma mark - 导航栏右侧按钮点击
- (void)rightBarButtonClick:(UIButton *)rightBarButton{
    
    if(!self.parkLabelName.text.length)
    {
        [YGAppTool showToastWithText:@"请选择所在园区"];
        return;
    }
    
    if (!self.comName.text.length) {
        [YGAppTool showToastWithText:@"请选择输入企业名称"];
        return;
    }
    if (!self.companyCity.text.length) {
        [YGAppTool showToastWithText:@"请选择地址"];
        return;
    }
    if (!self.comPlace.text.length) {
        [YGAppTool showToastWithText:@"请输入准确地址"];
        return;
    }
    if (!self.contactName.text.length) {
        [YGAppTool showToastWithText:@"请输入姓名"];
        return;
    }
    if (!self.contactPhone.text.length) {
        [YGAppTool showToastWithText:@"请输入真实电话"];
        return;
    }

    if ([YGAppTool isNotPhoneNumber:self.contactPhone.text])
        return;
    
    if (!self.leaveMessage.text.length) {
        [YGAppTool showToastWithText:@"请输入留言描述"];
        return;
    }
    if (_selectedPhotos.count == 0)
    {
        [YGAppTool showToastWithText:@"请至少选择一张图片上传哦"];
        return;
    }
    
    [UploadImageTool uploadImages:_selectedPhotos progress:^(CGFloat progress) {
        
    } success:^(NSArray *urlArray) {

        NSString * urlStr = @"";
        for(int i=0;i<urlArray.count;i++)
        {
            if(i==0)
                urlStr = urlArray[i];
            else
                urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@",%@",urlArray[i]]];
        }

        NSString * address = [NSString stringWithFormat:@"%@%@",self.companyCity.text,self.comPlace.text];
        [YGNetService YGPOST:@"AddIndoorDetail" parameters:@{@"userId":YGSingletonMarco.user.userId,@"firmName":self.comName.text,@"garden":self.parkLabelValue,@"repairAddress":address,@"indoorName":self.contactName.text,@"indoorPhone":self.contactPhone.text,@"indoorMessage":self.leaveMessage.text,@"indoorPicture":urlStr} showLoadingView:YES scrollView:nil success:^(id responseObject) {

            [YGAppTool showToastWithText:@"您的维修申请已成功提交\n等待维修工处理"];
     
            [self.navigationController popViewControllerAnimated:YES];

        } failure:^(NSError *error) {
            NSLog(@"提交失败");
        }];
        
        
    } failure:^{
        NSLog(@"传图失败");
    }];
}

#pragma mark - 设置UI视图
- (void)setupUI{
    
    //背景scrollowView
    UIScrollView * backScrollowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - YGNaviBarHeight - YGStatusBarHeight)];
    [self.view addSubview:backScrollowView];
    self.backScrollowView = backScrollowView;

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
    self.applyView =applyView;
    
    [applyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(0);
        make.bottom.equalTo(container.mas_bottom).offset(0);
        make.height.offset(kScreenH * 1.5);
    }];
    
    self.backScrollowView.contentSize = CGSizeMake(YGScreenWidth, kScreenH);
    
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
    image.image = LDImage(@"unfold_btn_gray");
    self.parkLabelName.rightView = rightView;
    self.parkLabelName.rightViewMode = UITextFieldViewModeAlways;
    self.parkLabelName.userInteractionEnabled = YES;
    self.parkLabelName.textAlignment = NSTextAlignmentRight;
    self.parkLabelName.enabled = NO;
    [applyView addSubview:self.parkLabelName];
    [self.parkLabelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parkLabel.mas_right).offset(5);
        make.top.bottom.equalTo(parkLabel);
        make.right.offset(-LDHPadding);
    }];
    
    //所在园区点击事件
    _parkLabelNameCoverButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:nil selectedTitle:nil normalTitleColor:nil selectedTitleColor:nil backGroundColor:kClearColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:0];
    
    _parkLabelNameCoverButton.frame = CGRectMake(parkLabelW + 5 + LDHPadding, parkLabel.ld_y + 10, kScreenW - (CGRectGetMaxX(parkLabel.frame) + 5 + LDHPadding), 50);
    [applyView addSubview:_parkLabelNameCoverButton];
    [_parkLabelNameCoverButton addTarget:self action:@selector(parkLabelNameCoverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * lineOne = [UIView new];
    [applyView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(parkLabel.mas_bottom);
        
    }];
    //***
    
    //企业/个人名称
    UILabel * comLabel = [UILabel new];
    [applyView addSubview:comLabel];
    CGFloat comLabelW = [UILabel calculateWidthWithString:@"企业名称" textFont:leftFont numerOfLines:1].width;
    comLabel.font = leftFont;
    
    [comLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(comLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineOne.mas_bottom);
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
        make.height.offset(self.comName.ld_height - 16);
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
    [applyView addSubview:comPlaceLabel];
    CGFloat comPlaceLabelW = [UILabel calculateWidthWithString:@"报修地址" textFont:leftFont numerOfLines:1].width;
    comPlaceLabel.font = leftFont;
    
    [comPlaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(comPlaceLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineFive.mas_bottom);
        make.height.offset(5 * LDVPadding);
    }];
    
    self.companyCity = [UILabel new];
    [applyView addSubview:self.companyCity];
    [self.companyCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScreenW - (comLabelW + 2 * LDHPadding + 5));
        make.right.offset(-LDHPadding);
        make.top.equalTo(comPlaceLabel.mas_top).offset(7);
        make.height.offset(50 - 16);
    }];
    
    self.companyCity.textAlignment = NSTextAlignmentRight;
    

    UIButton * companyCityButton = [[UIButton alloc]init];
    [applyView addSubview:companyCityButton];

    [companyCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScreenW - (comLabelW + 2 * LDHPadding + 5));
        make.right.offset(-LDHPadding);
        make.top.equalTo(comPlaceLabel.mas_top).offset(7);
        make.height.offset(50);
    }];
    [companyCityButton addTarget:self action:@selector(companyCityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * lineNew = [UIView new];
    [applyView addSubview:lineNew];
    lineNew.backgroundColor = colorWithLine;
    [lineNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(self.companyCity.mas_bottom).offset(8);;
    }];
    
    self.comPlace = [[LDTextView alloc] initWithFrame:CGRectMake(comLabelW + LDHPadding + 5, 295 + 12, kScreenW - (comLabelW + 2 * LDHPadding + 5), 50)];
    self.comPlace.textAlignment = NSTextAlignmentRight;
    self.comPlace.maxNumberOfLines = 4;
    [applyView addSubview:self.comPlace];
    
    [self.comPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.comPlace.ld_width);
        make.right.offset(-LDHPadding);
        make.top.equalTo(lineNew.mas_bottom).offset(8);
        make.height.offset(self.comName.ld_height - 16);
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
        make.top.equalTo(self.comPlace.mas_bottom).offset(8);
    }];

    
    //联系人
    UILabel * contactLabel = [UILabel new];
    [applyView addSubview:contactLabel];
    CGFloat contactLabelW = [UILabel calculateWidthWithString:@"联系人" textFont:leftFont numerOfLines:1].width;
    contactLabel.font = leftFont;
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(contactLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineFour.mas_bottom);
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
    
    UIView * lineSix = [UIView new];
    [applyView addSubview:lineSix];
    [lineSix mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(LDVPadding);
        make.top.equalTo(self.contactPhone.mas_bottom);
    }];
    
    //留言描述
    UILabel * messageLabel = [UILabel new];
    [applyView addSubview:messageLabel];
    CGFloat messageLabelW = [UILabel calculateWidthWithString:@"留言描述：" textFont:leftFont numerOfLines:1].width;
    messageLabel.font = leftFont;
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(messageLabelW);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineSix.mas_bottom);
        make.height.offset(3.5 * LDVPadding);
    }];
    
    self.leaveMessage = [[PlaceholderAndNoticeTextView alloc] initWithFrame:CGRectMake(LDHPadding, 0, kScreenW - 2 * LDHPadding , 80)];
    self.leaveMessage.textAlignment = NSTextAlignmentLeft;
    self.leaveMessage.font = [UIFont systemFontOfSize:16];

    [applyView addSubview:self.leaveMessage];
    self.leaveMessage.placeholder =@"请在此留言";

    [self.leaveMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.leaveMessage.ld_width);
        make.right.offset(-LDHPadding);
        make.top.equalTo(messageLabel.mas_bottom);
        make.height.offset(self.leaveMessage.ld_height);
    }];
    
    
    [self.leaveMessage textValueDidChanged:^(NSString *text, CGFloat textHeight) {

        CGRect frame = weakSelf.leaveMessage.frame;
        frame.size.height = textHeight;
        [weakSelf.leaveMessage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(textHeight);

        }];
        [weakSelf.view layoutIfNeeded];
//        if(text.length ==0)
//            self.leaveMessageLabel.hidden = NO;
//        else
//            self.leaveMessageLabel.hidden = YES;
    }];
    
    //"请在此留言
    self.leaveMessageLabel = [UILabel new];
    [applyView addSubview:self.leaveMessageLabel];
    CGFloat leavemessageLabelW = [UILabel calculateWidthWithString:@"请在此留言" textFont:leftFont numerOfLines:1].width;
    self.leaveMessageLabel.font = leftFont;
    [self.leaveMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(leavemessageLabelW);
        make.right.offset(-LDHPadding);
        make.top.equalTo(self.leaveMessage.mas_bottom);
        make.height.offset(3 * LDVPadding);
//        make.bottom.equalTo(applyView.mas_bottom);

    }];
        self.leaveMessageLabel.hidden = YES;

    
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
    
    self.companyCity.font = leftFont;
    
    parkLabel.text = @"所在园区";
    contactLabel.text = @"联系人";
    contactPhoneLabel.text = @"联系电话";
    comLabel.text = @"企业名称";
    comPlaceLabel.text = @"报修地址";
    messageLabel.text = @"留言描述：";
    self.leaveMessageLabel.text =@"请在此留言";
    
    parkLabel.textColor =colorWithDeepGray;
    contactLabel.textColor =colorWithDeepGray;
    contactPhoneLabel.textColor =colorWithDeepGray;
    comLabel.textColor =colorWithDeepGray;
    messageLabel.textColor =colorWithDeepGray;
    comPlaceLabel.textColor =colorWithDeepGray;

    applyInfo.textColor = LD16TextColor;
    backScrollowView.backgroundColor = kWhiteColor;
    container.backgroundColor = kWhiteColor;
    self.leaveMessageLabel.textColor = kLightGrayColor;
    
    applyInfo.font = LD15Font;
    self.parkLabelName.font = leftFont;
    self.contactName.font = leftFont;
    self.contactPhone.font = leftFont;
    self.leaveMessageLabel.font = leftFont;
   
    messageLabel.font =LD15Font;
    
    self.parkLabelName.placeholder = @"请选择所在园区";
    self.contactName.placeholder = @"请输入姓名";
    self.contactPhone.placeholder = @"请输入真实电话";
    self.comName.placeholder = @"请输入企业名称";
    self.comPlace.placeholder = @"请输入准确地址";
    

    //添加图片
    _whiteView = [UIView new];
    [applyView addSubview:_whiteView];

    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(YGScreenWidth);
        make.left.right.offset(0);
        make.top.equalTo(self.leaveMessageLabel.mas_bottom);
        make.height.offset((YGScreenWidth - 2 * 4 - 4) / 3 - 4);
//        make.bottom.equalTo(applyView.mas_bottom);
    }];
    

    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (YGScreenWidth - 2 * _margin - 4) / 3 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    
    //collectionView
 
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - 64) collectionViewLayout:layout];
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor clearColor];

    _collectionView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    [applyView addSubview:_collectionView];
    
    _whiteViewHeight = layout.headerReferenceSize.height + layout.itemSize.height + 30;
    _whiteView.height = _whiteViewHeight;
    _collectionView.height = _whiteViewHeight;
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(YGScreenWidth);
        make.left.right.offset(0);
        make.top.equalTo(self.leaveMessageLabel.mas_bottom);
        make.height.offset(_whiteViewHeight);
    }];
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake((YGScreenWidth - 40) / 3 + 20, _whiteView.height - 54, 120, 14)];
    _tipLabel.text = @"图片最多9张哦";
    _tipLabel.hidden = NO;
    _tipLabel.font = [UIFont systemFontOfSize:14.0];
    _tipLabel.textAlignment = NSTextAlignmentLeft;
    _tipLabel.textColor = colorWithLightGray;
    _tipLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [_whiteView addSubview:_tipLabel];
    
}
//发送状态
#pragma mark - 所在园区点击事件
- (void)parkLabelNameCoverButtonClick:(UIButton *)parkLabelNameCoverButton{
    
    [_parkLabelNameCoverButton  setEnabled:NO];
    
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
        
        [_parkLabelNameCoverButton  setEnabled:YES];
        
    } failure:^(NSError *error) {
        [_parkLabelNameCoverButton  setEnabled:YES];

    }];    
}


//转换image数组存到本地然后返回路径数组
- (NSString *)conventImageToLocalImage:(UIImage *)image name:(NSString *)name
{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tempimg"];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingPathComponent:name] contents:data attributes:nil];
    //得到选择后沙盒中图片的完整路径
    return [NSString stringWithFormat:@"%@/%@",DocumentsPath,name];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    cell.hidden = NO;
    if (_selectedPhotos.count == 0) {
        _tipLabel.hidden = NO;
    }else
    {
        _tipLabel.hidden = YES;
    }
    if (indexPath.row == _selectedPhotos.count)
    {
        if (_selectedPhotos.count == 9)
        {
            cell.hidden = YES;
        }
        cell.imageView.image = [UIImage imageNamed:@"steward_snapshot_addphotos"];
        cell.deleteBtn.hidden = YES;
    }
    else
    {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //如果是最后一个 添加
    if (indexPath.row == _selectedPhotos.count)
    {
        [self pushImagePickerController];
        
    }
    //预览
    else
    {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            [_collectionView reloadData];
            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
        }];
        imagePickerVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath
{
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath
{
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    //     imagePickerVc.navigationBar.barTintColor = [UIColor whiteColor];
    //     imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    //     imagePickerVc.oKButtonTitleColorNormal = colorWithBlack;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    imagePickerVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate

/// 用户点击了取消
// - (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
// NSLog(@"cancel");
// }

// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    [UIView animateWithDuration:0.3 animations:^{
        if (photos.count >2)
        {
            int count = (photos.count < 3)?0:((photos.count <6)?1:2);
            _whiteView.height = _whiteViewHeight + _itemWH * count + _margin;
        }
        else
        {
            _whiteView.height = _whiteViewHeight;
        }
    }];
    
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    
    _collectionView.height = _whiteView.height;
    _collectionView.contentSize = CGSizeMake(YGScreenWidth, _whiteView.height);
    self.backScrollowView.contentSize = CGSizeMake(YGScreenWidth, _collectionView.y +_collectionView.height + 10);
    
}


#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [UIView animateWithDuration:0.3 animations:^{
        if (_selectedPhotos.count >2)
        {
            _whiteView.height = _whiteViewHeight + _itemWH + _margin;
            
        }
        else
        {
            _whiteView.height = _whiteViewHeight;
           
        }
    }];
    
    _collectionView.height = _whiteView.height;

    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
    
//    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.applyView.mas_bottom);
//    }];
    
    self.backScrollowView.contentSize = CGSizeMake(YGScreenWidth, _collectionView.y +_collectionView.height + 10);
//    self.applyView.height = _collectionView.y +_collectionView.height + 10;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)companyCityButtonClick:(UIButton *)btn
{
    AreaSelectViewController * areaView =[[AreaSelectViewController alloc]init];
    areaView.tag = 3;//申请维护
    [self.navigationController pushViewController:areaView animated:YES];
}

- (void)locatemap{
    
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
//        [_locationManager requestAlwaysAuthorization];
        _currentCity = [[NSString alloc]init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0;
        [_locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    
    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
            _currentCity = placeMark.locality;
            //            if (!_currentCity) {
            //                _currentCity = @"无法定位当前城市";
            //            }
            //看需求定义一个全局变量来接收赋值
            
            if (!_currentCity) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                self.companyCity.text = placeMark.administrativeArea;
            }else
            {
                self.companyCity.text = [NSString stringWithFormat:@"%@%@",placeMark.administrativeArea,_currentCity];
            }
                    
        }else if (error == nil && placemarks.count){
            
            NSLog(@"NO location and error return");
        }else if (error){
            
            NSLog(@"loction error:%@",error);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{ //此方法为定位失败的时候调用。并且由于会在失败以后重新定位，所以必须在末尾停止更新
    
    if(error.code == kCLErrorLocationUnknown)
    {
        NSLog(@"Currently unable to retrieve location.");
    }
    else if(error.code == kCLErrorNetwork)
    {
        NSLog(@"Network used to retrieve location is unavailable.");
    }
    else if(error.code == kCLErrorDenied)
    {
        NSLog(@"Permission to retrieve location is denied.");
        [manager stopUpdatingLocation];
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

