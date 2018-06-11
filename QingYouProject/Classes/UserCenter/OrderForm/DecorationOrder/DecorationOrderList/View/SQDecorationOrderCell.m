//
//  SQDecorationOrderCell.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/17.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationOrderCell.h"
#import "NSString+SQStringSize.h"
#import "WKDecorationStageView.h"
#import "UIButton+SQImagePosition.h"

#define KSPACE 20

@implementation SQDecorationOrderCell {

    UIImageView *orderImage;
    UILabel *orderTitle;
    UILabel *orderDesc;
    UILabel *orderPrice;

    @public
    WKDecorationStageView *paymentStageView;//订金阶段视图
    SQDecorationDetailModel *_orderInfo;//订单信息
    CALayer *bottomLineLayer;

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        orderImage = [[UIImageView alloc] init];
        orderImage.contentMode = UIViewContentModeScaleAspectFill;
        orderImage.clipsToBounds = YES;
        [self.contentView addSubview:orderImage];
        
        orderTitle = [[UILabel alloc] init];
        orderTitle.font = KFONT(28.0);
        orderTitle.textColor = kCOLOR_666;
        orderTitle.numberOfLines = 2;
        [self.contentView addSubview:orderTitle];
        
        orderDesc = [[UILabel alloc] init];
        orderDesc.font = KFONT(28.0);
        orderDesc.textColor = kCOLOR_666;
        orderDesc.numberOfLines = 1;
        [self.contentView addSubview:orderDesc];
        
        orderPrice = [[UILabel alloc] init];
        orderPrice.font = KFONT(28.0);
        orderPrice.textColor = kCOLOR_666;
        [self.contentView addSubview:orderPrice];
        
        paymentStageView = [[WKDecorationStageView alloc] init];
        paymentStageView.delegate = self;
        [self.contentView addSubview:paymentStageView];
        
        bottomLineLayer = [CALayer layer];
        bottomLineLayer.backgroundColor = colorWithLine.CGColor;
        [self.contentView.layer addSublayer:bottomLineLayer];
        
        [self sqlayoutSubviews];
    }
    return self;
}


- (void)sqlayoutSubviews {

    [orderImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(KSCAL(30));
        make.top.mas_equalTo(KSCAL(KSPACE));
        make.width.mas_equalTo(KSCAL(240));
        make.height.mas_equalTo(KSCAL(180));
    }];
    
    [orderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderImage.mas_right).offset(KSCAL(KSPACE));
        make.top.equalTo(orderImage);
        make.right.equalTo(self.contentView).offset(-KSCAL(30));
    }];
    
    [orderDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(orderTitle);
        make.top.equalTo(orderTitle.mas_baseline).offset(KSCAL(KSPACE));
    }];
    
    [orderPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(orderTitle);
        make.bottom.equalTo(orderImage.mas_bottom);
    }];
    
    [paymentStageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderImage);
        make.centerX.mas_equalTo(0);
        make.top.equalTo(orderImage.mas_bottom).offset(KSCAL(KSPACE));
        make.height.mas_equalTo(KSCAL(88));
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    bottomLineLayer.frame = CGRectMake(KSCAL(30), self.contentView.height-KSCAL(KSPACE), self.contentView.width-KSCAL(60), 1);
}

- (void)setModel:(id)model {
    orderImage.backgroundColor = [UIColor orangeColor];
    orderImage.image = [UIImage imageNamed:@"mine_instashot"];
    orderTitle.text = @"产品名称产品名称产品名称产品名称产品名称产品名称产品名称";
    orderDesc.text = @"产品描述产品描述产品描述产品描述产品描述产品描述产品描述";
    orderPrice.text = @"189230元";
}

- (CGSize)intrinsicContentSize {
    return [self viewSize];
}

