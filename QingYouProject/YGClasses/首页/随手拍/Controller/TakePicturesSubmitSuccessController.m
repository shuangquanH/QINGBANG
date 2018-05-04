
//
//  TakePicturesSubmitSuccessController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "TakePicturesSubmitSuccessController.h"
#import "ManagerViewController.h"

@interface TakePicturesSubmitSuccessController ()

@property (nonatomic, assign) int earnPoints;
@property (nonatomic,strong)UIImageView *bgImageView;//最上面刮奖的imageView
@property (nonatomic,strong)UIButton *clickmeButton; //点我刮奖吧按钮
@property (nonatomic,strong)UILabel *explainLabel;//青币可以抵现金哦
@property (nonatomic,strong)UIImageView *bottomImageView;//最下面刮奖的imageView

@property(nonatomic,strong)NSString *once;//是否是第一次执行
//擦除区域半径
@property (nonatomic,assign) CGFloat clearRadius;

@end

@implementation TakePicturesSubmitSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setFd_interactivePopDisabled:YES];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, 35, 35);
    [doneButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [doneButton setTitle:@"完成" forState:normal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.once = @"0";
    
    //设置擦除区域默认半径
    self.clearRadius = self.clearRadius == 0 ? 15 : self.clearRadius;
    
    self.view.backgroundColor = colorWithTable;
}
- (void)configAttribute
{
    NSString *bottomString;
    UIColor *color;

    self.naviTitle = @"提交成功";
    bottomString = @"您已提交成功\n我们将第一时间为您处理";
    color = colorWithYGWhite;
//    self.navigationItem.rightBarButtonItem = [self createBarbuttonWithNormalTitleString:@"完成" selectedTitleString:@"完成" selector:@selector(doneButtonClick)];
    [self configUIWithBottomString:bottomString withBackColor:color];
}

- (void)configUIWithBottomString:(NSString *)bottomString withBackColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    
    UIView *baseTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 150)];
    baseTopView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:baseTopView];
    
    UIImageView *correctImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_finish_icon_green"]];
    [correctImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [baseTopView addSubview:correctImageView];

    UILabel *bottomLabel = [[UILabel alloc]init];
    bottomLabel.textColor = colorWithDeepGray;
    bottomLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [bottomLabel addAttributedWithString:bottomString lineSpace:8];
    //    bottomLabel.text = bottomString;
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.numberOfLines = 0;
    [baseTopView addSubview:bottomLabel];
    
    [correctImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.view);
         make.top.mas_equalTo(35);
     }];
    
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(correctImageView);
         make.top.mas_equalTo(correctImageView.mas_bottom).offset(12);
     }];
    
    UIView *baseBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, baseTopView.height+10, YGScreenWidth, YGScreenWidth * 0.48)];
    baseBottomView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:baseBottomView];

    self.bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, YGScreenWidth - 30, YGScreenWidth * 0.48 - 30)];
    self.bottomImageView.image = [UIImage imageNamed:@"steward_snapshot_scratchoff_finish_bj"];
//    self.bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
    [baseBottomView addSubview:self.bottomImageView];

    UILabel *pointsLabel = [[UILabel alloc]init];
    pointsLabel.textColor = colorWithOrangeColor;
    pointsLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    [pointsLabel addAttributedWithString:bottomString lineSpace:8];
    [pointsLabel addAttributedWithString:[NSString stringWithFormat:@"恭喜您获得%d个青币",_earnPoints] range:NSMakeRange(0, @"恭喜您获得".length) color:colorWithBlack];
    pointsLabel.tag = 1994;
    pointsLabel.frame = CGRectMake(80, (YGScreenWidth * 0.48 - 20) / 2, YGScreenWidth - 160, 30);
    [baseBottomView addSubview:pointsLabel];
    
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, YGScreenWidth - 30, YGScreenWidth * 0.48 - 30)];
    self.bgImageView.image = [UIImage imageNamed:@"steward_snapshot_scratchoff_bj"];
