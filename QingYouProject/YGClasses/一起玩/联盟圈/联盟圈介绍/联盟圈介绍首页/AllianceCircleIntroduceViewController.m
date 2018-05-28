//
//  AllianceCircleIntroduceViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/5.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceCircleIntroduceViewController.h"
#import "YGSegmentView.h"

#define heraderHeight  (90+120+10+10+40)

#import "AllianceCircleTrendsViewController.h"
#import "AllianceCircleActivityViewController.h"

#import "AllianceMainViewController.h"
#import "AllianceMainSignViewController.h"
#import "AllianceMainSignRankViewController.h"
#import "AllianceMemberViewController.h"

#import "AlliancePublishTrendsViewController.h"
#import "AlliancePopView.h"

#import "AllianceCircleIntroduceModel.h"

#import "AllianceMainMemberViewController.h"

@interface AllianceCircleIntroduceViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate,YGSegmentViewDelegate,AllianceCircleTrendsViewControllerDelegate,AllianceCircleActivityViewControllerDelegate>
{
    NSMutableArray * _controllersArray;//Controller数组
    YGSegmentView * _segmentView;//选择器
    UIScrollView * _scrollView;
    AllianceCircleTrendsViewController * _allianceCircleTrendsViewController;
    AllianceCircleActivityViewController * _allianceCircleActivityViewController;
    
    UIImageView *_leftImageView; //左边的图
    UILabel *_titleLabel; //标题
    UILabel *_visitLabel; //人气
    UILabel *_describeLabel; //内容

    UIImageView *_avaterImageView; //头像
    UILabel *_nameLabel; //昵称
    UIButton *_identityButton; //身份
    UIButton *_signForGiftsButton; //签到的礼物
    UIButton *_signRankButton; //签到排行榜
    int  _index;
    UIButton *_announcementButton;
    AllianceCircleIntroduceModel *_model;
    UIButton *_coverButton;
}

@end

@implementation AllianceCircleIntroduceViewController
{
    SDCycleScrollView *_adScrollview; //广告轮播
    UIView          *_baseView;
    UILabel *_newPriceLabel;
    UILabel  *_oldPriceLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataFromServer];
}

