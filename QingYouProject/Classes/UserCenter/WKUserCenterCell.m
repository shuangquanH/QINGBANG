//
//  WKUserCenterCell.m
//  QingYouProject
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKUserCenterCell.h"

@implementation WKUserCenterCell
{
    UIImageView *_badgeImageView;
    UILabel *_badgeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _userImageView = [[UIImageView alloc] init];
        _userImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_userImageView];
        
        _titleLabel = [UILabel labelWithFont:18 textColor:kCOLOR_333];
        _titleLabel.numberOfLines = 1;
        [self.contentView addSubview:_titleLabel];
        
        UIImageView *arrowImageView = [UIImageView new];
        arrowImageView.image = [UIImage imageNamed:@"usercenter_arrow_icon"];
        arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:arrowImageView];
        
        [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(KSCAL(34));
            make.size.mas_equalTo(CGSizeMake(KSCAL(45), KSCAL(45)));
        }];
        
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-KSCAL(34));
            make.size.mas_equalTo(CGSizeMake(KSCAL(16), KSCAL(26)));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.equalTo(_userImageView.mas_right).offset(KSCAL(30));
        }];
    }
    return self;
}

- (void)configBadgeNum:(NSInteger)badgeNum {
    if (badgeNum > 0 && !_badgeImageView) {
        _badgeImageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"myorder_list_message"];
        _badgeImageView.image = image;
        [self.contentView addSubview:_badgeImageView];
        
        _badgeLabel = [UILabel labelWithFont:12 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        [_badgeImageView addSubview:_badgeLabel];
    }
    
    if (badgeNum <= 0) {
        _badgeImageView.hidden = YES;
    }
    else {

        _badgeImageView.hidden = NO;
        NSString *badgeStr = [NSString stringWithFormat:@"%ld", MIN(99, badgeNum)];
        _badgeLabel.text = badgeStr;
        [_badgeLabel sizeToFit];
        CGSize labelSize = _badgeLabel.size;
        
        //图片宽高比
        CGFloat scale = _badgeImageView.image.size.width / _badgeImageView.image.size.height;
        CGFloat scaleHead = 32.0 / 41.0;
        CGFloat imageHeight = labelSize.height / scaleHead;
        double  imageWidth = imageHeight * scale;
        
        _badgeImageView.size = CGSizeMake(imageWidth, imageHeight);
        _badgeImageView.centery = KSCAL(88) / 2.0;
        _badgeImageView.x = CGRectGetMaxX(_titleLabel.frame) + KSCAL(14);
        _badgeLabel.center = CGPointMake(_badgeImageView.width / 2.0, _badgeLabel.height / 2.0);
    }
}

@end
