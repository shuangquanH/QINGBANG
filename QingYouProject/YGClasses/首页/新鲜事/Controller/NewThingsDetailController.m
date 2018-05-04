//
//  NewThingsDetailController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/16.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "NewThingsDetailController.h"
#import <WebKit/WebKit.h>
#import "NewThingsCommentCell.h"
#import <IQKeyboardManager.h>
#import "CommentModel.h"
#import "MoreCommentViewController.h"

@interface NewThingsDetailController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,WKUIDelegate,UITextFieldDelegate>
{
    NSMutableArray *_listArray;
    UITableView *_tableView;
    NSMutableArray *_commentArray;
    UIView *_bottomCommentView; //最下面的写评论栏
    BOOL _wasKeyboardManagerEnabled;
}

@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)NSDictionary *detailDictionary;//详情结果字典
@property(nonatomic,strong)UIView *detailHeaderView;//头视图
@property(nonatomic,strong)UILabel *titleLabel;//标题
@property(nonatomic,strong)UILabel *intructionLabel;//来源日期
@property(nonatomic,strong)UIButton *praiseButton;//赞
@property(nonatomic,strong)UITextField *commenttextField; //评论框
@property(nonatomic,strong)NSString *firstIdString; //评论一级id
@property(nonatomic,strong)NSString *secondIdString; //评论二级id
@property(nonatomic,strong)UIButton *favoriteButton;//收藏
@property(nonatomic,strong)UIView *seperateView;//分割线
@end

@implementation NewThingsDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新鲜事";
 
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
    
    _listArray = [NSMutableArray array];
    
    //tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - 50 - YGBottomMargin) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[NewThingsCommentCell class] forCellReuseIdentifier:@"NewThingsCommentCell"];
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = colorWithYGWhite;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    if (@available(iOS 11.0, *)) {
        
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:_tableView];
    [self loadData];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [self refreshActionWithIsRefreshHeaderAction:YES];
    
    
    
    _bottomCommentView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenHeight - 50 - YGNaviBarHeight - YGStatusBarHeight - YGBottomMargin, YGScreenWidth, 50 + YGBottomMargin)];
    _bottomCommentView.backgroundColor = [UIColor whiteColor];
    self.commenttextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 10, YGScreenWidth - 65, 30)];
    self.commenttextField .placeholder = @"   写评论……";
    [self.commenttextField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    self.commenttextField .backgroundColor = YGUIColorFromRGB(0xf5f5f5, 1);
    self.commenttextField .layer.cornerRadius = 5;
    self.commenttextField .clipsToBounds = YES;
    self.commenttextField .delegate = self;
    self.commenttextField.inputAccessoryView = [[UIView alloc]init];
    self.commenttextField.returnKeyType = UIReturnKeyDone;
    [_bottomCommentView addSubview:self.commenttextField];
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(YGScreenWidth - 50, 0, 50, 50);
    [commentButton setTitle:@"发送" forState:UIControlStateNormal];
    [commentButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [commentButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomCommentView addSubview:commentButton];
    
    [self.view addSubview:_bottomCommentView];
    
//    [self configBottomButton];
    
    
}

//发送评论
-(void)sendMessage:(UIButton *)button
{
    if (!self.commenttextField.text.length) {
        [YGAppTool showToastWithText:@"评论信息不能为空哦!"];
        return;
    }
    if ([self.commenttextField.placeholder isEqualToString:@"   写评论……"]) {
        self.firstIdString = @"";
        self.secondIdString = @"";
    }
    [YGNetService YGPOST:@"AddFreshNewsComment" parameters:@{@"freshNewsId":self.idString,@"firstId":self.firstIdString,@"secondId":self.secondIdString,@"userid":YGSingletonMarco.user.userId,@"content":self.commenttextField.text} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        [self.commenttextField resignFirstResponder];
        
//        self.commenttextField.placeholder = @" 写评论……";
        self.commenttextField.text = @"";
//        self.firstIdString = @"";
//        self.secondIdString = @"";
        if ([[responseObject valueForKey:@"result"] integerValue]) {
            [YGAppTool showToastWithText:@"评论成功!"];
            [self refreshActionWithIsRefreshHeaderAction:YES];
        }

    } failure:^(NSError *error) {
        
    }];
    
    
}



