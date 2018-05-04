//
//  SecondhandReplacementMyFollowTableViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplacementMyFollowTableViewCell.h"
#import "SecondhandReplacementMyFollowModel.h"

@implementation SecondhandReplacementMyFollowTableViewCell
{
    UIImageView *_leftImageView;
    UILabel *_titleLabel;
    UILabel *_describeLabel;
    UIView *_headerView;
    UIButton * _cancelBtn;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SecondhandReplacementMyFollowModel *)model
{
    _model = model;
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:YGDefaultImgAvatar];
    _leftImageView.layer.cornerRadius = 20;
    _leftImageView.clipsToBounds = YES;
    _titleLabel.text = _model.name;
    _describeLabel.text = _model.autograph;
    [_describeLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-85];
    _headerView.frame = CGRectMake(0, 0, YGScreenWidth, (20+_describeLabel.height+10)>60?(20+_describeLabel.height+10+20):60);

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 50)];
        [self.contentView addSubview:_headerView];
        //左线
        _leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_tool1.png"]];
        _leftImageView.frame = CGRectMake(10, 10, 40, 40);
        _leftImageView.layer.borderColor = colorWithLine.CGColor;
        _leftImageView.layer.borderWidth = 0.5;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headerView addSubview:_leftImageView];
        

        _cancelBtn = [[UIButton alloc]init];
        [self addSubview:_cancelBtn];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.cornerRadius = 12;
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.borderColor = colorWithMainColor.CGColor;
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_cancelBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        
        float w = ([UILabel calculateWidthWithString:_cancelBtn.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30);
        
        _cancelBtn.frame = CGRectMake(YGScreenWidth - 15 - w, _leftImageView.y + LDHPadding, w, 24);
        
        //热门推荐label
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = colorWithBlack;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _titleLabel.text = @"";
        _titleLabel.frame = CGRectMake(_leftImageView.x+_leftImageView.width+10, _leftImageView.y,YGScreenWidth- 85 - w , 20);
        [_headerView addSubview:_titleLabel];
        
        
        //热门推荐label
        _describeLabel = [[UILabel alloc]init];
        _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height+5 , YGScreenWidth- 85 - w , 0);
        _describeLabel.textColor = colorWithBlack;
        _describeLabel.text = @"";
        _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _describeLabel.numberOfLines = 0;
        [_headerView addSubview:_describeLabel];

    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(YGScreenWidth, _headerView.height);
}
-(void)cancelBtnClick:(UIButton *)btn
{
    [self.delegate secondhandReplacementMyFollowTableViewCellCannelButton:btn withRow:self.row];
}

@end

