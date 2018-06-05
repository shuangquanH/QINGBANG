//
//  AdvertisementDetailController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AdvertisementDetailController.h"
#import "RecommendCollectionCell.h"
#import "AdvertisementInstructionCell.h"
#import "ApplyImmediatelyController.h"
#import "AdvertisementLocationApplyController.h"
#import "CooperateThingViewController.h"
#import "PanoramicViewController.h"

@interface AdvertisementDetailController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,WKNavigationDelegate,WKUIDelegate>
{
    UITableView *_tableView;
    UIView *_headView;
//    SDCycleScrollView *_adScrollview; //轮播图
    UICollectionView *_collectionView;//滑动列表
    UIImageView *_adImageView;//最上面的广告图
}
@property(nonatomic,strong)NSString *htmlString;
@property(nonatomic,strong)NSString *adNameString;
@property(nonatomic,strong)NSMutableArray *caseArray;//合作案例
@property(nonatomic,strong)NSString *imageString;//最上面的3D图
@property(nonatomic,strong)NSString *picString; //立即申请页图片
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)UILabel *nameLabel;//广告名字
@property(nonatomic,strong)UIButton *collectNavButton;//收藏按钮



@end

@implementation AdvertisementDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"广告位置";
    
    self.caseArray = [NSMutableArray array];
    
    self.collectNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectNavButton.frame = CGRectMake(0, 0, 20, 20);
    self.collectNavButton.titleLabel.text = @"";
    [self.collectNavButton setImage:[UIImage imageNamed:@"collect_icon_black"] forState:UIControlStateNormal];
    [self.collectNavButton setImage:[UIImage imageNamed:@"collect_icon_green_finish"] forState:UIControlStateSelected];
    [self.collectNavButton addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.collectNavButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth / 2)];
    
    [self configUI];
    [self configBottomButtons];
    [self loadData];

    
}

-(void)loadData
{
    [YGNetService YGPOST:REQUEST_AdsDetail parameters:@{@"adsID":self.adsIDString,@"userID":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
        
        self.naviTitle = [[responseObject valueForKey:@"adsDetail"] valueForKey:@"adsName"];
        
        self.picString = [[responseObject valueForKey:@"adsDetail"] valueForKey:@"adsImgIndex"];
        
        self.imageString = [[responseObject valueForKey:@"adsDetail"] valueForKey:@"ads3D"];
        [_adImageView sd_setImageWithURL:[NSURL URLWithString:self.imageString] placeholderImage:YGDefaultImgFour_Three];
        
        self.htmlString = [[responseObject valueForKey:@"adsDetail"] valueForKey:@"adsDetail"];
        self.adNameString = [[responseObject valueForKey:@"adsDetail"] valueForKey:@"adsName"];
        
        if ([[[responseObject valueForKey:@"adsDetail"] valueForKey:@"isCollect"] isEqualToString:@"1"]) {
            self.collectNavButton.selected = YES;
        }else
        {
            self.collectNavButton.selected = NO;
        }
        
        self.caseArray = [responseObject valueForKey:@"cooperation"];
        
        [self configHeader];
        [self configWebView];
        
        [_collectionView reloadData];
        [_tableView reloadData];
       
    } failure:^(NSError *error) {
        
    }];
}


-(void)configBottomButtons
{
    UIButton *contactServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contactServiceButton.frame = CGRectMake(0, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - 50, YGScreenWidth / 2, 50);
    contactServiceButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
    
    [contactServiceButton setTitle:@"联系客服" forState:UIControlStateNormal];
    contactServiceButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    contactServiceButton.backgroundColor = [UIColor whiteColor];
    [contactServiceButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [contactServiceButton setImage:[UIImage imageNamed:@"decorate_nav_icon"] forState:UIControlStateNormal];
    contactServiceButton.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    // 重点位置开始
    contactServiceButton.imageEdgeInsets = UIEdgeInsetsMake(0, contactServiceButton.titleLabel.width + 2.5, 0, -contactServiceButton.titleLabel.width - 2.5);
    contactServiceButton.titleEdgeInsets = UIEdgeInsetsMake(0, -contactServiceButton.currentImage.size.width, 0, -contactServiceButton.currentImage.size.width - contactServiceButton.currentImage.size.width);
    
    [contactServiceButton addTarget:self action:@selector(contactService:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:contactServiceButton];
    
    
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applyButton.frame = CGRectMake(YGScreenWidth / 2, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - 50, YGScreenWidth / 2, 50);
    applyButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
    [applyButton setTitle:@"立即申请" forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    applyButton.backgroundColor = colorWithMainColor;
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyButton addTarget:self action:@selector(applyImdeiatelyClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyButton];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenHeight - 50 - YGNaviBarHeight - YGStatusBarHeight, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithLine;
    [self.view addSubview:lineView];
}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGStatusBarHeight - YGNaviBarHeight - 50 - YGBottomMargin) style:UITableViewStyleGrouped];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}