- (void)loadDataFromServer
{
    
    [YGNetService YGPOST:REQUEST_AllianceDetail parameters:@{@"allianceID":_allianceID,@"userID":YGSingletonMarco.user.userId}  showLoadingView:NO scrollView:nil success:^(id responseObject) {
        [_model setValuesForKeysWithDictionary:responseObject];
        if ([_model.allianceNotice isEqualToString:@""]) {
            _model.allianceNotice = @"联盟圈公告。。";
        }
        [self configUI];

    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ---- 重写导航条
- (void)configAttribute
{
//    self.naviTitle = @"联盟圈";
    UILabel *naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth - 120, 20)];
    naviTitleLabel.textColor = colorWithBlack;
    naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    naviTitleLabel.text = @"联盟圈" ;
    [naviTitleLabel sizeToFit];
    naviTitleLabel.frame = CGRectMake(YGScreenWidth/2-naviTitleLabel.width/2, 0, naviTitleLabel.width, 20);
    self.navigationItem.titleView = naviTitleLabel;
    
    
    self.fd_interactivePopDisabled = YES;
    _model = [[AllianceCircleIntroduceModel alloc] init];
    
}

#pragma mark ---- 配置UI
-(void)configUI
{
    
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-40,20,40,40)];
    shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateSelected];
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    UIButton *favoriteButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-70,20,40,40)];
    [favoriteButton setImage:[UIImage imageNamed:@"collect_icon_black"] forState:UIControlStateNormal];
    [favoriteButton setImage:[UIImage imageNamed:@"collect_icon_green_finish"] forState:UIControlStateSelected];
    favoriteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [favoriteButton addTarget:self action:@selector(favoriteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    favoriteButton.selected = [_model.isCollect boolValue];
    UIBarButtonItem *favoriteButtonItem = [[UIBarButtonItem alloc] initWithCustomView:favoriteButton];
    
    self.navigationItem.rightBarButtonItems =@[shareButtonItem,favoriteButtonItem];
    
    /********************** 头视图两个按钮 *****************/
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, heraderHeight)];
    _baseView.backgroundColor = colorWithTable;
    [self.view addSubview:_baseView];
   
    UIView *headerTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 70+20)];
    headerTopView.backgroundColor = colorWithYGWhite;
    [_baseView addSubview:headerTopView];
    
    //左线
    _leftImageView = [[UIImageView alloc]initWithImage:YGDefaultImgSquare];
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_model.allianceImg] placeholderImage:YGDefaultImgSquare];
    _leftImageView.frame = CGRectMake(10, 10, 70, 70);
    _leftImageView.layer.borderColor = colorWithLine.CGColor;
    _leftImageView.layer.borderWidth = 0.5;
    _leftImageView.layer.cornerRadius = 5;
    _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    _leftImageView.clipsToBounds = YES;
    [headerTopView addSubview:_leftImageView];
    
    //新鲜事标题label
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    _titleLabel.text = _model.allianceName;
    _titleLabel.frame = CGRectMake(_leftImageView.x+_leftImageView.width+10, _leftImageView.y,YGScreenWidth-_leftImageView.width-25, 20);
    [headerTopView addSubview:_titleLabel];
    
    //新鲜事标题label
    _visitLabel = [[UILabel alloc]init];
    _visitLabel.textColor = colorWithLightGray;
    _visitLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    _visitLabel.text = [NSString stringWithFormat:@"人气 %@ ∙昨日来访+%@",_model.attentionCount,_model.visitorCountYesterday];
    _visitLabel.frame = CGRectMake(_titleLabel.x, _titleLabel.y+_titleLabel.height,YGScreenWidth-_leftImageView.width-15, 20);
    [headerTopView addSubview:_visitLabel];

    
    
    //新鲜事内容label
    _describeLabel = [[UILabel alloc]init];
    _describeLabel.frame = CGRectMake(_leftImageView.x+_leftImageView.width+5,_visitLabel.y+_visitLabel.height+5 , YGScreenWidth-_leftImageView.width-25, 25);
    _describeLabel.textColor = colorWithBlack;
    _describeLabel.text = [NSString stringWithFormat:@"【公告】%@",_model.allianceNotice];
    _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [headerTopView addSubview:_describeLabel];
    
    _announcementButton = [[UIButton alloc]initWithFrame:CGRectMake(_titleLabel.x,_visitLabel.y+_visitLabel.height+5 , YGScreenWidth-_leftImageView.width-25, 25)];
    [_announcementButton addTarget:self action:@selector(announcementButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [headerTopView addSubview:_announcementButton];
    
    
    UIView *headerMiddleView = [[UIView alloc] initWithFrame:CGRectMake(0,headerTopView.y+headerTopView.height+10, YGScreenWidth, 120)];
    headerMiddleView.backgroundColor = colorWithYGWhite;
    [_baseView addSubview:headerMiddleView];
    
    
    //左线
    _avaterImageView = [[UIImageView alloc]initWithImage:YGDefaultImgSquare];
    [_avaterImageView sd_setImageWithURL:[NSURL URLWithString:_model.userImg] placeholderImage:YGDefaultImgAvatar];
    _avaterImageView.frame = CGRectMake(10, 15, 40, 40);
    _avaterImageView.layer.borderColor = colorWithLine.CGColor;
    _avaterImageView.layer.borderWidth = 0.5;
    _avaterImageView.layer.cornerRadius = 20;
    _avaterImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avaterImageView.clipsToBounds = YES;
    [headerMiddleView addSubview:_avaterImageView];
    
    //昵称
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avaterImageView.x+_avaterImageView.width+5, _avaterImageView.y, YGScreenWidth/2, 20)];
    _nameLabel.text = _model.userName;
    _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _nameLabel.textColor = colorWithBlack;
    [headerMiddleView addSubview:_nameLabel];
    
    UIButton *allianceMainButton = [[UIButton alloc]initWithFrame:CGRectMake(0,_avaterImageView.y,_nameLabel.x+_nameLabel.width,_avaterImageView.height)];
    allianceMainButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
    [allianceMainButton addTarget:self action:@selector(AllianceMainButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [headerMiddleView addSubview:allianceMainButton];

    if (_model.memberImgList.count>0) {
        for (int i = (int)_model.memberImgList.count; i>0; i--) {
            //左线
            UIImageView *litteHeadImageView = [[UIImageView alloc]initWithImage:YGDefaultImgSquare];
            [litteHeadImageView sd_setImageWithURL:[NSURL URLWithString:_model.memberImgList[i-1][@"userImg"]] placeholderImage:YGDefaultImgSquare];
            litteHeadImageView.frame = CGRectMake(YGScreenWidth-27-(37*i), 10, 30, 30);
            litteHeadImageView.layer.borderColor = colorWithLine.CGColor;
            litteHeadImageView.layer.borderWidth = 0.5;
            litteHeadImageView.backgroundColor = colorWithMainColor;
            litteHeadImageView.layer.cornerRadius = 15;
            litteHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
            litteHeadImageView.clipsToBounds = YES;
            [headerMiddleView addSubview:litteHeadImageView];
            litteHeadImageView.centery = _avaterImageView.centery;
        }
    }
   
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.frame = CGRectMake(YGScreenWidth-25, 0, 17, 17);
    arrowImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
    [arrowImageView sizeToFit];
    arrowImageView.userInteractionEnabled = YES;
    [headerMiddleView addSubview:arrowImageView];
    arrowImageView.centery = _avaterImageView.centery;
    
    UIButton *litteHeadImageButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-27-(37*3),10,(37*3)+27,30)];
    litteHeadImageButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
    [litteHeadImageButton addTarget:self action:@selector(litteHeadImageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [headerMiddleView addSubview:litteHeadImageButton];
    //身份
    _identityButton = [[UIButton alloc]initWithFrame:CGRectMake(_nameLabel.x, _nameLabel.y+_nameLabel.height+3, 30, 15)];
    [_identityButton setTitle:@"盟主"  forState:UIControlStateNormal];
    _identityButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallThree];
    [_identityButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    _identityButton.backgroundColor = colorWithMainColor;
    [headerMiddleView addSubview:_identityButton];
    
    UIView *btnBaseLineView = [[UIView alloc] initWithFrame:CGRectMake(10, headerMiddleView.height-50, YGScreenWidth-20, 1)];
    btnBaseLineView.backgroundColor = colorWithLine;
    [headerMiddleView addSubview:btnBaseLineView];
    
    //签到的礼物
//    UIImage *signForGiftImage = [UIImage imageNamed:@"home_playtogeher_signin"];
    _signForGiftsButton = [[UIButton alloc]initWithFrame:CGRectMake(0, headerMiddleView.height-50, YGScreenWidth/2, 50)];
    [_signForGiftsButton setImage:[UIImage imageNamed:@"home_playtogeher_signin"] forState:UIControlStateNormal];
    [_signForGiftsButton setImage:[UIImage imageNamed:@"home_playtogeher_signin"] forState:UIControlStateHighlighted];
    [_signForGiftsButton setTitle:@"签到得礼物"  forState:UIControlStateNormal];
    _signForGiftsButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [_signForGiftsButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [_signForGiftsButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [_signForGiftsButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    _signForGiftsButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_signForGiftsButton addTarget:self action:@selector(signForGiftsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [headerMiddleView addSubview:_signForGiftsButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_signForGiftsButton.width, headerMiddleView.height-40, 1, 30)];
    lineView.backgroundColor = colorWithLine;
    [headerMiddleView addSubview:lineView];
    
    //签到排行榜
    _signRankButton = [[UIButton alloc]initWithFrame:CGRectMake(_signForGiftsButton.width, headerMiddleView.height-50, YGScreenWidth/2, 50)];
    [_signRankButton setImage:[UIImage imageNamed:@"home_playtogeher_ranking_list"] forState:UIControlStateNormal];
    [_signRankButton setImage:[UIImage imageNamed:@"home_playtogeher_ranking_list"] forState:UIControlStateHighlighted];
    [_signRankButton setTitle:@"签到排行榜"  forState:UIControlStateNormal];
    _signRankButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_signRankButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [_signRankButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [_signRankButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    _signRankButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_signRankButton addTarget:self action:@selector(signRankButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [headerMiddleView addSubview:_signRankButton];

    
    UIView *headerBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, headerMiddleView.y+headerMiddleView.height+10, YGScreenWidth, 40)];
    headerBottomView.backgroundColor = colorWithYGWhite;
    [_baseView addSubview:headerBottomView];

    
    /********************** 选择器 ********************/;
    //选择页面按钮
    YGSegmentView *segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"看动态",@"看活动"] lineColor:colorWithMainColor delegate:self];
    segmentView.backgroundColor = colorWithYGWhite;
    [headerBottomView addSubview:segmentView];
    
    /********************* _scrollView ***************/
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _baseView.height, YGScreenWidth, YGScreenHeight - _baseView.height - 45-YGBottomMargin - _segmentView.height-YGNaviBarHeight-YGStatusBarHeight)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth * 2, _scrollView.height+10);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
  
    
    /****************************** 按钮 **************************/
    _coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
    _coverButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
    [_coverButton addTarget:self action:@selector(joinInAllianceCircleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _coverButton.backgroundColor = colorWithMainColor;
    _coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [self.view addSubview:_coverButton];
    [_coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    if (![_model.isMember isEqualToString:@"1"])
    {
        _scrollView.frame = CGRectMake(0, _baseView.height, YGScreenWidth, YGScreenHeight - 64 - 45-YGBottomMargin - _segmentView.height);
        [_coverButton setTitle:@"加入盟圈" forState:UIControlStateNormal];
    }else
    {
        _scrollView.frame = CGRectMake(0, _baseView.height, YGScreenWidth, YGScreenHeight - 64 -YGBottomMargin - _segmentView.height);
        _coverButton.hidden = YES;
    }

    //默认第0页
    [self segmentButtonClickWithIndex:0];
    
    //选择页面按钮
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"看动态",@"看活动"] lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithTable;
    [self.view addSubview:_segmentView];
    _segmentView.hidden = YES;
    
}

#pragma mark ---- 改变当前Controller
-(void)segmentButtonClickWithIndex:(int)buttonIndex
{
    [self loadControllerWithIndex:buttonIndex];
    
    [UIView animateWithDuration:0.25 animations:^{
        _scrollView.contentOffset = CGPointMake(buttonIndex * YGScreenWidth, _scrollView.contentOffset.y);
    }];
}

//#pragma mark ---- 滑动切换Controller
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    int index = scrollView.contentOffset.x / YGScreenWidth;
//    [self loadControllerWithIndex:index];
//    [_segmentView selectButtonWithIndex:index];
//}

#pragma mark ---- 加载Controller
-(void)loadControllerWithIndex:(int)index
{
    _index = index;
    if (index == 0)
    {
     
        if (_allianceCircleTrendsViewController == nil) {
            _allianceCircleTrendsViewController = [[AllianceCircleTrendsViewController alloc]init];
            _allianceCircleTrendsViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height-_coverButton.height-YGBottomMargin);
            _allianceCircleTrendsViewController.allianceCircleTrendsViewControllerDelegate = self;
            _allianceCircleTrendsViewController.allianceID = _allianceID;
            [self addChildViewController:_allianceCircleTrendsViewController];
            [_scrollView addSubview:_allianceCircleTrendsViewController.view];

        }
        if ([_model.isMember isEqualToString:@"1"])
        {
            _allianceCircleTrendsViewController.isMember = @"1";
            [_coverButton setTitle:@"发动态" forState:UIControlStateNormal];
            _allianceCircleTrendsViewController.controllerFrame = CGRectMake(YGScreenWidth * 1, 1, _scrollView.width, _scrollView.height-_segmentView.height);
            _coverButton.hidden = NO;
        }
    }
    else if (index == 1)
    {
        if (_allianceCircleActivityViewController == nil) {
            _allianceCircleActivityViewController = [[AllianceCircleActivityViewController alloc]init];
            _allianceCircleActivityViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height-_coverButton.height-YGBottomMargin);
            _allianceCircleActivityViewController.allianceID = _allianceID;
            _allianceCircleActivityViewController.allianceCircleActivityViewControllerDelegate = self;
            [self addChildViewController:_allianceCircleActivityViewController];
            [_scrollView addSubview:_allianceCircleActivityViewController.view];
        }
        if ([_model.isMember isEqualToString:@"1"])
        {
            _coverButton.hidden = YES;
            _allianceCircleActivityViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
        }else
        {
            _allianceCircleActivityViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height-_segmentView.height);
        }

        
    }
}

