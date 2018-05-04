//
//  BabyDetailsController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/12/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "BabyDetailsController.h"
#import "BabyImageCell.h"
#import "AllianceCircleTrendsCommentDetailTableViewCell.h"
#import "SecondHandCommentModel.h"
#import "SecondHandPayController.h"
#import "SeccondHandExchangeChooseTypeViewController.h"
#import "RealNameCertifyViewController.h"
#import "SeccondCertifyProfileViewController.h"
#import "SecondhandReplaceOtherHomePageViewController.h"

@interface BabyDetailsController () <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    UITableView *_tableView;
    UITableView *_selectTableView;
    UITableView *_selectGoodsTableView;
    NSMutableArray *_replaceWayArray;//弹出的置换方式array
    NSMutableArray *_goodsArray;//弹出的置换方式array
    
    UIView *_changeView;//置换view
    UIView *_changeGoodsView;//置换view
    
    UITextView *myTextView;
    UILabel *textViewPlaceLabel;
    UIView * sendMessageView;
    
    UIButton *_commentButton;
}

@property(nonatomic,strong)UILabel *titleLabel;//标题
@property(nonatomic,strong)UILabel *intructionLabel;//想换。。。
@property(nonatomic,strong)UILabel *detailLabel;//详情描述
@property(nonatomic,strong)UIView *blackView;//黑色透明蒙版
@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)UIButton *favoriteButton; //收藏
@property(nonatomic,strong)NSMutableArray *commentArray;//评论
@property(nonatomic,strong)NSString *commentCountString;//评论总数
@property(nonatomic,strong)NSString *wayText;//选择哪种方式
@property(nonatomic,strong)NSString *goodsIdString;//用来换的商品idString
@property(nonatomic,strong)NSString *selFlagIdString;//1:是自己发布的 2:不是自己发布的
@property(nonatomic,strong)NSString *mechantIdString;//发布人id
@end

@implementation BabyDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.naviTitle = @"宝贝详情";
    
    //标题居中
    UILabel *naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth - 120, 20)];
    naviTitleLabel.textColor = colorWithBlack;
    naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    naviTitleLabel.text = @"宝贝详情" ;
    [naviTitleLabel sizeToFit];
    naviTitleLabel.frame = CGRectMake(YGScreenWidth/2-naviTitleLabel.width/2, 0, naviTitleLabel.width, 20);
    self.navigationItem.titleView = naviTitleLabel;
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [shareButton setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"share_green"] forState:UIControlStateSelected];
    [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    self.favoriteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.favoriteButton setImage:[UIImage imageNamed:@"collect_icon_black"] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"collect_icon_green_finish"] forState:UIControlStateSelected];
    [self.favoriteButton addTarget:self action:@selector(favoriteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:self.favoriteButton];
    self.navigationItem.rightBarButtonItems = @[leftBtnItem,rightBtnItem];
    
    self.blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight)];
    self.blackView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    
    self.imageArray = [NSMutableArray array];
    self.commentArray = [NSMutableArray array];
    _replaceWayArray = [NSMutableArray array];
    _goodsArray = [NSMutableArray array];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self loadData];
}

