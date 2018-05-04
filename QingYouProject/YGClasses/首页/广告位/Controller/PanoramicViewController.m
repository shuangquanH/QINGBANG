//
//  PanoramicViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PanoramicViewController.h"
//#import "YQPanoramaView.h"
#import "PanoramaView.h"


@interface PanoramicViewController ()
{
    PanoramaView *panoramaView;
}

//@property (nonatomic,strong) YQPanoramaView *panaromview;

@end

@implementation PanoramicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //标题居中
    UILabel *naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth - 120, 20)];
    naviTitleLabel.textColor = colorWithBlack;
    naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    naviTitleLabel.text = @"3D全景图" ;
    [naviTitleLabel sizeToFit];
    naviTitleLabel.frame = CGRectMake(YGScreenWidth/2-naviTitleLabel.width/2, 0, naviTitleLabel.width, 20);
    self.navigationItem.titleView = naviTitleLabel;
//    self.naviTitle = @"3D全景图";

//    //初始化
//    self.panaromview = [[YQPanoramaView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGStatusBarHeight - YGNaviBarHeight)];
//    //设图片
//    self.panaromview.image = image;
//    //显示
//    [self.view addSubview:self.panaromview];
//    self.panaromview.Fisheye = NO;//鱼眼效果
    
    //acceptable image sizes: (4096×2048), 2048×1024, 1024×512, 512×256, 256×128 ...
    panoramaView = [[PanoramaView alloc] init];
    [panoramaView setImageWithName:self.picPathString];
//    [panoramaView setImage:self.zImage];
    [panoramaView setOrientToDevice:YES];
    [panoramaView setTouchToPan:NO];
    [panoramaView setPinchToZoom:YES];
    [panoramaView setShowTouches:NO];
    [panoramaView setVRMode:NO];
    [self setView:panoramaView];
}

-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [panoramaView draw];
}
//返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
