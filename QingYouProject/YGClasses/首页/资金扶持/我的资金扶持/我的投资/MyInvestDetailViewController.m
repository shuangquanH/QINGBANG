//
//  MyInvestDetailViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/11/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyInvestDetailViewController.h"
#import "YGSegmentView.h"

#import "ProgressView.h"
//认购
#import "RSCrowFundingSubscribeViewController.h"
#import "MyInvestUploadProofViewController.h"

@interface MyInvestDetailViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate,YGSegmentViewDelegate>
{
    NSMutableArray * _controllersArray;//Controller数组
    YGSegmentView * _segmentView;//选择器
    YGSegmentView * _movingSegmentView;//选择器
    UIScrollView * _mainScrollView;
//    UIScrollView * _scrollView;
    UILabel *_incomeRightsLabel; //收益权
    UILabel *_addressLabel; //地址
    UIView *_bottomView;
    UILabel  *_contentLabel;
    CrowdFundingHallModel *_model;
    NSString  *_avaterImageUrl;
    NSString  *_userNameString;
    
}


@end

@implementation MyInvestDetailViewController
{
    UIImageView *_projectVideoImageView; //广告轮播
    UIView          *_baseView;
    UILabel *_titleLabel;
    UILabel  *_contenttionLabel;
    
    
    UIImageView *_avaterImageView; //头像
    UILabel *_nameLabel; //昵称
    UIButton *_identityButton; //身份
    CGFloat     _headerHeight;
    ProgressView *_progressView;
    NSArray *_contentArray;
    int   _selectIndex;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

#pragma mark ---- 重写导航条
- (void)configAttribute
{
    self.naviTitle = @"项目详情";
    _model = [[CrowdFundingHallModel alloc] init];
}
-(void)loadData
{
    [self startPostWithURLString:REQUEST_investDetails parameters:@{@"pId":_projectID,@"uId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil];
}

- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    [_model setValuesForKeysWithDictionary:responseObject[@"pro"]];
    _model.amount = responseObject[@"sub"][@"amount"];
    _model.price = responseObject[@"price"];
    _userNameString = responseObject[@"usmuser"][@"name"];
    _avaterImageUrl = responseObject[@"usmuser"][@"img"];
    _model.subscribeId = responseObject[@"schSub"][@"id"];
    _model.subscriptionCopies = responseObject[@"schSub"][@"subscriptionCopies"];
    _model.subscribeType = responseObject[@"schSub"][@"subscribeType"];
    _model.telephone = responseObject[@"usmuser"][@"telephone"];
    _contentArray = @[_model.projectPlan,_model.projectIntroduction,_model.riskPrompt];
    [self configUI];
}
#pragma mark ---- 配置UI
-(void)configUI
{
    _headerHeight = (YGScreenWidth*0.75+115+70);
    
    /********************* _scrollView ***************/
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight -YGNaviBarHeight - YGStatusBarHeight)];
    _mainScrollView.contentSize = CGSizeMake(YGScreenWidth, _mainScrollView.height);
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    
    /********************** 头视图两个按钮 *****************/
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, _headerHeight)];
    _baseView.backgroundColor = colorWithYGWhite;
    [_mainScrollView addSubview:_baseView];
    //广告滚动
    _projectVideoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth*0.56)];
    [_projectVideoImageView sd_setImageWithURL:[NSURL URLWithString:_model.picture] placeholderImage:YGDefaultImgSixteen_Nine];
    [_baseView addSubview:_projectVideoImageView];
    NSArray *typeArry = @[@"",@"待付款",@"",@"待审核",@"已失效"];
    //热门推荐label
    UILabel *statusLabel = [[UILabel alloc]init];
    statusLabel.textColor = colorWithYGWhite;
    statusLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    statusLabel.text = typeArry[[_model.projectState intValue]];
    statusLabel.frame = CGRectMake(0, 20,100, 30);
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.backgroundColor = [colorWithMainColor colorWithAlphaComponent:0.5];
    [_projectVideoImageView addSubview:statusLabel];
    
    if ([_model.projectState isEqualToString:@"2"]) {
        statusLabel.text = typeArry[self.statusType];
        statusLabel.hidden = YES;
     
    }else
    {
        statusLabel.backgroundColor = [colorWithDeepGray colorWithAlphaComponent:0.5];
        statusLabel.text = typeArry[[_model.projectState intValue]];
     
    }
    
    if (self.statusType == 1) {
        statusLabel.text = typeArry[self.statusType];
        statusLabel.hidden = NO;
    }
    if (self.statusType == 2) {
        statusLabel.text = typeArry[self.statusType];
        statusLabel.hidden = NO;
    }
    if (self.statusType == 3) {
        statusLabel.text = typeArry[self.statusType];
        statusLabel.hidden = NO;
    }
