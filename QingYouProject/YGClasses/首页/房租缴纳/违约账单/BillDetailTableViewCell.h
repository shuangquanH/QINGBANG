//
//  BillDetailTableViewCell.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillDetailModel.h"

@interface BillDetailTableViewCell : UITableViewCell
@property (nonatomic, strong) BillDetailModel            *model;
- (void)setModel:(BillDetailModel *)model withType:(NSString *)type;
@end
