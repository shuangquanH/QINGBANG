//
//  SecondhandReplacementICollectTableViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplacementICollectTableViewCell.h"
#import "SecondhandPeplaceCollectModel.h"

@implementation SecondhandReplacementICollectTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //头像按钮
    _avatarButton = [[UIButton alloc]initWithFrame:CGRectMake(13, 15, 35, 35)];
    _avatarButton.layer.cornerRadius = 17.5;
    _avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarButton.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
    _avatarButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    _avatarButton.clipsToBounds = YES;
    _avatarButton.backgroundColor = colorWithRedColor;
    //    [_avatarButton addTarget:self action:@selector(avatarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_avatarButton];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(58, 15, YGScreenWidth - 65, 35)];
    [self.contentView addSubview:topView];
    
    _cancalButton = [[UIButton alloc]init];
    [topView addSubview:_cancalButton];
    [_cancalButton addTarget:self action:@selector(cancalButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancalButton.layer.borderWidth = 1;
    _cancalButton.layer.cornerRadius = 12;
    _cancalButton.layer.masksToBounds = YES;
    _cancalButton.layer.borderColor = colorWithMainColor.CGColor;
    _cancalButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_cancalButton setTitle:@"取消收藏" forState:UIControlStateNormal];
    [_cancalButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    
    float w = ([UILabel calculateWidthWithString:_cancalButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30);
    
    _cancalButton.frame = CGRectMake(topView.width - w - 3, 0, w, 24);
    
    //昵称
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textColor = colorWithBlack;
    _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _nameLabel.frame = CGRectMake(0, 0, topView.frame.size.width - _cancalButton.width -13, 17.5);
    [topView addSubview:_nameLabel];
    _nameLabel.text = @"";
    
    //时间图片
    UIImageView *timeImageView = [[UIImageView alloc]init];
    timeImageView.image = [UIImage imageNamed:@"unused_time_green"];
    timeImageView.frame = CGRectMake(0, 22, 13, 13);
    [topView addSubview:timeImageView];
    
    //时间
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = colorWithPlaceholder;
    _timeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    _timeLabel.frame = CGRectMake(20, 22, topView.frame.size.width - 20 -_cancalButton.width -13, 15);
    [topView addSubview:_timeLabel];
    _timeLabel.text = @"";

    _baseView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.y + topView.height + 15, YGScreenWidth, (YGScreenWidth - 36 )/ 3)];
    [self.contentView addSubview:_baseView];
    
    //三张imageView
    for (int i = 0; i<3; i++)
    {
        UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake(13 + _baseView.height * i + 5 * i, 0, _baseView.height, _baseView.height)];
        imageButton.tag = 100 + i;
        imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageButton.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
        imageButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        imageButton.clipsToBounds = YES;
        imageButton.hidden = YES;
        imageButton.userInteractionEnabled = NO;
        [_baseView addSubview:imageButton];
        [imageButton setBackgroundImage:YGDefaultImgSquare forState:UIControlStateNormal];
    }
    
    //物品名
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, _baseView.y +_baseView.height + 10, YGScreenWidth - 26, 25)];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.text = @"";
    
    
    //详情描述
    _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, _titleLabel.y +_titleLabel.height, YGScreenWidth - 153, 20)];
    _detailLabel.textColor = colorWithDeepGray;
    _detailLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [self.contentView addSubview:_detailLabel];
    _detailLabel.text = @"";
    
}


-(void)setModel:(SecondhandPeplaceCollectModel *) model
{
    _model = model;
    [_avatarButton sd_setImageWithURL:[NSURL URLWithString:model.userImg] forState:UIControlStateNormal placeholderImage:YGDefaultImgAvatar];
    _nameLabel.text = model.userName;
    _timeLabel.text = [NSString stringWithFormat:@"发布于%@",model.createDate];
    _titleLabel.text = model.title;
    _detailLabel.text = [NSString stringWithFormat:@"%@",model.wantChange];
    
    NSArray * imageArry = model.imgs;
    for (int i = 0; i < imageArry.count; i++) {
        UIButton *imageButton = [self.contentView viewWithTag:100+i];
        imageButton.hidden = NO;
        NSURL *imageUrl = [NSURL URLWithString:imageArry[i]];
        [imageButton sd_setBackgroundImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:YGDefaultImgSquare];
    }
    
}
-(void)cancalButtonClick:(UIButton *)btn
{
    [self.delegate secondhandReplacementICollectTableViewCellCancelButton:btn withRow:self.row];
}



@end

