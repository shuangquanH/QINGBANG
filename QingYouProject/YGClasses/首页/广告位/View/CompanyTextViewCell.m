//
//  CompanyTextViewCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/12.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CompanyTextViewCell.h"

@interface CompanyTextViewCell ()<UITextViewDelegate>
{
    UILabel *_placeHolderLabel;
}

@end

@implementation CompanyTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.applyTitleLabel.textColor = colorWithDeepGray;
    self.companyTextView.textColor = colorWithDeepGray;
    
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, YGScreenWidth - 130 - 5, 20)];
    _placeHolderLabel.textAlignment = NSTextAlignmentRight;
    _placeHolderLabel.font = [UIFont systemFontOfSize:14];
    _placeHolderLabel.text = @"请填写企业/个人全称";
    _placeHolderLabel.textColor = colorWithTextPlaceholder;
    [self.companyTextView addSubview:_placeHolderLabel];
    
    self.companyTextView.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        _placeHolderLabel.text = @"请填写企业/个人全称";
    }
    else
    {
        _placeHolderLabel.text = @"";
    }
    
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
