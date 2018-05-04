//
//  WaitToNetManagerTableViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/11/9.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "WaitToNetManagerTableViewCell.h"
#import "WaitToNetManagerModel.h"

@interface WaitToNetManagerTableViewCell ()



@end
@implementation WaitToNetManagerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = colorWithBlack;
    self.addressLabel.textColor = colorWithDeepGray;
    self.createDateLabel.textColor = colorWithDeepGray;
    self.contactLable.textColor = colorWithDeepGray;
    
//    self.titleLabel.text = @"可的而二级基尔加丹技术吗上到几点对对对计算计算教计算机哦哦00";
//    self.addressLabel.text = @"可的而二级基尔加丹技术吗上到几点对对对计算计算教计算机哦哦00737273ddjjsdjsdjdsjdsjdj思考思考思考思考思考00";
//    self.createDateLabel.text = @"创建时间: 2017.09.09 - 13.09";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(WaitToNetManagerModel *)model{
    _model = model;
    
    self.titleLabel.text = model.companyName;
    
    if(model.addressPhone.length >10)
      self.contactLable.text = [NSString stringWithFormat:@"%@ %@",model.addressName,[model.addressPhone stringByReplacingCharactersInRange:NSMakeRange(3, 5)  withString:@"*****"]];
    
    self.addressLabel.text = model.companyAddress;
    self.createDateLabel.text = [NSString stringWithFormat:@"创建时间：%@",model.createDate];

}
@end
