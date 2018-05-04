//
//  MineIntergralRecordOrderTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MineIntergralRecordOrderTableViewCell.h"

@implementation MineIntergralRecordOrderTableViewCell

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
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.contentView.backgroundColor = YGUIColorFromRGB(0xfafafa, 1);
    //图片
    self.goodsImageView = [UIImageView new];
    [self addSubview:self.goodsImageView];
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.top.offset(LDVPadding);
        make.width.height.offset(80);
    }];

    
    //商品名称
    self.goodsNamelabel = [UILabel ld_labelWithTextColor:kBlackColor textAlignment:NSTextAlignmentLeft font:LDFont(14) numberOfLines:2];
    [self addSubview:self.goodsNamelabel];
    [self.goodsNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(LDHPadding);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.goodsImageView.mas_top).offset(5);
    }];
    
    //商品价格
    self.goodsPrice = [UILabel ld_labelWithTextColor:kBlackColor textAlignment:NSTextAlignmentRight font:LDFont(12) numberOfLines:1];
    [self addSubview:self.goodsPrice];
    [self.goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(LDHPadding);
        make.bottom.equalTo(self.goodsImageView.mas_bottom).offset(-10);
        
    }];
    
}
- (void)setModel:(MineIntergralRecordOrderModel *)model
{
    _model = model;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:_model.dPicture] placeholderImage:YGDefaultImgSquare];
    _goodsNamelabel.text = _model.dName;
    _goodsPrice.text = [NSString stringWithFormat:@"%@ 青币",_model.dIntegral];
    
}
@end
