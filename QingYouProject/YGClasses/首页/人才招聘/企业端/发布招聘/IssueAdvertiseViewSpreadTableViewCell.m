//
//  IssueAdvertiseViewSpreadTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "IssueAdvertiseViewSpreadTableViewCell.h"

@implementation IssueAdvertiseViewSpreadTableViewCell
{
    UILabel *_nameLabel;
    NSMutableArray * _dataSource;
    UIView *_baseView;
    UIView *_titleBaseView;
    UIView *_lineView;
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
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = colorWithYGWhite;
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
        [self addSubview:_baseView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 80, 45)];
        _nameLabel.text = @"福利待遇";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _nameLabel.textColor = colorWithDeepGray;
        [_baseView addSubview:_nameLabel];
        
        _titleBaseView = [[UIView alloc] initWithFrame:CGRectMake(90, 10, YGScreenWidth-120, 30)];
        [_baseView addSubview:_titleBaseView];
        
//        _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, _baseView.height-1, YGScreenWidth-10, 1)];
//        _lineView.backgroundColor = colorWithLine;
//        [_baseView addSubview:_lineView];
        
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.frame = CGRectMake(0, 0, 17, 17);
        arrowImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
        [arrowImageView sizeToFit];
        self.accessoryView = arrowImageView;
    }
    return self;
}
- (void)setModel:(AdvertisesForInfoModel *)model withIndexPath:(NSIndexPath *)indexPath
{
    _model = model;
    _dataSource = [[NSMutableArray alloc] init];
    [_dataSource addObjectsFromArray: [_model.content componentsSeparatedByString:@","]];
    
    for (UIView *view in _titleBaseView.subviews) {
        [view removeFromSuperview];
    }
    CGSize size = CGSizeMake(YGScreenWidth, 45);
    if (_dataSource.count>0 && ((NSString *)_dataSource[0]).length>0) {
        
        size = [self createLabelsWithbaseView:_titleBaseView];
        _titleBaseView.frame = CGRectMake(_titleBaseView.x, _titleBaseView.y, _titleBaseView.width, size.height);
    }
    
    if (size.height <= 45) {
        _baseView.frame = CGRectMake(0, 0, YGScreenWidth, 45);
        
    }else
    {
        _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _titleBaseView.y+_titleBaseView.height);
        
    }
    _lineView.frame = CGRectMake(10, _baseView.height-1, YGScreenWidth-10, 1);
        
  
}
- (CGSize)createLabelsWithbaseView:(UIView *)baseView
{
    int k = 0;
    CGFloat widthCount = 0.0f;
    int j = 0;
    for (int i = 0;i<_dataSource.count;i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_dataSource[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [button.titleLabel sizeToFit];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 10000+i;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 25)];
        label.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        label.text = _dataSource[i];
        [label sizeToFit];
        
        CGFloat labeWidth = label.width+15;
        widthCount = widthCount +labeWidth;

        button.frame = CGRectMake(baseView.width-(10+widthCount+k*10), 25*j, labeWidth, 20) ;
        
//        widthCount = widthCount +labeWidth;
        
        if (widthCount>(baseView.width-20-k*10)) {
            j=j+1;
            k=0;
            widthCount = 0.0f;
            widthCount = widthCount +labeWidth;
            button.frame = CGRectMake(baseView.width-(10+widthCount+k*10),25*j, labeWidth, 20) ;
        }
        button.layer.borderColor = colorWithMainColor.CGColor;
        [button setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 1;
        k++;
        
        [baseView addSubview:button];
        
    }
    return CGSizeMake(YGScreenWidth, (j+1)*25);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(_baseView.width, _baseView.height);
}
@end
