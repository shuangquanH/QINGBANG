//
//  CrowdFundingAddProjectTableViewCell.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrowdFundingAddProjectModel.h"

@protocol CrowdFundingAddProjectTableViewCellDelegate <NSObject>

- (void)textfieldReturnValue:(NSString *)value withTextfiledTag:(NSInteger)textfieldTag;

- (void)textfieldReturnValue:(NSString *)value withTextIndexPath:(NSIndexPath *)indexPath;

@end
@interface CrowdFundingAddProjectTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, strong) CrowdFundingAddProjectModel            *model;
@property (nonatomic, assign) id<CrowdFundingAddProjectTableViewCellDelegate>delegate;
@property (nonatomic, strong) NSIndexPath            *indexPath;
@property (nonatomic, assign) BOOL            needReturnIndexPath;

- (void)setModel:(CrowdFundingAddProjectModel *)model withIndexPath:(NSIndexPath *)indexPath;
@end