//    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [baseBottomView addSubview:self.bgImageView];

    self.clickmeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clickmeButton setTitle:@"" forState:UIControlStateNormal];
    [self.clickmeButton setImage:[UIImage imageNamed:@"steward_snapshot_scratchoff_btn"] forState:UIControlStateNormal];
    self.clickmeButton.frame = CGRectMake(70, 75, YGScreenWidth - 140, 50);
    [self.clickmeButton addTarget:self action:@selector(clickmeClick:) forControlEvents:UIControlEventTouchUpInside];
    [baseBottomView addSubview:self.clickmeButton];

    self.explainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, YGScreenWidth, 40)];
    self.explainLabel.text = @"青币可以抵现金哦";
    self.explainLabel.font = [UIFont systemFontOfSize:14.0];
    self.explainLabel.textColor = colorWithBlack;
    self.explainLabel.textAlignment = NSTextAlignmentCenter;
    [baseBottomView addSubview:self.explainLabel];

//    [pointsLabel mas_makeConstraints:^(MASConstraintMaker *make)
//     {
//         make.top.mas_equalTo(baseBottomView.mas_top).offset((YGScreenWidth * 0.43 - 20) / 2);
//         make.left.mas_equalTo(100);
//
//     }];
    
}

//点我刮奖 试试手气吧
-(void)clickmeClick:(UIButton *)button
{
    self.bgImageView.userInteractionEnabled = YES;
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.bgImageView addGestureRecognizer:pan];
    [self.explainLabel removeFromSuperview];
    [self.clickmeButton removeFromSuperview];
}

-(void)pan:(UIGestureRecognizer *)pan
{
    //获取当前手指的点
//    CGPoint curP = [pan locationInView:self.bottomImageView];
    //确定擦除区域
//    CGFloat rectWH = 20;
//    CGFloat x =curP.x - rectWH * 0.5;
//    CGFloat y =curP.y - rectWH * 0.5;
//    CGRect rect = CGRectMake(x, y, rectWH, rectWH);
    
    //获取触摸的点
    CGPoint touchPoint = [pan locationInView:self.bottomImageView];
    //设置擦除区域
    CGFloat clearX = touchPoint.x - self.clearRadius;
    CGFloat clearY = touchPoint.y - self.clearRadius;
    CGFloat clearW = 2 * self.clearRadius;
    CGFloat clearH = 2 * self.clearRadius;
    CGRect rect = CGRectMake(clearX, clearY, clearW, clearH);
    
    //设置上下文的size(和topImageView的size一样大)
    CGSize ctxSize = self.bgImageView.bounds.size;

    //生成一张带有透明擦除区域的图片
    //1.开启图片上下文
    UIGraphicsBeginImageContextWithOptions(ctxSize, NO, 0);

    //2.把UIImageV内容渲染到当前的上下文当中
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.bgImageView.layer renderInContext:ctx];

    //3.擦除上下文当中的指定的区域
    CGContextClearRect(ctx, rect);

    //4.从上下文当中取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();

    //替换之前ImageView的图片
    self.bgImageView.image = newImage;
    
    if ([self.once isEqualToString:@"0"]) {
        [self getConins];
    }
    self.once = @"1";
}

//获得青币
-(void)getConins
{
    [YGNetService YGPOST:REQUEST_StochasticIntegral parameters:@{@"userId":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        UILabel *pointsLabel = [self.view viewWithTag:1994];
        [pointsLabel addAttributedWithString:[NSString stringWithFormat:@"恭喜您获得%@个青币",[responseObject valueForKey:@"num"]] lineSpace:8];
        [pointsLabel addAttributedWithString:[NSString stringWithFormat:@"恭喜您获得%@个青币",[responseObject valueForKey:@"num"]] range:NSMakeRange(0, @"恭喜您获得".length) color:colorWithBlack];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)doneButtonClick
{
    UINavigationController *navc = self.navigationController;
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (UIViewController *vc in [navc viewControllers]) {
        [viewControllers addObject:vc];
        if ([vc isKindOfClass:[ManagerViewController class]]) {
            break;
        }
    }
    [navc setViewControllers:viewControllers];
}

-(void)back
{
    UINavigationController *navc = self.navigationController;
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (UIViewController *vc in [navc viewControllers]) {
        [viewControllers addObject:vc];
        if ([vc isKindOfClass:[ManagerViewController class]]) {
            break;
        }
    }
    [navc setViewControllers:viewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