-(void)loadData
{
    [YGNetService YGPOST:@"FreshNewsDetail" parameters:@{@"id":self.idString,@"userid":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        _detailDictionary = responseObject[@"FreshNews"];
        if ([[_detailDictionary valueForKey:@"status"] isEqualToString:@"1"]) {
            self.favoriteButton.selected = YES;
        }
        else
        {
            self.favoriteButton.selected = NO;
        }
        
        if (self.detailHeaderView == nil) {
            [self configHeader];
        }else
        {
            [self.praiseButton setTitle:[self.detailDictionary valueForKey:@"count"] forState:UIControlStateNormal];
        }
    } failure:^(NSError *error) {
        
    }];
}

//webView
-(void)configHeader
{
    self.detailHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight)];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, YGScreenWidth - 20, 50)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = [_detailDictionary valueForKey:@"name"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self.detailHeaderView addSubview:self.titleLabel];
    
    self.intructionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, YGScreenWidth - 20, 20)];
    self.intructionLabel.font = [UIFont systemFontOfSize:13.0];
    self.intructionLabel.textColor = colorWithLightGray;
    self.intructionLabel.text = [NSString stringWithFormat:@"%@ %@",[_detailDictionary valueForKey:@"source"],[_detailDictionary valueForKey:@"time"]];
    [self.detailHeaderView addSubview:self.intructionLabel];
    
    
    //以下代码适配大小
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 85, YGScreenWidth, 300) configuration:wkWebConfig];
    
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.alwaysBounceVertical = YES;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO]; 
    [self.webView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"webbg.png"]]];
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.webView loadHTMLString: [NSString stringWithFormat:
                                   @"<html> \n"
                                   "<head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\">\n"
                                   "<style type=\"text/css\"> \n"
                                   "max-width:100%%"
                                   "</style> \n"
                                   "</head> \n"
                                   "<body>%@</body> \n"
                                   "</html>",[self.detailDictionary valueForKey:@"content"]
                                   ] baseURL:nil];
    [self.detailHeaderView addSubview:self.webView];
    
    self.praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.praiseButton.frame = CGRectMake(0, self.webView.height + 85, YGScreenWidth, 50);
    [self.praiseButton setTitle:[self.detailDictionary valueForKey:@"count"] forState:UIControlStateNormal];
    [self.praiseButton setImage:[UIImage imageNamed:@"zan_black"] forState:UIControlStateNormal];
    [self.praiseButton setImage:[UIImage imageNamed:@"zan_green"] forState:UIControlStateSelected];
    [self.praiseButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    [self.praiseButton setTitleColor:colorWithDeepGray forState:UIControlStateSelected];
    [self.praiseButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    self.praiseButton.layer.borderColor = colorWithLine.CGColor;
    self.praiseButton.layer.borderWidth = 0.5; 
    
    if([[self.detailDictionary valueForKey:@"state"] isEqualToString:@"1"])
    {
        self.praiseButton.selected = YES;
    }
    else
    {
        self.praiseButton.selected = NO;
    }
    [self.praiseButton addTarget:self action:@selector(praiseButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.detailHeaderView addSubview:self.praiseButton];
    
    self.seperateView = [[UIView alloc]init];
    self.seperateView .frame = CGRectMake(0, self.webView.height + 85 + 50, YGScreenWidth, 10);
    self.seperateView .backgroundColor = colorWithPlateSpacedColor;
    [self.detailHeaderView addSubview:self.seperateView ];
    
    _tableView.tableHeaderView = self.detailHeaderView;
}

//底部悬浮按钮
-(void)configBottomButton
{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundImage:[UIImage imageNamed:@"home_freshnews_comment_add"] forState:UIControlStateNormal];
    addButton.frame = CGRectMake(YGScreenWidth - 15 - 60, YGScreenHeight - YGStatusBarHeight - YGNaviBarHeight - 120, 60, 60);
    UIPanGestureRecognizer *panTouch = [[UIPanGestureRecognizer  alloc]initWithTarget:self action:@selector(handlePan:)];
    [addButton addGestureRecognizer:panTouch];
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
//    [self endRefreshWithScrollView:_tableView];
    
    [YGNetService YGPOST:@"QueryFreshNewsComment" parameters:@{@"freshNewsId":self.idString,@"userid":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if (((NSArray *)responseObject[@"list"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }
        [_listArray addObjectsFromArray: [CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
//        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:YES];
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    [_tableView reloadData];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [tableView fd_heightForCellWithIdentifier:@"NewThingsCommentCell" cacheByIndexPath:indexPath configuration:^(NewThingsCommentCell *cell) {
        cell.fd_enforceFrameLayout = YES;
        NSArray *commentArray = [_listArray[indexPath.section] valueForKey:@"list"];
        [cell setModel:commentArray[indexPath.row]];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *commentArray = [_listArray[section] valueForKey:@"list"];
    if (commentArray.count >= 2) {
        return 2;
    }
    else
    {
        return commentArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewThingsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewThingsCommentCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.fd_enforceFrameLayout = YES;
    NSArray *commentArray = [_listArray[indexPath.section] valueForKey:@"list"];
    [cell setModel:commentArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    if (_listArray.count) {
        headerView = [self headerViewWithData:_listArray[section] andSection:section];
    }
    return headerView.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self headerViewWithData:_listArray[section] andSection:section];
}

- (UIView *)headerViewWithData:(CommentModel *)model andSection:(NSInteger)section
{
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    //左线
    UIImageView *leftImageView = [[UIImageView alloc]init];
    if (_listArray.count) {
        [leftImageView sd_setImageWithURL:[NSURL URLWithString:[_listArray[section] valueForKey:@"userImg"]] placeholderImage:[UIImage imageNamed:@"defaultavatar"]];
    }
    leftImageView.frame = CGRectMake(10, 20, 50, 50);
    leftImageView.layer.cornerRadius = 25;
    leftImageView.clipsToBounds = YES;
    leftImageView.layer.borderColor = colorWithLine.CGColor;
    leftImageView.layer.borderWidth = 0.5;
    leftImageView.backgroundColor = colorWithMainColor;
    leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    [headerView addSubview:leftImageView];
    
    //热门推荐label
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    titleLabel.text = model.userName;
    titleLabel.frame = CGRectMake(leftImageView.x+leftImageView.width+10, leftImageView.y,YGScreenWidth-100-15, 20);
    [headerView addSubview:titleLabel];
    
    //点赞
    UIButton *zanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    zanButton.frame = CGRectMake(YGScreenWidth - 80, leftImageView.y - 5, 80, 25);
    [zanButton setTitle:model.count forState:UIControlStateNormal];
    [zanButton setImage:[UIImage imageNamed:@"zan_black"] forState:UIControlStateNormal];
    [zanButton setImage:[UIImage imageNamed:@"zan_green"] forState:UIControlStateSelected];
    [zanButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    [zanButton setTitleColor:colorWithDeepGray forState:UIControlStateSelected];
    [zanButton.titleLabel setFont:[UIFont systemFontOfSize:YGFontSizeSmallTwo]];
    if([[_listArray[section] valueForKey:@"state"] isEqualToString:@"0"])
    {
        zanButton.selected = NO;
    }
    if([[_listArray[section] valueForKey:@"state"] isEqualToString:@"1"])
    {
        zanButton.selected = YES;
    }
    zanButton.tag = section;
    [zanButton addTarget:self action:@selector(zanCommentClick:) forControlEvents:UIControlEventTouchUpInside];
    zanButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [headerView addSubview:zanButton];
    
    
    //内容
    UILabel *describeLabel = [[UILabel alloc]init];
    describeLabel.frame = CGRectMake(titleLabel.x,titleLabel.y+titleLabel.height+5 , YGScreenWidth-100, 0);
    describeLabel.textColor = colorWithBlack;
    describeLabel.text = model.content;
    describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    describeLabel.numberOfLines = 0;
    [describeLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-100];
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [describeLabel.text length])];
    //attributedText设置后之前设置的都失效
    describeLabel.attributedText = attributedString;
    
    [headerView addSubview:describeLabel];
    
    //时间label
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.frame = CGRectMake(titleLabel.x,describeLabel.y+describeLabel.height+5 , 100, 20);
    dateLabel.textColor = colorWithDeepGray;
    dateLabel.text = model.time;
    dateLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    dateLabel.numberOfLines = 0;
    [dateLabel sizeToFit];
    dateLabel.frame = CGRectMake(titleLabel.x,describeLabel.y+describeLabel.height+5 , dateLabel.width, 20);
    [headerView addSubview:dateLabel];
    
    //大button
    UIButton *replyButton = [[UIButton alloc]initWithFrame:CGRectMake(dateLabel.x+dateLabel.width+10, dateLabel.y, 60, 20)];
    [replyButton addTarget:self action:@selector(replyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [replyButton setTitle:@"回复" forState:UIControlStateNormal];
    replyButton.tag = section;
    [replyButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    replyButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    replyButton.contentMode = UIViewContentModeLeft;
    [headerView addSubview:replyButton];
    replyButton.centery = dateLabel.centery;
    
    headerView.frame = CGRectMake(0, 0, YGScreenWidth, (20+describeLabel.height+20+10)>60?(20+describeLabel.height+10+20+20 + 10):60);
    return headerView;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth*0.7)];
    //大button
    UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(80, 0, 80, 40)];
    [coverButton addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [coverButton setTitle:@"查看全部评论" forState:UIControlStateNormal];
    [coverButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    coverButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    coverButton.tag = section;
    [footerView addSubview:coverButton];
    
    NSArray *commentArray = [_listArray[section] valueForKey:@"list"];
    if (commentArray.count > 2) {
        return footerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSArray *commentArray = [_listArray[section] valueForKey:@"list"];
    if (commentArray.count > 2) {
        return 30;
    }
    return 0.0001;
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    //    [self.webView loadHTMLString:self.htmlString baseURL:nil];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载完成之后调用 此方法会调用多次
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // 禁止放大缩小
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
    __block CGFloat webViewHeight;
    
    //document.body.scrollHeight
    //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        // 此处js字符串采用scrollHeight而不是offsetHeight是因为后者并获取不到高度，看参考资料说是对于加载html字符串的情况下使用后者可以(@"document.getElementById(\"content\").offsetHeight;")，但如果是和我一样直接加载原站内容使用前者更合适
        //获取页面高度，并重置webview的frame
        webViewHeight = [result doubleValue];
        webView.height = webViewHeight;
        [_tableView beginUpdates];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.detailHeaderView).offset(10);
            make.right.mas_equalTo(self.detailHeaderView).offset(-10);
            make.top.mas_equalTo(self.detailHeaderView.mas_top).offset(15);
        }];
        [self.intructionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(self.detailHeaderView).offset(10);
            make.right.mas_equalTo(self.detailHeaderView).offset(-10);
            make.height.mas_equalTo(20);
        }];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.intructionLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(self.detailHeaderView).offset(0);
            make.right.mas_equalTo(self.detailHeaderView).offset(0);
        }];
        [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.webView.mas_bottom).offset(0);
            make.left.mas_equalTo(self.detailHeaderView).offset(0);
            make.right.mas_equalTo(self.detailHeaderView).offset(0);
            make.height.mas_equalTo(50);
        }];
        [self.seperateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.praiseButton.mas_bottom).offset(0);
            make.left.mas_equalTo(self.detailHeaderView).offset(0);
            make.right.mas_equalTo(self.detailHeaderView).offset(0);
            make.bottom.mas_equalTo(self.detailHeaderView.mas_bottom).offset(0);
            make.height.mas_equalTo(10);
        }];
        
        self.detailHeaderView.frame = CGRectMake(0, 0, YGScreenWidth, self.titleLabel.frame.size.height + webViewHeight + 90 + 10 + 5);
        
        [_tableView endUpdates];
        NSLog(@"%f",webViewHeight);
    }];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (self.secondIdString.length == 0 || self.firstIdString.length == 0) {
//        self.firstIdString = @"";
//        self.secondIdString = @"";
//    }
//}
-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    self.commenttextField.placeholder = @"   写评论……";
//    self.commenttextField.text  = @"";
    self.firstIdString = @"";
    self.secondIdString = @"";

    [self.commenttextField resignFirstResponder];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.commenttextField.placeholder = @"   写评论……";
//    self.commenttextField.text  = @"";
    self.firstIdString = @"";
    self.secondIdString = @"";
    [self.commenttextField resignFirstResponder];

    return YES;
}

//悬浮评论按钮点击
-(void)addButtonClick:(UIButton *)button
{
    [self.commenttextField becomeFirstResponder];
    self.commenttextField.placeholder = @"   写评论……";
//    self.commenttextField.text  = @"";
    self.firstIdString = @"";
    self.secondIdString = @"";
}

//二级评论回复别人
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.commenttextField becomeFirstResponder];
    NSArray *commentArray = [_listArray[indexPath.section] valueForKey:@"list"];
    self.commenttextField.placeholder = [NSString stringWithFormat:@" 回复 %@:",[commentArray[indexPath.row] valueForKey:@"userName"]];
    self.firstIdString = [_listArray[indexPath.section] valueForKey:@"ID"];
    self.secondIdString = [commentArray[indexPath.row] valueForKey:@"ID"];
}

