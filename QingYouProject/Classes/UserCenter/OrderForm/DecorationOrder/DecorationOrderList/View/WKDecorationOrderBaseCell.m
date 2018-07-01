//
//  SQDecorationOrderCell.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/17.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationOrderBaseCell.h"
#import "WKDecorationStageView.h"
#import "UIButton+SQImagePosition.h"
#import "NSString+SQStringSize.h"

#define KSPACE 20

@implementation WKDecorationOrderBaseCell {
    
    UIImageView *orderImage;
    UILabel *orderTitle;
    UILabel *orderDesc;
    UILabel *orderPrice;
    UIView  *skuActionView;
    UIButton *avoidClickBtn;//避免点击到阶段部分时调用cell的select方法
    
    @public
    WKDecorationStageView *paymentStageView;//订金阶段视图
    WKDecorationOrderListModel *_orderListInfo;//订单列表信息
    CALayer *bottomLineLayer;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        orderImage = [[UIImageView alloc] init];
        orderImage.contentMode = UIViewContentModeScaleAspectFill;
        orderImage.clipsToBounds = YES;
        [self.contentView addSubview:orderImage];
        
        orderTitle = [UILabel labelWithFont:KSCAL(28.0) textColor:kCOLOR_666];
        orderTitle.numberOfLines = 2;
        [self.contentView addSubview:orderTitle];
        
        orderDesc = [UILabel labelWithFont:KSCAL(25.0) textColor:kCOLOR_666];
        orderDesc.numberOfLines = 3;
        [self.contentView addSubview:orderDesc];
        
        orderPrice = [UILabel labelWithFont:KSCAL(28.0) textColor:kCOLOR_666];
        orderPrice.numberOfLines = 1;
        [self.contentView addSubview:orderPrice];
        
        avoidClickBtn = [UIButton new];
        [self.contentView addSubview:avoidClickBtn];
        
        paymentStageView = [[WKDecorationStageView alloc] init];
        paymentStageView.delegate = self;
        [self.contentView addSubview:paymentStageView];
        
        bottomLineLayer = [CALayer layer];
        bottomLineLayer.backgroundColor = KCOLOR_LINE.CGColor;
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
    
    [avoidClickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(orderImage.mas_bottom).offset(KSCAL(KSPACE));
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

- (CGSize)intrinsicContentSize {
    return [self viewSize];
}

- (void)setupTextWithOrderInfo:(WKDecorationOrderListModel *)orderInfo {
    
    [orderImage sd_setImageWithURL:[NSURL URLWithString:[orderInfo.skuDetails.skuImgUrl componentsSeparatedByString:@","].firstObject] placeholderImage:[UIImage imageNamed:@"placeholderfigure_rectangle_420x300"]];
    
    orderTitle.attributedText = orderInfo.skuProductNameAttributeString;
    orderTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    orderDesc.attributedText = orderInfo.skuDetails.skuProductDescAttributeString;
    orderDesc.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableAttributedString *skuProductPriceAttributeString;
    NSString *skuPrice = [self skuPriceWithDoublePrice:orderInfo.skuDetails.skuPrice];
    if (orderInfo.status == 4) {
        skuProductPriceAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@", skuPrice]];
    } else {
        skuProductPriceAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@（预估价）", skuPrice]];
    }
    [skuProductPriceAttributeString setAttributes:@{NSForegroundColorAttributeName: kCOLOR_PRICE_RED} range:NSMakeRange(0, 2+skuPrice.length)];
    orderPrice.attributedText = skuProductPriceAttributeString;
    orderPrice.lineBreakMode = NSLineBreakByTruncatingTail;
}
//精确2位小数
- (NSString *)skuPriceWithDoublePrice:(float)doublePrice {
    
    int noneZero = doublePrice;
    if (noneZero == doublePrice) {
        return [NSString stringWithFormat:@"%d", noneZero];
    }
    
    int oneZero = doublePrice * 10;
    if (oneZero == doublePrice * 10) {
        return [NSString stringWithFormat:@"%.1f", doublePrice];
    }

    return [NSString stringWithFormat:@"%.2f", doublePrice];
}

#pragma mark - SQDecorationDetailViewProtocol
- (void)configOrderInfo:(WKDecorationOrderListModel *)orderInfo {
    _orderListInfo = orderInfo;
    [self setupTextWithOrderInfo:orderInfo];
    [paymentStageView configOrderInfo:orderInfo withStage:0 withInDetail:self.isInOrderDetail];
}

- (void)configOrderDetailInfo:(WKDecorationOrderDetailModel *)orderDetailInfo {
    _orderListInfo = orderDetailInfo.orderInfo;
    [self setupTextWithOrderInfo:orderDetailInfo.orderInfo];
    [paymentStageView configOrderDetailInfo:orderDetailInfo withStage:0 withInDetail:self.isInOrderDetail];
}

- (CGSize)viewSize {
    CGFloat height = KSCAL(88.0) + KSCAL(180.0) + 3 * KSCAL(KSPACE);
    return CGSizeMake(KAPP_WIDTH, height);
}

#pragma mark - WKDecorationStageViewDelegate
- (void)stageView:(WKDecorationStageView *)stageView didClickActionType:(WKDecorationOrderActionType)actionType forStage:(NSInteger)stage {
    if ([self.delegate respondsToSelector:@selector(decorationCell:tapedOrderActionType:forStage:)]) {
        [self.delegate decorationCell:self tapedOrderActionType:actionType forStage:stage];
    }
}

#pragma mark - public
+ (CGFloat)cellHeightWithOrderInfo:(WKDecorationOrderDetailModel *)orderInfo {
    return KSCAL(88.0) + KSCAL(180) + 3 * KSCAL(KSPACE);
}

@end

@implementation WKDecorationOrderMutableStageCell {
    NSMutableArray<WKDecorationStageView *> *stageViewArray;
}


- (void)sqlayoutSubviews {
    [super sqlayoutSubviews];
    
    stageViewArray = [NSMutableArray array];
}

- (void)setupStagesByOrderInfo:(WKDecorationOrderListModel *)orderInfo {
    //清除多余单阶段视图
    while (stageViewArray.count > (orderInfo.paymentList.count - 1)) {
        WKDecorationStageView *v = stageViewArray.lastObject;
        [v removeFromSuperview];
        [stageViewArray removeLastObject];
    }
    
    //订金阶段视图
    UIView *lastView = paymentStageView;
    for (int i = 0; i < orderInfo.paymentList.count - 1; i++) {
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

#pragma mark - SQDecorationDetailViewProtocol
- (void)configOrderDetailInfo:(WKDecorationOrderDetailModel *)orderDetailInfo {
    [super configOrderDetailInfo:orderDetailInfo];
    [self setupStagesByOrderInfo:orderDetailInfo.orderInfo];
}

- (void)configOrderInfo:(WKDecorationOrderListModel *)orderInfo {
    [super configOrderInfo:orderInfo];
    [self setupStagesByOrderInfo:orderInfo];
}

- (CGSize)viewSize {
    NSInteger count = _orderListInfo.paymentList.count ? _orderListInfo.paymentList.count - 1 : 0;
    CGFloat height = MAX(count, 0) * KSCAL(88.0) + KSCAL(88.0) + KSCAL(180.0) + 3 * KSCAL(KSPACE);
    return CGSizeMake(KAPP_WIDTH, height);
}

+ (CGFloat)cellHeightWithOrderInfo:(WKDecorationOrderListModel *)orderInfo {
    NSInteger count = orderInfo.paymentList.count ? : 0;
    return count * KSCAL(88.0) + 3 * KSCAL(KSPACE) + KSCAL(180);
}

@end

/////////////
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
    dealingLine.backgroundColor = KCOLOR_LINE;
    [dealingBgView addSubview:dealingLine];
    
    dealingTipLabel = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_999 textAlignment:NSTextAlignmentCenter text:@"系统正在受理您的订单，请耐心等待~"];
    [dealingBgView addSubview:dealingTipLabel];
    
    connectServiceBtn = [UIButton buttonWithTitle:@"联系客服" titleFont:KSCAL(28.0) titleColor:KCOLOR(@"32bcea") normalImage:@"service_tel_icon" highlightImage:nil];
    [connectServiceBtn sq_setImagePosition:SQImagePositionLeft spacing:5];
    [connectServiceBtn addTarget:self action:@selector(click_connectService) forControlEvents:UIControlEventTouchUpInside];
    [dealingBgView addSubview:connectServiceBtn];
    
    [dealingBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(paymentStageView);
        make.top.equalTo(paymentStageView.mas_bottom);
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
        make.left.mas_equalTo(35);
    }];
}

- (void)click_connectService {
    if ([self.delegate respondsToSelector:@selector(decorationCell:tapedOrderActionType:forStage:)]) {
        [self.delegate decorationCell:self
                 tapedOrderActionType:WKDecorationOrderActionTypeCallService
                             forStage:0];
    }
}

#pragma mark - SQDecorationDetailViewProtocol
- (void)configOrderDetailInfo:(WKDecorationOrderDetailModel *)orderDetailInfo {
    [super configOrderDetailInfo:orderDetailInfo];
}
- (void)configOrderInfo:(WKDecorationOrderListModel *)orderInfo {
    [super configOrderInfo:orderInfo];
}
- (CGSize)viewSize {
    return CGSizeMake(KAPP_WIDTH, KSCAL(88.0) + KSCAL(180.0) + 3 * KSCAL(KSPACE) + KSCAL(155));
}
+ (CGFloat)cellHeightWithOrderInfo:(WKDecorationOrderListModel *)orderInfo {
    return KSCAL(88.0) + KSCAL(180.0) + 3 * KSCAL(KSPACE) + KSCAL(155);
}

@end

