//
//  MyIntroduceTableViewCell.h
//  FrienDo
//
//  Created by zhangkaifeng on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyIntroduceTableViewCell;

@protocol MyIntroduceTableViewCellDelegate

- (void)myIntroduceTableViewCell:(MyIntroduceTableViewCell *)cell textFieldDidEndEditingWithString:(NSString *)string;

@end

@interface MyIntroduceTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *detailTextField;
@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, assign) id <MyIntroduceTableViewCellDelegate>delegate;

@end