//回复评论
-(void)replyButtonClick:(UIButton *)button
{
    
    self.commenttextField.placeholder = [NSString stringWithFormat:@" 回复 %@:",[_listArray[button.tag] valueForKey:@"userName"]];
    [self.commenttextField becomeFirstResponder];
    self.firstIdString = [_listArray[button.tag] valueForKey:@"ID"];
    self.secondIdString = @"";
    
}
//查看更多评论
- (void)coverButtonClick:(UIButton *)btn
{
    MoreCommentViewController *vc = [[MoreCommentViewController alloc]init];
    vc.idString = self.idString;
    vc.commentIdString = [_listArray[btn.tag] valueForKey:@"ID"];
    [self.navigationController pushViewController:vc animated:YES];
}

//新鲜事点赞
-(void)praiseButtonClick:(UIButton *)button
{
    if([[self.detailDictionary valueForKey:@"state"] isEqualToString:@"1"])
    {
        return;
    }
    [YGNetService YGPOST:@"ADDFreshNewsLike" parameters:@{@"freshNewsId":self.idString,@"userid":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if([[responseObject valueForKey:@"result"] isEqualToString:@"1"])
        {
            self.praiseButton.selected = YES;
        }
        [self loadData];
        
    } failure:^(NSError *error) {
        
    }];
}
//评论点赞
-(void)zanCommentClick:(UIButton *)button
{
    if([[_listArray[button.tag] valueForKey:@"state"] isEqualToString:@"1"])
    {
        return;
    }
    [YGNetService YGPOST:@"ADDFreshNewsCommentLike" parameters:@{@"freshNewsCommentId":[_listArray[button.tag] valueForKey:@"ID"],@"userid":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        [self refreshActionWithIsRefreshHeaderAction:YES];
        
    } failure:^(NSError *error) {
        
    }];
}


