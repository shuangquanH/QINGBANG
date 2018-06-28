//
//  WKAfterSaleRecordCell.m
//  QingYouProject
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKAfterSaleRecordCell.h"
#import "WKImageCollectionView.h"

#import "NSString+SQStringSize.h"

@implementation WKAfterSaleRecordCell
{
    UILabel *_stateLab;//状态
    UILabel *_timeLab;
    UILabel *_problemLab;
    UILabel *_certificateTipLab;
    UILabel *_resultLab;
    
    WKImageCollectionView *_imageCollectView;
    WKAfterSaleModel *_saleInfo;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        [self setupSubviews];
        
        [self makeConstraints];
    }
    return self;
}

- (void)configInfo:(WKAfterSaleModel *)info {
    
    _saleInfo = info;
    
    _stateLab.text = info.stateDesc;
    _timeLab.text = [NSString stringWithFormat:@"您于%@发起了售后申请：", info.createTime];
    _problemLab.text = [NSString stringWithFormat:@"问题描述：%@", info.afterSaleDesc?:@""];
    
    NSArray *urls = [info.images componentsSeparatedByString:@","];
    if (!urls.count) {
        _imageCollectView.hidden = YES;
        _certificateTipLab.hidden = YES;
        [_resultLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self->_stateLab);
            make.top.equalTo(_problemLab.mas_bottom).offset(KSCAL(20));
        }];
    }
    else {
        [_imageCollectView setHidden:NO forRange:NSMakeRange(0, urls.count)];
        for (int i = 0; i < urls.count; i++) {
            [_imageCollectView setImageUrl:urls[i] forIndex:i];
        }
        _certificateTipLab.hidden = NO;
        [_resultLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self->_stateLab);
            make.top.equalTo(_imageCollectView.mas_bottom).offset(KSCAL(20));
        }];
    }
    
    if (info.afterSaleState == 0) {
        _resultLab.text = @"";
    }
    else {
        _resultLab.text = [NSString stringWithFormat:@"处理结果：%@", info.afterSaleResult?:@""];
    }
}

- (void)setupSubviews {
    _stateLab = [UILabel labelWithFont:KSCAL(38) textColor:kCOLOR_333];
    _stateLab.numberOfLines = 1;
    [self.contentView addSubview:_stateLab];
    
    _timeLab = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_666];
    _timeLab.numberOfLines = 1;
    [self.contentView addSubview:_timeLab];
    
    _problemLab = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_666];
    [self.contentView addSubview:_problemLab];
    
    _certificateTipLab = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_666];
    [_certificateTipLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:_certificateTipLab];
    
    _imageCollectView = [[WKImageCollectionView alloc] initWithMaxCount:1 hasDeleteAction:NO];
    [self.contentView addSubview:_imageCollectView];
    
    _resultLab = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_666];
    [self.contentView addSubview:_resultLab];
 
    _certificateTipLab.text = @"凭证：";
    
    @weakify(self)
    _imageCollectView.viewClicker = ^(UIView *view, NSInteger index) {
        @strongify(self)
        if ([self.delegate respondsToSelector:@selector(recordCell:didSelectImageIndex:withSaleInfo:withTargetView:)]) {
            [self.delegate recordCell:self didSelectImageIndex:index withSaleInfo:self->_saleInfo withTargetView:view];
        }
    };
}

- (void)makeConstraints {
    [_stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(30));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(KSCAL(50));
    }];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_stateLab);
        make.top.equalTo(_stateLab.mas_bottom).offset(KSCAL(30));
    }];
    
    [_problemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_stateLab);
        make.top.equalTo(_timeLab.mas_bottom).offset(KSCAL(20));
    }];
    
    [_certificateTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_stateLab);
        make.top.equalTo(_problemLab.mas_bottom).offset(KSCAL(20));
    }];
    
    [_imageCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_certificateTipLab.mas_right).offset(5);
        make.top.equalTo(_certificateTipLab);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(KSCAL(130));
    }];
    
    [_resultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_stateLab);
        make.top.equalTo(_imageCollectView.mas_bottom).offset(KSCAL(20));
    }];
}

+ (CGFloat)cellHeightWithSaleInfo:(WKAfterSaleModel *)saleInfo {
    
    CGFloat height = KSCAL(100);
    
    NSArray *imageUrls = [saleInfo.images componentsSeparatedByString:@","];
    if (imageUrls.count) {
        height += KSCAL(150);
    }
    
    if (saleInfo.afterSaleState == 2) {
        NSString *result = [NSString stringWithFormat:@"处理结果：%@", saleInfo.afterSaleResult];
        CGFloat resultH = [result sizeWithFont:KFONT(28) andMaxSize:CGSizeMake(KAPP_WIDTH-KSCAL(60), MAXFLOAT)].height;
        height += (resultH + KSCAL(20));
    }
    CGFloat stateH = [@"38高度" sizeWithFont:KFONT(38) andMaxSize:CGSizeMake(KAPP_WIDTH-KSCAL(60), MAXFLOAT)].height;
    height += stateH;
    
    CGFloat timeH = [@"28高度" sizeWithFont:KFONT(28) andMaxSize:CGSizeMake(KAPP_WIDTH-KSCAL(60), MAXFLOAT)].height;
    height += (timeH + KSCAL(30));
    
    NSString *problem = [NSString stringWithFormat:@"问题描述：%@", saleInfo.afterSaleDesc];
    CGFloat problemH = [problem sizeWithFont:KFONT(28) andMaxSize:CGSizeMake(KAPP_WIDTH-KSCAL(60), MAXFLOAT)].height;
    height += (problemH + KSCAL(20));
    
    return height;
}


@end
