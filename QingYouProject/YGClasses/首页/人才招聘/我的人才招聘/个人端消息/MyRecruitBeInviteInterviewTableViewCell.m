//
//  MyRecruitBeInviteInterviewTableViewCell.m
//  QingYouProject
//
//  Created by 王丹 on 2017/11/16.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyRecruitBeInviteInterviewTableViewCell.h"

@implementation MyRecruitBeInviteInterviewTableViewCell
{
    UILabel *_statusLabel;
    UILabel *_companyLabel;
    UILabel *_jobLabel;
    UILabel *_dateLabel;
    UILabel *_addressLabel;
    UIButton *_deliverCurriculumButton; //投递简历按钮
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(AdvertiseModel *)model
{
    _model = model;
    _companyLabel.text = _model.company;
    _jobLabel.text = _model.job;
    _dateLabel.text = _model.time;
    _addressLabel.text = _model.address;
    if ([model.state isEqualToString:@"3"]) {
        [_deliverCurriculumButton setTitle:@"已接受" forState:UIControlStateNormal];
        [_deliverCurriculumButton setTitleColor:colorWithOrangeColor forState:UIControlStateNormal];
        _deliverCurriculumButton.layer.borderWidth = 0;
        _deliverCurriculumButton.userInteractionEnabled = NO;
        _deliverCurriculumButton.backgroundColor =[UIColor clearColor];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //热门推荐label
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.textColor = colorWithBlack;
        _statusLabel.font =  [UIFont fontWithName:@"AmericanTypewriter-Bold" size:YGFontSizeBigTwo];
        _statusLabel.text = @"邀请您到公司面试";
        _statusLabel.frame = CGRectMake(10, 10,YGScreenWidth-100, 25);
        [self.contentView addSubview:_statusLabel];

        
        _companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,_statusLabel.y+_statusLabel.height+5 , YGScreenWidth-30, 25)];
        _companyLabel.text = @"江山为尊商贸有限公司";
        _companyLabel.textAlignment = NSTextAlignmentLeft;
        _companyLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _companyLabel.textColor = colorWithBlack;
        [self.contentView addSubview:_companyLabel];
        
        
        //热门推荐label
        _jobLabel = [[UILabel alloc]init];
        _jobLabel.textColor = colorWithDeepGray;
        _jobLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _jobLabel.text = @"业务员";
        _jobLabel.frame = CGRectMake(10, _companyLabel.y+_companyLabel.height,120, 25);
        [self.contentView addSubview:_jobLabel];
        

        UILabel *dateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,_jobLabel.y+_jobLabel.height , 40, 25)];
        dateTitleLabel.text = @"时间:";
        dateTitleLabel.textAlignment = NSTextAlignmentLeft;
        dateTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        dateTitleLabel.textColor = colorWithDeepGray;
        [self.contentView addSubview:dateTitleLabel];
        
        
        //热门推荐label
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.textColor = colorWithBlack;
        _dateLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _dateLabel.text = @"2017-10-09 下午15：00";
        _dateLabel.frame = CGRectMake(dateTitleLabel.x+dateTitleLabel.width+10, dateTitleLabel.y,YGScreenWidth-dateTitleLabel.width-30, 20);
        [self.contentView addSubview:_dateLabel];
        

        UILabel *addressTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,dateTitleLabel.y+dateTitleLabel.height , dateTitleLabel.width, 25)];
        addressTitleLabel.text = @"地址:";
        addressTitleLabel.textAlignment = NSTextAlignmentLeft;
        addressTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        addressTitleLabel.textColor = colorWithDeepGray;
        [self.contentView addSubview:addressTitleLabel];
        
        
        //热门推荐label
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.textColor = colorWithBlack;
        _addressLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _addressLabel.text = @"安徽合肥大厦XX街";
        _addressLabel.frame = CGRectMake(addressTitleLabel.x+addressTitleLabel.width+10, addressTitleLabel.y,YGScreenWidth-dateTitleLabel.width-30, 20);
        [self.contentView addSubview:_addressLabel];
        
        
        
        _deliverCurriculumButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-70,_statusLabel.y+10,70,35)];
        [_deliverCurriculumButton setTitle:@"接受面试" forState:UIControlStateNormal];
        [_deliverCurriculumButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
        [_deliverCurriculumButton addTarget:self action:@selector(acceptInterviewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _deliverCurriculumButton.layer.borderColor = colorWithLine.CGColor;
        _deliverCurriculumButton.layer.borderWidth = 1;
        _deliverCurriculumButton.layer.cornerRadius = 17;
        _deliverCurriculumButton.tag = 1000;
        _deliverCurriculumButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [_deliverCurriculumButton sizeToFit];
        _deliverCurriculumButton.backgroundColor =colorWithMainColor;
        [self.contentView addSubview:_deliverCurriculumButton];
        _deliverCurriculumButton.frame = CGRectMake(YGScreenWidth-_deliverCurriculumButton.width-30,_statusLabel.y+10,_deliverCurriculumButton.width+20,35);
        
    
    }
    return self;
}

- (void)acceptInterviewButtonAction:(UIButton *)btn
{
    [self.delegate acceptInterviewButtonActionWithModel:_model];
}

@end
