//
//  SQHomeCollectionHeader.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/23.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  首页collectionView的头部视图

#import <UIKit/UIKit.h>

/** Model  */
#import "SQHomeIndexPageModel.h"



@protocol SQHomeCollectionHeaderDeleage

//model的类型可能是:SQHomeBannerModel,表示轮播图数据,有可能是:SQHomeFuncsModel,表示头部功能按钮数据,有可能是:SQHomeHeadsModel表示用户定制化功能按钮数据
- (void)tapedFuncsWithModel:(id)model;

@end

@interface SQHomeCollectionHeader : UIView

@property (nonatomic, weak) id <SQHomeCollectionHeaderDeleage> delegate;


@property (nonatomic, strong) SQHomeIndexPageModel       *model;


@end