#pragma mark - SQDecorationDetailViewProtocol
- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {
    
    _orderInfo = orderInfo;
    
    orderDesc.text = orderInfo.decorateDescribe;
    NSMutableAttributedString *estimatePrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@（预估价）", orderInfo.estimate]];
    [estimatePrice setAttributes:@{NSForegroundColorAttributeName: kCOLOR_PRICE_RED} range:NSMakeRange(0, 2+orderInfo.estimate.length)];
    orderPrice.attributedText = estimatePrice;
    [orderImage sd_setImageWithURL:[NSURL URLWithString:orderInfo.decorate_icon] placeholderImage:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    NSAttributedString *decorateName = [[NSAttributedString alloc] initWithString:orderInfo.decorateName attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    orderTitle.attributedText = decorateName;
    orderTitle.lineBreakMode = NSLineBreakByTruncatingTail;

    [paymentStageView configOrderInfo:orderInfo withStage:0 withInDetail:self.isInOrderDetail];
}

- (CGSize)viewSize {
    CGFloat height = KSCAL(88.0) + KSCAL(180.0) + 3 * KSCAL(KSPACE);
    return CGSizeMake(kScreenW, height);
}

#pragma mark - WKDecorationStageViewDelegate
- (void)stageView:(WKDecorationStageView *)stageView didClickActionType:(WKDecorationOrderActionType)actionType forStage:(NSInteger)stage {
    if ([self.delegate respondsToSelector:@selector(decorationCell:tapedOrderActionType:forStage:)]) {
        [self.delegate decorationCell:self tapedOrderActionType:actionType forStage:stage];
    }
}

#pragma mark - public
+ (CGFloat)cellHeightWithOrderInfo:(SQDecorationDetailModel *)orderInfo {
    return KSCAL(88.0) + KSCAL(180) + 3 * KSCAL(KSPACE);
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation WKDecorationOrderMutableStageCell {
    @public
    NSMutableArray<WKDecorationStageView *> *stageViewArray;
}


- (void)sqlayoutSubviews {
    [super sqlayoutSubviews];
    
    stageViewArray = [NSMutableArray array];
}

- (void)setModel:(id)model {
    [super setModel:model];
}

- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {
    
    [super configOrderInfo:orderInfo];
    
    while (stageViewArray.count > (orderInfo.stage_list.count - 1)) {
        WKDecorationStageView *v = stageViewArray.lastObject;
        [v removeFromSuperview];
        [stageViewArray removeLastObject];
    }
    
    UIView *lastView = paymentStageView;
    
    for (int i = 0; i < orderInfo.stage_list.count - 1; i++) {
        WKDecorationStageView *view;
        if (stageViewArray.count > i) {
            view = [stageViewArray objectAtIndex:i];
        }
        else {
            view = [[WKDecorationStageView alloc] init];
            view.delegate = self;
            [self.contentView addSubview:view];
            [stageViewArray addObject:view];
        }
        [view configOrderInfo:orderInfo withStage:i+1 withInDetail:self.isInOrderDetail];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(lastView);
            make.top.equalTo(lastView.mas_bottom);
            make.left.right.equalTo(lastView);
        }];
        
        lastView = view;
    }
}

- (CGSize)viewSize {
    CGFloat height = MAX(0, _orderInfo.stage_list.count-1) * KSCAL(88.0) + [super viewSize].height;
    return CGSizeMake(kScreenW, height);
}

+ (CGFloat)cellHeightWithOrderInfo:(SQDecorationDetailModel *)orderInfo {
    return orderInfo.stage_list.count * KSCAL(88.0) + 3 * KSCAL(KSPACE) + KSCAL(180);
}

@end


@implementation WKDecorationDealingOrderCell
{
    UILabel  *dealingTipLabel;
    UIButton *connectServiceBtn;
    UIView   *dealingBgView;
    UIView   *dealingLine;
}
- (void)sqlayoutSubviews {
    
    [super sqlayoutSubviews];
    
    bottomLineLayer.hidden = YES;
    
    dealingBgView = [UIView new];
    [self.contentView addSubview:dealingBgView];
    
    dealingLine = [UIView new];
    dealingLine.backgroundColor = colorWithLine;
    [dealingBgView addSubview:dealingLine];
    
    dealingTipLabel = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_999 textAlignment:NSTextAlignmentCenter text:@"系统正在受理您的订单，请耐心等待~"];
    [dealingBgView addSubview:dealingTipLabel];
    
    connectServiceBtn = [UIButton new];
    [connectServiceBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [connectServiceBtn setTitleColor:KCOLOR(@"32bcea") forState:UIControlStateNormal];
    [connectServiceBtn setImage:[UIImage imageNamed:@"service_tel_icon"] forState:UIControlStateNormal];
    [connectServiceBtn sq_setImagePosition:SQImagePositionLeft spacing:5];
    [connectServiceBtn addTarget:self action:@selector(click_connectService) forControlEvents:UIControlEventTouchUpInside];
    connectServiceBtn.titleLabel.font = KFONT(28.0);
    [dealingBgView addSubview:connectServiceBtn];
    
    UIView *lastView;
    if (stageViewArray.count) {
        lastView = stageViewArray.lastObject;
    }
    else {
        lastView = paymentStageView;
    }
    
    [dealingBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(paymentStageView);
        make.top.equalTo(lastView.mas_bottom);
        make.height.mas_equalTo(KSCAL(175));
    }];
    
    [dealingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [dealingTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(dealingBgView.mas_centerY).offset(-KSCAL(10));
    }];
    
    [connectServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(dealingBgView.mas_centerY).offset(KSCAL(10));
    }];
}

- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {
    [super configOrderInfo:orderInfo];
    
    UIView *lastView;
    if (stageViewArray.count) {
        lastView = stageViewArray.lastObject;
    }
    else {
        lastView = paymentStageView;
    }
    
    [dealingBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(paymentStageView);
        make.top.equalTo(lastView.mas_bottom);
        make.height.mas_equalTo(KSCAL(175));
    }];
}

- (CGSize)viewSize {
    return CGSizeMake(kScreenW, [super viewSize].height + KSCAL(155));
}

- (void)click_connectService {
    if ([self.delegate respondsToSelector:@selector(decorationCell:tapedOrderActionType:forStage:)]) {
        [self.delegate decorationCell:self tapedOrderActionType:WKDecorationOrderActionTypeCallService forStage:1];
    }
}

+ (CGFloat)cellHeightWithOrderInfo:(SQDecorationDetailModel *)orderInfo {
    return orderInfo.stage_list.count * KSCAL(88.0) + 2 * KSCAL(KSPACE) + KSCAL(180) + KSCAL(175);
}

@end

