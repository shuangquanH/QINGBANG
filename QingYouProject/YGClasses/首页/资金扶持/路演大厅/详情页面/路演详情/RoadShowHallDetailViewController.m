//
//  FundSupportDetailViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RoadShowHallDetailViewController.h"
#import "YGSegmentView.h"
#import "AskBPViewController.h"
#import "ZFPlayer.h"

@interface RoadShowHallDetailViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate,YGSegmentViewDelegate,ZFPlayerDelegate>
{
    NSMutableArray * _controllersArray;//Controller数组
    YGSegmentView * _segmentView;//选择器
    UIScrollView * _scrollView;

}
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@end

@implementation RoadShowHallDetailViewController
{
    UIImageView *_projectVideoImageView; //广告轮播
    UIView          *_baseView;
    UILabel *_titleLabel;
    UILabel *_newPriceLabel;
    UILabel  *_oldPriceLabel;
    
    
    UIImageView *_avaterImageView; //头像
    UILabel *_nameLabel; //昵称
    UIButton *_identityButton; //身份
    UILabel  *_contentLabel;

    NSString *_nameString;
    NSString *_imgUrlString;
    NSArray *_roadShowWebContentArray;
    int   _selectIndex;
    
    UIView *_bottomView;
    ZFPlayerModel *_playerModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configAttribute];
    [self configUI];
    [self loadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        [self.playerView pause];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.playerView resetPlayer];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 调用playerView的layoutSubviews方法
    if (self.playerView) { [self.playerView setNeedsLayout]; }
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        [self.playerView play];
    }
    if (self.isPlaying == NO) {
        [self.playerView resetPlayer];
    }
}
#pragma mark ---- 重写导航条
- (void)configAttribute
{
    self.naviTitle = @"路演项目";
    _roadShowWebContentArray = [[NSMutableArray alloc] init];
}
-(void)loadData
{
    [self startPostWithURLString:REQUEST_getRoadShowDetails parameters:@{@"id":_roadShowProjectModel.id} showLoadingView:NO scrollView:nil];
}

- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    [_roadShowProjectModel setValuesForKeysWithDictionary:responseObject[@"rsDetails"]];
//    _roadShowProjectModel.roadshowGrade = responseObject[@"rsDetails"][@"roadshowGrade"];
//    _roadShowProjectModel.teamIntroduction = responseObject[@"rsDetails"][@"teamIntroduction"];
//    _roadShowProjectModel.roadshowIntroduction = responseObject[@"rsDetails"][@"roadshowIntroduction"];
//    _roadShowProjectModel.competitiveAdvantage = responseObject[@"rsDetails"][@"competitiveAdvantage"];
//    _roadShowProjectModel.companyName
    _nameLabel.text = responseObject[@"usmUser"][@"name"];
    [_identityButton setTitle:_roadShowProjectModel.companyName forState:UIControlStateNormal];
    [_identityButton sizeToFit];
    [_avaterImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"usmUser"][@"img"]] placeholderImage:YGDefaultImgAvatar];
    _roadShowWebContentArray = @[_roadShowProjectModel.roadshowGrade,_roadShowProjectModel.teamIntroduction,_roadShowProjectModel.roadshowIntroduction,_roadShowProjectModel.competitiveAdvantage];
    
}
#pragma mark ---- 配置UI
-(void)configUI
{
    
    /********************* _scrollView ***************/
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight -YGStatusBarHeight)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _scrollView.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = colorWithTable;
    [self.view addSubview:_scrollView];
    
    /********************** 头视图两个按钮 *****************/
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, _scrollView.height)];
    _baseView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:_baseView];
    //广告滚动
    _projectVideoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth-0, YGScreenWidth/2)];
    _projectVideoImageView.backgroundColor = [UIColor clearColor];
    _projectVideoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _projectVideoImageView.clipsToBounds = YES;
    _projectVideoImageView.userInteractionEnabled = YES;
    [_projectVideoImageView sd_setImageWithURL:[NSURL URLWithString:_roadShowProjectModel.videoImg] placeholderImage:YGDefaultImgFour_Three];
    [_baseView addSubview:_projectVideoImageView];

    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _projectVideoImageView.width, _projectVideoImageView.height)];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    coverView.userInteractionEnabled = YES;
    [_projectVideoImageView addSubview:coverView];

    UIButton  *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"steward_capital_play_btn"] forState:UIControlStateNormal];
    playBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_projectVideoImageView addSubview:playBtn];
    [playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    playBtn.frame = CGRectMake(coverView.width/2-20, coverView.height/2-20, 40, 40);
    playBtn.center = coverView.center;
  
    
    //热门推荐label
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    _titleLabel.text = _roadShowProjectModel.roadshowName;
    _titleLabel.frame = CGRectMake(10, _projectVideoImageView.height+10,YGScreenWidth-30, 35);
    _titleLabel.numberOfLines = 0;
    [_baseView addSubview:_titleLabel];
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(_titleLabel.x, _titleLabel.y,_titleLabel.width, _titleLabel.height+10);

    
    //小的书签标志
    UIImageView * eyeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _titleLabel.y+_titleLabel.height+5, 15, 15)];
    eyeImageView.layer.masksToBounds = YES;
    eyeImageView.image = [UIImage imageNamed:@"steward_capital_time"];
    eyeImageView.userInteractionEnabled = YES;
    [_baseView addSubview:eyeImageView];
    
    
    //时间label
    _newPriceLabel = [[UILabel alloc]init];
    _newPriceLabel.frame = CGRectMake(eyeImageView.x+eyeImageView.width+3,eyeImageView.y , YGScreenWidth-20, 20);
    _newPriceLabel.textColor = colorWithDeepGray;
    _newPriceLabel.text = _roadShowProjectModel.createDate;
    _newPriceLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    _newPriceLabel.numberOfLines = 0;
    [_newPriceLabel sizeToFit];
    _newPriceLabel.frame = CGRectMake(_newPriceLabel.x,_titleLabel.y+_titleLabel.height , _newPriceLabel.width, 20);
    [_baseView addSubview:_newPriceLabel];
    _newPriceLabel.centery = eyeImageView.centery;
    
    /********************** 分割线 ********************/
    
    UIView *seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, _newPriceLabel.y+_newPriceLabel.height+10, YGScreenWidth, 10)];
    seperateView.backgroundColor = colorWithTable;
    [_baseView addSubview:seperateView];
    
    UIView *headerMiddleView = [[UIView alloc] initWithFrame:CGRectMake(0,seperateView.y+seperateView.height+10, YGScreenWidth, 70)];
    headerMiddleView.backgroundColor = colorWithYGWhite;
    [_baseView addSubview:headerMiddleView];
    
    //左线
    _avaterImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_tool1.png"]];
    _avaterImageView.frame = CGRectMake(10, 10, 40, 40);
    _avaterImageView.layer.borderColor = colorWithLine.CGColor;
    _avaterImageView.layer.borderWidth = 0.5;
    _avaterImageView.backgroundColor = colorWithMainColor;
    _avaterImageView.layer.cornerRadius = 20;
    _avaterImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avaterImageView.clipsToBounds = YES;
    [headerMiddleView addSubview:_avaterImageView];
    
    //昵称
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avaterImageView.x+_avaterImageView.width+5, _avaterImageView.y, YGScreenWidth-30, 20)];
    _nameLabel.text = @"我们为您解答";
    _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _nameLabel.textColor = colorWithBlack;
    [headerMiddleView addSubview:_nameLabel];
    
    //身份
    _identityButton = [[UIButton alloc]initWithFrame:CGRectMake(_nameLabel.x, _nameLabel.y+_nameLabel.height+3, YGScreenWidth-_nameLabel.x-20, 15)];
    [_identityButton setTitle:@"盟主"  forState:UIControlStateNormal];
    _identityButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_identityButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    [headerMiddleView addSubview:_identityButton];
    
    
    _controllersArray = [[NSMutableArray alloc]initWithArray:@[@"项目成绩",@"团队介绍",@"项目介绍",@"竞争优势"]];
    
    /********************** 选择器 ********************/
    UIView *seperateSegmentLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, YGScreenWidth, 1)];
    seperateSegmentLineView.backgroundColor = colorWithTable;
    [headerMiddleView addSubview:seperateSegmentLineView];
    
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(15,headerMiddleView.y+headerMiddleView.height, YGScreenWidth-30, 40) titlesArray:_controllersArray lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
    _segmentView.lineColor = colorWithMainColor;
    [_scrollView addSubview:_segmentView];

    
    //默认第0页
    [self segmentButtonClickWithIndex:0];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,_segmentView.y+_segmentView.height, YGScreenWidth, 100)];
    _bottomView.backgroundColor = colorWithYGWhite;
    [_baseView addSubview:_bottomView];
    
    UIView *seperateLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
    seperateLineView.backgroundColor = colorWithTable;
    [_bottomView addSubview:seperateLineView];
    
    //昵称
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _avaterImageView.y, YGScreenWidth-30, 20)];
    _contentLabel.text = @"我们为您解答";
    _contentLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _contentLabel.textColor = colorWithBlack;
    [_bottomView addSubview:_contentLabel];
    
    /****************************** 按钮 **************************/
    if (_roadShowProjectModel.auditStatus != nil)
    {
        _scrollView.frame  = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight -YGStatusBarHeight);
