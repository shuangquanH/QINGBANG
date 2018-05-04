//
//  NewThingsCommentCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/16.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "NewThingsCommentCell.h"

@implementation NewThingsCommentCell
{
    UIView *_baseView;
    UILabel *_titleLabel; //标题
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(SonCommentModel *)model
{
    _model = model;
    _baseView.backgroundColor = colorWithTable;
    
    if(model.name.length)
    {
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@回复%@: %@",model.userName,model.name,model.content]];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:colorWithMainColor range:NSMakeRange(0, model.userName.length)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:colorWithMainColor range:NSMakeRange(model.userName.length + @"回复".length,model.name.length)];
        _titleLabel.attributedText = AttributedStr;
        
    }
    else
    {
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@ ",model.userName,model.content]];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:colorWithMainColor range:NSMakeRange(0, model.userName.length)];
        _titleLabel.attributedText = AttributedStr;
    }
    [_titleLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-90];
    _baseView.frame = CGRectMake(60+15-3, 0, YGScreenWidth-90 + 3, _titleLabel.height + 10);
    
    
    
//    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@回复%@",model.name,model.content]];
//    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]  range:NSMakeRange(0, [model.name length])];
//    _titleLabel.attributedText = AttributedStr;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
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
        _baseView = [[UIView alloc]initWithFrame:CGRectMake(0,0, YGScreenWidth, 100)];
        _baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:_baseView];
        
        
        //热门推荐label
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = colorWithBlack;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _titleLabel.text = @"今日头条";
        _titleLabel.frame = CGRectMake(5, 5,YGScreenWidth - 100, 20);
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
