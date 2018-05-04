//
//  PlayTogetherDetailViewController.m
//  QingYouProject
//
//  Created by apple on 2017/11/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PlayTogetherDetailViewController.h"
#import "OfficePurchaseTableViewCell.h"//评论Cell
//#import "CustomerCommentViewController.h"//用户评价
#import <WebKit/WebKit.h>
#import "ChooseGoodsFatherView.h"//选择商品规格视图
#import "LDTextView.h"

#import "PlayTogetherMoreActiveCollectionViewCell.h"
#import "PlayTogetherDetailModel.h"
#import "playTogetherJudgeViewController.h"

#import "SignUpSelectView.h"
#import "PlayTogetherDetailAddSignUpViewController.h"

#import "OfficePurchaseDetailModel.h"
#import "PlayTogetherDetailMemberListModel.h"
#import "PlayTogetherDetailRecommendListModel.h"
#import "PlayTogetherSignUpPayViewController.h"


#define imageCount 13 //控制评论cell最多有几张图片
#define commentCellCount 3 //该页面展示几条评论cell

@interface PlayTogetherDetailViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,ChooseGoodsFatherViewDelegate,SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,SignUpSelectViewDelegate>
{
    UITextView *myTextView;
    UILabel *textViewPlaceLabel;
    UIView * sendMessageView;
    PlayTogetherDetailModel *_detailModel;
    PlayTogetherDetailRecommendListModel * _recommendListModel;
    PlayTogetherDetailMemberListModel * _memberListModel;
    OfficePurchaseDetailModel * _commentListModel;
    NSMutableArray *_commentListArry;
    NSMutableArray *_memberListArry;
    UIButton * _attentionButton;
    UIView * _activityView;
    
    NSString * _price;
    NSString * _remain;
    NSString * _hour;
    UIButton * _favoriteButton;
    NSString *_isCollect;
    NSInteger _selectNum;
    UILabel * _lineThree;
    UIButton * _moreMessageBtn;
    UILabel * _line;
    UILabel * _moreActivity;
    NSString * _url;
//    UILabel * _leaveLine;
}

/** scetionHeader  */
@property (nonatomic,strong) UIView * sectionHeaderView;
@property (nonatomic,strong) UIView * sectionFooterView;


/** 用户评价Label  */
@property (nonatomic,strong) UILabel * commentLabel;
/** 查看更多Button  */
@property (nonatomic,strong) LDExchangeButton * leaveMessageButton;
/** tableView  */
@property (nonatomic,strong) UITableView * tableView;
/**  footerView */
@property (nonatomic,strong) UIView * footerView;
/**  footerWebView */
//@property (nonatomic,strong) WKWebView * footerWebView;
/** 真实数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;
/** 当前控制器需要的数据源  */
//@property (nonatomic,strong) NSMutableArray * realDataArray;
/** 底部悬浮视图  */
@property (nonatomic,strong) UIView * bottomView;
/** <#name#>  */
@property (nonatomic,strong) NSArray * titleArray;
/** <#name#>  */
@property (nonatomic,strong) NSArray * tagArray;
//
//@property (nonatomic,strong) OfficePurchaseDetailShowModel * model;
//@property (nonatomic,strong) OfficePurchaseDetailCommodityModel *  CommodityModel;

@property (nonatomic,strong) NSString *  value1;
@property (nonatomic,strong) NSString *  value2;

@property (nonatomic,strong) SignUpSelectView * signUpView;

@property (nonatomic,assign) int webViewHeight;
@property (nonatomic,strong) UIButton * btn;

@property (nonatomic,strong) UIView * headView;

@property (nonatomic,strong) SDCycleScrollView * cycleScrollView;

@property (nonatomic,strong) UILabel * titleName;
@property (nonatomic,strong) UILabel * createDateLable;
@property (nonatomic,strong) UILabel * sartDateLable;
@property (nonatomic,strong) UILabel * addressLable;
@property (nonatomic,strong) UILabel * personCountLable;

@property (nonatomic,strong) UIImageView * allianceImage;
@property (nonatomic,strong) UILabel * allianceName;
@property (nonatomic,strong) UILabel * allianceDetail;
//@property (nonatomic,strong) WKWebView * detailWebView;
@property (nonatomic,strong) UIView * container;

@property (nonatomic,strong) UILabel  * nameList;
@property (nonatomic,strong) LDExchangeButton * moreNameButton;
@property (nonatomic,strong) UIView  * nameView;

@property (nonatomic,strong) UICollectionView * collectionView;

@property (nonatomic,strong) NSMutableArray * activeDataArray;
@property (nonatomic, strong)  UILabel * introduce;

@end

