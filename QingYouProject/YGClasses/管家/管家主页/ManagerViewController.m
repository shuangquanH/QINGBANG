//
//  FindHouseViewController.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/1/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ManagerViewController.h"
#import "NetManagerVC.h"//网络管家
#import "LDManagerHeaderCell.h"//轮播图下面的视图
#import "AdvertisementPageViewController.h"//广告位申请
#import "LDPlayPayViewController.h"//一起玩 : 立即申请
#import "OfficePurchaseViewController.h"//办公采购
#import "DecorationCarMainController.h"//装修直通车
#import "MeetingAreaChooseViewController.h"//会议室预订
#import "PropertyRepairViewController.h"
#import "HomePageLegalServiceViewController.h"

@interface ManagerViewController ()<UITableViewDelegate,SDCycleScrollViewDelegate,UITableViewDataSource>
/** 轮播图  */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
/** tableview */
@property (nonatomic,strong) UITableView * tableView;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;
/** footerView  */
@property (nonatomic,strong) UIView * footerView;
/** titleButton数据源  */
@property (nonatomic,strong) NSArray * titleArray;

@property (nonatomic,strong) LDManagerHeaderCell * cell;


@end

@implementation ManagerViewController
#pragma mark - 程序入口
- (void)viewDidLoad {
    [super viewDidLoad];
  
    //添加tableView
    [self.view addSubview:self.tableView];
    
    //设置导航栏
    self.naviTitle = @"管家";
    
    //网络请求

    [self createRefreshWithScrollView:_tableView containFooter:NO];
    [_tableView.mj_header beginRefreshing];
    
}
#pragma mark - 网络请求
//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    [YGNetService YGPOST:@"getHomepage" parameters:@{}  showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        NSArray * aList = responseObject[@"aList"];
        NSMutableArray * topArry = [NSMutableArray new];
        [topArry addObject:[NSString stringWithFormat:@"%@",aList[0][@"imgUrl"]]];
        self.cycleScrollView.imageURLStringsGroup = topArry;

        [self.cell.button sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",aList[1][@"imgUrl"]]] forState:UIControlStateNormal placeholderImage:YGDefaultImgHorizontal];

        for (UIImageView * image in self.footerView.subviews )
        {
            switch (image.tag) {
                case 100:
                        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",aList[2][@"imgUrl"]]] placeholderImage:YGDefaultImgTwo_One];
                    break;
                case 101:
                    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",aList[3][@"imgUrl"]]] placeholderImage:YGDefaultImgTwo_One];
                    break;
                case 102:
                    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",aList[4][@"imgUrl"]]] placeholderImage:YGDefaultImgTwo_One];
                    break;
                case 103:
                    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",aList[5][@"imgUrl"]]] placeholderImage:YGDefaultImgTwo_One];
                    break;
                case 104:
                    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",aList[6][@"imgUrl"]]] placeholderImage:YGDefaultImgTwo_One];
                    break;
//                case 105:
//                    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",aList[7][@"imgUrl"]]] placeholderImage:YGDefaultImgTwo_One];
//                    break;
                default:
                    break;
            }
        }
        [self endRefreshWithScrollView:_tableView];
    } failure:^(NSError *error) {
        [self endRefreshWithScrollView:_tableView];

    }];
}

#pragma mark - tableViewDelegate And DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        self.cell = [tableView dequeueReusableCellWithIdentifier:LDManagerHeaderCellId];
        return self.cell;
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return 165;
    
}
#pragma mark - cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if(![self loginOrNot])
        return;
    LDLogFunc
    
}

static NSString * const LDManagerHeaderCellId = @"LDManagerHeaderCellId";
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - 50) style:UITableViewStylePlain];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //tableHeaderView
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.ld_width, floorf(kScreenW / Banner_W_H_Scale)) delegate:self placeholderImage:YGDefaultImgTwo_One];
        
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScrollTimeInterval = 3;

        _tableView.tableHeaderView = self.cycleScrollView;
        _cycleScrollView.backgroundColor = kClearColor;
        _tableView.showsVerticalScrollIndicator = NO;
        //注册cell
        [_tableView registerClass:[LDManagerHeaderCell class] forCellReuseIdentifier:LDManagerHeaderCellId];

        //五个子试图frame
        CGFloat bigImageY = 50;
        CGFloat bigImageW = (kScreenW - 3 * LDHPadding) / 2;
        CGFloat bigImage_W_H = 34.0 / 19.0;
        CGFloat bigImageH = bigImageW / bigImage_W_H;
        
        CGFloat smallImageY = bigImageY + bigImageH + LDVPadding;
        CGFloat smallImageW = (kScreenW - 4 * LDHPadding) / 3;
        CGFloat smallImage_W_H = 220.0 / 126.0;
        CGFloat smallImageH = smallImageW / smallImage_W_H;
        //tableFooterView高度
        CGFloat footerH = smallImageY + smallImageH + 15 + smallImageH + LDHPadding ;

        self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, footerH)];
        _tableView.tableFooterView = self.footerView;
        //分割线
        UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, LDVPadding)];
        [self.footerView addSubview:topLine];
        topLine.backgroundColor = LDRGBColor(236, 236, 245);
        //为您推荐
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding, LDVPadding *2, kScreenW - 20, 18)];
        lable.text = @"为您推荐";
