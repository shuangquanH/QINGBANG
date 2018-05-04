//
//  JobOutsourceViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "JobOutsourceViewController.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "FinacialAccountPopView.h"
#import "JobOutsourceTradeRecoredViewController.h"

#define HEADERHEIGHT (YGScreenWidth * 0.77 + 15 + 45)

@interface JobOutsourceViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource,SDCycleScrollViewDelegate,FinacialAccountPopViewDelegate>
{
    UIScrollView *_scrollView; //底层的大scrollView
    SDCycleScrollView *_adScrollview; //广告轮播
    NSMutableArray *_dataArray;//首页数据
    UIView *_headerView;  //整个的headerView
    FinacialAccountPopView *_inputInfoView;
    NewPagedFlowView *_pageFlowView;
    NSString *_titleString;
    NSString *_contentString;
    NSString *_url;

}
@property (nonatomic, strong) NSMutableArray *imageArray; //图片数组
@property (nonatomic, strong) NewPagedFlowView *pageFlowView; //轮播图

@end

@implementation JobOutsourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)configAttribute
{
    self.imageArray = [[NSMutableArray alloc] init];
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-55,20,40,40)];
    shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateSelected];
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = shareButtonItem;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    [self startPostWithURLString:REQUEST_OutsourcingIndexList parameters:@{} showLoadingView:NO scrollView:nil];
    
}

- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    if ([URLString isEqualToString:REQUEST_OutsourcingIndexList]) {
        [self.imageArray addObjectsFromArray: [responseObject[@"Outsourcing"][@"imgs"] componentsSeparatedByString:@","]];
        _titleString = responseObject[@"Outsourcing"][@"title"];
        _contentString = responseObject[@"Outsourcing"][@"content"];
        _url = responseObject[@"url"];
        [self configUI];
    }
    if ([URLString isEqualToString:REQUEST_AddOutsourcingApplyAudit]) {
        [_inputInfoView selfDisappear];
        [YGAppTool showToastWithText:@"申请成功"];
        JobOutsourceTradeRecoredViewController *vc =[[JobOutsourceTradeRecoredViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)configUI
{
    self.naviTitle = @"岗位外包服务";

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGBottomMargin-YGNaviBarHeight)];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _scrollView.height);
    [self.view addSubview:_scrollView];
    
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 9 / 16 + 56)];
    _headerView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:_headerView];

    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 9 / 16 - 40)];
    [_headerView addSubview:bottomScrollView];
    
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 8, YGScreenWidth, YGScreenWidth * 9 / 16 - 40)];
    pageFlowView.backgroundColor = YGUIColorFromRGB(0xefeff4, 1);
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.1;
    pageFlowView.orginPageCount = self.imageArray.count;
    pageFlowView.isOpenAutoScroll = YES;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 24, YGScreenWidth, 8)];
    pageFlowView.pageControl = pageControl;
    [pageFlowView addSubview:pageControl];
    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为NewPagedFlowView的容器View,才会显示正常,如下
     *****************************/
    [pageFlowView reloadData];
    [bottomScrollView addSubview:pageFlowView];
    
    self.pageFlowView = pageFlowView;
    
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,bottomScrollView.height+5 , YGScreenWidth-20, 20)];
    titleLabel.text = _titleString;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    titleLabel.textColor = colorWithBlack;
    titleLabel.numberOfLines = 0;
    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(titleLabel.x,titleLabel.y , titleLabel.width, titleLabel.height+10);
    [_headerView addSubview:titleLabel];

    _headerView.frame = CGRectMake(0, 0, YGScreenWidth, titleLabel.y+titleLabel.height+10);
    
    
    
    UIView  *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.height+10, YGScreenWidth, 100)];
    bottomView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:bottomView];
    
    UILabel * seviceDetailTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 20)];
    seviceDetailTitleLabel.text = @"服务详情页信息";
    seviceDetailTitleLabel.textAlignment = NSTextAlignmentLeft;
    seviceDetailTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    seviceDetailTitleLabel.textColor = colorWithBlack;
    [bottomView addSubview:seviceDetailTitleLabel];
    
    UIView  *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithTable;
    [bottomView addSubview:lineView];
    
    UILabel * seviceDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,lineView.y+lineView.height+10 , YGScreenWidth-20, 20)];
    seviceDetailLabel.text = _contentString;
    seviceDetailLabel.textAlignment = NSTextAlignmentLeft;
    seviceDetailLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    seviceDetailLabel.textColor = colorWithBlack;
    seviceDetailLabel.numberOfLines = 0;
    [bottomView addSubview:seviceDetailLabel];
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:seviceDetailLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [seviceDetailLabel.text length])];
    NSDictionary *attribute =@{NSFontAttributeName:seviceDetailLabel.font,NSParagraphStyleAttributeName:paragraphStyle};
    //attributedText设置后之前设置的都失效
    CGSize size = [seviceDetailLabel.text boundingRectWithSize:CGSizeMake(YGScreenWidth -20, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    seviceDetailLabel.attributedText = attributedString;
    seviceDetailLabel.frame = CGRectMake(seviceDetailLabel.x, seviceDetailLabel.y, seviceDetailLabel.width, size.height+20);
    
    bottomView.frame = CGRectMake(bottomView.x, bottomView.y, bottomView.width, 50+seviceDetailLabel.height);
    
    
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, bottomView.y+bottomView.height+20);
    /****************************** 按钮 **************************/
    
    UIView  *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth/2,45+YGBottomMargin)];
    buttonView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:buttonView];
    


    for (int i = 0; i<2; i++)
    {
        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth/2*i,0,YGScreenWidth/2,45+YGBottomMargin)];
        coverButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
        coverButton.tag = 1000+i;
        [coverButton addTarget:self action:@selector(aplyForOrTradeRecoredAction:) forControlEvents:UIControlEventTouchUpInside];
        coverButton.backgroundColor = colorWithMainColor;
        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        [buttonView addSubview:coverButton];
        
        if (i == 0)
        {
            coverButton.backgroundColor = colorWithYGWhite;
            [coverButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            [coverButton setTitle:@"立即申请" forState:UIControlStateNormal];
        }else
        {
            coverButton.backgroundColor = colorWithMainColor;
            [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
            [coverButton setTitle:@"交易记录" forState:UIControlStateNormal];
        }
    }
    
    UIView  *buttonLineView = [[UIView alloc] initWithFrame:CGRectMake(0,0,YGScreenWidth,1)];
    buttonLineView.backgroundColor = colorWithLine;
    [buttonView addSubview:buttonLineView];
}
#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView
{
    return CGSizeMake(YGScreenWidth - 40, (YGScreenWidth - 40) * 9 / 16 - 30);
}
//点击了第几个cell
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    //    self.indicateLabel.text = [NSString stringWithFormat:@"点击了第%ld张图",(long)subIndex + 1];
}