@implementation PlayTogetherDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.naviTitle = @"活动详情";
    UILabel *naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth - 120, 20)];
    naviTitleLabel.textColor = colorWithBlack;
    naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    naviTitleLabel.text = @"活动详情" ;
    [naviTitleLabel sizeToFit];
    naviTitleLabel.frame = CGRectMake(YGScreenWidth/2-naviTitleLabel.width/2, 0, naviTitleLabel.width, 20);
    self.navigationItem.titleView = naviTitleLabel;
    _selectNum = 1;
    
    [self cerateItem];

    [self createHeadViewUI];

    //添加tableView
    [self.view addSubview:self.tableView];
    //网络请求
    
    [self.view addSubview:self.bottomView];
    [self configUI];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [self loadDataFromServer];
   
}
-(void)cerateItem
{
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateNormal];
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    _favoriteButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [_favoriteButton addTarget:self action:@selector(favoriteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *favoriteButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_favoriteButton];
    [_favoriteButton setImage:[UIImage imageNamed:@"collect_icon_black"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems =@[shareButtonItem,favoriteButtonItem];
    
}
-(void)shareButtonAction:(UIButton *)btn
{
    [YGAppTool shareWithShareUrl:_url shareTitle:_detailModel.activityName shareDetail:@"" shareImageUrl:_detailModel.activityCoverUrl shareController:self];
}
-(void)favoriteButtonAction:(UIButton *)btn
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"userID"] = YGSingletonMarco.user.userId;
    dict[@"activityID"] = self.activityID;
    
    
    [YGNetService YGPOST:@"collectActivity" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        if([_isCollect isEqualToString:@"0"])
        {
            _isCollect =@"1";
            [_favoriteButton setImage:[UIImage imageNamed:@"collect_icon_green_finish"] forState:UIControlStateNormal];
            [YGAppTool showToastWithText:@"收藏成功"];
        }
        else
        {
            _isCollect =@"0";
            [_favoriteButton setImage:[UIImage imageNamed:@"collect_icon_black"] forState:UIControlStateNormal];
            [YGAppTool showToastWithText:@"取消收藏"];
        }
        
    } failure:^(NSError *error) {
        [YGAppTool showToastWithText:@"操作失败"];
    }];
}
-(void)createHeadViewUI
{
    self.headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 600)];

    self.headView.backgroundColor = [UIColor whiteColor];
    
     self.container = [[UIView alloc] init];
 
    [self.headView addSubview:self.container];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.width.offset(YGScreenWidth);
        make.bottom.equalTo(self.headView.mas_bottom).offset(-15);
    }];
    
    //轮播图
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth / (375 / 158)) delegate:self placeholderImage:YGDefaultImgTwo_One];
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.autoScrollTimeInterval = 3;
    _cycleScrollView.backgroundColor = kClearColor;
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _cycleScrollView.clipsToBounds = YES;
    [self.container addSubview:self.cycleScrollView];
    
    
    self.titleName = [UILabel new];
    self.titleName.numberOfLines  = 0;
    self.titleName.textAlignment = NSTextAlignmentCenter;
    self.titleName.font = [UIFont boldSystemFontOfSize:22];
    [self.container addSubview:self.titleName];
    
    [self.titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(YGScreenWidth -  2 * LDHPadding);
        make.right.offset(-LDHPadding);
        make.top.equalTo(self.container).offset(YGScreenWidth / (375 / 158) + 14);

//        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(5);
        make.height.offset(self.titleName.ld_height);
    }];
    
    self.createDateLable = [[UILabel alloc]init];
    self.createDateLable.font = [UIFont systemFontOfSize:13];
    self.createDateLable.textColor = colorWithLightGray;
    self.createDateLable.textAlignment = NSTextAlignmentCenter;
    [self.container addSubview:self.createDateLable];
    [self.createDateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(YGScreenWidth -  2 * LDHPadding);
        make.right.offset(-LDHPadding);
        make.top.equalTo(self.titleName.mas_bottom).offset(10);
        make.height.offset(20);
    }];

    UILabel * lineOne = [[UILabel alloc]init];
    lineOne.backgroundColor =colorWithLine;
    [self.container addSubview:lineOne];

    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(YGScreenWidth -  2 * LDHPadding);
        make.right.offset(-LDHPadding);
        make.top.equalTo(self.createDateLable.mas_bottom).offset(10);
        make.height.offset(1);
    }];
    
    UIImageView * dateImage = [UIImageView new];
    dateImage.image =[UIImage imageNamed:@"home_playtogeher_time_gray"];
    [self.container addSubview:dateImage];

    [dateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(13);
        make.left.offset(LDHPadding);
        make.top.equalTo(lineOne.mas_bottom).offset(15);
    }];
    
    self.sartDateLable = [[UILabel alloc]init];
    self.sartDateLable.font = LD14Font;
    self.sartDateLable.textColor = colorWithBlack;
    [self.container addSubview:self.sartDateLable];
    [self.sartDateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(YGScreenWidth - 2 * LDHPadding - 13 - 5);
        make.left.equalTo(dateImage.mas_right).offset(5);
        make.top.equalTo(dateImage.mas_top).offset(-1);
        make.height.offset(15);
    }];
    
    UIImageView * addressImage = [UIImageView new];
    addressImage.image =[UIImage imageNamed:@"home_playtogeher_address_gray"];
    [self.container addSubview:addressImage];
    
    [addressImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(13);
        make.left.offset(LDHPadding);
        make.top.equalTo(dateImage.mas_bottom).offset(15);
    }];
    
    self.addressLable = [[UILabel alloc]init];
    self.addressLable.font = LD14Font;
    self.addressLable.numberOfLines = 0;
    self.addressLable.textColor = colorWithBlack;
    [self.container addSubview:self.addressLable];
    [self.addressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(YGScreenWidth - 2 * LDHPadding - 13 - 5);
        make.left.equalTo(addressImage.mas_right).offset(5);
        make.top.equalTo(addressImage.mas_top).offset(-1);
    }];
    
    
    UIImageView * countImage = [UIImageView new];
    countImage.image =[UIImage imageNamed:@"home_playtogeher_baoming_gray"];
    [self.container addSubview:countImage];
    
    [countImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(13);
        make.left.offset(LDHPadding);
        make.top.equalTo(self.addressLable.mas_bottom).offset(15);
    }];
    
    self.personCountLable = [[UILabel alloc]init];
    self.personCountLable.font = LD14Font;
    self.personCountLable.textColor = colorWithBlack;
    [self.container addSubview:self.personCountLable];
    [self.personCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(YGScreenWidth - 2 * LDHPadding - 13 - 5);
        make.left.equalTo(countImage.mas_right).offset(5);
        make.top.equalTo(countImage.mas_top).offset(-1);
        make.height.offset(15);
    }];
    
    //报名人数下面的横线
    UILabel * lineTwo = [[UILabel alloc]init];
    lineTwo.backgroundColor = colorWithLine;
    [self.container addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset(0);
        make.top.equalTo(countImage.mas_bottom).offset(15);
        make.height.offset(LDHPadding);
    }];
    
    //联盟下面的横线
    _lineThree = [[UILabel alloc]init];
    _lineThree.backgroundColor = colorWithLine;
    [self.container addSubview:_lineThree];
    
    if(![_official isEqualToString:@"青网官方"] && ![_official isEqualToString:@"1"])//官方
    {
        self.allianceImage = [UIImageView new];
        [self.container addSubview:self.allianceImage];
        self.allianceImage.layer.masksToBounds = YES;
        self.allianceImage.layer.cornerRadius = 5;
        [self.allianceImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(LDHPadding);
            make.top.equalTo(lineTwo.mas_bottom).offset(LDHPadding);
            make.height.offset(50);
            make.width.offset(50);
        }];
        
        self.allianceName = [[UILabel alloc]init];
        self.allianceName.font = [UIFont systemFontOfSize:15];
        self.allianceName.textColor = colorWithBlack;
        [self.container addSubview:self.allianceName];
        [self.allianceName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(YGScreenWidth - 3 * LDHPadding - 50 );

            make.left.equalTo(self.allianceImage.mas_right).offset(LDHPadding);
            make.top.equalTo(self.allianceImage.mas_top);
            make.height.offset(YGFontSizeSmallOne +2);
            make.right.offset(-LDHPadding );
        }];
        
        self.allianceDetail = [[UILabel alloc]init];
        self.allianceDetail.font = [UIFont systemFontOfSize:13];
        self.allianceDetail.textColor = colorWithDeepGray;
        self.allianceDetail.numberOfLines = 2;
        [self.container addSubview:self.allianceDetail];
        [self.allianceDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(YGScreenWidth - 4 * LDHPadding - 50 );
            make.right.offset(-LDHPadding );
            make.left.equalTo(self.allianceName.mas_left);
            make.top.equalTo(self.allianceName.mas_bottom ).offset(3);
            make.height.offset(13*2 + 10);
        }];
    

        UIButton * contacButton = [[UIButton alloc]init];
        [self.container addSubview:contacButton];
        
        contacButton.layer.masksToBounds = YES;
        contacButton.layer.cornerRadius = 13;
        contacButton.layer.borderWidth  = 1.0f;
        contacButton.layer.borderColor  = colorWithMainColor.CGColor;
        [contacButton  setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        contacButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [contacButton setTitle:@"联系Ta" forState:UIControlStateNormal];
        [contacButton addTarget:self action:@selector(contactTAButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [contacButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(80);
            make.left.equalTo(self.allianceName.mas_left);
            make.top.equalTo(self.allianceDetail.mas_bottom).offset(LDHPadding);
            make.height.offset(25);
        }];
        
        _attentionButton = [[UIButton alloc]init];
        [self.container addSubview:_attentionButton];
        
        _attentionButton.layer.masksToBounds = YES;
        _attentionButton.layer.cornerRadius = 13;
        [_attentionButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _attentionButton.backgroundColor =colorWithMainColor;
        _attentionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_attentionButton setTitle:@"+关注" forState:UIControlStateNormal];
        [_attentionButton addTarget:self action:@selector(attentionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(80);
            make.right.offset( - 5*LDHPadding);
            make.top.equalTo(self.allianceDetail.mas_bottom).offset(LDHPadding);
            make.height.offset(25);
        }];
        
        [_lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.offset(0);
            make.top.equalTo(_attentionButton.mas_bottom).offset(15);
            make.height.offset(LDHPadding);
        }];
    }
    else
    {
        _lineThree.backgroundColor = [UIColor clearColor];

        [_lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.offset(0);
            make.top.equalTo(lineTwo.mas_bottom).offset(0);
            make.height.offset(0.001);
        }];
    }
   
    
    self.introduce = [[UILabel alloc]init];
    [self.container addSubview:self.introduce];
    self.introduce.text = @"活动详情介绍";
    self.introduce.textColor = colorWithBlack;
    self.introduce.font =[UIFont systemFontOfSize:YGFontSizeNormal];
    [self.introduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset(15);
        make.top.equalTo(_lineThree.mas_bottom).offset(15);
        make.height.offset( YGFontSizeNormal +2);
//        make.bottom.equalTo(self.introduce.mas_bottom).offset(15);
        
    }];
    
    _activityView = [[UIView alloc]init];
    [self.container addSubview:_activityView];

}
- (void)loadDataFromServer
{
    NSDictionary *parameters = @{
                                @"activityID":self.activityID,
                                 @"userID":YGSingletonMarco.user.userId,
                                 };
    NSString *url = @"ActivityDetail";
    
    [YGNetService YGPOST:url parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
    
        _url = responseObject[@"url"];
        _commentListArry = [[NSMutableArray alloc]init];
        [_commentListArry addObjectsFromArray:[OfficePurchaseDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"commentList"]]];
        
        _memberListArry = [[NSMutableArray alloc]init];
        [_memberListArry addObjectsFromArray:[PlayTogetherDetailMemberListModel mj_objectArrayWithKeyValuesArray:responseObject[@"memberList"]]];
        
        _detailModel = [[PlayTogetherDetailModel alloc]init];
        _detailModel = [PlayTogetherDetailModel mj_objectWithKeyValues:responseObject[@"activityMap"]];
        
  
        _isCollect = _detailModel.isCollect;
        if([_isCollect isEqualToString:@"1"])
        {
            [_favoriteButton setImage:[UIImage imageNamed:@"collect_icon_green_finish"] forState:UIControlStateNormal];
        }
        
        NSMutableArray * imArray = [[NSMutableArray alloc]init];
        [imArray addObject:_detailModel.activityCoverUrl];
        self.cycleScrollView.imageURLStringsGroup = imArray;

        self.titleName.text = _detailModel.activityName;
        
        CGSize titleNameSize = [self.titleName sizeThatFits:CGSizeMake(YGScreenWidth -  2 * LDHPadding, 1000)];
        
        [self.titleName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(titleNameSize.height);
        }];
        
        
        NSString * startDate = @"";
        if(_detailModel.activityCreateDate.length >0)
        {
            NSArray * dateArray = [_detailModel.activityCreateDate componentsSeparatedByString:@" "];
            startDate = dateArray[0];
        }
        self.createDateLable.text =[NSString stringWithFormat:@"%@ 发布 · 浏览%@ · 收藏%@",startDate,_detailModel.activityPageView,_detailModel.activityCollectCount];
        
        
        self.sartDateLable.text = [NSString stringWithFormat:@"%@ 至 %@",[_detailModel.activityBeginTime substringToIndex:(_detailModel.activityBeginTime.length -3)],[_detailModel.activityEndTime substringToIndex:(_detailModel.activityEndTime.length -3)]];
        self.addressLable.text = _detailModel.activityAddress;
        
        CGSize addressLableSize = [self.addressLable sizeThatFits:CGSizeMake(YGScreenWidth - 2 * LDHPadding - 13 - 5, 1000)];

