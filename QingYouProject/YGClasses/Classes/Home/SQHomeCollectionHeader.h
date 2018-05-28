//
//  SQHomeCollectionHeader.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/23.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SQHomeCollectionHeaderDeleage

- (void)tapedFuncsWithModel:(NSString   *)model;

@end

@interface SQHomeCollectionHeader : UIView

@property (nonatomic, weak) id <SQHomeCollectionHeaderDeleage> delegate;

//轮播图数据
@property (nonatomic, strong) NSArray       *cycleViewData;
//个性定制化数据
@property (nonatomic, strong) NSArray       *scrollViewData;

@end