#pragma mark NewPagedFlowView Datasource
//返回显示view的个数
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.imageArray.count;
}

//给某一列设置属性
- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 9 / 16 - 30)];
    }
    
    //在这里下载网络图片
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[index]] placeholderImage:YGDefaultImgFour_Three];
//    bannerView.mainImageView.image = [UIImage imageNamed:self.imageArray[index]];
    bannerView.layer.cornerRadius = 6;
    bannerView.layer.masksToBounds = YES;
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"TestViewController 滚动到了第%ld页",pageNumber);
}
- (void)dealloc {
    
    /****************************
     在dealloc或者返回按钮里停止定时器
     ****************************/
    
    [self.pageFlowView stopTimer];
}

#pragma 代理
- (void)aplyForOrTradeRecoredAction:(UIButton *)btn
{
    if (btn.tag == 1000) {
        _inputInfoView = [[FinacialAccountPopView alloc]init];
        _inputInfoView.finacialAccountPopViewDelegate = self;
        [_inputInfoView createFrame:CGRectMake(0, YGScreenHeight-(300+YGBottomMargin+20+40), YGScreenWidth, 300+YGBottomMargin+20+40) withInfoArray:@[@"联系人",@"手机",@"企业/个人名称",@"地址"] andPageType:@"joboutsource"];
        [self.navigationController.view addSubview:_inputInfoView];

    }else
    {
        JobOutsourceTradeRecoredViewController *vc =[[JobOutsourceTradeRecoredViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)confirmPayWithInfoDict:(NSDictionary *)dict
{
    [self startPostWithURLString:REQUEST_AddOutsourcingApplyAudit parameters:dict showLoadingView:NO scrollView:nil];

}
- (void)cancleAllPopViews
{
    [_inputInfoView selfDisappear];
}
- (void)shareButtonAction
{
    [YGAppTool shareWithShareUrl:_url shareTitle:_titleString shareDetail:_contentString shareImageUrl:self.imageArray[0] shareController:self];

}
@end
