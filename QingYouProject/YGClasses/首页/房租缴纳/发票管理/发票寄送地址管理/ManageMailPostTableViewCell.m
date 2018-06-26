//
//  ManageMailPostTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/30.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ManageMailPostTableViewCell.h"

@implementation ManageMailPostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
        self.backgroundColor = colorWithTable;
        
        UIView *baseView = [[UIView alloc]init];
        baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:baseView];
        [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(0);
            make.width.mas_equalTo(YGScreenWidth);
            make.top.mas_offset(0);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-1);
        }];
        
        
        //姓名
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"逆袭学院";
        _nameLabel.textColor = colorWithBlack;
        _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        [baseView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.top.mas_offset(12);
        }];
        
        //电话
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.text = @"123456";
        _phoneLabel.textColor = _nameLabel.textColor;
        _phoneLabel.font = _nameLabel.font;
        [baseView addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(_nameLabel.mas_right).offset(10);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
        }];
        
        //省市区
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.text = @"杭州市 玉溪区";
        _addressLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _addressLabel.textColor = colorWithDeepGray;
        [baseView addSubview:_addressLabel];
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.centerY.mas_equalTo(baseView);
        }];
        
        //具体地址
        _detailAddressLabel = [[UILabel alloc]init];
        _detailAddressLabel.font = _addressLabel.font;
        _detailAddressLabel.textColor = _addressLabel.textColor;
        _detailAddressLabel.text = @"浦东路2661号";
        [baseView addSubview:_detailAddressLabel];
        [_detailAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.top.mas_equalTo(_addressLabel.mas_bottom).offset(10);
            make.bottom.mas_equalTo(baseView.mas_bottom).mas_offset(-10);
        }];
        
    }
    
    return self;
}
-(void)setModel:(ManageMailPostModel *)model
{
    if (_model != model) {
        
        _model = model;
    }
    
    _nameLabel.text = _model.name;
    
    _phoneLabel.text = _model.phone;
    
    _addressLabel.text = [NSString stringWithFormat:@"%@%@%@",_model.prov,_model.city,_model.dist];
    
    _detailAddressLabel.text = _model.address;
    
}

@end
