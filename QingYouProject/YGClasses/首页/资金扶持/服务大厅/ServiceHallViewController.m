//
//  ServiceHallViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ServiceHallViewController.h"
#import "ServiceContentViewController.h"
#import "ServiceReasonViewController.h"
#import "ServiceHallBaseProfileViewController.h"
#import "ServiceHallAdvertiseImgModel.h"
#import "ChoiceCaseViewController.h"

@interface ServiceHallViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@end

@implementation ServiceHallViewController
{
    UIScrollView  *_mainScrollView;
    UILabel  *_countLabel;
    UITextField *_emailTextfield;
    SDCycleScrollView *_playTogetherScrollview; //一起玩轮播
    NSMutableArray *_advertiseArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadAdvertiseData];
    // Do any additional setup after loading the view.
}
- (void)configAttribute
{
    self.naviTitle = @"服务大厅";
    _advertiseArray = [[NSMutableArray alloc] init];
}
- (void)loadAdvertiseData
{
    [self startPostWithURLString:REQUEST_MoneyPagePicture parameters:@{} showLoadingView:NO scrollView:nil];
}

- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    _advertiseArray = [ServiceHallAdvertiseImgModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (ServiceHallAdvertiseImgModel *model in _advertiseArray) {
        [array addObject:model.picture];
    }
    [_playTogetherScrollview setImageURLStringsGroup:array];
}
- (void)configUI
{
    self.view.backgroundColor = colorWithYGWhite;
    /********************* _scrollView ***************/
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - 45-YGBottomMargin)];
    _mainScrollView.backgroundColor = colorWithYGWhite;
    _mainScrollView.contentSize = CGSizeMake(YGScreenWidth, _mainScrollView.height);
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    /********************* 上部分 ***************/
    NSArray *imageArray = @[[UIImage imageNamed:@"steward_capital_choice_btn"],[UIImage imageNamed:@"steward_capital_solve_btn"]];
    
    for (int i = 0; i<2; i++)
    {
        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(15+((YGScreenWidth-45)/2+15)*i,15,(YGScreenWidth-45)/2,50)];
        coverButton.tag = 1000+i;
        [coverButton addTarget:self action:@selector(coverButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        coverButton.layer.cornerRadius = 5;
        coverButton.clipsToBounds = YES;
        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        [_mainScrollView addSubview:coverButton];
        [coverButton setImage:imageArray[i] forState:UIControlStateNormal];
        [coverButton.imageView sizeToFit];
        coverButton.imageView.contentMode = UIViewContentModeCenter;

    }
    
    //左线
    UIImageView *caseLeftLineImageView = [[UIImageView alloc]init];
    caseLeftLineImageView.frame = CGRectMake(10,100, 2, 17);
    caseLeftLineImageView.backgroundColor = colorWithMainColor;
    [_mainScrollView addSubview:caseLeftLineImageView];

    UILabel *caseLeaderLabel = [[UILabel alloc] init];
    caseLeaderLabel.textColor = colorWithBlack;
    caseLeaderLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    caseLeaderLabel.text = @"精选案例";
    caseLeaderLabel.frame = CGRectMake(18, caseLeftLineImageView.y, YGScreenWidth-20, 25);
    [_mainScrollView addSubview:caseLeaderLabel];
    caseLeaderLabel.centery = caseLeftLineImageView.centery;
    
    _playTogetherScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, caseLeftLineImageView.y+caseLeftLineImageView.height+10, YGScreenWidth-20, YGScreenWidth*0.45) delegate:self placeholderImage:YGDefaultImgTwo_One];
    _playTogetherScrollview.imageURLStringsGroup = @[];
    _playTogetherScrollview.layer.cornerRadius = 5;
    _playTogetherScrollview.clipsToBounds = YES;
    _playTogetherScrollview.autoScroll = YES;
    _playTogetherScrollview.delegate = self;
    _playTogetherScrollview.infiniteLoop = YES;
//    _playTogetherScrollview.localizationImageNamesGroup = @[YGDefaultImgTwo_One,YGDefaultImgTwo_One];
//    _playTogetherScrollview.titlesGroup = @[@"小鸟儿音响",@"大鸟儿音响"];
    [_mainScrollView addSubview:_playTogetherScrollview];
    

    //左线
    UIImageView *leftLineImageView = [[UIImageView alloc]init];
    leftLineImageView.frame = CGRectMake(10, _playTogetherScrollview.y+_playTogetherScrollview.height+30, 2, 17);
    leftLineImageView.backgroundColor = colorWithMainColor;
    [_mainScrollView addSubview:leftLineImageView];
    
    UILabel *leaderLabel = [[UILabel alloc] init];
    leaderLabel.textColor = colorWithBlack;
    leaderLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    leaderLabel.text = @"服务流程";
    leaderLabel.frame = CGRectMake(18, leftLineImageView.y, YGScreenWidth-20, 25);
    [_mainScrollView addSubview:leaderLabel];
    leaderLabel.centery = leftLineImageView.centery;

    //流程
    UIImageView *processImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"steward_capital_serviceprocess"]];
    processImageView.frame = CGRectMake(leaderLabel.x, leftLineImageView.y+leftLineImageView.height+30, 2, 17);
    [processImageView sizeToFit];
    processImageView.frame = CGRectMake(processImageView.x, processImageView.y,processImageView.width, processImageView.height);
    [_mainScrollView addSubview:processImageView];
    processImageView.centerx = _mainScrollView.centerx;
    _mainScrollView.contentSize = CGSizeMake(YGScreenWidth, processImageView.y+processImageView.height+30);
    
    UIButton *applyButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
    applyButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
    [applyButton addTarget:self action:@selector(applyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    applyButton.backgroundColor = colorWithMainColor;
    applyButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [self.view addSubview:applyButton];
    [applyButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [applyButton setTitle:@"立即申请撰写服务" forState:UIControlStateNormal];

}
- (void)applyButtonAction:(UIButton *)btn
{
    ServiceHallBaseProfileViewController *serviceReasonViewController = [[ServiceHallBaseProfileViewController alloc] init];
    [self.navigationController pushViewController:serviceReasonViewController animated:YES];
}
- (void)coverButtonAction:(UIButton *)btn
{
    if (btn.tag-1000 ==0)
    {
        ServiceReasonViewController *serviceReasonViewController = [[ServiceReasonViewController alloc] init];
        [self.navigationController pushViewController:serviceReasonViewController animated:YES];
    }else
    {
        ServiceContentViewController *serviceContentViewController = [[ServiceContentViewController alloc] init];
        [self.navigationController pushViewController:serviceContentViewController animated:YES];

    }

}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    ServiceHallAdvertiseImgModel *model = _advertiseArray[index];
    ChoiceCaseViewController *vc = [[ChoiceCaseViewController alloc]init];
    vc.contentUrl = model.text;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
