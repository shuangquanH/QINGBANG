//
//  SearchAdvertieseTableViewCell.h
//  QingYouProject
//
//  Created by 王丹 on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertiseModel.h"

@protocol SearchAdvertieseTableViewCellDelegate <NSObject>

@optional
//删除
- (void)deleteAdvertiseWithModel:(AdvertiseModel *)model;


@end

@interface SearchAdvertieseTableViewCell : UITableViewCell
@property (nonatomic, assign) id<SearchAdvertieseTableViewCellDelegate>delegate;
@property (nonatomic, strong) AdvertiseModel            *model;

@end
