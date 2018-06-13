//
//  WKUserCenterCell.h
//  QingYouProject
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKUserCenterCell : SQBaseTableViewCell

@property (nonatomic, strong) UIImageView *userImageView;

@property (nonatomic, strong) UILabel *titleLabel;

- (void)configBadgeNum:(NSInteger)badgeNum;

@end