//        self.addressLable.preferredMaxLayoutWidth = YGScreenWidth - 2 * LDHPadding - 13 - 5;
        [self.addressLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(addressLableSize.height);
        }];
        
        NSString *  activityPersonLimit = [NSString stringWithFormat:@"%@",_detailModel.activityPersonLimit];
        if([activityPersonLimit isEqualToString:@"0"] || !activityPersonLimit.length)
            self.personCountLable.text =[NSString stringWithFormat:@"已报名%@人 (不限制名额)",_detailModel.activityPersonCount];
        else
            self.personCountLable.text =[NSString stringWithFormat:@"已报名%@人 (最多%@人)",_detailModel.activityPersonCount,activityPersonLimit];


        [self.allianceImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_detailModel.allianceImg]] placeholderImage:YGDefaultImgSquare];
        
        self.allianceName.text = _detailModel.allianceName;
        self.allianceDetail.text = _detailModel.allianceInfo;
        
        if([_detailModel.isAttention isEqualToString:@"1"])
        {
            [_attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
            _attentionButton.userInteractionEnabled = NO;
        }
        
        UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDHPadding, 0, YGScreenWidth - 2*LDHPadding, 0)];
        detailLabel.text = _detailModel.activityDetail;
        [_activityView addSubview:detailLabel];
        detailLabel.textColor = colorWithDeepGray;
        detailLabel.font =[UIFont systemFontOfSize:YGFontSizeNormal];
        
        // 调整行间距
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:detailLabel.text];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:5];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailLabel.text length])];
            detailLabel.attributedText = attributedString;
            [detailLabel sizeToFit];
        
        
        detailLabel.numberOfLines = 0;
        CGSize detailLabeleSize = [detailLabel sizeThatFits:CGSizeMake(YGScreenWidth - 2*LDHPadding, 10000)];
        
        detailLabel.frame= CGRectMake(LDHPadding, 0, YGScreenWidth - 2*LDHPadding, detailLabeleSize.height);
       
        NSArray * activeImageArray = [ [NSString stringWithFormat:@"%@",_detailModel.activityDetailImg] componentsSeparatedByString:@","];

        float height = detailLabel.y + detailLabel.height;
        for(int i = 0; i<activeImageArray.count; i++)
        {
            UIImage *imgFromUrl = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[[NSURL alloc]initWithString:activeImageArray[i]]]];
            CGSize myImageSize = imgFromUrl.size;
            if(myImageSize.width == 0)
                myImageSize.width = 1.0;
            
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(LDHPadding, height, YGScreenWidth - 2*LDHPadding, 0)];
            imageView.tag = 1000 + i;
              imageView.height = imageView.width * (myImageSize.height/myImageSize.width);
            //自适应图片宽高比例
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:activeImageArray[i]] placeholderImage:[UIImage imageNamed:@"YGDefaultImgFour_Three"]];
            
            [_activityView addSubview:imageView];

            height += imageView.height +LDHPadding;
            
        }
        
  
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(self.introduce.mas_bottom).offset(15);
            make.bottom.equalTo(self.container.mas_bottom).offset(-15);
            make.bottom.mas_equalTo([_activityView viewWithTag:1000 + activeImageArray.count - 1].mas_bottom).offset(-15);
        }];

        self.nameList.text =[NSString stringWithFormat:@"报名清单（%@）",_detailModel.activityPersonCount];
        
        UIView * header = self.sectionHeaderView;
        
        [self.nameView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];

        
        NSInteger count = 0;
        count = YGScreenWidth / (2 * LDHPadding + 32) ;
        if(_memberListArry.count < count)
            count = _memberListArry.count ;
        for(int i=0;i<count;i++)
        {
            UIImageView * personImage = [[UIImageView alloc]initWithFrame:CGRectMake(LDHPadding * (1 + i) + (32 + LDHPadding)* i, LDHPadding, 32, 32)];
            personImage.backgroundColor =[UIColor cyanColor];
            personImage.layer.masksToBounds = YES;
            [personImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",((PlayTogetherDetailMemberListModel *)_memberListArry[i]).userImg]] placeholderImage:YGDefaultImgAvatar];

            personImage.layer.cornerRadius = 32/2;
            [self.nameView addSubview:personImage];


            UILabel * name =[[UILabel alloc]initWithFrame:CGRectMake( (2 * LDHPadding + personImage.width) *i, personImage.y + personImage.height + 5, 2 * LDHPadding + personImage.width, 15)];
            name.text = [NSString stringWithFormat:@"%@",((PlayTogetherDetailMemberListModel *)_memberListArry[i]).userName];
            name.textColor = colorWithBlack;
            name.font = [UIFont systemFontOfSize:12];
            name.textAlignment = NSTextAlignmentCenter;
            [self.nameView addSubview:name];
        }
        
//        //将字典数组转化为模型数组，再加入到数据源
        [self.activeDataArray addObjectsFromArray:[PlayTogetherDetailRecommendListModel mj_objectArrayWithKeyValuesArray:responseObject[@"recommendList"]]];

        CGFloat H = (kScreenW - 3 * LDHPadding) / 2 + 5 * LDVPadding + LDHPadding;

        _footerView.frame = CGRectMake(0, 0, kScreenW, (self.activeDataArray.count /2 +  self.activeDataArray.count %2 )*H + 3 * LDHPadding);
        _tableView.tableFooterView = _footerView;
        
        _headView.height = [_container systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 15;
        _tableView.tableHeaderView = self.headView;

        [_tableView reloadData];
        [self.collectionView reloadData];
        
    } failure:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return _commentListArry.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * header = self.sectionHeaderView;
    
    self.commentLabel.text =[NSString stringWithFormat:@"留言区(%@)",_detailModel.activityCommentCount];
    self.nameList.text =[NSString stringWithFormat:@"报名清单(%@)",_detailModel.activityPersonCount];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 165;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSString *  activityCommentCount =[NSString stringWithFormat:@"%@",_detailModel.activityCommentCount];
    
    self.commentLabel.text =[NSString stringWithFormat:@"留言区(%@)",_detailModel.activityCommentCount];

        UIView * footer = self.sectionFooterView;
        {
            if([activityCommentCount integerValue] >3)
            {
                _moreMessageBtn.hidden = NO;
                [_moreMessageBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(40);
                }];
                
//                [_line mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.offset(LDHPadding);
//                }];
  
            }
            else
            {
                _moreMessageBtn.hidden = YES;

                [_moreMessageBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                }];
                
//                [_line mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.offset(0);
//                }];
            }