-(void)configHeader
{
    UIButton *pictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pictureButton setTitle:@"3D全景图" forState:UIControlStateNormal];
    pictureButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    pictureButton.backgroundColor = colorWithMainColor;
    pictureButton.frame = CGRectMake(YGScreenWidth - 15 - 80, 20, 80, 30);
    pictureButton.layer.cornerRadius = 5;
    pictureButton.clipsToBounds = YES;
    [pictureButton addTarget:self action:@selector(seeViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //滑动列表
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(YGScreenWidth * 0.43, YGScreenWidth * 0.28 - 20)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, YGScreenWidth / 2, YGScreenWidth, YGScreenWidth * 0.28) collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    UINib *nib = [UINib nibWithNibName:@"RecommendCollectionCell"
                                bundle: [NSBundle mainBundle]];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"RecommendCollectionCell"];
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, _adImageView.height)];
    
    [_headView addSubview:_adImageView];
    if(self.caseArray.count)
    {
        [_headView addSubview:_collectionView];
        _headView.frame = CGRectMake(0, 0, YGScreenWidth, _adImageView.height + _collectionView.height);

    }
    [_headView addSubview:pictureButton];
    _tableView.tableHeaderView = _headView;
}

//webView
-(void)configWebView
{
    //以下代码适配大小
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight) configuration:wkWebConfig];
    
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.alwaysBounceVertical = YES;
    _tableView.tableFooterView = self.webView;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;
//    [self.webView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"webbg.png"]]];
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.webView loadHTMLString: [NSString stringWithFormat:
                               @"<html> \n"
                               "<head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\">\n"
                               "<style type=\"text/css\"> \n"
                               "max-width:100%%"
                               "</style> \n"
                               "</head> \n"
                               "<body>%@</body> \n"
                               "</html>",self.htmlString
                               ] baseURL:nil];
    
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.text = @"";
        lineLabel.backgroundColor = colorWithLine;
        lineLabel.frame = CGRectMake(0, 39, YGScreenWidth, 1);
        [cell.contentView addSubview:lineLabel];
    }
    cell.textLabel.text = self.adNameString;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    view.backgroundColor = colorWithTable;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma -mark CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.caseArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommendCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendCollectionCell" forIndexPath:indexPath];
    NSString *imageString = [self.caseArray[indexPath.item] valueForKey:@"cooperationImg"];
    [cell.recommendImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:YGDefaultImgFour_Three];
    cell.contentView.clipsToBounds = YES;
    return cell;
}

//推荐滑动列表collectionview的选中方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CooperateThingViewController *vc = [[CooperateThingViewController alloc]init];
    vc.cooperationIdString = [self.caseArray[indexPath.item] valueForKey:@"cooperationID"];
    [self.navigationController pushViewController:vc animated:YES];
}



//收藏
-(void)collect:(UIButton *)button
{
    [YGNetService YGPOST:@"AdsCollect" parameters:@{@"userID":YGSingletonMarco.user.userId,@"adsID":self.adsIDString} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        button.selected = !button.selected;
        if(button.selected == YES)
        {
            [YGAppTool showToastWithText:@"收藏成功!"];
        }else
        {
            [YGAppTool showToastWithText:@"取消收藏成功!"];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//立即申请
-(void)applyImdeiatelyClick:(UIButton *)button
{
    ApplyImmediatelyController *controller = [[ApplyImmediatelyController alloc]init];
    controller.adNameString = self.adNameString;
    controller.picString = self.picString;
    [self.navigationController pushViewController:controller animated:YES];
}

//联系客服
-(void)contactService:(UIButton *)button
{
    [self contactWithCustomerServerWithType:ContactServerTakePicturesEasy button:button];
}

//3D全景图
-(void)seeViewClick:(UIButton *)button
{
//    NSString *urlString = @"http://ww3.sinaimg.cn/large/0060lm7Tly1fl517nx6fsj31kw0sgqow.jpg";
    NSString *urlString = self.imageString;
    
    [YGNetService showLoadingViewWithSuperView:self.view];
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
        NSLog(@"%fKB/%fKB",(long)receivedSize/1024.0,(long)expectedSize/1024.0);
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        [YGNetService dissmissLoadingView];
            PanoramicViewController *vc = [[PanoramicViewController alloc]init];
        vc.zImage = image;
        
        //png格式
        NSData *imagedata=UIImagePNGRepresentation(image);
        //JEPG格式
        //NSData *imagedata=UIImageJEPGRepresentation(m_imgFore,1.0);
        
        NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *documentsDirectory=[paths objectAtIndex:0];
        NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:@"11.png"];
        [imagedata writeToFile:savedImagePath atomically:YES];
        vc.picPathString = savedImagePath;
        [self.navigationController pushViewController:vc animated:YES];
        NSLog(@"download finish!");
    }];
//    vc.picString = self.imageString;

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
        [_tableView setTableFooterView:self.webView];
        [_tableView endUpdates];
        NSLog(@"%f",webViewHeight);
    }];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

