//
//  DecorationMoneyDetailsCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "DecorationMoneyDetailsCell.h"

@implementation DecorationMoneyDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.payExplainLabel.preferredMaxLayoutWidth = YGScreenWidth - 35 - self.explainLabel.size.width;
}
//-(void)viewDidLayoutSubviews{
//    [self.payExplainLabel sizeToFit];//使文字在最上方显示
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