//            if([activityCommentCount integerValue] >0)
//                _leaveLine.hidden = YES;
        }
        return footer;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSString *  activityCommentCount =[NSString stringWithFormat:@"%@",_detailModel.activityCommentCount];
    if([activityCommentCount integerValue] >3)
    {
        return 90;
    }
    else
    {
        return 50;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OfficePurchaseDetailModel * model = _commentListArry[indexPath.row];
    
    NSString * reuseIdentifier = [NSString stringWithFormat:@"%ld",model.countOfArr];
    
    OfficePurchaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.model = model;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OfficePurchaseDetailModel * model = _commentListArry[indexPath.row];

    NSString * reuseIdentifier = [NSString stringWithFormat:@"%ld",model.countOfArr];

    return  [tableView fd_heightForCellWithIdentifier:reuseIdentifier cacheByIndexPath:indexPath configuration:^(OfficePurchaseTableViewCell* cell) {
        cell.model = _commentListArry[indexPath.row];
    }];
    
}
static NSString * const  OfficePurchaseTableViewCellId = @"OfficePurchaseTableViewCellId";
- (UITableView *)tableView{
    
    if (!_tableView) {
        CGFloat H = kScreenH - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
     
        self.tableView.tableHeaderView = self.headView;
        //footer
        self.tableView.tableFooterView = self.footerView;
        
        _tableView.estimatedRowHeight =0 ;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
        [_tableView setSeparatorColor:colorWithLine];
        
        //注册cell
        for (NSInteger i = 0; i < imageCount; i++) {
            NSString * reuseIdentifier = [NSString stringWithFormat:@"%ld",i];

            [self.tableView registerClass:[OfficePurchaseTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        }
        
        if (@available(iOS 11.0, *)) {
            
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
        } else {
            
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.backgroundColor = kWhiteColor;

    }
    return _tableView;
}


#pragma mark - 联系客服
- (void)contactButtonClick:(UIButton *)contactButton{
    [self contactWithCustomerServerWithType:ContactServerPlayTogether button:contactButton];
}
#pragma mark - 立刻购买
- (void)buyButtonClick:(UIButton *)buyButton{
  
    NSDictionary *parameters = @{
                                 @"activityID":self.activityID,
                                 };
    NSString *url = @"ActivityApply";

    
    [YGNetService YGPOST:url parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {

        _price = responseObject[@"price"];
        _remain = responseObject[@"remain"];
        _hour = responseObject[@"hour"];
        [self signUpUI];

    } failure:nil];
}


#pragma mark - 评论查看更多
- (void)moreButtonClick:(UIButton*)moreButton{
    
    playTogetherJudgeViewController * message =[[playTogetherJudgeViewController alloc]init];
    message.pageType = @"MoreSingUp";
    message.activityID = self.activityID;
    message.commentCount = _detailModel.activityPersonCount;
    message.activeAllianceID = _detailModel.allianceID;
    [self.navigationController pushViewController:message animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)activeDataArray{
    if (!_activeDataArray) {
        _activeDataArray = [NSMutableArray array];
    }
    return _activeDataArray;
}

#pragma mark - sectionHeaderView
- (UIView *)sectionHeaderView{
    if (!_sectionHeaderView) {
        
        _sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 165)];
        
        
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 165)];
        [_sectionHeaderView addSubview:backView];
        
        UILabel * lineFour = [[UILabel alloc]init];
        lineFour.backgroundColor = colorWithLine;
        [backView addSubview:lineFour];
        [lineFour mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.offset(0);
            make.top.offset(0);
            make.height.offset(LDHPadding);
            
        }];
        
        self.nameList = [[UILabel alloc]init];
        self.nameList.font = [UIFont boldSystemFontOfSize:16];
        self.nameList.textColor = colorWithBlack;
        [backView addSubview:self.nameList];
        [self.nameList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineFour.mas_bottom).offset(LDHPadding);
            make.width.offset(YGScreenWidth /2 );
            make.left.offset(LDHPadding);
            make.height.offset(YGFontSizeNormal +2);
        }];
        
     

        self.moreNameButton = [LDExchangeButton buttonWithType:UIButtonTypeCustom];
        [backView addSubview:self.moreNameButton];
        [self.moreNameButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        [self.moreNameButton setTitle:@"更多报名" forState:UIControlStateNormal];
        [self.moreNameButton setImage:LDImage(@"steward_more_green") forState:UIControlStateNormal];
        [self.moreNameButton.titleLabel setFont:LDFont(14)];
        [self.moreNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(- LDHPadding);
            make.top.offset(2* LDHPadding);
        }];
        [self.moreNameButton sizeToFit];
        [self.moreNameButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * lineOne = [[UILabel alloc]init];
        lineOne.backgroundColor =colorWithLine;
        [backView addSubview:lineOne];
        
        [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(self.nameList.mas_bottom).offset(LDHPadding);
            make.height.offset(1);
        }];
        
        
        self.nameView = [[UIView alloc]init];
        [backView addSubview:self.nameView];
        
        [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(lineOne.mas_bottom).offset(0);
            make.height.offset(70);
        }];
        
        UILabel * lineTwo = [[UILabel alloc]init];
        lineTwo.backgroundColor = colorWithLine;
        [backView addSubview:lineTwo];
        
        [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(self.nameView.mas_bottom).offset(0);
            make.height.offset(LDHPadding);
        }];
        
        self.commentLabel = [UILabel ld_labelWithTextColor:kBlackColor textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13] numberOfLines:1];
        self.commentLabel.font =[UIFont boldSystemFontOfSize:16];
        [backView addSubview:self.commentLabel];
        
        [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(LDHPadding);
            make.width.offset(YGScreenWidth/2);
            make.top.equalTo(lineTwo.mas_bottom).offset(LDHPadding);
            
        }];
        
