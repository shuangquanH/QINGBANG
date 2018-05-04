//
//  ServiceProtectTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/12.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ServiceProtectTableViewCell.h"

@implementation ServiceProtectTableViewCell
{
    UIImageView  *_baseImg;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //title
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, YGScreenWidth-30, 25)];
        titleLabel.text = @"服务我们保障";
        titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        titleLabel.textColor = colorWithBlack;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
        //背景
        _baseImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, titleLabel.y+titleLabel.height+5, YGScreenWidth - 30, (YGScreenWidth-30)*0.28)];
        _baseImg.contentMode = UIViewContentModeScaleAspectFill;
        _baseImg.layer.cornerRadius = 5;
        _baseImg.clipsToBounds = YES;
        [self.contentView addSubview:_baseImg];
        
        self.isCreate =NO;
        //
//        [self createRecommendServiceViews];
    }
    return self;

}

- (void)createRecommendServiceViewsWithBottomList:(NSArray *)list withBaseImageUrl:(NSString *)url
{
    if(self.isCreate == YES)
        return;
    [_baseImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:YGDefaultImgTwo_One];

    UILabel *recommendTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,_baseImg.y+_baseImg.height+20, YGScreenWidth-20, 25)];
    recommendTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    recommendTitleLabel.textColor = colorWithBlack;
    recommendTitleLabel.textAlignment = NSTextAlignmentCenter;
    recommendTitleLabel.text = @"因为我们专业";
    [self.contentView addSubview:recommendTitleLabel];
    
    UIScrollView *littleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, recommendTitleLabel.y+recommendTitleLabel.height+5, YGScreenWidth-15, YGScreenWidth*0.67-25)];
    littleScrollView.contentSize = CGSizeMake((YGScreenWidth*0.29+10)*4, YGScreenWidth*0.29*1.36+60);
    [self.contentView addSubview:littleScrollView];
    littleScrollView.showsHorizontalScrollIndicator = NO;
    //    width = 0.28   h =0.58
    for (int i = 0; i<list.count; i++) {
        NSDictionary * dict = [[NSDictionary alloc]init];
        dict = list[i];
        //背景
        UIImageView * baseImg = [[UIImageView alloc]initWithFrame:CGRectMake((YGScreenWidth*0.28+10)*i, 10, YGScreenWidth*0.29, YGScreenWidth*0.29*1.36)];
        [baseImg sd_setImageWithURL:[NSURL URLWithString:dict[@"img"]] placeholderImage:YGDefaultImgThree_Four];
        baseImg.contentMode = UIViewContentModeScaleAspectFill;
        baseImg.layer.cornerRadius = 5;
        baseImg.clipsToBounds = YES;
        [littleScrollView addSubview:baseImg];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(baseImg.x, baseImg.y+baseImg.height+5,YGScreenWidth*0.28,20)];
        nameLabel.text = dict[@"name"];
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        nameLabel.textColor = colorWithBlack;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [littleScrollView addSubview:nameLabel];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(baseImg.x, nameLabel.y+nameLabel.height+5,YGScreenWidth*0.28,100)];
        titleLabel.text = dict[@"info"];
        titleLabel.numberOfLines = 2;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleLabel.text];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:3];
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleLabel.text length])];
        
        titleLabel.attributedText = attributedString;
        
        titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
        titleLabel.textColor = colorWithLightGray;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [littleScrollView addSubview:titleLabel];
        
        CGSize labeleSize = [titleLabel sizeThatFits:CGSizeMake(YGScreenWidth*0.28, 100)];
        
        titleLabel.frame= CGRectMake(baseImg.x, nameLabel.y+nameLabel.height+5,YGScreenWidth*0.28, labeleSize.height);
    }
}
@end