//
    //热门推荐label
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _titleLabel.text = _model.projectName;
    _titleLabel.frame = CGRectMake(10, _projectVideoImageView.height+10,YGScreenWidth-30, 35);
    _titleLabel.numberOfLines = 0;
    [_titleLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-20];
    _titleLabel.frame = CGRectMake(10, _projectVideoImageView.height+10,YGScreenWidth-30, _titleLabel.height);
    [_baseView addSubview:_titleLabel];
    
    //热门推荐label
    _contenttionLabel = [[UILabel alloc]init];
    _contenttionLabel.frame = CGRectMake(10,_titleLabel.y+_titleLabel.height+5, YGScreenWidth-20, 15);
    _contenttionLabel.textColor = colorWithDeepGray;
    _contenttionLabel.text = _model.projectDescribe;
    _contenttionLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _contenttionLabel.numberOfLines = 0;
    [_contenttionLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-20];
    _contenttionLabel.frame = CGRectMake(10,_titleLabel.y+_titleLabel.height+5, YGScreenWidth-20, _contenttionLabel.height);
    [_baseView addSubview:_contenttionLabel];
    /********************** 收益权 地址 ********************/
    
    UIImageView *incomeRightsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _contenttionLabel.y+_contenttionLabel.height+5, 20, 20)];
    incomeRightsImageView.image = [UIImage imageNamed:@"steward_capital_label"];
    [incomeRightsImageView sizeToFit];
    [_baseView addSubview:incomeRightsImageView];
    
    //收益权
    _incomeRightsLabel = [[UILabel alloc]initWithFrame:CGRectMake(incomeRightsImageView.x+incomeRightsImageView.width+5, _contenttionLabel.y+_contenttionLabel.height+5, 100, 30)];
    _incomeRightsLabel.textColor = colorWithDeepGray;
    _incomeRightsLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [_baseView addSubview:_incomeRightsLabel];
    _incomeRightsLabel.centery = incomeRightsImageView.centery;
    _incomeRightsLabel.text = _model.calm;
    
    UIImageView *addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(130, incomeRightsImageView.y, 20, 20)];
    addressImageView.image = [UIImage imageNamed:@"steward_capital_address"];
    [addressImageView sizeToFit];
    [_baseView addSubview:addressImageView];
    
    //收益权
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(addressImageView.x+addressImageView.width+5, _incomeRightsLabel.y, YGScreenWidth-(addressImageView.x+addressImageView.width+5-20), 30)];
    _addressLabel.textColor = colorWithDeepGray;
    _addressLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _addressLabel.text = _model.projectAddress;
    [_baseView addSubview:_addressLabel];
    _baseView.centery = addressImageView.centery;
    
    /********************** 进度条 众筹 ********************/
    UIView *progressBaseView = [[UIView alloc] initWithFrame:CGRectMake(10, incomeRightsImageView.y+incomeRightsImageView.height+5, YGScreenWidth-20, 60)];
    [_baseView addSubview:progressBaseView];
    
    _progressView = [[ProgressView alloc] initWithHeight:25 andWidth:YGScreenWidth-20];
    [_progressView setProgress:250.0 andTotal:300.0];
    [progressBaseView addSubview:_progressView];
    
    
    progressBaseView.frame = CGRectMake(progressBaseView.x, progressBaseView.y, progressBaseView.width, progressBaseView.height);
    [_projectVideoImageView sd_setImageWithURL:[NSURL URLWithString:_model.picture] placeholderImage:YGDefaultImgFour_Three];
    [_progressView setProgress:[_model.hasRaise doubleValue] andTotal:[_model.raiseGoal doubleValue]];
    
    
    NSArray *titleArr = @[[NSString stringWithFormat:@"筹集目标¥%@",_model.raiseGoal],[NSString stringWithFormat:@"已筹集¥%@",_model.hasRaise],[NSString stringWithFormat:@"剩余天数%@",_model.raiseDays]];
    
    
    for (int i = 0; i<3; i++)
    {
        //热门推荐label
        UILabel *crowdFundingLabel = [[UILabel alloc]init];
        crowdFundingLabel.textColor = colorWithMainColor;
        crowdFundingLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
        crowdFundingLabel.text = titleArr[i];
        [progressBaseView addSubview:crowdFundingLabel];
        if (i == 0 || i == 1)
        {
            crowdFundingLabel.frame = CGRectMake((YGScreenWidth/3+10)*i, 25,YGScreenWidth/3, 20);
            
        }else
        {
            crowdFundingLabel.frame = CGRectMake(YGScreenWidth/3*i, 25,(YGScreenWidth-20)-YGScreenWidth/3*2, 20);
            crowdFundingLabel.textAlignment = NSTextAlignmentRight;
        }
        
    }
    /********************** 分割线 ********************/
    
    UIView *seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, progressBaseView.y+progressBaseView.height+5, YGScreenWidth, 10)];
    seperateView.backgroundColor = colorWithTable;
    [_baseView addSubview:seperateView];
    
    /********************** 头像 segment ********************/
    
    UIView *headerMiddleView = [[UIView alloc] initWithFrame:CGRectMake(0,seperateView.y+seperateView.height, YGScreenWidth, 60)];
    headerMiddleView.backgroundColor = colorWithYGWhite;
    [_baseView addSubview:headerMiddleView];
    
    //左线
    _avaterImageView = [[UIImageView alloc]init];
    _avaterImageView.frame = CGRectMake(10, 10, 40, 40);
    [_avaterImageView sd_setImageWithURL:[NSURL URLWithString:_avaterImageUrl] placeholderImage:YGDefaultImgAvatar];
    _avaterImageView.layer.borderColor = colorWithLine.CGColor;
    _avaterImageView.layer.borderWidth = 0.5;
    _avaterImageView.backgroundColor = colorWithMainColor;
    _avaterImageView.layer.cornerRadius = 20;
    _avaterImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avaterImageView.clipsToBounds = YES;
    [headerMiddleView addSubview:_avaterImageView];
    
    //昵称
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avaterImageView.x+_avaterImageView.width+5, _avaterImageView.y, YGScreenWidth-30, 20)];
    _nameLabel.text = _userNameString;
    _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _nameLabel.textColor = colorWithBlack;
    [headerMiddleView addSubview:_nameLabel];
    
    //身份
    _identityButton = [[UIButton alloc]initWithFrame:CGRectMake(_nameLabel.x, _nameLabel.y+_nameLabel.height+3, YGScreenWidth-_nameLabel.x-20, 15)];
    [_identityButton setTitle:[NSString stringWithFormat:@"%@ 发布",_model.createDate]   forState:UIControlStateNormal];
    _identityButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    [_identityButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    [_identityButton sizeToFit];
    [headerMiddleView addSubview:_identityButton];
    
    /********************** 选择器 ********************/
    _controllersArray = [[NSMutableArray alloc]initWithArray:@[@"项目方案",@"项目介绍",@"风险提示"]];
    
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0,headerMiddleView.y+headerMiddleView.height, YGScreenWidth, 40) titlesArray:_controllersArray lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
    _segmentView.lineColor = colorWithMainColor;
    [_baseView addSubview:_segmentView];
    
    _headerHeight = _segmentView.y+_segmentView.height;
    _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _headerHeight);

    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,_segmentView.y+_segmentView.height, YGScreenWidth, 100)];
    _bottomView.backgroundColor = colorWithYGWhite;
    [_mainScrollView addSubview:_bottomView];
    
    UIView *seperateLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
    seperateLineView.backgroundColor = colorWithTable;
    [_bottomView addSubview:seperateLineView];
    
    //昵称
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _avaterImageView.y, YGScreenWidth-30, 20)];
    _contentLabel.text = @"我们为您解答";
    _contentLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _contentLabel.textColor = colorWithBlack;
    [_bottomView addSubview:_contentLabel];
    
    _baseView.frame = CGRectMake(_baseView.x, _baseView.y, _baseView.width, _headerHeight);
    
    /****************************** 按钮 **************************/
    

    
    if (self.statusType == 1) {
        _mainScrollView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - 64 - 45-YGBottomMargin);

        UIView *bottomAlphaView  = [[UIView alloc] initWithFrame:CGRectMake(0, YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin-30, YGScreenWidth, 45+YGBottomMargin)];
        bottomAlphaView.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.5];
        [self.view addSubview:bottomAlphaView];
        
        UILabel *subscribesLabel = [[UILabel alloc]init];
        subscribesLabel.textColor = colorWithYGWhite;
        subscribesLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        subscribesLabel.text = [NSString stringWithFormat:@"¥%@0000/份   您认购%@份   共计¥%@万 ",_model.amount,_model.subscriptionCopies,_model.price];
        subscribesLabel.frame = CGRectMake(20, 0,YGScreenWidth-20, 30);
        [bottomAlphaView addSubview:subscribesLabel];
        
        UIView *bottomView  = [[UIView alloc] initWithFrame:CGRectMake(0, YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin, YGScreenWidth, 45+YGBottomMargin)];
        bottomView.backgroundColor = colorWithYGWhite;
        [self.view addSubview:bottomView];
        
        NSArray *btnTitleArr = @[@"联系发起人",@"申请撤投",@"上传凭证"];
        for (int i = 0; i<3; i++)
        {
            UIButton *coverButton = [[UIButton alloc]init];
            coverButton.tag = 1000+i;
            [coverButton addTarget:self action:@selector(contanctOrCancleInvetOrSubscribeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            coverButton.backgroundColor = colorWithYGWhite;
            coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            [bottomView addSubview:coverButton];
            [coverButton setTitle:btnTitleArr[i] forState:UIControlStateNormal];
            [coverButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            [coverButton setTitleEdgeInsets:UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0)];
            coverButton.frame = CGRectMake(YGScreenWidth/3*i, 0, YGScreenWidth/3, 45+YGBottomMargin);

            if (i == 2)
            {
                coverButton.backgroundColor = colorWithMainColor;
                [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
            }
            
            UIView *coverLineView  = [[UIView alloc] initWithFrame:CGRectMake(coverButton.x, 0, 1, 45+YGBottomMargin)];
            coverLineView.backgroundColor = colorWithLine;
            [bottomView addSubview:coverLineView];

        }
        UIButton *saveBtn = [bottomView viewWithTag:1001];
        saveBtn.selected = [_model.colFlag boolValue];
    }
    _movingSegmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0,0, YGScreenWidth, 40) titlesArray:_controllersArray lineColor:colorWithMainColor delegate:self];
    _movingSegmentView.backgroundColor = colorWithYGWhite;
    _movingSegmentView.lineColor = colorWithMainColor;
    [self.view addSubview:_movingSegmentView];
    _movingSegmentView.hidden = YES;
    
    
    //默认第0页
    [self segmentButtonClickWithIndex:0];
}