//        _leaveLine =[UILabel new];
//        _leaveLine.backgroundColor =colorWithLine;
//        [backView addSubview:_leaveLine];
//
//        [_leaveLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.offset(0);
//            make.width.offset(YGScreenWidth);
//            make.height.offset(1);
//            make.top.equalTo(self.commentLabel.mas_bottom).offset(LDHPadding);
//        }];
        
        self.leaveMessageButton = [LDExchangeButton buttonWithType:UIButtonTypeCustom];
        [backView addSubview:self.leaveMessageButton];
        [self.leaveMessageButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        [self.leaveMessageButton setTitle:@"我要留言" forState:UIControlStateNormal];
        [self.leaveMessageButton setImage:LDImage(@"steward_more_green") forState:UIControlStateNormal];
        [self.leaveMessageButton.titleLabel setFont:LDFont(14)];
        [self.leaveMessageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(- LDHPadding);
            make.bottom.offset(0).offset(-LDHPadding);
        }];
        [self.leaveMessageButton sizeToFit];
        [self.leaveMessageButton addTarget:self action:@selector(leaveMessageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return _sectionHeaderView;
}
#pragma mark - sectionHeaderView
- (UIView *)sectionFooterView{
    if (!_sectionFooterView) {
        
        _sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 90)];
        
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 90)];
        [_sectionFooterView addSubview:backView];
        
         _moreMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backView addSubview:_moreMessageBtn];
        [_moreMessageBtn setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
        [_moreMessageBtn setTitle:@"查看更多留言" forState:UIControlStateNormal];
        [_moreMessageBtn setImage:LDImage(@"home_playtogether_unfold_gray") forState:UIControlStateNormal];
//        [_moreMessageBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [_moreMessageBtn.titleLabel setFont:LDFont(13)];
        
        [_moreMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.offset(0);
            make.top.offset(0);
            make.height.offset(40);
        }];
        
        CGFloat typeButtonimageWidth = _moreMessageBtn.imageView.bounds.size.width;
        
        CGFloat typeButtonlabelWidth = _moreMessageBtn.titleLabel.bounds.size.width;
        
        _moreMessageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, typeButtonlabelWidth, 0, -typeButtonlabelWidth-10);
        
        _moreMessageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -typeButtonimageWidth, 0, typeButtonimageWidth);
        
    
