//
//  ManageMailPostTableViewCell.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/30.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManageMailPostModel.h"
#import "WKInvoiceAddressModel.h"

@protocol ManageMailPostTableViewCellDelegate <NSObject>
@optional
- (void)modifyButtonClickWithIndexPath:(NSIndexPath *)indexPath;

@end
@interface ManageMailPostTableViewCell : UITableViewCell
@property (nonatomic,strong) ManageMailPostModel * model;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * phoneLabel;
@property (nonatomic,strong) UILabel * addressLabel;
@property (nonatomic,strong) UILabel * detailAddressLabel;
@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) id <ManageMailPostTableViewCellDelegate> delegate;

@end