#pragma mark ---- 改变当前Controller
-(void)segmentButtonClickWithIndex:(int)buttonIndex
{
    //    [self loadControllerWithIndex:buttonIndex];
    [_segmentView selectButtonWithIndex:buttonIndex];
    [_movingSegmentView selectButtonWithIndex:buttonIndex];
    if (_contentArray.count >0) {
        CGFloat height = [self getLabelHeightWithText:_contentArray[buttonIndex] withLabel:_contentLabel];
        _contentLabel.frame = CGRectMake(_contentLabel.x, _contentLabel.y, _contentLabel.width, height+20);
        _bottomView.frame = CGRectMake(_bottomView.x, _bottomView.y, _bottomView.width, _contentLabel.height+20);
        _mainScrollView.contentSize = CGSizeMake(YGScreenWidth, _bottomView.y+_bottomView.height+20);
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _mainScrollView) {
        //页面没有加载的时候不进行调整
        if (!self.view.window) {
            
            return;
        }
        
        CGFloat offsetY = scrollView.contentOffset.y;
        
        //上拉加载更多（头部还没有隐藏），动态移动header
        if (offsetY >= _headerHeight)
        {
            [UIView animateWithDuration:1 animations:^{
                _movingSegmentView.hidden = NO;
            }];
        }else
        { //下拉刷新
            [UIView animateWithDuration:1 animations:^{
                _movingSegmentView.hidden = YES;
            }];
            
        }
    }
}
//- (void)changeFatherViewContentSize:(CGSize)contentSize
//{
//    _scrollView.frame = CGRectMake(_scrollView.x, _scrollView.y, _scrollView.width, contentSize.height);
//    _scrollView.contentSize = contentSize;
//    _mainScrollView.contentSize =CGSizeMake(contentSize.width, contentSize.height+_headerHeight);
//}

#pragma mark ---- 按钮点击
//分享按钮
- (void)contanctOrCancleInvetOrSubscribeBtnAction:(UIButton *)btn
{
    //1000 交流群 1001收藏
    if (btn.tag == (1000+2))
    {
        MyInvestUploadProofViewController *vc = [[MyInvestUploadProofViewController alloc] init];
        vc.projectID = self.projectID;
        [self.navigationController pushViewController:vc animated:YES];

        
    }
    if (btn.tag == 1001)
    {
        [YGAlertView  showAlertWithTitle:@"是否确定撤投此项目？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithDeepGray,colorWithMainColor] handler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
          
                [self.navigationController popViewControllerAnimated:YES];

            }else
            {
                [YGNetService YGPOST:REQUEST_revokeInvest parameters:@{@"pId":_projectID,@"uId":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:nil success:^(id responseObject) {
                    [self back];
                } failure:^(NSError *error) {
                    
                }];
            }
        }];
  
    }
    if (btn.tag == 1000)
    {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_model.telephone];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
    
    
}



@end