//        [self.moreNameButton sizeToFit];
        [_moreMessageBtn addTarget:self action:@selector(moreMessageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
         _line = [[UILabel alloc]init];
        _line.backgroundColor = colorWithLine;
        [backView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.offset(0);
            make.top.equalTo(_moreMessageBtn.mas_bottom).offset(0);
            make.height.offset(LDHPadding);
        }];
        
         _moreActivity = [[UILabel alloc]init];
        _moreActivity.text =@"更多精彩活动";
        _moreActivity.font = [UIFont boldSystemFontOfSize:16];
        _moreActivity.textColor = colorWithBlack;
        [backView addSubview:_moreActivity];
        [_moreActivity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_line.mas_bottom).offset(0);
            make.width.offset(YGScreenWidth /2 );
            make.left.offset(LDHPadding);
            make.height.offset(45);
        }];
        
        UILabel * lineOne = [[UILabel alloc]init];
        lineOne.backgroundColor =colorWithLine;
        [backView addSubview:lineOne];
        
        [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(_moreActivity.mas_bottom).offset(0);
            make.height.offset(1);
        }];
    }
    return _sectionFooterView;
}
#pragma mark - footerView
- (UIView *)footerView{
    if (!_footerView) {
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
        _footerView.backgroundColor = kWhiteColor;
        [_footerView addSubview:self.collectionView];
    }
    return _footerView;
}