//分享
-(void)shareButtonClick:(UIButton *)button
{
    [YGAppTool shareWithShareUrl:_detailDictionary[@"url"] shareTitle:[_detailDictionary valueForKey:@"name"] shareDetail:@"" shareImageUrl:@"" shareController:self];
}
//收藏
-(void)favoriteButtonClick:(UIButton *)button
{
    [YGNetService showLoadingViewWithSuperView:self.view];
    [YGNetService YGPOST:@"FreshNewsCollect" parameters:@{@"freshNewsId":self.idString,@"userid":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        [YGNetService dissmissLoadingView];
        
        if ([[responseObject valueForKey:@"state"] isEqualToString:@"1"]) {
            [YGAppTool showToastWithText:@"收藏成功!"];
        }else
        {
            [YGAppTool showToastWithText:@"取消收藏成功!"];
        }
        
        [self loadData];
        
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];
    }];
}



//悬浮按钮拖动手指移动
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    //视图前置操作
    [recognizer.view.superview bringSubviewToFront:recognizer.view];
    
    CGPoint center = recognizer.view.center;
    CGFloat cornerRadius = recognizer.view.frame.size.width / 2;
    CGPoint translation = [recognizer translationInView:self.view];
    //NSLog(@"%@", NSStringFromCGPoint(translation));
    recognizer.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        //计算速度向量的长度，当他小于200时，滑行会很短
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        //NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult); //e.g. 397.973175, slideMult: 1.989866
        
        //基于速度和速度因素计算一个终点
        float slideFactor = 0.1 * slideMult;
        CGPoint finalPoint = CGPointMake(center.x + (velocity.x * slideFactor),
                                         center.y + (velocity.y * slideFactor));
        //限制最小［cornerRadius］和最大边界值［self.view.bounds.size.width - cornerRadius］，以免拖动出屏幕界限
        finalPoint.x = MIN(MAX(finalPoint.x, cornerRadius),
                           self.view.bounds.size.width - cornerRadius);
        finalPoint.y = MIN(MAX(finalPoint.y, cornerRadius),
                           self.view.bounds.size.height - cornerRadius);
        
        //使用 UIView 动画使 view 滑行到终点
        [UIView animateWithDuration:slideFactor*2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             recognizer.view.center = finalPoint;
                         }
                         completion:nil];
    }
}



@end