//加载数据
-(void)loadData
{
    [YGNetService YGPOST:@"CommodityDetail" parameters:@{@"uid":YGSingletonMarco.user.userId,@"mid":self.idString} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        self.dataDic = responseObject;
        
        NSString *huanString = responseObject[@"huan"];
        _replaceWayArray = [huanString componentsSeparatedByString:@","].mutableCopy;
        
        
        self.imageArray = [self.dataDic[@"img"] componentsSeparatedByString:@","].mutableCopy;
        
        self.selFlagIdString = self.dataDic[@"selFlag"];
        self.mechantIdString = self.dataDic[@"mId"];
        
        if ([self.dataDic[@"flag"] isEqualToString:@"1"]) {
            
            self.favoriteButton.selected = YES;
        }else
        {
            self.favoriteButton.selected = NO;
        }
        
        [self configUI];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:@"getReplacementComment" parameters:@{@"mid":self.idString,@"total":self.totalString,@"count":self.countString} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        NSInteger count = [responseObject[@"count"] integerValue];
        
        self.commentCountString = [NSString stringWithFormat:@"%ld",count];
        
        if (((NSArray *)responseObject[@"cList"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        if (headerAction == YES) {
            [_commentArray removeAllObjects];
        }
        [_commentArray addObjectsFromArray:[SecondHandCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"cList"]]];
        //        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:YES];
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - YGBottomMargin - 50) style:UITableViewStyleGrouped];
    [_tableView registerNib:[UINib nibWithNibName:@"BabyImageCell" bundle:nil] forCellReuseIdentifier:@"BabyImageCell"];
    [_tableView registerClass:[AllianceCircleTrendsCommentDetailTableViewCell class] forCellReuseIdentifier:@"AllianceCircleTrendsCommentDetailTableViewCell"];
    _tableView.backgroundColor = colorWithTable;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.estimatedRowHeight = 200;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self configHeader];
    
    if([self.selFlagIdString isEqualToString:@"0"])
    {
        [self configBottomButton];
        [self configCommentView];
    }
    else
    {
        _tableView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight);
    }
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
}

- (void)configCommentView
{
    CGFloat H = YGNaviBarHeight ;
    CGFloat Y = kScreenH - H  - YGNaviBarHeight - YGStatusBarHeight;
    
    sendMessageView = [[UIView alloc]initWithFrame:CGRectMake(0, Y, YGScreenWidth, 70)];
    [self.view addSubview:sendMessageView];
    sendMessageView.hidden =YES;
    
    sendMessageView.backgroundColor =[UIColor whiteColor];
    //输入框
    myTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, YGScreenWidth-10 - 90, 45)];
    myTextView.delegate = self;
    myTextView.backgroundColor = [UIColor whiteColor];
    myTextView.bounces = NO;
    myTextView.tag = 2000;
    myTextView.font = [UIFont systemFontOfSize:15];
    myTextView.textColor = colorWithBlack;
    myTextView.returnKeyType = UIReturnKeyDone;
    myTextView.inputAccessoryView = [UIView new];
    [sendMessageView addSubview:myTextView];
    
    //  placeLabel
    textViewPlaceLabel = [[UILabel alloc]init];
    textViewPlaceLabel.text = @"  说点什么";
    textViewPlaceLabel.numberOfLines = 2;
    textViewPlaceLabel.textColor = colorWithLightGray;
    textViewPlaceLabel.font = [UIFont systemFontOfSize:15];
    textViewPlaceLabel.frame = CGRectMake(10, 10, YGScreenWidth - 100, 30);
    [textViewPlaceLabel sizeToFit];
    [sendMessageView addSubview:textViewPlaceLabel];
    
    UIButton *sendBtn =[[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth - 90, 0, 90, 45)];
    sendBtn.backgroundColor = colorWithMainColor;
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sendMessageView addSubview:sendBtn];
}

