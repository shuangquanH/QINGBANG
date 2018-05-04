//
//  SecondMainCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/12/12.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondMainCell.h"

@implementation SecondMainCell

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
    _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 15, 35, 35)];
    _avatarImageView.layer.cornerRadius = 17.5;
//    _avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    _avatarButton.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
//    _avatarButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    _avatarImageView.clipsToBounds = YES;
//    [_avatarButton addTarget:self action:@selector(avatarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_avatarImageView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(58, 15, YGScreenWidth - 65, 35)];
    [self.contentView addSubview:topView];
    
    //昵称
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textColor = colorWithBlack;
    _nameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    _nameLabel.frame = CGRectMake(0, 0, topView.frame.size.width, 17.5);
    [topView addSubview:_nameLabel]; 
    _nameLabel.text = @"我叫xxx";
    
    //时间图片
    UIImageView *timeImageView = [[UIImageView alloc]init];
    timeImageView.image = [UIImage imageNamed:@"unused_time_green"];
    timeImageView.frame = CGRectMake(0, 22, 13, 13);
    [topView addSubview:timeImageView];
    
    //时间
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = colorWithPlaceholder;
    _timeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    _timeLabel.frame = CGRectMake(20, 22, topView.frame.size.width - 20, 15);
    [topView addSubview:_timeLabel];
    _timeLabel.text = @"4小时前发布 安徽 合肥";
    
    
    _baseView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.y + topView.height + 15, YGScreenWidth, (YGScreenWidth - 30 )/ 3)];
    [self.contentView addSubview:_baseView];
    
    //三张imageView
//    for (int i = 0; i<3; i++)
//    {
//        UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake(13 + _baseView.height * i + 5 * i, 0, _baseView.height, _baseView.height)];
//        imageButton.tag = 100 + i;
//        imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageButton.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
//        imageButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
//        imageButton.clipsToBounds = YES;
//        imageButton.hidden = YES;
//        imageButton.userInteractionEnabled = NO;
//        [_baseView addSubview:imageButton];
//
//    }
    
    //物品名
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, _baseView.y +_baseView.height + 10, YGScreenWidth - 26, 25)];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.font = [UIFont boldSystemFontOfSize:YGFontSizeBigOne];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.text = @"维莎日式白橡木纯实木书架家具";
    
    
    //详情描述
    _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, _titleLabel.y +_titleLabel.height, YGScreenWidth - 153, 20)];
    _detailLabel.textColor = colorWithDeepGray;
    _detailLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [self.contentView addSubview:_detailLabel];
    _detailLabel.text = @"想换 沙发,餐厅桌,电脑桌";
    
    //评论按钮
    _commentButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth - 90, _titleLabel.y + 20, 40, 30)];
    [_commentButton setImage:[UIImage imageNamed:@"unused_comment"] forState:UIControlStateNormal];
    [_commentButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    _commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//    [_commentButton addTarget:self action:@selector(commentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_commentButton];
    
    //收藏按钮
    _goodButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth - 50, _titleLabel.y + 20, 40, 30)];
    [_goodButton setImage:[UIImage imageNamed:@"unused_zan"] forState:UIControlStateNormal];
//    [_goodButton setImage:[UIImage imageNamed:@"zan_green"] forState:UIControlStateSelected];
    [_goodButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    _goodButton.titleLabel.font = _commentButton.titleLabel.font;
    _goodButton.titleEdgeInsets = _commentButton.titleEdgeInsets;
    //    [_goodButton addTarget:self action:@selector(goodButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_goodButton];
    
}

-(void)setModel:(WorthInModel *)model
{
    _model = model;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:YGDefaultImgAvatar];
//    [_avatarButton sd_setImageWithURL:[NSURL URLWithString:model.img] forState:UIControlStateNormal placeholderImage:YGDefaultImgAvatar];
    _nameLabel.text = model.name;
    _timeLabel.text = [NSString stringWithFormat:@"%@ · %@",model.time,model.address];
    _titleLabel.text = model.title;
//    _detailLabel.text = [NSString stringWithFormat:@"想换 %@",model.classify];
    _detailLabel.text = model.classify;
    
    NSArray *picListArray = [model.picList componentsSeparatedByString:@","].mutableCopy;
    NSMutableArray *imageArray = [NSMutableArray array];
    
    if (picListArray.count > 3) {
        for (int i = 0; i < 3; i++) {
            [imageArray addObject:picListArray[i]];
        }
    }
    else
    {
        imageArray = picListArray.mutableCopy;
    }
    
    for (UIView *view in _baseView.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < imageArray.count; i++) {
        UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake(13 + _baseView.height * i + 5 * i, 0, _baseView.height, _baseView.height)];
        imageButton.tag = 100 + i;
        imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageButton.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
        imageButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        imageButton.clipsToBounds = YES;
//        imageButton.hidden = YES;
        imageButton.userInteractionEnabled = NO;
        [_baseView addSubview:imageButton];
//        UIButton *imageButton = [self.contentView viewWithTag:100+i];
//        imageButton.hidden = NO;
        NSURL *imageUrl = [NSURL URLWithString:imageArray[i]];
        [imageButton sd_setImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:YGDefaultImgSquare];
    }
    
    [_goodButton setTitle:model.colCounts forState:UIControlStateNormal];
    [_commentButton setTitle:model.size forState:UIControlStateNormal];
    
}




@end
