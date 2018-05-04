//
//  TakePicturesOrderDetailController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "TakePicturesOrderDetailController.h"
#import "TakePhotosDetailInfoView.h"
#import "EvaluateViewController.h"
#import "KSPhotoBrowser.h"

@interface TakePicturesOrderDetailController () <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    TakePhotosDetailInfoView *_topinfoView; //上面两栏的信息
    TakePhotosDetailInfoView *_bottominfoView; //上面两栏的信息
}
@property(nonatomic,strong)NSArray *imgArray;//图片数组
@property(nonatomic,strong)NSDictionary *dataDic;//数据字典

@end

@implementation TakePicturesOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"随手拍";
    
//    UIButton *hurryButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    hurryButton.frame = CGRectMake(0, 0, 30, 30);
//    [hurryButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
//    [hurryButton setTitle:@"" forState:normal];
//    [hurryButton addTarget:self action:@selector(hurryButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:hurryButton];
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    _imgArray = [NSArray array];
    
    [self loadData];
   
}

-(void)loadData
{
    [YGNetService YGPOST:REQUEST_SnapshotOrderDetail parameters:@{@"id":self.idString} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
//        _dataArray = [MeetingBookingModel mj_objectArrayWithKeyValuesArray:responseObject[@"aList"]];
        
        _imgArray = [responseObject valueForKey:@"img"];
        _dataDic = [responseObject valueForKey:@"snapshotData"];
        
        [self configUI];
        
        
    } failure:^(NSError *error) {
        
    }];
}



-(void)configUI
{
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _topinfoView = [[TakePhotosDetailInfoView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.25+16) andType:@"0" andDic:self.dataDic];
    [_scrollView addSubview:_topinfoView];
    
    _bottominfoView = [[TakePhotosDetailInfoView alloc]initWithFrame:CGRectMake(0, YGScreenWidth * 0.25+16, YGScreenWidth, YGScreenWidth * 0.25+16) andType:@"1" andDic:self.dataDic];
    [_scrollView addSubview:_bottominfoView];
    
    UIView *bottomWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenWidth * 0.5+32, YGScreenWidth, 200)];
    bottomWhiteView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bottomWhiteView];
    
    UILabel *describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, YGScreenWidth - 30, 20)];
//    UILabel *describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, YGScreenWidth * 0.5 + 10, YGScreenWidth - 30, 20)];
    describeLabel.text = @"图片描述:";
    describeLabel.font = [UIFont systemFontOfSize:16.0];
    describeLabel.textColor = colorWithDeepGray;
//    [_scrollView addSubview:describeLabel];
    [bottomWhiteView addSubview:describeLabel];
    
//    NSArray *array = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    
 //   NSInteger picOrignY = YGScreenWidth * 0.5 + 30;
    NSInteger picOrignY = 30;
    
    NSInteger imageHeight = YGScreenWidth * 0.22; //每张图片的高度
    
    //for循环添加图片并计算图片尺寸
    for (int i = 1; i <= self.imgArray.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"" forState:UIControlStateNormal];
//        imageView.image = [UIImage imageNamed:@"0.jpg"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imgArray[i-1]] placeholderImage:YGDefaultImgFour_Three];
        NSInteger row = i / 3; //行
        NSInteger line = i % 3; //列
        if (line == 0) {
            line = 3;
            row = row - 1;
        }
        CGFloat width = (YGScreenWidth - 40) / 3;
        imageView.frame = CGRectMake(width * (line - 1) + (10 * line), imageHeight * row + (10 * (row + 1)) +picOrignY, width , imageHeight);
 //       [_scrollView addSubview:imageView];
        imageView.layer.cornerRadius = 5;
        imageView.clipsToBounds = YES;
        
        button.frame = imageView.frame;
        button.tag = i;
        [button addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomWhiteView addSubview:imageView];
        [bottomWhiteView addSubview:button];
    }
    
    NSInteger row = self.imgArray.count / 3;
    if (self.imgArray.count % 3 != 0) {
        row = row + 1;
    }
    NSInteger imageY = 10 * row + picOrignY + imageHeight * row; //总高度加上原始高度
    
    UILabel *mesDescribeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, imageY + 10, YGScreenWidth - 30, 20)];
    mesDescribeLabel.text = @"留言描述:";
    mesDescribeLabel.font = [UIFont systemFontOfSize:16.0];
    mesDescribeLabel.textColor = colorWithDeepGray;
//    [_scrollView addSubview:mesDescribeLabel];
     [bottomWhiteView addSubview:mesDescribeLabel];
    
    UILabel *messagelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, imageY + 10 + 20 + 10, YGScreenWidth - 30, 50)];
    messagelabel.numberOfLines = 2;
    messagelabel.textColor = colorWithBlack;
    messagelabel.text = [self.dataDic valueForKey:@"description"];
//    [_scrollView addSubview:messagelabel];
    [bottomWhiteView addSubview:messagelabel];
    bottomWhiteView.frame = CGRectMake(0,  YGScreenWidth * 0.5+32, YGScreenWidth, imageY + 100);
}

//点击图片查看
-(void)imageBtnClick:(UIButton *)button
{
    NSMutableArray *items = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.imgArray.count; i++)
    {
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:(UIImageView *)button imageUrl:[NSURL URLWithString:self.imgArray[i]]];
        [items addObject:item];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:button.tag-1];
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
    [browser showFromViewController:self];
}


//催单
-(void)hurryButtonClick
{
    EvaluateViewController *eVC = [[EvaluateViewController alloc]init];
    [self.navigationController pushViewController:eVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