-(void)configBottomButton
{
    UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contactButton.backgroundColor = [UIColor whiteColor];
    contactButton.frame = CGRectMake(0, YGScreenHeight - 50 - YGNaviBarHeight - YGStatusBarHeight, YGScreenWidth / 3, 50);
    [contactButton setTitle:@"联系卖家" forState:UIControlStateNormal];
    [contactButton setImage:[UIImage imageNamed:@"unused_connect"] forState:UIControlStateNormal];
    [contactButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    contactButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [contactButton addTarget:self action:@selector(contactClick:) forControlEvents:UIControlEventTouchUpInside];
    [contactButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [self.view addSubview:contactButton];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.backgroundColor = [UIColor whiteColor];
    _commentButton.frame = CGRectMake(YGScreenWidth / 3, YGScreenHeight - 50 - YGNaviBarHeight - YGStatusBarHeight, YGScreenWidth / 3, 50);
    [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [_commentButton setImage:[UIImage imageNamed:@"unused_comment_big"] forState:UIControlStateNormal];
    [_commentButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    [_commentButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    _commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_commentButton addTarget:self action:@selector(commentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commentButton];
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.backgroundColor = [UIColor whiteColor];
    changeButton.frame = CGRectMake(YGScreenWidth / 3 * 2, YGScreenHeight - 50 - YGNaviBarHeight - YGStatusBarHeight, YGScreenWidth / 3, 50);
    [changeButton setTitle:@"我要换" forState:UIControlStateNormal];
    [changeButton setImage:[UIImage imageNamed:@"unused_change"] forState:UIControlStateNormal];
    [changeButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    [changeButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    changeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [changeButton addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenHeight - 50 - YGNaviBarHeight - YGStatusBarHeight, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithLine;
    [self.view addSubview:lineView];
}

-(void)configHeader
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 305)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    //头像按钮
    UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 40)];
    avatarImageView.layer.cornerRadius = 17.5;
    avatarImageView.clipsToBounds = YES;
    avatarImageView.userInteractionEnabled = YES;
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"userImg"]] placeholderImage:YGDefaultImgAvatar];
//    [avatarImageView addTarget:self action:@selector(avatarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:avatarImageView];
    
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarTap)];
    [avatarImageView addGestureRecognizer:avatarTap];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(55, 17, YGScreenWidth - 65, 38)];
    [headerView addSubview:topView];
    
    //昵称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = colorWithBlack;
    nameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    nameLabel.frame = CGRectMake(0, 0, 120, 17.5);
    [topView addSubview:nameLabel];
    nameLabel.text = _dataDic[@"name"];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(0);
        make.top.equalTo(topView.mas_top).offset(0);
        make.height.offset(17.5);
    }];
    
    UIImageView *autonymImageView = [[UIImageView alloc]init];
    autonymImageView.image = [UIImage imageNamed:@"home_playtogether_realname"];
    autonymImageView.frame = CGRectMake(120, 0, 60, 17.5);
    [topView addSubview:autonymImageView];
    [autonymImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(10);
        make.top.equalTo(topView.mas_top).offset(0);
        make.width.offset(60);
        make.height.offset(17.5);
    }];
    
    //时间图片
    UIImageView *timeImageView = [[UIImageView alloc]init];
    timeImageView.image = [UIImage imageNamed:@"unused_time_green"];
    timeImageView.frame = CGRectMake(0, 22, 13, 13);
    [topView addSubview:timeImageView];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = colorWithPlaceholder;
    timeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    timeLabel.frame = CGRectMake(20, 21, topView.frame.size.width - 20, 15);
    [topView addSubview:timeLabel];
    timeLabel.text = [NSString stringWithFormat:@"%@发布 · %@",_dataDic[@"time"],_dataDic[@"address"]];
    
    //线
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, YGScreenWidth, 1)];
    lineLabel.text = @"";
    lineLabel.backgroundColor = colorWithLine;
    [headerView addSubview:lineLabel];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 81, YGScreenWidth - 20, 42)];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = _dataDic[@"title"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self.titleLabel sizeToFit];
    [headerView addSubview:self.titleLabel];
    

    self.intructionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 123, YGScreenWidth - 20, 26)];
    self.intructionLabel.font = [UIFont systemFontOfSize:14.0];
    self.intructionLabel.textColor = colorWithLightGray;
    self.intructionLabel.text = _dataDic[@"wantStr"];
    self.intructionLabel.numberOfLines = 2;
    [self.intructionLabel sizeToFit];
    [headerView addSubview:self.intructionLabel];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 156, YGScreenWidth - 20, 300)];
    self.detailLabel.font = [UIFont systemFontOfSize:15.0];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.textColor = colorWithBlack;
    self.detailLabel.text = _dataDic[@"introduce"];
    [self.detailLabel setAttributedText:[self setContent:self.detailLabel.text]];
    [self.detailLabel sizeToFit];
    
    [headerView addSubview:self.detailLabel];
    
    
    headerView.frame = CGRectMake(0, 0, YGScreenWidth, 156 + self.detailLabel.size.height + 15);
    _tableView.tableHeaderView = headerView;
    
    
}
- (NSMutableAttributedString *)setContent:(NSString *)content
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10]; //设置行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    
    return attributedString;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _selectTableView || tableView == _selectGoodsTableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        
        UIButton *optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        optionButton.frame = CGRectMake(YGScreenWidth - 40, 10, 30, 30);
        [optionButton setImage:[UIImage imageNamed:@"nochoice_btn_gray"] forState:UIControlStateNormal];
        [optionButton setImage:[UIImage imageNamed:@"order_choice_btn_green"] forState:UIControlStateSelected];
        [optionButton addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:optionButton];
        
        if (tableView == _selectTableView) {
            cell.textLabel.text = _replaceWayArray[indexPath.row];
            optionButton.tag = 100 + indexPath.row;
        }
        if (tableView == _selectGoodsTableView) {
            cell.textLabel.text = [_goodsArray[indexPath.row] valueForKey:@"title"];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[_goodsArray[indexPath.row] valueForKey:@"picture"]] placeholderImage:YGDefaultImgSquare];
            optionButton.tag = 1000 + indexPath.row;
        }
        return cell;
    }
    if(indexPath.section == 0)
    {
        BabyImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BabyImageCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.row]] placeholderImage:YGDefaultImgFour_Three];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        cell.picString = self.imageArray[indexPath.row];
        return cell;
    }
    AllianceCircleTrendsCommentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllianceCircleTrendsCommentDetailTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.secondModel = self.commentArray[indexPath.row];
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _selectTableView)
    {
        return _replaceWayArray.count;
    }
    
    if(tableView == _selectGoodsTableView)
    {
        return _goodsArray.count;
    }
    if (section == 0)
    {
        return self.imageArray.count;
    }
    return _commentArray.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == _selectTableView || tableView == _selectGoodsTableView)
    {
        return 1;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _selectTableView || tableView == _selectGoodsTableView)
    {
        return 50;
    }
    if (indexPath.section == 0) {
//        NSData *data0 = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageArray[indexPath.row]]];
//        UIImage *image0 = [UIImage imageWithData:data0];
//        return image0.size.height/image0.size.width * YGScreenWidth;
        return UITableViewAutomaticDimension;
    }
    return [tableView fd_heightForCellWithIdentifier:@"AllianceCircleTrendsCommentDetailTableViewCell" cacheByIndexPath:indexPath configuration:^(AllianceCircleTrendsCommentDetailTableViewCell *cell) {
        cell.secondModel = _commentArray[indexPath.row];
    }];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view;
    view.backgroundColor = colorWithPlateSpacedColor;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView == _selectTableView || tableView == _selectGoodsTableView)
    {
        return 0.0001;
    }
    if (section == 0) {
        return 10;
    }
    return 0.0001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == _selectTableView || tableView == _selectGoodsTableView)
    {
        return nil;
    }
    if (section == 1) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, YGScreenWidth - 20, 40)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.text = [NSString stringWithFormat:@"留言区(%@)",self.commentCountString];
        [headerView addSubview:label];
        return headerView;
    }
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == _selectTableView || tableView == _selectGoodsTableView)
    {
        return 0.0001;
    }
    if (section == 1) {
        return 40;
    }
    return 0.0001;
}

