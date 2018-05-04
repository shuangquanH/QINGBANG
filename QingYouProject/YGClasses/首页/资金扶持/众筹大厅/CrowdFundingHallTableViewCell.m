//
//  CrowdFundingHallTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CrowdFundingHallTableViewCell.h"
#import "ProgressView.h"

@implementation CrowdFundingHallTableViewCell
{
    UIImageView *_projectVideoImageView; //广告轮播
    UIView          *_baseView;
    UILabel *_titleLabel;
    UILabel  *_contenttionLabel;
    
    
    UIImageView *_avaterImageView; //头像
    UILabel *_nameLabel; //昵称
    UIButton *_identityButton; //身份
    CGFloat     _headerHeight;
    
    UILabel *_incomeRightsLabel; //收益权
    UILabel *_addressLabel; //地址
    ProgressView *_progressView;
    UIView *_rightsAndAddressBaseView;
    UIView *_progressBaseView;
    
    UILabel *_statusLabel;
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
        self.contentView.backgroundColor = colorWithTable;
        [self setSubviews];
    }
    return self;
}
- (void)setSubviews
{
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, (YGScreenWidth/2+115+70))];
    _baseView.backgroundColor = colorWithYGWhite;
    [self.contentView addSubview:_baseView];
    //广告滚动
    _projectVideoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, YGScreenWidth-20, (YGScreenWidth-20)*0.56)];
    _projectVideoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _projectVideoImageView.clipsToBounds = YES;
