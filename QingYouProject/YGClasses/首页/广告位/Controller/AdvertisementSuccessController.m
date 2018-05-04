//
//  AdvertisementSuccessController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/9/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AdvertisementSuccessController.h"

@interface AdvertisementSuccessController ()

@end

@implementation AdvertisementSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"提交成功";
    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.frame = CGRectMake(0, 0, 20, 20);
    [completeButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(completeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:completeButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

//点击完成
-(void)completeButtonClick:(UIButton *)button
{
    NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