#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.activeDataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PlayTogetherMoreActiveCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:PlayTogetherMoreActiveCollectionViewCellId forIndexPath:indexPath];
    
    cell.model = self.activeDataArray[indexPath.row];

    return  cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PlayTogetherDetailViewController * detailVC = [[PlayTogetherDetailViewController alloc] init];
    detailVC.activityID = ((PlayTogetherDetailRecommendListModel *)self.activeDataArray[indexPath.row]).activityID;
    detailVC.official =  ((PlayTogetherDetailRecommendListModel *)self.activeDataArray[indexPath.row]).official;
    [self.navigationController pushViewController:detailVC animated:YES];
}

static NSString * const LDManagerHeaderCellId = @"LDManagerHeaderCellId";


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
static NSString * const PlayTogetherMoreActiveCollectionViewCellId = @"PlayTogetherMoreActiveCollectionViewCellId";

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc] init];
        layOut.minimumLineSpacing = LDHPadding;
        layOut.minimumInteritemSpacing = LDHPadding;
        
        CGFloat W = (kScreenW - 3 * LDHPadding) / 2;
        
        layOut.itemSize = CGSizeMake(W, 174);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, LDHPadding, kScreenW, kScreenH - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight - floorf(kScreenW / Banner_W_H_Scale)) collectionViewLayout:layOut];

        _collectionView.contentInset = UIEdgeInsetsMake(LDVPadding, LDHPadding,2 * LDVPadding, LDVPadding);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kWhiteColor;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"PlayTogetherMoreActiveCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:PlayTogetherMoreActiveCollectionViewCellId];
        _collectionView.scrollEnabled = NO;

    }
    
    return _collectionView;
    
}


-(void)configUI
{
     CGFloat H = YGNaviBarHeight ;
    CGFloat Y = kScreenH - H  - YGNaviBarHeight - YGStatusBarHeight;

    sendMessageView = [[UIView alloc]initWithFrame:CGRectMake(0, Y, YGScreenWidth, 70)];
    [self.view addSubview:sendMessageView];
    sendMessageView.hidden =YES;
    
    sendMessageView.backgroundColor =[UIColor whiteColor];
    //输入框
    myTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, YGScreenWidth-10 -  90, 45)];
    myTextView.delegate = self;
    myTextView.backgroundColor = [UIColor whiteColor];
    myTextView.bounces = NO;
    myTextView.tag = 100;
    myTextView.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    myTextView.textColor = colorWithBlack;
    myTextView.returnKeyType = UIReturnKeyDone;
    [sendMessageView addSubview:myTextView];
    
    //  placeLabel
    textViewPlaceLabel = [[UILabel alloc]init];
    textViewPlaceLabel.text = @"  说点什么";
    textViewPlaceLabel.numberOfLines = 2;
    textViewPlaceLabel.textColor = colorWithLightGray;
    textViewPlaceLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    textViewPlaceLabel.frame = CGRectMake(10, 10, YGScreenWidth - 100, 30);
    [textViewPlaceLabel sizeToFit];
    [sendMessageView addSubview:textViewPlaceLabel];
    
    UIButton * sendBtn =[[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth - 90, 0, 90, 45)];
    sendBtn.backgroundColor = colorWithMainColor;
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [sendMessageView addSubview:sendBtn];
}
-(void)textViewDidChange:(UITextView *)textView
{
    [textView becomeFirstResponder];
    if (textView.text.length > 0)
    {
        textViewPlaceLabel.hidden = YES;
    }else
    {
        textViewPlaceLabel.hidden = NO;
    }
    if (textView.text.length >50)
    {
        [textView resignFirstResponder];
        [YGAppTool showToastWithText:@"输入文字不能多于50字哦！"];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        sendMessageView.hidden = YES;
        _bottomView.hidden = NO;
        return NO;
    }
    return YES;
}

-(void)sendBtnClick
{
    if (myTextView.text.length <1)
    {
        [YGAppTool showToastWithText:@"请输入留言内容"];
        return ;
    }
    if (myTextView.text.length >50)
    {
        [YGAppTool showToastWithText:@"输入文字不能多于50字哦！"];
        return ;
    }
    [myTextView resignFirstResponder];
    sendMessageView.hidden = YES;
    
    
    [YGNetService YGPOST:@"postActivityComment" parameters:@{@"userID":YGSingletonMarco.user.userId,@"content":myTextView.text,@"activityID":self.activityID} showLoadingView:YES scrollView:nil success:^(id responseObject) {

        [YGAppTool showToastWithText:@"留言成功！"];
        myTextView.text = @"";
         [self loadDataFromServer];
        
    } failure:^(NSError *error) {
    }];
}

