//
//  WKUserInfoMessageCell.m
//  QingYouProject
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKUserCenterMessageCell.h"
#import "WKUserCenterMessageModel.h"

#import "NSString+SQStringSize.h"

static const CGFloat kCircleW = 4.0;

@implementation WKUserCenterMessageCell
{
    UIView *_bgView;
    
    UILabel *_titleLabel;
    UILabel *_detailLabel;
    UILabel *_timeLabel;
    
    CAReplicatorLayer *_topReplicatorLayer;
    CAReplicatorLayer *_leftReplicatorLayer;
    CAReplicatorLayer *_rightReplicatorLayer;
    CAReplicatorLayer *_bottomReplicatorLayer;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    
    _titleLabel = [UILabel labelWithFont:KSCAL(36) textColor:kCOLOR_333 textAlignment:NSTextAlignmentCenter];
    _titleLabel.numberOfLines = 1;
    [_bgView addSubview:_titleLabel];
    
    _detailLabel = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_666];
    [_bgView addSubview:_detailLabel];
    
    _timeLabel = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_666];
    [_bgView addSubview:_timeLabel];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(KSCAL(36), KSCAL(50), KSCAL(36), KSCAL(50)));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(KSCAL(30));
        make.top.mas_equalTo(KSCAL(20));
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(KSCAL(20));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleLabel);
        make.bottom.mas_equalTo(-KSCAL(20));
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_topReplicatorLayer) {
        
        
        CGFloat width = self.width - 2 * KSCAL(30);
        NSInteger hCount = width / kCircleW / 2.0 + 1;
        _topReplicatorLayer = [CAReplicatorLayer layer];
        _topReplicatorLayer.instanceCount = hCount;
        _topReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(kCircleW * 2, 0, 0);
        [_topReplicatorLayer addSublayer:[self circleLayer]];
        _topReplicatorLayer.frame = CGRectMake(KSCAL(30), KSCAL(16), width, kCircleW);
        _topReplicatorLayer.masksToBounds = YES;
        [self.contentView.layer addSublayer:_topReplicatorLayer];
        
        _bottomReplicatorLayer = [CAReplicatorLayer layer];
        _bottomReplicatorLayer.instanceCount = hCount;
        _bottomReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(kCircleW * 2, 0, 0);
        [_bottomReplicatorLayer addSublayer:[self circleLayer]];
        _bottomReplicatorLayer.frame = CGRectMake(KSCAL(30), self.height - KSCAL(16) - kCircleW, width, kCircleW);
        _bottomReplicatorLayer.masksToBounds = YES;
        [self.contentView.layer addSublayer:_bottomReplicatorLayer];
        
        //左右
        CGFloat height = self.height - 2 * KSCAL(16);
        NSInteger vCount = height / kCircleW / 2 + 1;
        _leftReplicatorLayer = [CAReplicatorLayer layer];
        _leftReplicatorLayer.instanceCount = vCount;
        _leftReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, kCircleW * 2, 0);
        [_leftReplicatorLayer addSublayer:[self circleLayer]];
        _leftReplicatorLayer.frame = CGRectMake(KSCAL(30), KSCAL(16), kCircleW, height);
        _leftReplicatorLayer.masksToBounds = YES;
        [self.contentView.layer addSublayer:_leftReplicatorLayer];
        
        _rightReplicatorLayer = [CAReplicatorLayer layer];
        _rightReplicatorLayer.instanceCount = vCount;
        _rightReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, kCircleW * 2, 0);
        [_rightReplicatorLayer addSublayer:[self circleLayer]];
        _rightReplicatorLayer.frame = CGRectMake(self.width-KSCAL(30)-kCircleW, KSCAL(16), kCircleW, height);
        _rightReplicatorLayer.masksToBounds = YES;
        [self.contentView.layer addSublayer:_rightReplicatorLayer];
    }
}

- (void)configMessageInfo:(WKUserCenterMessageModel *)messageInfo {
    _titleLabel.text = messageInfo.messageTitle;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3.0];
    NSAttributedString *detail = [[NSAttributedString alloc] initWithString:messageInfo.messageDetail attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    _detailLabel.attributedText = detail;
    _timeLabel.text = messageInfo.messageTime;
}

+ (CGFloat)cellHeightWithMessageInfo:(WKUserCenterMessageModel *)messageInfo {
    CGFloat height = KSCAL(36) * 2 + 4 * KSCAL(20);
    
    CGFloat maxW = kScreenW - KSCAL(80) * 2;
    
    CGFloat titleH = [messageInfo.messageTitle sizeWithFont:KFONT(36) andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    CGFloat timeH = [messageInfo.messageTime sizeWithFont:KFONT(28) andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    CGFloat descH = [messageInfo.messageDetail labelAutoCalculateRectWithLineSpace:3.0 Font:KFONT(28) MaxSize:CGSizeMake(maxW, MAXFLOAT)].height;
    height += (titleH + timeH + descH);
    
    return height;
}

- (CALayer *)circleLayer {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, kCircleW, kCircleW);
    layer.cornerRadius = kCircleW / 2.0;
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    return layer;
}

@end
