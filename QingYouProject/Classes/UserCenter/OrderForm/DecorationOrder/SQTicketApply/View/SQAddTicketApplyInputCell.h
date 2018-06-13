//
//  SQAddTicketApplyInputCell.h
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SQAddTicketApplyInputCell;

@protocol SQAddTicketApplyInputCellDelegate<NSObject>

- (void)cell:(SQAddTicketApplyInputCell *)cell didEditTextField:(UITextField *)textField;

@end

@interface SQAddTicketApplyInputCell : UITableViewCell

@property (nonatomic, weak) id<SQAddTicketApplyInputCellDelegate> delegate;

- (void)configTitle:(NSString *)title placeHodler:(NSString *)placeHodler content:(NSString *)content necessary:(BOOL)necessary;

@end
