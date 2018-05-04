//
//  OrderCheckHouseDetailTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderCheckHouseDetailTableViewCell.h"

@implementation OrderCheckHouseDetailTableViewCell
{
    UIView *_baseView;
    UILabel *_contentLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setContent:(NSString *)content
{
    _content = content;
    _contentLabel.text = _content;
   CGFloat height = [self getLabelHeightWithText:_content withLabel:_contentLabel];
    _contentLabel.frame = CGRectMake(_contentLabel.x,_contentLabel.y , YGScreenWidth-20, height);
    _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _contentLabel.y+_contentLabel.height+10);

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = colorWithTable;
        
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 20)];
        _baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:_baseView];
        
//       UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 20)];
//        titleLabel.text = @"房源详情";
//        titleLabel.textAlignment = NSTextAlignmentLeft;
//        titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
//        titleLabel.textColor = colorWithBlack;
//        [_baseView addSubview:titleLabel];
        
        
//        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.x,titleLabel.y+titleLabel.height+10 , YGScreenWidth-20, 25)];
                _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 25)];

        _contentLabel.text = @"爱姐弟仨激动死ad就死啊哈似乎发生独爱回复的说法是丢啊回复虽大横幅上帝啊回复is的护肤四；啊回复撒返回时啦就死傲娇发is代缴费is阿金费四大家粉丝大姐夫is大姐夫is大姐夫is啊";
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _contentLabel.textColor = colorWithDeepGray;
        _contentLabel.numberOfLines = 0;
        [_contentLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-20];
        _contentLabel.frame = CGRectMake(_contentLabel.x,_contentLabel.y , YGScreenWidth-20, _contentLabel.height);
        [_baseView addSubview:_contentLabel];
        _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _contentLabel.y+_contentLabel.height+10);
        
    }
    return self;
}

- (CGFloat)getLabelHeightWithText:(NSString *)content withLabel:(UILabel *)label
{
    // 调整行间距
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    paragraphStyle.paragraphSpacingBefore = 0.0;//段首行空白空间
    paragraphStyle.paragraphSpacing = 0.0; //段与段之间间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    //attributedText设置后之前设置的都失效
    
    label.attributedText = attributedString;
    
    [label sizeToFitVerticalWithMaxWidth:YGScreenWidth -20];
    
    NSDictionary *attribute =@{NSFontAttributeName:label.font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:colorWithDeepGray};
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(YGScreenWidth -20, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.height;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(_baseView.width, _baseView.height);
}

@end
