//
//  MyCollectionViewController.h
//  QingYouProject
//
//  Created by zhaoao on 2017/11/9.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@interface MyCollectionViewController : RootViewController

@property(nonatomic,assign)NSInteger type;//0资金扶持,1抢购,2财务代记账,3工商一体化,4广告位置,5办公采购,6网络管家,7新鲜事,8一起玩,9,法律服务

@property(nonatomic,strong)NSString *titleString;

@end