#pragma mark ---- DiscoverySubViewController上拉滑动更新位置代理
- (void)scrollViewDidScrollWithHeight:(CGFloat)offset {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        CGFloat height = _baseView.height;//偏移量
        if (offset > 0)//向下拉是负值，向上是正
        {
            _baseView.y = - height + _segmentView.height;
        }
        else if(offset < 0)
        {
            _baseView.y = 0;
            
        }
        _scrollView.y = CGRectGetMaxY(_baseView.frame);
        
    } completion:nil];
}

#pragma mark ---- 按钮点击

- (void)joinInAllianceCircleButtonAction:(UIButton *)btn
{
    if (![_model.isMember isEqualToString:@"1"])
    {
        
        [self joinInAllianceCircle];

    }else
    {
        AlliancePublishTrendsViewController *vc = [[AlliancePublishTrendsViewController alloc] init];
        vc.allianceID = _allianceID;
        [self.navigationController pushViewController:vc animated:YES];
    }

}
//分享按钮
- (void)shareButtonAction:(UIButton *)btn
{
    [YGAppTool shareWithShareUrl:_model.url shareTitle:_model.allianceName shareDetail:@"" shareImageUrl:_model.allianceImg shareController:self];
}
//收藏
- (void)favoriteButtonAction:(UIButton *)btn
{
    // 收藏与取消收藏
    [YGNetService YGPOST:REQUEST_collectAlliance parameters:@{@"allianceID":_allianceID,@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        btn.selected = !btn.isSelected;
        if (btn.selected == YES) {
            [YGAppTool showToastWithText:@"收藏成功"];
        }else
        {
            [YGAppTool showToastWithText:@"取消收藏成功"];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)AllianceMainButtonAction
{
    
    [YGNetService YGPOST:REQUEST_isManager parameters:@{@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        
        //判断是不是盟成员  或者是自己的联盟
        
        //是盟主并且是自己的联盟
        if ([responseObject[@"isManager"] isEqualToString:@"0"])
        {
            YGSingletonMarco.user.allianceID = responseObject[@"allianceID"];
            if ( [responseObject[@"allianceID"] isEqualToString:_allianceID])
            {
                AllianceMainViewController *vc = [[AllianceMainViewController alloc] init];
                
                vc.allianceID = _allianceID;
                
                [self.navigationController pushViewController:vc animated:YES];
                return ;
            }
        }
        
        
        if([_model.isMember isEqualToString:@"0"])
        {
            
            [self joinInAllianceCircle];
            
        }else
        {
            AllianceMainViewController *vc = [[AllianceMainViewController alloc] init];
            
            vc.allianceID = _allianceID;
            
            [self.navigationController pushViewController:vc animated:YES];
        }

    } failure:^(NSError *error) {
        
    }];
 
 
}
- (void)signForGiftsButtonAction
{
    
    [YGNetService YGPOST:REQUEST_isManager parameters:@{@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        

        //判断是不是盟成员  或者是自己的联盟
        
        //是盟主并且是自己的联盟
        if ([responseObject[@"isManager"] isEqualToString:@"0"])
        {
            YGSingletonMarco.user.allianceID = responseObject[@"allianceID"];
            
            if ( [responseObject[@"allianceID"] isEqualToString:_allianceID])
            {
                AllianceMainSignViewController *mainVc = [[AllianceMainSignViewController alloc] init];
        
                mainVc.allianceID = _allianceID;
                
                [self.navigationController pushViewController:mainVc animated:YES];
                return ;

            }
        }
        
        
        if([_model.isMember isEqualToString:@"0"])
        {
            
            [self joinInAllianceCircle];
            
        }else
        {
            AllianceMainSignViewController *mainVc = [[AllianceMainSignViewController alloc] init];
            
            mainVc.allianceID = _allianceID;
            
            [self.navigationController pushViewController:mainVc animated:YES];
        }

    } failure:^(NSError *error) {
        
    }];

}
- (void)signRankButtonAction
{
    AllianceMainSignRankViewController *vc = [[AllianceMainSignRankViewController alloc] init];
    vc.allianceID = _allianceID;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)litteHeadImageButtonAction
{
    [YGNetService YGPOST:REQUEST_isManager parameters:@{@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject)
     {
         
         //判断是不是盟成员  或者是自己的联盟
         
         //是盟主并且是自己的联盟
         if ([responseObject[@"isManager"] isEqualToString:@"0"])
         {
             YGSingletonMarco.user.allianceID = responseObject[@"allianceID"];
             
             if ( [responseObject[@"allianceID"] isEqualToString:_allianceID])
             {
                 AllianceMainMemberViewController *mainVc = [[AllianceMainMemberViewController alloc] init];
                 mainVc.allianceID = _allianceID;
                 [self.navigationController pushViewController:mainVc animated:YES];
                 return ;

             }
         }
         
         
      
             AllianceMemberViewController *vc = [[AllianceMemberViewController alloc] init];
             vc.allianceID = _allianceID;
             [self.navigationController pushViewController:vc animated:YES];
     
         
    } failure:^(NSError *error) {
        
    }];
    

}
- (void)announcementButtonAction
{
    AlliancePopView *pop = [[AlliancePopView alloc] init];
    [self.navigationController.view addSubview:pop];
    [pop createAlliancePopViewWithContent:_model.allianceNotice withTitle:@"【公告】"];
}

- (void)joinInAllianceCircle
{
    [YGAlertView showAlertWithTitle:@"是否要加入该联盟？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }
        // 加入联盟
        [YGNetService YGPOST:REQUEST_operateAllianceMember parameters:@{@"allianceID":_allianceID,@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
            _model.isMember = @"1";
            _allianceCircleTrendsViewController.isMember = @"1";

            if (_index == 0) {
                [_coverButton setTitle:@"发动态" forState:UIControlStateNormal];
                _coverButton.hidden = NO;
                _allianceCircleActivityViewController.controllerFrame = CGRectMake(YGScreenWidth * 1, 1, _scrollView.width, _scrollView.height-_segmentView.height);
                
            }else
            {
                _coverButton.hidden = YES;
                [_coverButton setTitle:@"发动态" forState:UIControlStateNormal];

            }
            
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
}

@end
