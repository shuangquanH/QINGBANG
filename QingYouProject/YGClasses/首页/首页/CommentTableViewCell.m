//
//  CommentTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/9/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell
{
    UIView *_baseView;
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
- (void)setDict:(NSDictionary *)dict
{
    _titleLabel.text = [NSString stringWithFormat:@"%@回复%@",dict[@"name"],dict[@"detail"]];
    [_titleLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-100-15];
    _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _titleLabel.height+20);
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@回复%@",dict[@"name"],dict[@"detail"]]];

    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]  range:NSMakeRange(0, [dict[@"name"] length])];
    
//    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([dict[@"name"] length]+2, [dict[@"name"] length]+[dict[@"name"] length]+1)];
    _titleLabel.attributedText = AttributedStr;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //右边的accessoryView给图片
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.frame = CGRectMake(0, 0, 17, 17);
        arrowImageView.image = [UIImage imageNamed:@"go_gray.png"];
        self.accessoryView = arrowImageView;
        
        //热门推荐view
        _baseView = [[UIView alloc]initWithFrame:CGRectMake(0,0, YGScreenWidth, 100)];
        _baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:_baseView];
        

        //热门推荐label
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = colorWithBlack;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _titleLabel.text = @"今日头条";
        _titleLabel.frame = CGRectMake( 60+15, 15,YGScreenWidth-100-15, 20);
        _titleLabel.numberOfLines = 0;
        [_baseView addSubview:_titleLabel];
        
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
  return  CGSizeMake(_baseView.width, _baseView.height);
}
@end
