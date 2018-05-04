//
//  HomePageSeccondTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/9/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "HomePageSeccondTableViewCell.h"

@implementation HomePageSeccondTableViewCell
{
    UIView *_baseView;
    UIImageView *_leftImageView; //左边的图
    UILabel *_describeLabel; //内容
    UILabel *_titleLabel; //标题
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(HomePageModel *)model withType:(NSString *)type
{
    _model = model;
//    if ([type isEqualToString:@"remmend"]) {
//        _leftImageView.layer.cornerRadius = 30;
//        _leftImageView.clipsToBounds = YES;
//        _describeLabel.numberOfLines = 3;
//        _titleLabel.y = _leftImageView.y-5;
//
//    }else
//    {
//        _leftImageView.layer.cornerRadius = 0;
//        _leftImageView.clipsToBounds = YES;
//        _describeLabel.numberOfLines = 4;
//        _leftImageView.y = 25;
//        _titleLabel.y = _leftImageView.y-10;
//
//    }
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:YGDefaultImgThree_Four];
    if (model.img == nil) {
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgs] placeholderImage:YGDefaultImgThree_Four];

    }
    _titleLabel.text = _model.name;
    _describeLabel.text = _model.content;
    [_describeLabel sizeToFit];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //右边的accessoryView给图片
//        UIImageView *arrowImageView = [[UIImageView alloc] init];
//        arrowImageView.frame = CGRectMake(0, 0, 17, 17);
//        arrowImageView.image = [UIImage imageNamed:@"go_gray.png"];
//        self.accessoryView = arrowImageView;
        
        //热门推荐view
        _baseView = [[UIView alloc]initWithFrame:CGRectMake(0,0, YGScreenWidth, 90)];
        _baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:_baseView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,0, YGScreenWidth, 1)];
        lineView.backgroundColor = colorWithLine;
        [_baseView addSubview:lineView];
        
        //左线
        _leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_tool1.png"]];
        _leftImageView.frame = CGRectMake(10, 15, 60*1.73, 60);
        _leftImageView.layer.borderColor = colorWithLine.CGColor;
        _leftImageView.layer.borderWidth = 0.5;
        _leftImageView.backgroundColor = colorWithMainColor;
        _leftImageView.layer.cornerRadius = 5;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.clipsToBounds = YES;
        [_baseView addSubview:_leftImageView];
       
        //新鲜事标题label
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = colorWithBlack;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _titleLabel.text = @"今日头条   ";
        _titleLabel.frame = CGRectMake(_leftImageView.x+_leftImageView.width+10, _leftImageView.y+5,YGScreenWidth-_leftImageView.width-30, 20);
        [_baseView addSubview:_titleLabel];
        
        
        //新鲜事内容label
        _describeLabel = [[UILabel alloc]init];
        _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height+5 , YGScreenWidth-_leftImageView.width-25, 35);
        _describeLabel.textColor = colorWithLightGray;
        _describeLabel.text = @"is就嗲减低设计费is分解符及时答复hi合肥如武汉";
        _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _describeLabel.numberOfLines = 2;
        _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_baseView addSubview:_describeLabel];
 
    }
    return self;
}

@end