//分享
-(void)shareButtonClick:(UIButton *)button
{
    [YGAppTool shareWithShareUrl:_dataDic[@"url"] shareTitle:_dataDic[@"title"] shareDetail:_dataDic[@"introduce"] shareImageUrl:self.imageArray[0] shareController:self];
}
//收藏
-(void)favoriteButtonClick:(UIButton *)button
{
    [YGNetService showLoadingViewWithSuperView:self.view];
    [YGNetService YGPOST:@"replacementCollection" parameters:@{@"uid":YGSingletonMarco.user.userId,@"mid":self.idString} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        [YGNetService dissmissLoadingView];
        NSLog(@"%@",responseObject);
        
        button.selected = !button.selected;
        
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];
    }];
    
    
}

//我要换
-(void)changeClick:(UIButton *)button
{
//    _replaceWayArray = [NSMutableArray arrayWithObjects:@"以物换",@"以青币换",@"以物钱换", nil];
    
    [self.view addSubview:_blackView];
    
    UIView *changeView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenHeight - 330 - YGStatusBarHeight - YGNaviBarHeight, YGScreenWidth, 330)];
    changeView.backgroundColor = [UIColor whiteColor];
    [_blackView addSubview:changeView];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, YGScreenWidth - 120, 45)];
    titleLabel.text = @"请选择置换方式";
    titleLabel.tag = 2001;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    [titleView addSubview:titleLabel];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(YGScreenWidth - 60, 0, 60, 45);
    [cancleButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    [cancleButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:cancleButton];
    
    [changeView addSubview:titleView];
    
    _selectTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, YGScreenWidth, changeView.frame.size.height - 45 - 50) style:UITableViewStyleGrouped];
    //    [_selectTableView registerClass:[SecondMainCell class] forCellReuseIdentifier:@"SecondMainCell"];
    _selectTableView.backgroundColor = colorWithTable;
    _selectTableView.scrollEnabled = NO;