//    [_projectVideoImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:YGDefaultImgAvatar];
    [_baseView addSubview:_projectVideoImageView];
    
    
    //热门推荐label
    _statusLabel = [[UILabel alloc]init];
    _statusLabel.textColor = colorWithYGWhite;
    _statusLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _statusLabel.frame = CGRectMake(0, 20,100, 30);
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.backgroundColor = [colorWithMainColor colorWithAlphaComponent:0.5];
    [_projectVideoImageView addSubview:_statusLabel];

    
    
    //热门推荐label
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _titleLabel.text = @"沿江股份首次公开发行浮漂并创业板上市路演";
    _titleLabel.frame = CGRectMake(10, _projectVideoImageView.y+_projectVideoImageView.height+10,YGScreenWidth-30, 35);
    _titleLabel.numberOfLines = 0;
    [_titleLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-20];
    _titleLabel.frame = CGRectMake(10, _titleLabel.y,YGScreenWidth-30, _titleLabel.height);
    [_baseView addSubview:_titleLabel];
    
    //热门推荐label
    _contenttionLabel = [[UILabel alloc]init];
    _contenttionLabel.frame = CGRectMake(10,_titleLabel.y+_titleLabel.height+10, YGScreenWidth-20, 35);
    _contenttionLabel.textColor = colorWithDeepGray;
    _contenttionLabel.text = @"说的是离开的删了的可是；来的快速发送；理发师";
    _contenttionLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [_baseView addSubview:_contenttionLabel];
    /********************** 收益权 地址 ********************/
    
    _rightsAndAddressBaseView = [[UIView alloc] initWithFrame:CGRectMake(10, _contenttionLabel.y+_contenttionLabel.height+5, YGScreenWidth-20, 25)];
    [_baseView addSubview:_rightsAndAddressBaseView];
    
    
    UIImageView *incomeRightsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    incomeRightsImageView.image = [UIImage imageNamed:@"steward_capital_label"];
    [incomeRightsImageView sizeToFit];
    [_rightsAndAddressBaseView addSubview:incomeRightsImageView];
    
    //收益权
    _incomeRightsLabel = [[UILabel alloc]initWithFrame:CGRectMake(incomeRightsImageView.x+incomeRightsImageView.width+5, 0, 70, 25)];
    _incomeRightsLabel.textColor = colorWithDeepGray;
    _incomeRightsLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _incomeRightsLabel.text = @"收益权";
    [_rightsAndAddressBaseView addSubview:_incomeRightsLabel];
    _incomeRightsLabel.centery = incomeRightsImageView.centery;
    
    UIImageView *addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(90, incomeRightsImageView.y, 20, 20)];
    addressImageView.image = [UIImage imageNamed:@"steward_capital_address"];
    [addressImageView sizeToFit];
    [_rightsAndAddressBaseView addSubview:addressImageView];
    
    //收益权
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(addressImageView.x+addressImageView.width+5, _incomeRightsLabel.y, YGScreenWidth-(addressImageView.x+addressImageView.width+5-20), 25)];
    _addressLabel.textColor = colorWithDeepGray;
    _addressLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _addressLabel.text = @"收益权";
    [_rightsAndAddressBaseView addSubview:_addressLabel];
    _addressLabel.centery = addressImageView.centery;
    
    /********************** 进度条 众筹 ********************/
    _progressBaseView = [[UIView alloc] initWithFrame:CGRectMake(10, _rightsAndAddressBaseView.y+_rightsAndAddressBaseView.height+10, YGScreenWidth-20, 80)];
    [_baseView addSubview:_progressBaseView];
    
    NSArray *contentArr = @[@"¥300,000",@"¥250,000",@"10"];
    NSArray *titleArr = @[@"筹集目标",@"已筹集",@"剩余天数"];

    for (int i = 0; i<3; i++)
    {
        //热门推荐label
        UILabel *crowdFundingLabel = [[UILabel alloc]init];
        crowdFundingLabel.textColor = colorWithMainColor;
        crowdFundingLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        crowdFundingLabel.text = contentArr[i];
        crowdFundingLabel.tag = 88888+i;
        crowdFundingLabel.textAlignment = NSTextAlignmentCenter;
        [_progressBaseView addSubview:crowdFundingLabel];
        crowdFundingLabel.frame = CGRectMake((YGScreenWidth/3)*i, 30,YGScreenWidth/3, 20);
        
        //热门推荐label
        UILabel *crowdFundingTitleLabel = [[UILabel alloc]init];
        crowdFundingTitleLabel.textColor = colorWithLightGray;
        crowdFundingTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        crowdFundingTitleLabel.text = titleArr[i];
        crowdFundingTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_progressBaseView addSubview:crowdFundingTitleLabel];
        crowdFundingTitleLabel.frame = CGRectMake((YGScreenWidth/3)*i,50 ,YGScreenWidth/3, 20);

        
    }
    _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _progressBaseView.y+_progressBaseView.height);
}
- (void)setModel:(CrowdFundingHallModel *)model
{
    _model = model;
    _titleLabel.text = _model.projectName;
    _titleLabel.numberOfLines = 2;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(10, _titleLabel.y,YGScreenWidth-20, _titleLabel.height+5);
    
    UILabel *crowdFundingLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, YGScreenWidth-20, 35)];
    crowdFundingLabel.textColor = colorWithMainColor;
    crowdFundingLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    crowdFundingLabel.text = _model.projectDescribe;
    crowdFundingLabel.numberOfLines = 0;
    [crowdFundingLabel sizeToFit];
    
    _contenttionLabel.text = _model.projectDescribe;

    if (crowdFundingLabel.height>20) {
        _contenttionLabel.numberOfLines = 2;
        _contenttionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _contenttionLabel.frame = CGRectMake(10,_titleLabel.y+_titleLabel.height+10, YGScreenWidth-20, 45);
    }else
    {
        _contenttionLabel.numberOfLines = 1;
        _contenttionLabel.frame = CGRectMake(10,_titleLabel.y+_titleLabel.height+10, YGScreenWidth-20, 25);
    }
    _rightsAndAddressBaseView.frame = CGRectMake(10, _contenttionLabel.y+_contenttionLabel.height+5, YGScreenWidth-20, 25);
    _progressBaseView.frame = CGRectMake(_progressBaseView.x, _rightsAndAddressBaseView.y+_rightsAndAddressBaseView.height+10, _progressBaseView.width, _progressBaseView.height);
    [_projectVideoImageView sd_setImageWithURL:[NSURL URLWithString:_model.picture] placeholderImage:YGDefaultImgSixteen_Nine];
    
    if (_progressView) {
        [_progressView removeFromSuperview];
    }
    _progressView = [[ProgressView alloc] initWithHeight:25 andWidth:YGScreenWidth-20];
    [_progressBaseView addSubview:_progressView];
    [_progressView setProgress:[model.hasRaise doubleValue] andTotal:[model.raiseGoal doubleValue]];
    _incomeRightsLabel.text = _model.calm;
    _addressLabel.text = _model.projectAddress;

    for (int i = 0; i<3; i++)
    {
        UILabel *crowdFundingLabel = [self.contentView viewWithTag:88888+i];
        if (i == 0)
        {
            crowdFundingLabel.text = [NSString stringWithFormat:@"¥%@",_model.raiseGoal];
        }
        if (i == 1)
        {
            if ([_model.hasRaise isEqualToString:@"0"]) {
                crowdFundingLabel.text = [NSString stringWithFormat:@"¥%@",_model.hasRaise];

            }else
            {
                crowdFundingLabel.text = [NSString stringWithFormat:@"¥%@",_model.hasRaise];

            }

        }
        if (i == 2)
        {
            crowdFundingLabel.text = [NSString stringWithFormat:@"%@",_model.raiseDays];

        }
        
    }
    if (_model.project_state == nil && _model.projectState == nil) {
        _statusLabel.hidden = YES;
    }else
    {
        NSArray *typeArry = @[@"",@"待审核",@"",@"审核不通过",@"已失效"];
        NSArray *typeColorArry = @[colorWithMainColor,colorWithMainColor,colorWithMainColor,colorWithBlack,colorWithBlack];
        _statusLabel.backgroundColor = [((UIColor *)typeColorArry[[_model.project_state intValue]]) colorWithAlphaComponent:0.7];
        if (_model.project_state) {
            _statusLabel.text = typeArry[[_model.project_state intValue]];

        }
        if (_model.projectState) {
            _statusLabel.text = typeArry[[_model.projectState intValue]];
        }
        _statusLabel.hidden = YES;
        if ([_model.projectState isEqualToString:@"4"]) {
            _statusLabel.hidden = NO;
        }

        
    }

    _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _progressBaseView.y+_progressBaseView.height);

}
- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(YGScreenWidth, _baseView.height);
}
@end