- (UIView *)bottomView{
    if (!_bottomView) {
        
        //悬浮视图
        CGFloat H = YGNaviBarHeight + YGBottomMargin ;
        CGFloat Y = kScreenH - H  - YGNaviBarHeight - YGStatusBarHeight;
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Y, kScreenW, H )];
        [self.view addSubview:_bottomView];
        
        
        UIButton * contactButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:@"service_black" selectedImage:@"service_black" normalTitle:@"在线咨询" selectedTitle:@"在线咨询" normalTitleColor:LD16TextColor selectedTitleColor:LD16TextColor backGroundColor:kWhiteColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:14];

        [contactButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];

        [contactButton addTarget:self action:@selector(contactButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        contactButton.frame = CGRectMake(0, 0, kScreenW / 2, H);
        [_bottomView addSubview:contactButton];
        
        UILabel * line = [UILabel new];
        line.backgroundColor = colorWithLine;
        line.frame = CGRectMake(0, 0, YGScreenWidth, 1);
        [_bottomView addSubview:line];
        
        UIButton * buyButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:@"我要报名" selectedTitle:@"我要报名" normalTitleColor:kWhiteColor selectedTitleColor:kWhiteColor backGroundColor:LDMainColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:14];
        [buyButton addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        buyButton.frame = CGRectMake(kScreenW / 2, 0, kScreenW / 2, H);
        [_bottomView addSubview:buyButton];
        

        
    }
    return _bottomView;
}

#pragma mark - 轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{

}
-(void)contactTAButtonClick:(UIButton *)btn
{
    [YGAlertView showAlertWithTitle:@"是否拨打电话？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[NSString stringWithFormat:@"%@",_detailModel.alliancePhone]];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }
    }];
    
}
-(void)attentionButtonClick:(UIButton *)btn
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"userID"] = YGSingletonMarco.user.userId;
    dict[@"allianceID"] = _detailModel.allianceID;
    
    [YGNetService YGPOST:@"attentionAlliance" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        [YGAppTool showToastWithText:@"关注成功"];
        [_attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
        _attentionButton.userInteractionEnabled =NO;
        
    } failure:^(NSError *error) {
    }];
}
-(void)moreMessageBtnClick:(UIButton *)btn
{
    playTogetherJudgeViewController * message =[[playTogetherJudgeViewController alloc]init];
    message.pageType = @"LeaveMessage";
    message.activityID =self.activityID;
    message.commentCount = _detailModel.activityCommentCount;
    [self.navigationController pushViewController:message animated:YES];
}
-(void)leaveMessageButtonClick:(UIButton *)btn
{
    sendMessageView.hidden = NO;
    [myTextView becomeFirstResponder];
    
    _bottomView.hidden =YES;
}


-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [myTextView resignFirstResponder];
    sendMessageView.hidden = YES;
    _bottomView.hidden = NO;
}
/**
  我要报名
 */
-(void)signUpUI
{
    self.signUpView = [[SignUpSelectView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.signUpView.delegate = self;
    [self.signUpView reloadViewWithPrice:_price withHour:_hour withCount:_remain];
    [self.navigationController.view addSubview:self.signUpView];

//    [[UIApplication sharedApplication].keyWindow addSubview:self.signUpView];
}
//协议方法
- (void)SignUpSelectViewNextWay:(UIButton *)btn withPersonNum:(NSInteger)num
{
    _selectNum = num;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"activityID"] = self.activityID;
    
    [YGNetService YGPOST:@"ActivityApplyInfo" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
       NSMutableArray *  messageList = responseObject[@"messageList"];
        NSMutableArray * dataArray = [[NSMutableArray alloc]init];
  
        dataArray =@[
                     @{
                         @"isCheck":@"1",
                         @"customName":@"姓名"
                         },
                     @{
                         @"isCheck":@"1",
                         @"customName":@"手机"
                         }
                    ].mutableCopy;
        
        [dataArray addObjectsFromArray:messageList];

        if(dataArray.count <5)
        {
            [self.signUpView signupInformationWithInfoArray:dataArray];
            return;
        }
        
        [self.signUpView pushOtherView];
        PlayTogetherDetailAddSignUpViewController * signupView =[[PlayTogetherDetailAddSignUpViewController alloc]init];
        signupView.price = _price;
        signupView.messageList = dataArray;
        signupView.personNum = num;
        signupView.activityID = self.activityID;
        [self.navigationController pushViewController:signupView animated:YES];
  
    } failure:^(NSError *error) {
        [YGAppTool showToastWithText:@"操作失败"];
    }];

} 
- (void)signUpSelectViewSurePayWay:(UIButton *)btn withIsFree:(BOOL)isFree withName:(NSString *)name withPhone:(NSString *)phone withArray:(NSArray *)arry
{
    NSString * jsonStr =  [self arrayToJsonString:arry];
    
    NSDictionary * dict = @{
                            @"activityID":self.activityID,
                            @"count":[NSString stringWithFormat:@"%ld",(long)_selectNum],
                            @"userID":YGSingletonMarco.user.userId,
                            @"userName":name,
                            @"userPhone":phone,
                            @"userDetail":jsonStr,
                            };
    
    if(isFree)
    {
        [YGNetService YGPOST:@"ActivityCreateOrder" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
            
                NSDictionary * parameters =@{
                                             @"orderID":responseObject[@"orderID"],
                                             @"channel":@"",
                                             };
                
                [YGNetService YGPOST:@"ActivityPayOrder" parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
                    
                    [YGAppTool showToastWithText:@"您已报名成功"];
                    [self.signUpView pushOtherView];
                    [self loadDataFromServer];
                    
                } failure:^(NSError *error) {
                }];
            
        } failure:^(NSError *error) {
            [YGAppTool showToastWithText:@"操作失败"];
        }];
    }
    else
    {
        [YGNetService YGPOST:@"ActivityCreateOrder" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
            
            PlayTogetherSignUpPayViewController * singUpPay =[[PlayTogetherSignUpPayViewController alloc]init];
            singUpPay.orderID = responseObject[@"orderID"];
            [self.navigationController pushViewController:singUpPay animated:YES];
            
        } failure:^(NSError *error) {
            [YGAppTool showToastWithText:@"操作失败"];
        }];
    }
   
}

- (NSString *)arrayToJsonString:(NSArray *)arr{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

