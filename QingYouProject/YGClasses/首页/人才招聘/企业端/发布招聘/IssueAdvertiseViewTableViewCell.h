//
//  IssueAdvertiseViewTableViewCell.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertisesForInfoModel.h"
#import "TextViewAjustHeight.h"
#import "RootViewController.h"

@class IssueAdvertiseViewTableViewCell;

@protocol IssueAdvertiseViewTableViewCellDelegate <NSObject>

- (void)reloadCellHeight:(CGFloat)height withText:(NSString *)text;

- (void)textViewCell:(IssueAdvertiseViewTableViewCell *)cell didChangeText:(NSString *)text;

- (void)textfieldEndEdtingWithModel:(AdvertisesForInfoModel *)model withIndexPath:(NSIndexPath *)indexpath;

@end
@interface IssueAdvertiseViewTableViewCell : UITableViewCell<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) AdvertisesForInfoModel            *model;
@property (nonatomic, assign) id<IssueAdvertiseViewTableViewCellDelegate>delegate;
@property (nonatomic, strong)      RootViewController       *viewcontroller;
@property (nonatomic, strong) NSIndexPath            *indexPath;
- (void)setModel:(AdvertisesForInfoModel *)model  withIndexPath:(NSIndexPath *)indexPath;
@end
