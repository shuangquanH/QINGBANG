//
//  WKUserCenterCollectCell.h
//  QingYouProject
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKUserCenterCollectModel, WKUserCenterCollectCell;

@protocol WKUserCenterCollectCellDelegate<NSObject>

- (void)collectCell:(WKUserCenterCollectCell *)collectCell didClickCancelCollectInfo:(WKUserCenterCollectModel *)collectInfo;

@end

@interface WKUserCenterCollectCell : UITableViewCell

@property (nonatomic, weak) id<WKUserCenterCollectCellDelegate> delegate;

- (void)configCollectInfo:(WKUserCenterCollectModel *)collectInfo;

@end
