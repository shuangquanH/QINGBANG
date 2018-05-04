//
//  AllianceCircleTrendsCommentDetailTableViewCell.h
//  QingYouProject
//
//  Created by nefertari on 2017/11/30.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllianceCircleTrendsCommentDetailModel.h"
#import "SecondHandCommentModel.h"

@interface AllianceCircleTrendsCommentDetailTableViewCell : UITableViewCell
@property (nonatomic, strong) AllianceCircleTrendsCommentDetailModel            *model;
@property (nonatomic, strong) SecondHandCommentModel *secondModel;

@end
