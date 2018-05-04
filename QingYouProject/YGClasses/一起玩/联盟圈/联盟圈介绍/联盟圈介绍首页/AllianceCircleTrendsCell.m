//
//  AllianceCircleTrendsCell.m
//  
//
//  Created by nefertari on 2017/10/16.
//

#import "AllianceCircleTrendsCell.h"

@implementation AllianceCircleTrendsCell
{
    UIImageView *_headImageView;
}

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
    _headImageView = [[UIImageView  alloc]init];
    _headImageView.layer.cornerRadius = 17.5;
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.clipsToBounds = YES;
    _headImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_headImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarButtonClick)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_headImageView addGestureRecognizer:tap];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textColor = colorWithBlack;
    _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [self.contentView addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = colorWithDeepGray;
    _timeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [self.contentView addSubview:_timeLabel];
    
    _detailLabel = [[UILabel alloc]init];
    _detailLabel.textColor = colorWithBlack;
    _detailLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _detailLabel.numberOfLines = 0;
    [self.contentView addSubview:_detailLabel];
    
    _baseView = [[UIView alloc]init];
    [self.contentView addSubview:_baseView];
    
    UIView *subBaseView = [[UIView alloc]initWithFrame:CGRectMake(48, 0, (YGScreenWidth -48-10), 0)];
    [_baseView addSubview:subBaseView];
    
    _detailLabel.preferredMaxLayoutWidth = subBaseView.width;
    
    for (int i = 0; i<self.reuseIdentifier.intValue; i++)
    {
        int x = i%3;
        int y = i/3;
        UIImageView *imageButton = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (subBaseView.width - 5*2)/3, (subBaseView.width - 5*2)/3)];
        imageButton.x = x * (imageButton.width+5);
        imageButton.y = y * (imageButton.height+5);
        imageButton.tag = 100 + i;
        imageButton.contentMode = UIViewContentModeScaleAspectFill;
//        imageButton.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
//        imageButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        imageButton.clipsToBounds = YES;
        imageButton.userInteractionEnabled = NO;
//        [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [subBaseView addSubview:imageButton];
        
        if (self.reuseIdentifier.integerValue == 1)
        {
            imageButton.width = subBaseView.width;
            imageButton.height = imageButton.width * 380 / 690;
        }
        
        if (i == self.reuseIdentifier.intValue - 1)
        {
            subBaseView.height = imageButton.y + imageButton.height;
        }
        
    }
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = colorWithYGWhite;
    [self.contentView addSubview:lineView];
    
    _commentButton = [[UIButton alloc]init];
    [_commentButton setImage:[UIImage imageNamed:@"home_playtogether_comment_black"] forState:UIControlStateNormal];
    [_commentButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    _commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [_commentButton addTarget:self action:@selector(commentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_commentButton];
    
    _goodButton = [[UIButton alloc]init];
    [_goodButton setImage:[UIImage imageNamed:@"zan_black"] forState:UIControlStateNormal];
    [_goodButton setImage:[UIImage imageNamed:@"zan_green"] forState:UIControlStateSelected];
    [_goodButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    _goodButton.titleLabel.font = _commentButton.titleLabel.font;
    _goodButton.titleEdgeInsets = _commentButton.titleEdgeInsets;
    [_goodButton addTarget:self action:@selector(goodButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_goodButton];

    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(35);
        make.left.top.mas_equalTo(10);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_headImageView.mas_centerY);
        make.left.mas_equalTo(_headImageView.mas_right).offset(8);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImageView.mas_right).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(8);
    }];
    
    [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(subBaseView);
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(_detailLabel.mas_bottom).offset(10);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_baseView.mas_bottom).offset(7);
        make.left.right.mas_equalTo(_baseView);
        make.height.mas_equalTo(1);
    }];
    
    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.top.mas_equalTo(lineView.mas_bottom).offset(5);
        make.width.mas_equalTo(60);
        make.bottom.mas_equalTo(-10);
    }];
    
    [_goodButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_commentButton.mas_left).offset(-5);
        make.centerY.mas_equalTo(_commentButton.mas_centerY);
        make.width.mas_equalTo(_commentButton.mas_width);
    }];

    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.centerY.mas_equalTo(_goodButton.mas_centerY);
    }];
    MASAttachKeys(_headImageView,_nameLabel,_timeLabel,_detailLabel,_baseView,lineView,_commentButton,_goodButton);
}

- (void)setModel:(AllianceCircleTrendsModel *)model
{
    _model = model;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.userImg] placeholderImage:YGDefaultImgAvatar];
    _nameLabel.text = model.userName;
    _timeLabel.text = model.createDate;
    _detailLabel.text = model.content;
    _goodButton.selected = model.isLike.intValue;
    [_goodButton setTitle:_model.likeCount forState:UIControlStateNormal];
    [_commentButton setTitle:model.commentCount forState:UIControlStateNormal];
    
    for (int i = 0; i<model.imgArr.count; i++)
    {
        if (model.imgArr.count == 1) {
            UIImageView *imageButton = [self.contentView viewWithTag:100 + i];
            [imageButton sd_setImageWithURL:[NSURL URLWithString:model.imgArr[i]] placeholderImage:YGDefaultImgAvatar];

        }
        else
        {
            UIImageView *imageButton = [self.contentView viewWithTag:100 + i];
            [imageButton sd_setImageWithURL:[NSURL URLWithString:model.imgArr[i]] placeholderImage:YGDefaultImgAvatar];
        }
    }
    
}

- (void)imageButtonClick:(UIButton *)button
{
    [_delegate circleTableViewCell:self didClickImageButtonWithIndex:(int)button.tag - 100 imageButton:button imageArray:_model.imgArr];
}

- (void)avatarButtonClick
{
    [_delegate circleTableViewCell:self didClickAvatarButtonWithModel:_model];
}

- (void)commentButtonClick
{
    [_delegate circleTableViewCell:self didClickCommentButtonWithModel:_model];
}

- (void)goodButtonClick:(UIButton *)button
{
    [_delegate circleTableViewCell:self didClickGoodButtonWithModel:_model goodButton:button];
}

- (void)collectButtonClick:(UIButton *)button
{
    [_delegate circleTableViewCell:self didClickCollectButtonWithModel:_model collectButton:button];
}

@end
