//
//  ApplyRemarkCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/9/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ApplyRemarkCell.h"

@interface ApplyRemarkCell () <UITextViewDelegate>

@end

@implementation ApplyRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.remarkPlaceHolerLabel.frame = CGRectMake(15, 15, YGScreenWidth - 30, 20);
    self.remarkPlaceHolerLabel.textColor = colorWithTextPlaceholder;
    self.remarkPlaceHolerLabel.numberOfLines = 0;
    self.remarkTextView.textColor = colorWithDeepGray;
    self.remarkTextView.delegate = self;
}



//设置textView的placeholder
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{   //[text isEqualToString:@""] 表示输入的是退格键
    if (![text isEqualToString:@""])
    {
        self.remarkPlaceHolerLabel.hidden = YES;
    }
    //range.location == 0 && range.length == 1 表示输入的是第一个字符
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
    {
        self.remarkPlaceHolerLabel.hidden = NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGRect bounds = textView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;
    textView.bounds = bounds;
    // 让 table view 重新计算高度
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    
    return (UITableView *)tableView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
