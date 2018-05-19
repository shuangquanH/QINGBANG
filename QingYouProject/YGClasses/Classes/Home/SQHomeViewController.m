//
//  SQHomeViewController.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/18.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQHomeViewController.h"

#import "SQCustomView.h"
#import "SQHomeTopFunBtns.h"

@interface SQHomeViewController ()

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
    
    
//    SQCustomView *customView = [[SQCustomView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:customView];
    
    CGRect frame = CGRectMake((YGScreenWidth-260)/2.0, 60, 260, 260);
    SQHomeTopFunBtns    *topBtn = [[SQHomeTopFunBtns alloc] initWithFrame:frame withCenterSize:CGSizeMake(140, 140)];
    [self.view addSubview:topBtn];
}

@end
