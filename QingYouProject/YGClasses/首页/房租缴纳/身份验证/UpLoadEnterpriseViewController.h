//
//  UpLoadEnterpriseViewController.h
//  FrienDo
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

//选择完图片回调
@protocol UpLoadEnterpriseDelegate <NSObject>

- (void)upLoadPersonBtnAction:(UIButton *)button;

@end

@interface UpLoadEnterpriseViewController : RootViewController

@property(nonatomic,weak) id <UpLoadEnterpriseDelegate> delegate;

/**
 View 位置
 */
@property(nonatomic,assign) CGRect controllerFrame;
@property (nonatomic, strong)     NSMutableArray *listArray;
@property (nonatomic, strong) UITableView *tableView;  
@end
