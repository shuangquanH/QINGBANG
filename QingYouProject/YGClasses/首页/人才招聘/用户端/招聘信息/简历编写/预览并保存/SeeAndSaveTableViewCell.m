//
//  SeeAndSaveTableViewCell.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SeeAndSaveTableViewCell.h"

@implementation SeeAndSaveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _titleLabel.textColor = colorWithDeepGray;
    _subLabel.textColor = colorWithBlack;
    _subLabel.preferredMaxLayoutWidth = YGScreenWidth - 120 - 12;
}

- (void)setInfoDic:(NSDictionary *)infoDic
{
    _infoDic = infoDic;
    _titleLabel.text = infoDic[@"title"];
    _subLabel.text = infoDic[@"detail"];
}


@end
