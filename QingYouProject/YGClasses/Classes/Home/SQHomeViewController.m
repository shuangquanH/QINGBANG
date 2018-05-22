//
//  SQHomeViewController.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/18.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQHomeViewController.h"

#import "SQCustomView.h"
#import "SQOvalFuncButtons.h"

@interface SQHomeViewController () <SQOvalFuncButtonDelegate>

@property (nonatomic, strong) UICollectionView        *collectionView;

@end

@implementation SQHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
//    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//
    
    
//    [self needtestVeiw];
    [self usedOvalView];

}


- (void)needtestVeiw {
    SQCustomView *customView = [[SQCustomView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:customView];

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
















@end
