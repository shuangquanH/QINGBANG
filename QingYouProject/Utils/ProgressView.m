//
//  ProgressView.m
//  Entertainer
//
//  Created by nefertari on 16/7/25.
//  Copyright © 2016年 王丹. All rights reserved.
//

#import "ProgressView.h"
#define PROGRESSWIDTH   (YGScreenWidth-20)
@implementation ProgressView
{
    UIImageView     *_trackImageView;
    UIImageView     *_progressImageView;
    UILabel         *_percentLabel;
    UILabel *_processLabel;
}
- (instancetype)initWithHeight:(CGFloat)progressHeight andWidth:(CGFloat)progressWidth
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, progressWidth, progressHeight);
        _progressHeight = 3;
        _progressWidth = progressWidth;
        [self createProgress];
        
    }
    return self;
}

- (void)setProgress:(double)progress andTotal:(double)total
{
    //超出的
    CGFloat  morePercent = 0.0;
    if ((progress/total*100)*PROGRESSWIDTH /100 >= PROGRESSWIDTH) {
        
        _progress = progress/total*100;
        morePercent = PROGRESSWIDTH;
    }else
    {
        _progress = progress/total*100;
        morePercent = _progress * PROGRESSWIDTH /100;
    }
    
    
    if (!isnan(progress)) {
        [_progressImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.mas_equalTo(_trackImageView);
            make.width.mas_equalTo(morePercent);
        }];
    }
    _processLabel.text = [NSString stringWithFormat:@"%d%%",(int)_progress];
    [_processLabel sizeToFit];

    if (morePercent <= 20) {
        [_processLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_progressImageView.mas_left);
            make.width.mas_equalTo(_processLabel.width+10);
            make.height.mas_equalTo(_processLabel.height);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
    }else
    {
        [_processLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_progressImageView.mas_right);
            make.width.mas_equalTo(_processLabel.width+10);
            make.height.mas_equalTo(_processLabel.height);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    if (morePercent>=PROGRESSWIDTH) {
        [_processLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_progressImageView.mas_right).mas_offset(-_processLabel.width-10);
            make.width.mas_equalTo(_processLabel.width+10);
            make.height.mas_equalTo(_processLabel.height);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    
    
    
}
- (void)createProgress
{

      CGFloat  offset = 12;
    _percentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _percentLabel.text = @"项目进度";
    _percentLabel.textColor = [UIColor blackColor];
    _percentLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [self addSubview:_percentLabel];
    [_percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(_percentLabel.height);
        make.width.mas_equalTo(_percentLabel.width);
    }];
    
    _trackImageView = [[UIImageView alloc]init];
    _trackImageView.backgroundColor = colorWithLine;
    _trackImageView.layer.cornerRadius = 1;
    _trackImageView.clipsToBounds = YES;
    [self addSubview:_trackImageView];
    [_trackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(offset);
        make.left.mas_equalTo(_percentLabel.mas_right).mas_equalTo(3);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(_progressHeight);
    }];
    
    
    _progressImageView = [[UIImageView alloc]init];
    _progressImageView.backgroundColor = colorWithMainColor;
    _progressImageView.layer.cornerRadius = 1;
    _progressImageView.clipsToBounds = YES;
    [_trackImageView addSubview:_progressImageView];
    [_progressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_trackImageView);
        make.height.mas_equalTo(_progressHeight);
    }];
    
    _processLabel = [[UILabel alloc] init];
    _processLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    _processLabel.textColor = [UIColor whiteColor];
    _processLabel.textAlignment = NSTextAlignmentCenter;
    _processLabel.backgroundColor = colorWithMainColor;
    _processLabel.layer.cornerRadius = 7;
    _processLabel.clipsToBounds = YES;
    [self addSubview:_processLabel];
}

@end