//        NSArray *typeArry = @[@"",@"待审核",@"募集中",@"审核不通过",@"已完成"];
//        //热门推荐label
//        UILabel *statusLabel = [[UILabel alloc]init];
//        statusLabel.textColor = colorWithYGWhite;
//        statusLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
//        statusLabel.text = typeArry[[_roadShowProjectModel.auditStatus intValue]];
//        statusLabel.frame = CGRectMake(0, 20,100, 30);
//        statusLabel.textAlignment = NSTextAlignmentCenter;
//        statusLabel.backgroundColor = [colorWithMainColor colorWithAlphaComponent:0.5];
//        [coverView addSubview:statusLabel];
//        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight-YGStatusBarHeight)];
//
    }else
    {
        _scrollView.frame  = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin);

        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
        coverButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
        [coverButton addTarget:self action:@selector(contanctWithCustomerServiceOrOrderAction:) forControlEvents:UIControlEventTouchUpInside];
        coverButton.backgroundColor = colorWithMainColor;
        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        [self.view addSubview:coverButton];
        [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
        [coverButton setTitle:@"索要BP" forState:UIControlStateNormal];
    }
}


#pragma mark ---- 改变当前Controller
-(void)segmentButtonClickWithIndex:(int)buttonIndex
{
    _selectIndex = buttonIndex;
    [self loadControllerWithIndex:buttonIndex];
}

#pragma mark ---- 加载Controller
-(void)loadControllerWithIndex:(int)index
{
    if (_roadShowWebContentArray.count >0) {
        CGFloat height = [self getLabelHeightWithText:_roadShowWebContentArray[index] withLabel:_contentLabel];
        _contentLabel.frame = CGRectMake(_contentLabel.x, _contentLabel.y, _contentLabel.width, height+20);
        _bottomView.frame = CGRectMake(_bottomView.x, _bottomView.y, _bottomView.width, _contentLabel.height);
        _scrollView.contentSize = CGSizeMake(YGScreenWidth, _bottomView.y+_bottomView.height+20);
    }
 
}

- (CGFloat)getLabelHeightWithText:(NSString *)content withLabel:(UILabel *)label
{
    // 调整行间距
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    paragraphStyle.paragraphSpacingBefore = 0.0;//段首行空白空间
    paragraphStyle.paragraphSpacing = 0.0; //段与段之间间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    //attributedText设置后之前设置的都失效
    
    label.attributedText = attributedString;
    
    [label sizeToFitVerticalWithMaxWidth:YGScreenWidth -20];
    
    NSDictionary *attribute =@{NSFontAttributeName:label.font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:colorWithDeepGray};
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(YGScreenWidth -20, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.height;
}

#pragma mark ---- 按钮点击

- (void)contanctWithCustomerServiceOrOrderAction:(UIButton *)btn
{
    AskBPViewController *askBP = [[AskBPViewController alloc] init];
    askBP.roadshowId = _roadShowProjectModel.id;
    [self.navigationController pushViewController:askBP animated:YES];
}



- (ZFPlayerView *)playerView
{
    if (!_playerView)
    {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        _playerView.hasDownload = NO;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        // 当cell划出屏幕的时候停止播放
//        _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        //_playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        
        
        // _playerView.mute = YES;
    }
    return _playerView;
}
-(void)zf_playerBackAction
{
    [self.playerView resetPlayer];
}
- (ZFPlayerControlView *)controlView
{
    if (!_controlView)
    {
        _controlView = [[ZFPlayerControlView alloc] init];
//        _controlView.downLoadBtn.hidden = YES;
    }
    return _controlView;
}

- (void)playAction:(UIButton *)btn
{
    //player
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
//    playerModel.title = model.name;
    playerModel.videoURL  = [NSURL URLWithString:_roadShowProjectModel.videoData];
    playerModel.placeholderImage = YGDefaultImgFour_Three;
//    playerModel.tableView = weakSelf.myTableView;
//    playerModel.indexPath = weakIndexPath;
    // player的父视图
    playerModel.fatherView = _projectVideoImageView;
    // 设置播放控制层和model
    [self.playerView playerControlView:self.controlView playerModel:playerModel];
    // 下载功能
    self.playerView.hasDownload = NO;
    // 自动播放
    [self.playerView autoPlayTheVideo];
}

@end
