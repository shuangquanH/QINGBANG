//
//  UpLoadEnterpriseTableViewCell.m
//  FrienDo
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "UpLoadEnterpriseTableViewCell.h"

@implementation UpLoadEnterpriseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.enImageView.layer.cornerRadius = 5;
    self.enImageView.layer.masksToBounds = YES;
    self.enImageView.layer.borderWidth = 10;
    self.enImageView.layer.borderColor = [UIColor colorWithHue:0.63 saturation:0.02 brightness:0.96 alpha:1].CGColor;
    self.enImageView.contentMode = UIViewContentModeScaleAspectFill;
    _upLoadButton.layer.cornerRadius = 12;
    _upLoadButton.layer.masksToBounds = YES;
}

-(void)setMainModel:(UpLoadModel *)mainModel
{
    _mainModel = mainModel;
    _enImageView.image = _mainModel.image;
    _titleLabel.text = _mainModel.title;
    _upLoadButton.hidden = [_mainModel.upState boolValue];
}

@end
