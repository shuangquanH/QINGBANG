//
//  SecondhandReplacementICreateTableViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplacementICreateTableViewCell.h"
#import "SecondhandReplacementICreateModel.h"

@interface SecondhandReplacementICreateTableViewCell ()
{
    UIButton * _platformButton;
    UIButton * _deleteButton;
    UIButton * _editButton;
    
    UILabel *_line;
    UIImageView * _goodsImageView;
    UILabel * _titleLabel;
    UILabel * _imageLabel;
}
@end
@implementation SecondhandReplacementICreateTableViewCell

-(void)setModel:(SecondhandReplacementICreateModel *)model{
    _titleLabel.text = model.title;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:YGDefaultImgSquare];
    _imageLabel.hidden =YES;
    
    NSString * bottomStatus = [NSString stringWithFormat:@"%@",model.bottomStatus];
    if([model.lockFlag isEqualToString:@"1"])//置换成功
    {
        _platformButton.hidden =YES;
        _editButton.hidden = YES;
        _imageLabel.hidden = NO;

        _deleteButton.frame = CGRectMake(YGScreenWidth - 15 - ([UILabel calculateWidthWithString:_editButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 56, ([UILabel calculateWidthWithString:_editButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
        return;
    }
     // bottomStatus  兜底状态 空未处理 0已处理 1同意 2拒绝 3过期
    if([bottomStatus isEqualToString:@"0"] || [bottomStatus isEqualToString:@"3"] )//平台未兜底
    {
        _platformButton.hidden =NO;
        _editButton.hidden =NO;
        
        _deleteButton.frame = CGRectMake(_editButton.x -15- ([UILabel calculateWidthWithString:_deleteButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30),  56, ([UILabel calculateWidthWithString:_deleteButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
    }
    else
    {
        _platformButton.hidden =YES;
        _editButton.hidden = NO;
        
        _deleteButton.frame = CGRectMake(_editButton.x -15 - ([UILabel calculateWidthWithString:@"删除" textFont:LDFont(12) numerOfLines:1].width + 30), 56, ([UILabel calculateWidthWithString:_deleteButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
    }

  
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}
- (void)setupUI{
    
    _goodsImageView = [UIImageView new];
    [self addSubview:_goodsImageView];
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.top.offset(LDVPadding);
        make.width.height.offset(70);
    }];
    _imageLabel = [UILabel new];
    [self addSubview:_imageLabel];
    _imageLabel.text =@"置换成功";
    _imageLabel.textColor = [UIColor whiteColor];
    _imageLabel.textAlignment = NSTextAlignmentCenter;
    _imageLabel.font = [UIFont systemFontOfSize:12];
    _imageLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [_imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.top.offset(LDVPadding);
        make.width.height.offset(70);
    }];
    
    _titleLabel = [UILabel ld_labelWithTextColor:kBlackColor textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:YGFontSizeBigOne] numberOfLines:1];
    [self addSubview:_titleLabel];
    _titleLabel.numberOfLines = 2;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-LDHPadding);
        make.left.equalTo(_goodsImageView.mas_right).offset(LDVPadding);
        make.top.equalTo(_goodsImageView).offset(LDVPadding / 2);
    }];
    
    _platformButton = [[UIButton alloc]init];
    [self addSubview:_platformButton];
    [_platformButton addTarget:self action:@selector(platformButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _platformButton.layer.borderWidth = 1;
    _platformButton.layer.cornerRadius = 12;
    _platformButton.layer.masksToBounds = YES;
    _platformButton.layer.borderColor = colorWithLine.CGColor;
    _platformButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_platformButton setTitle:@"平台兜底" forState:UIControlStateNormal];
    [_platformButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    
    _deleteButton = [[UIButton alloc]init];
    [self addSubview:_deleteButton];
    [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _deleteButton.layer.borderWidth = 1;
    _deleteButton.layer.cornerRadius = 12;
    _deleteButton.layer.masksToBounds = YES;
    _deleteButton.layer.borderColor = colorWithLine.CGColor;
    _deleteButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    
    _editButton = [[UIButton alloc]init];
    [self addSubview:_editButton];
    [_editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _editButton.layer.borderWidth = 1;
    _editButton.layer.cornerRadius = 12;
    _editButton.layer.masksToBounds = YES;
    _editButton.layer.borderColor = colorWithMainColor.CGColor;
    _editButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_editButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    
    _editButton.frame = CGRectMake(YGScreenWidth - 15 - ([UILabel calculateWidthWithString:_editButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 56, ([UILabel calculateWidthWithString:_editButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
    
    _deleteButton.frame = CGRectMake(_editButton.x -15 - ([UILabel calculateWidthWithString:_deleteButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 56, ([UILabel calculateWidthWithString:_deleteButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
    
    _platformButton.frame = CGRectMake(_deleteButton.x -15 - ([UILabel calculateWidthWithString:_platformButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30),  56, ([UILabel calculateWidthWithString:_platformButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30), 24);
    
}

-(void)platformButtonClick:(UIButton *)btn
{
    [self.delegate secondhandReplacementICreateTableViewCellPlatformButton:btn withRow:self.row];
}
-(void)editButtonClick:(UIButton *)btn
{
    [self.delegate  secondhandReplacementICreateTableViewCellEditBtn:btn withRow:self.row];
}
-(void)deleteButtonClick:(UIButton *)btn
{
    [self.delegate secondhandReplacementICreateTableViewCellDeleteBtn:btn withRow:self.row];
}

@end




