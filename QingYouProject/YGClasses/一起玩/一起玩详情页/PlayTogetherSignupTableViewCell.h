//
//  PlayTogetherSignupTableViewCell.h
//  QingYouProject
//
//  Created by apple on 2017/12/6.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlayTogetherSignupTableViewCell;

@protocol PlayTogetherSignupTableViewCellDelegate

- (void)PlayTogetherSignupTableViewCell:(PlayTogetherSignupTableViewCell *)cell textFieldDidEndEditingWithString:(NSString *)string;

@end
@interface PlayTogetherSignupTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *detailTextField;
@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, assign) id <PlayTogetherSignupTableViewCellDelegate>delegate;
@end
