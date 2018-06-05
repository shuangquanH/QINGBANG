//
//  FindHouseViewController.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/1/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyComplaintsViewController.h"
#import "YGSegmentView.h"
#import "AddComplaintsViewController.h"
#import "WaitReplyViewController.h"
@interface MyComplaintsViewController ()<YGSegmentViewDelegate,UIScrollViewDelegate,AddComplaintsViewControllerDelegate>
{
    YGSegmentView *_segmentView;
    UIScrollView *_scrollView;
    NSMutableArray *_controllersArray;
    UIButton *_moveSubButton;
}
@end

@implementation MyComplaintsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}


- (void)configAttribute
{
    self.naviTitle = @"我的投诉";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"decorate_nav_icon"] highImage:nil target:self action:@selector(rightBarButtonClick:) title:nil normalColor:LDMainColor highColor:LDMainColor titleFont:LDFont(14)];
    
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"待回复",@"已回复"] lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
    [self.view  addSubview: _segmentView];
}

- (void)configUI
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _segmentView.y + _segmentView.height, YGScreenWidth, YGScreenHeight - (YGStatusBarHeight + YGNaviBarHeight) - _segmentView.y - _segmentView.height)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth * _segmentView.titlesArray.count, _scrollView.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _controllersArray = [[NSMutableArray alloc]initWithArray:@[@"WaitReplyViewController",@"AlreadyViewController"]];
    
    [self segmentButtonClickWithIndex:0];
    
    
    UIPanGestureRecognizer   *  panTouch    =   [[UIPanGestureRecognizer  alloc]initWithTarget:self action:@selector(handlePan:)];
    if (_moveSubButton==nil) {
        _moveSubButton =   [[UIButton  alloc]initWithFrame:CGRectMake(YGScreenWidth - 57 - 20 , YGScreenHeight - (YGStatusBarHeight + YGNaviBarHeight) - 49 - 20 - 45, 57, 57)];
    }
    [_moveSubButton setBackgroundImage:[UIImage imageNamed:@"steward_repairs_issue"] forState:UIControlStateNormal];
    [_moveSubButton addTarget:self action:@selector(floatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_moveSubButton addGestureRecognizer:panTouch];
    [self.view  addSubview:_moveSubButton];
    
}
/**
 *  处理拖动手势
 *
 *  @param recognizer 拖动手势识别器对象实例
 */
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

-(void)segmentButtonClickWithIndex:(int)buttonIndex
{
    [self loadControllerWithIndex:buttonIndex];
    
    [UIView animateWithDuration:0.25 animations:^{
        _scrollView.contentOffset = CGPointMake(buttonIndex * YGScreenWidth, _scrollView.contentOffset.y);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / YGScreenWidth;
    
    [self loadControllerWithIndex:index];
    [_segmentView selectButtonWithIndex:index];
}

-(void)loadControllerWithIndex:(int)index
{
    if ([_controllersArray[index] isKindOfClass:[NSString class]])
    {
        UIViewController *controller = [[NSClassFromString(_controllersArray[index])  alloc]init];
        [controller performSelector:@selector(setControllFrame:) withObject:NSStringFromCGRect(CGRectMake(YGScreenWidth * index, 0, _scrollView.width, _scrollView.height))];
        
//        [model performSelector: NSSelectorFromString(arry[index.row])  withObject:@"22"];
     
        [self addChildViewController:controller];
        [_scrollView addSubview:controller.view];
        [_controllersArray replaceObjectAtIndex:index withObject:controller];
    }
}

//浮动按钮点击
- (void)floatButtonClick:(UIButton *)button
{
    AddComplaintsViewController * comPlaints =[[AddComplaintsViewController alloc]init];
    comPlaints.delegate = self;
    [self.navigationController pushViewController:comPlaints animated:YES];
}
- (void)addComplaintsViewController:(UIViewController *)controller didClickSaveButtonWithModel:(WaitReplyModel *)model
{
    if (![_controllersArray[0] isKindOfClass:[UIViewController class]])
        return;
    
    WaitReplyViewController * waitReply = _controllersArray[0];
    [waitReply addModelToDataArray:model];

}
-(void)rightBarButtonClick:(UIButton *)btn
{
    [self contactWithCustomerServerWithType:ContactServerPropertyRepair button:btn];
}

@end

