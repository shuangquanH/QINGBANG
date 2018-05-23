//
//  SQHomeViewController.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/18.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQHomeViewController.h"
#import "SQOvalFuncButtons.h"
#import "SQCardScrollView.h"

@interface SQHomeViewController () <SQOvalFuncButtonDelegate>

@property (nonatomic, strong) UICollectionView        *collectionView;

@end

@implementation SQHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"首页";
    [self.view addSubview:self.collectionView];
    
    
    [self usedOvalView];
    
    
    NSMutableArray  *btnArr = [NSMutableArray array];
    NSArray *btnTitle = @[@"水电缴费", @"会议室预定", @"办公耗材",
                          @"财税代理", @"办公室装修", @"人才招聘",
                          @"工商代办", @"项目申报", @"办公",
                          @"物业服务", @"资金扶持", @"广告位招商"];
    for (NSString *title in btnTitle) {
        UIButton    *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        button.backgroundColor = colorWithMainColor;
        [button setImage:[UIImage imageNamed:@"ovalimage"] forState:UIControlStateNormal];
        [btnArr addObject:button];
        [button addTarget:self action:@selector(btnaction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CGRect frame = CGRectMake(0, 400, YGScreenWidth, 100);
    SQCardScrollView    *scrollview = [[SQCardScrollView alloc] initWithFrame:frame];
    [self.view addSubview:scrollview];
    [scrollview setItemArr:btnArr alongAxis:SQSAxisTypeHorizontal spacing:20 leadSpace:0 tailSpace:0 itemSize:CGSizeMake(200, 100)];
}
- (void)btnaction {
    NSLog(@"dd");
}

- (void)usedOvalView {
    CGRect frame = CGRectMake((YGScreenWidth-260)/2.0, 60, 280, 220);
    SQOvalFuncButtons   *view = [[SQOvalFuncButtons alloc] initWithFrame:frame centBtnSize:CGSizeMake(30, 30) backImage:[UIImage imageNamed:@"ovalimage"]];
    view.delegate = self;
    [self.view addSubview:view];
}
- (void)didselectWithClicktype:(ClickType)type {
    NSLog(@"%lu", (unsigned long)type);
}






#pragma lazyLoad
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    }
    return _collectionView;
}











@end
