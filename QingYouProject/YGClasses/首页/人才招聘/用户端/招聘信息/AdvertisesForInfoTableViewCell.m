//
//  AdvertisesForInfoTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AdvertisesForInfoTableViewCell.h"

@implementation AdvertisesForInfoTableViewCell
{
    UILabel *_titleLabel; //标题
    UILabel *_money; //月薪
//    UILabel *_jobNameLabel; //职位
    UIView *_treatmentBaseView; //待遇
    UIButton *_deliverCurriculumButton; //投递简历按钮
    UIButton *_deleteCurriculumButton; //删除简历按钮
    UILabel *_deliverStateLabel; //投递状态

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
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
        baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:baseView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 20)];
        _titleLabel.text = @"诚聘业务员、业务经理";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _titleLabel.textColor = colorWithBlack;
        [baseView addSubview:_titleLabel];
        
        _deliverStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(YGScreenWidth-100,_titleLabel.y , 90, 20)];
        _deliverStateLabel.text = @"已投递";
        _deliverStateLabel.textAlignment = NSTextAlignmentLeft;
        _deliverStateLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _deliverStateLabel.textColor = colorWithMainColor;
        [_deliverStateLabel sizeToFit];
        _deliverStateLabel.frame = CGRectMake(YGScreenWidth-_deliverStateLabel.width-10,_deliverStateLabel.y , _deliverStateLabel.width, 20);
        [baseView addSubview:_deliverStateLabel];
        
        
        _money = [[UILabel alloc] initWithFrame:CGRectMake(10,_titleLabel.y+_titleLabel.height+5 , YGScreenWidth/2, 20)];
        _money.text = @"3000-5000元/月";
        _money.textAlignment = NSTextAlignmentLeft;
        _money.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _money.textColor = colorWithOrangeColor;
//        [_money sizeToFit];
//        _money.frame = CGRectMake(10,_money.y , _money.width, 20);
        [baseView addSubview:_money];
        
//        _jobNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_money.x+_money.width+10,_money.y , 100, 20)];
//        _jobNameLabel.text = @"业务员";
//        _jobNameLabel.textAlignment = NSTextAlignmentLeft;
//        _jobNameLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
//        _jobNameLabel.textColor = colorWithDeepGray;
//        [_jobNameLabel sizeToFit];
//        _jobNameLabel.frame = CGRectMake(_jobNameLabel.x,_money.y , _jobNameLabel.width, 20);
//        [baseView addSubview:_jobNameLabel];
        
        _treatmentBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, _money.y+_money.height+10, YGScreenWidth*0.6, 30)];
        [baseView addSubview:_treatmentBaseView];
        
       
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, _treatmentBaseView.y+_treatmentBaseView.height, YGScreenWidth-10, 1)];
        lineView.backgroundColor = colorWithTable;
        [baseView addSubview:lineView];
        
        
        _deliverCurriculumButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-70,_money.y+10,70,35)];
        [_deliverCurriculumButton setTitle:@"投递简历" forState:UIControlStateNormal];
        [_deliverCurriculumButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
        [_deliverCurriculumButton addTarget:self action:@selector(deliverCurriculumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _deliverCurriculumButton.layer.cornerRadius = 17;
        _deliverCurriculumButton.tag = 1000;
        _deliverCurriculumButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [_deliverCurriculumButton sizeToFit];
        _deliverCurriculumButton.backgroundColor =colorWithMainColor;
        [baseView addSubview:_deliverCurriculumButton];
        _deliverCurriculumButton.frame = CGRectMake(YGScreenWidth-_deliverCurriculumButton.width-30,_money.y+10,_deliverCurriculumButton.width+20,35);
        
        
        
        _deleteCurriculumButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-50,_treatmentBaseView.y,40,40)];
        [_deleteCurriculumButton addTarget:self action:@selector(deleteCurriculumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteCurriculumButton.tag = 10000;
        [_deleteCurriculumButton setImage:[UIImage imageNamed:@"steward_delete_black"] forState:UIControlStateNormal];
        _deleteCurriculumButton.imageView.contentMode = UIViewContentModeCenter;
        [baseView addSubview:_deleteCurriculumButton];
        
        if ([reuseIdentifier isEqualToString:@"AdvertisesForInfoTableViewCellEnterprise"])
        {
            _deliverCurriculumButton.hidden = YES;
            _deleteCurriculumButton.hidden = NO;
            _deliverStateLabel.hidden = YES;
            lineView.hidden = YES;
        }else if([reuseIdentifier isEqualToString:@"AdvertisesForInfoTableViewCellDeliverRecored"])
        {
            _deliverCurriculumButton.hidden = YES;
            _deleteCurriculumButton.hidden = YES;
            _deliverStateLabel.hidden = NO;
            lineView.hidden = YES;
        }else
        {
            _deliverCurriculumButton.hidden = NO;
            _deleteCurriculumButton.hidden = YES;
            _deliverStateLabel.hidden = YES;
        }
    }
    return self;
}

- (void)setModel:(AdvertiseModel *)model
{
    _model = model;
    _deliverCurriculumButton.tag = 1000+_model.indexPath.section;
    _deleteCurriculumButton.tag = 10000+_model.indexPath.section;
    _titleLabel.text = _model.name == nil?_model.job:_model.name;

    _money.text = [NSString stringWithFormat:@"%@/月",_model.price == nil?_model.salary:_model.price];
    if ((_model.price != nil && [_model.price isEqualToString:@"面议"]) || (_model.salary != nil && [_model.salary isEqualToString:@"面议"]) || (_model.price != nil && [_model.price isEqualToString:@"不限"]) || (_model.salary != nil && [_model.salary isEqualToString:@"不限"])) {
        _money.text = [NSString stringWithFormat:@"%@",_model.price == nil?_model.salary:_model.price];
    }
    for (UIView *view in _treatmentBaseView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat widthCount = 0.0f;
    NSArray *array = [_model.content == nil?_model.benefits:_model.content componentsSeparatedByString:@","];
    for (int i = 0;i<array.count;i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10+widthCount+i*5, 0, 0, 20)];
        label.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        label.textColor = colorWithMainColor;
        label.text = array[i];
        [label sizeToFit];
        CGFloat labeWidth = label.width+10;
        label.frame = CGRectMake(10+widthCount+i*5, 0, labeWidth, 20) ;
        label.layer.cornerRadius = 5;
        label.layer.borderColor = colorWithMainColor.CGColor;
        label.layer.borderWidth = 1;
        label.textAlignment = NSTextAlignmentCenter;
        widthCount = widthCount +labeWidth;
        if (widthCount>(YGScreenWidth*0.6-i*5)) {
            if (i<array.count) {
                UIImageView *cellImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"omit_green"]];
                cellImageView.frame = CGRectMake(_treatmentBaseView.width-10,0,40, 5);
                cellImageView.contentMode = UIViewContentModeScaleAspectFill;
                cellImageView.clipsToBounds = YES;
                [cellImageView sizeToFit];
                [_treatmentBaseView addSubview:cellImageView];
                cellImageView.centery = label.centery;
            }
            break;
        }
        [_treatmentBaseView addSubview:label];
        
        ;
    }
}

- (void)deliverCurriculumButtonAction:(UIButton *)btn
{
    [self.delegate deliverIntroduceWithModel:_model];
}

- (void)deleteCurriculumButtonAction:(UIButton *)btn
{
    [self.delegate deleteAdvertiseWithModel:_model];
}

@end
