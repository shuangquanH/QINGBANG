//
//  UpLoadPersonTableViewCell.m
//  FrienDo
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "UpLoadPersonTableViewCell.h"

@implementation UpLoadPersonTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.idImageView.layer.cornerRadius = 5;
    self.idImageView.layer.masksToBounds = YES;
    self.idImageView.layer.borderWidth = 10;
    self.idImageView.layer.borderColor = [UIColor colorWithHue:0.63 saturation:0.02 brightness:0.96 alpha:1].CGColor;
    //self.idImageView.contentMode = UIViewContentModeScaleAspectFill;
    _upLoadButton.layer.cornerRadius = 12;
    _upLoadButton.layer.masksToBounds = YES;
}

-(void)setMainModel:(UpLoadModel *)mainModel
{
    _mainModel = mainModel;
    [_idImageView setImage:mainModel.image];
    _titleLabel.text = _mainModel.title;
    _upLoadButton.hidden = [_mainModel.upState boolValue];

}


@end