//    _selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _selectTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _selectTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _selectTableView.sectionHeaderHeight = 0.001;
    _selectTableView.sectionFooterHeight = 0.001;
    _selectTableView.delegate = self;
    _selectTableView.dataSource = self;
    [changeView addSubview:_selectTableView];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, changeView.frame.size.height - 50, YGScreenWidth, 50);
    nextButton.backgroundColor = colorWithMainColor;
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [nextButton addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [changeView addSubview:nextButton];

    
}
//下一步
-(void)nextClick:(UIButton *)button
{
    if (!self.wayText.length) {
        [YGAppTool showToastWithText:@"请选择置换方式!"];
        return;
    }
    if ([self.wayText isEqualToString:@"以青币换"]) {
        SecondHandPayController *vc = [[SecondHandPayController alloc]init];
        vc.payType = @"1";
        vc.idString = self.idString;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([self.wayText isEqualToString:@"以钱换"]) {
        SecondHandPayController *vc = [[SecondHandPayController alloc]init];
        vc.payType = @"2";
        vc.idString = self.idString;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
       [self getselectGoods];
    }
    
}

//以物换
-(void)getselectGoods
{
    [YGNetService YGPOST:@"myMerchandise" parameters:@{@"uid":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        //        _goodsArray = [NSMutableArray arrayWithObjects:@"为啥日式白橡木春木石家家居",@"简介黑白布艺沙",@"小型超声波空气加湿器", nil];
        
        _goodsArray = responseObject[@"merchandise"];
        
        _changeGoodsView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenHeight - 330 - YGStatusBarHeight - YGNaviBarHeight, YGScreenWidth, 330)];
        _changeGoodsView.backgroundColor = [UIColor whiteColor];
        [_blackView addSubview:_changeGoodsView];
        
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, YGScreenWidth - 120, 45)];
        titleLabel.text = @"请选择一种物品";
        titleLabel.tag = 2001;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15.0];
        [titleView addSubview:titleLabel];
        
        UIButton *fanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        fanButton.frame = CGRectMake(0, 0, 60, 45);
        [fanButton setTitle:@"" forState:UIControlStateNormal];
        [fanButton setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
        [fanButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
        [fanButton addTarget:self action:@selector(fanhui:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:fanButton];
        
        UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleButton.frame = CGRectMake(YGScreenWidth - 60, 0, 60, 45);
        [cancleButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
        [cancleButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancleButton addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:cancleButton];
        
        [_changeGoodsView addSubview:titleView];
        
        _selectGoodsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, YGScreenWidth, _changeGoodsView.frame.size.height - 45 - 50) style:UITableViewStyleGrouped];
        //    [_selectTableView registerClass:[SecondMainCell class] forCellReuseIdentifier:@"SecondMainCell"];
        _selectGoodsTableView.backgroundColor = colorWithTable;
//        _selectGoodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _selectGoodsTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
        _selectGoodsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
        _selectGoodsTableView.sectionHeaderHeight = 0.001;
        _selectGoodsTableView.sectionFooterHeight = 0.001;
        _selectGoodsTableView.delegate = self;
        _selectGoodsTableView.dataSource = self;
        [_changeGoodsView addSubview:_selectGoodsTableView];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(0, _changeGoodsView.frame.size.height - 50, YGScreenWidth / 2, 50);
        addButton.backgroundColor = [UIColor whiteColor];
        [addButton setTitle:@"添加" forState:UIControlStateNormal];
        [addButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
        [addButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [addButton addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
        [_changeGoodsView addSubview:addButton];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(YGScreenWidth / 2, _changeGoodsView.frame.size.height - 50, YGScreenWidth / 2, 50);
        confirmButton.backgroundColor = colorWithMainColor;
        [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [_changeGoodsView addSubview:confirmButton];
        
    } failure:^(NSError *error) {
        
    }];
}




//联系卖家
-(void)contactClick:(UIButton *)button
{
    [YGAlertView showAlertWithTitle:@"是否拨打卖家电话？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[NSString stringWithFormat:@"%@",self.dataDic[@"phone"]]];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }
    }];
}

//添加
-(void)addClick:(UIButton *)button
{
    button.userInteractionEnabled = NO;
    
    [YGNetService YGPOST:REQUEST_userInformation parameters:@{@"userId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        button.userInteractionEnabled = YES;
        
        YGSingletonMarco.user.isUploadBaseInfoForSeccondHand =[responseObject[@"user"] boolValue];
        //没填过信息
        if (YGSingletonMarco.user.isUploadBaseInfoForSeccondHand == FALSE )
        {
            // 查询是否认证过
            [YGNetService YGPOST:REQUEST_authentication parameters:@{@"userId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                button.userInteractionEnabled = YES;
                
                YGSingletonMarco.user.isCertified =[responseObject[@"zhiMaXinYong"] boolValue];
                //没认证过
                if (YGSingletonMarco.user.isCertified == NO) {
                    
                    [YGAlertView showAlertWithTitle:@"发布二手置换需要进行身份认证，\n是否现在进行认证？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithPlaceholder,colorWithMainColor] handler:^(NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            RealNameCertifyViewController *controller = [[RealNameCertifyViewController alloc]init];
                            controller.pageType  = @"addSeccondHandExchange";
                            [self.navigationController pushViewController:controller animated:YES];
                            return ;
                        }
                    }];
                }else
                {
                    //认证过 没填过信息
                    SeccondCertifyProfileViewController *vc = [[SeccondCertifyProfileViewController alloc] init];
                    vc.pageType  = @"addSeccondHandExchange";
                    [self.navigationController pushViewController:vc animated:YES];
                    return ;
                    
                }
                
            } failure:^(NSError *error) {
                button.userInteractionEnabled = YES;
                
            }];
            
            
        }else
        {
            //天国信息直接选择分类
            button.userInteractionEnabled = YES;
            SeccondHandExchangeChooseTypeViewController *vc = [[SeccondHandExchangeChooseTypeViewController alloc] init];
            vc.pageType  = @"addSeccondHandExchange";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    } failure:^(NSError *error) {
        button.userInteractionEnabled = YES;
        
    }];
    
    
    
}
//确认
-(void)confirmClick:(UIButton *)button
{
    if (!self.goodsIdString.length) {
        [YGAppTool showToastWithText:@"请选择一种物品!"];
        return;
    }
    [YGNetService YGPOST:@"addInteraction" parameters:@{@"merchandiseId":self.idString,@"tobeChangeId":self.goodsIdString} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        [YGAppTool showToastWithText:@"交易申请成功!"];
        
        self.wayText = @"";
        self.goodsIdString = @"";
        [_blackView removeFromSuperview];
        
    } failure:^(NSError *error) {
        
    }];
    
}
//选择
-(void)optionButtonClick:(UIButton *)button
{
    if (button.tag >= 100 && button.tag < 103) {
        for (int i = 100; i < 100 + _replaceWayArray.count; i++) {
            UIButton *relButton = [_selectTableView viewWithTag:i];
            relButton.selected = NO;
        }
        UITableViewCell *cell = [_selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag - 100 inSection:0]];
        self.wayText = cell.textLabel.text;
    }else
    {
        for (int i = 1000; i < 1000 + _goodsArray.count; i++) {
            UIButton *goodsButton = [_selectGoodsTableView viewWithTag:i];
            goodsButton.selected = NO;
        }
        self.goodsIdString = [_goodsArray[button.tag - 1000] valueForKey:@"id"];
    }
    
    button.selected = YES;
}