//        lable.font = LDFont(16);
//        lable.font = [UIFont boldSystemFontOfSize:16];
        [lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [self.footerView addSubview:lable];

        for (int i = 0; i < 2; i++) {
            
            UIImageView * imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake(LDHPadding + (bigImageW + LDHPadding) * i, bigImageY, bigImageW, bigImageH);
            imageView.tag = 100 + i;
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 5;
            [self.footerView addSubview:imageView];

            UIButton * imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [imageButton setTitle:self.titleArray[i] forState:UIControlStateNormal];
            imageButton.tag = 200 + i;
            [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            imageButton.layer.masksToBounds = YES;
            imageButton.layer.cornerRadius = 5;
            imageButton.frame = CGRectMake(LDHPadding + (bigImageW + LDHPadding) * i, bigImageY, bigImageW, bigImageH);
            imageButton.titleLabel.font =[UIFont systemFontOfSize:15];
            imageButton.backgroundColor =[colorWithBlack colorWithAlphaComponent:0.4];
            [_footerView addSubview:imageButton];
        }
        
        
        for (int i = 2; i < 5; i++) {
            UIImageView * imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake(LDHPadding + (smallImageW + LDHPadding) * (i - 2), smallImageY, smallImageW, smallImageH);
            imageView.tag = 100 + i;
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 5;
            [self.footerView addSubview:imageView];
            
            UIButton * imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButton.tag = 200 + i;
            [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            imageButton.layer.masksToBounds = YES;
            imageButton.layer.cornerRadius = 5;
            [imageButton setTitle:self.titleArray[i] forState:UIControlStateNormal];
            imageButton.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.4];
            imageButton.frame = CGRectMake(LDHPadding + (smallImageW + LDHPadding) * (i - 2), smallImageY, smallImageW, smallImageH);
            imageButton.titleLabel.font =[UIFont systemFontOfSize:15];
            [self.footerView addSubview:imageButton];
        }
        
            /*
            UIImageView * imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake(LDHPadding , smallImageY + smallImageH + LDHPadding, kScreenW - 2 * LDHPadding, smallImageH);
            imageView.tag = 105;
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 5;
            [self.footerView addSubview:imageView];
            
            UIButton * imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [imageButton setTitle:self.titleArray[5] forState:UIControlStateNormal];
            imageButton.tag = 205;
            [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            imageButton.layer.masksToBounds = YES;
            imageButton.layer.cornerRadius = 5;
            imageButton.frame = CGRectMake(LDHPadding , smallImageY + smallImageH + LDHPadding, kScreenW - 2 * LDHPadding, smallImageH);
            imageButton.titleLabel.font =[UIFont systemFontOfSize:15];
            imageButton.backgroundColor =[colorWithBlack colorWithAlphaComponent:0.4];
            [_footerView addSubview:imageButton];
       */
    }
    return _tableView;
}
#pragma mark - 为您推荐  点击事件
- (void)imageButtonClick:(UIButton *)imageButton {

    if(![self loginOrNot])
        return;
    
    NSInteger imgTag = imageButton.tag;
        
    switch (imgTag) {
        case 200:
        {//装修直通车
            
            DecorationCarMainController * vc = [[DecorationCarMainController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
            
        case 201:
        {//室内报修
        
            PropertyRepairViewController * vc = [[PropertyRepairViewController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 202:
        {//广告位申请
            AdvertisementPageViewController *controller = [[AdvertisementPageViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];

        }
            break;
        case 203:
        {//办公采购
            OfficePurchaseViewController * VC = [[OfficePurchaseViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 204:
        {//网络管家
          
            NetManagerVC * netVC = [[NetManagerVC alloc] init];
            [self.navigationController pushViewController:netVC animated:YES];
        }
            break;
        case 205:
        {//法律服务
            
            HomePageLegalServiceViewController * legalService = [[HomePageLegalServiceViewController alloc]init];
            [self.navigationController pushViewController:legalService animated:YES];
        }
            break;
    }

}
- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"装修直通车",@"室内报修",@"我要做广告",@"办公采购",@"网络管家",@"法律服务"];
    }
    return _titleArray;
}

@end
