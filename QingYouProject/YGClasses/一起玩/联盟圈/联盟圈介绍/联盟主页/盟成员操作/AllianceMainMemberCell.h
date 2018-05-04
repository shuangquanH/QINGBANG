//
//  AllianceMainMemberCell.h
//  QingYouProject
//
//  Created by nefertari on 2017/11/29.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllianceMemberModel.h"

@protocol AllianceMainMemberCellDelegate <NSObject>

- (void)removeMemberWithModel:(AllianceMemberModel *)model;

@end
@interface AllianceMainMemberCell : UITableViewCell
@property (nonatomic, strong) AllianceMemberModel            *model;
@property (nonatomic,assign) id<AllianceMainMemberCellDelegate> delegate;

@end