//返回上一级
-(void)fanhui:(UIButton *)button
{
    self.wayText = @"以物换";
    self.goodsIdString = @"";
    [_selectGoodsTableView removeFromSuperview];
    [_changeGoodsView removeFromSuperview];
}
//取消
-(void)cancleClick:(UIButton *)button
{
    self.wayText = @"";
    self.goodsIdString = @"";
    [_selectTableView removeFromSuperview];
    [_selectGoodsTableView removeFromSuperview];
    [_changeGoodsView removeFromSuperview];
    [_blackView removeFromSuperview];
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
    //    if (textView.text.length >140)
    //    {
    //        [textView resignFirstResponder];
    //        [YGAppTool showToastWithText:@"输入文字不能多于50字哦！"];
    //    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        sendMessageView.hidden = YES;
        _commentButton.hidden = NO;
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [myTextView becomeFirstResponder];
    
    sendMessageView.hidden =YES;
    
//    _commentButton.hidden =NO;
    
    return YES;
}
- (void)commentButtonAction
{
    sendMessageView.hidden = NO;
    [myTextView becomeFirstResponder];
    
//    _commentButton.hidden =YES;
}

-(void)sendBtnClick
{
    sendMessageView.hidden = YES;
    
    if (myTextView.text.length <1)
    {
        [YGAppTool showToastWithText:@"请输入评价文字"];
        return ;
    }
    if (myTextView.text.length >140)
    {
        [myTextView resignFirstResponder];
        [YGAppTool showToastWithText:@"输入文字不能多于50字哦！"];
        return ;
    }
    [YGNetService YGPOST:@"addReplacementComment" parameters:@{@"mid":self.idString,@"uid":YGSingletonMarco.user.userId,@"comment":myTextView.text} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        [YGAppTool showToastWithText:@"评论成功!"];
        [self refreshActionWithIsRefreshHeaderAction:YES];
        myTextView.text = @"";
        [myTextView resignFirstResponder];

    } failure:^(NSError *error) {
        
    }];
    
    
}

//头像按钮点击
-(void)avatarTap
{
    //查看他人主页
    SecondhandReplaceOtherHomePageViewController * otherHomepage = [[SecondhandReplaceOtherHomePageViewController alloc]init];
    otherHomepage.otherId = self.mechantIdString;
    [self.navigationController pushViewController:otherHomepage animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
