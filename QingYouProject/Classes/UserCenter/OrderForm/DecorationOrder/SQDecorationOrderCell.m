//
//  SQDecorationOrderCell.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/17.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationOrderCell.h"
#import "NSString+SQStringSize.h"

#define KSPACE 20

static CGFloat singleLineHeight() {
    static CGFloat h;
    if (h == 0) {
        NSString *singleH = @"单行高度";
        h = [singleH sizeWithFont:[UIFont systemFontOfSize:17.0] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    }
    return h;
}

@implementation SQDecorationOrderCell {
    
    UILabel *orderStateLabel;
    UIImageView *orderImage;
    UILabel *orderTitle;
    UILabel *orderDesc;
    UILabel *orderPrice;
    
    UIView  *paymentLine;
    UIView  *paymentBgView;
    UILabel *paymentLabel;
    UILabel *paymentPrice;
    SQDecorationCellPayButtonView *paymentState;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        orderStateLabel = [[UILabel alloc] init];
        [self.contentView addSubview:orderStateLabel];
        
        orderImage = [[UIImageView alloc] init];
        orderImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:orderImage];
        
        orderTitle = [[UILabel alloc] init];
        orderTitle.font = KFONT(28.0);
        orderTitle.textColor = KCOLOR(@"666666");
        orderTitle.numberOfLines = 2;
        [self.contentView addSubview:orderTitle];
        
        orderDesc = [[UILabel alloc] init];
        orderDesc.font = KFONT(28.0);
        orderDesc.textColor = KCOLOR(@"666666");
        orderDesc.numberOfLines = 1;
        [self.contentView addSubview:orderDesc];
        
        orderPrice = [[UILabel alloc] init];
        orderPrice.font = KFONT(28.0);
        orderPrice.textColor = KCOLOR(@"333333");
        [self.contentView addSubview:orderPrice];
        
        paymentBgView = [UIView new];
        [self.contentView addSubview:paymentBgView];
        
        paymentLine = [UIView new];
        paymentLine.backgroundColor = colorWithLine;
        [paymentBgView addSubview:paymentLine];
        
        /** 定金  */
        paymentLabel = [[UILabel alloc] init];
        paymentLabel.font = KFONT(28.0);
        paymentLabel.textColor = KCOLOR(@"333333");
        [paymentBgView addSubview:paymentLabel];
        
        /** 定金金额  */
        paymentPrice = [[UILabel alloc] init];
        paymentPrice.font = KFONT(28.0);
        paymentPrice.textColor = KCOLOR(@"e60012");
        [paymentPrice setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [paymentBgView addSubview:paymentPrice];
        
        /** 定金状态  */
        paymentState = [[SQDecorationCellPayButtonView alloc] init];
        paymentState.actionDelegate = self;
        [paymentBgView addSubview:paymentState];
    
        paymentLabel.text = @"定金:";

        [self sqlayoutSubviews];
        
    }
    return self;
}


- (void)sqlayoutSubviews {
    [orderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-KSCAL(30));
        make.top.equalTo(self.contentView).offset(KSCAL(KSPACE));
    }];
    
    [orderImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(KSCAL(30));
        make.top.equalTo(orderStateLabel.mas_bottom).offset(KSCAL(KSPACE));
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
    
    [paymentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderImage);
        make.centerX.mas_equalTo(0);
        make.top.equalTo(orderImage.mas_bottom).offset(KSCAL(KSPACE));
        make.height.mas_equalTo(KSCAL(88));
    }];
    
    [paymentLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1.0);
    }];
    
    [paymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.equalTo(orderImage);
    }];
    [paymentPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paymentLabel);
        make.left.equalTo(paymentLabel.mas_right).offset(KSCAL(KSPACE));
    }];
    
    [paymentState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.equalTo(paymentPrice);
        make.left.equalTo(paymentPrice.mas_right).offset(KSCAL(KSPACE));
        make.height.equalTo(paymentPrice);
    }];

}


- (void)setModel:(id)model {
    orderStateLabel.text = @"装修中,待付款";
    orderImage.backgroundColor = [UIColor orangeColor];
    orderImage.image = [UIImage imageNamed:@"mine_instashot"];
    orderTitle.text = @"产品名称产品名称产品名称产品名称产品名称产品名称产品名称";
    orderDesc.text = @"产品描述产品描述产品描述产品描述产品描述产品描述产品描述";
    orderPrice.text = @"189230元";
    paymentLabel.text = @"定金:";
    paymentPrice.text = @"100元";
    paymentState.backgroundColor = colorWithMainColor;
}

- (void)setIsInDetail:(BOOL)isInDetail {
    paymentState.isInDetail = isInDetail;
}

- (CGSize)intrinsicContentSize {
    return [self viewSize];
}

#pragma mark - SQDecorationDetailViewProtocol
- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {
    
    [paymentState configOrderInfo:orderInfo stage:0];
    
    orderStateLabel.text = orderInfo.orderTitle;
    orderDesc.text = orderInfo.decorateDescribe;
    orderPrice.text = [NSString stringWithFormat:@"¥ %@（预估价）", orderInfo.estimate];
    paymentPrice.text = [NSString stringWithFormat:@"¥ %@", orderInfo.depositPrice];
    paymentState.backgroundColor = colorWithMainColor;
    [orderImage sd_setImageWithURL:[NSURL URLWithString:orderInfo.decorate_icon] placeholderImage:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [paragraphStyle setMinimumLineHeight:0.0];
    NSAttributedString *decorateName = [[NSAttributedString alloc] initWithString:orderInfo.decorateName attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    orderTitle.attributedText = decorateName;
    orderTitle.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (CGSize)viewSize {
    CGFloat height = KSCAL(88.0) + KSCAL(180.0) + 3 * KSCAL(KSPACE) + singleLineHeight();
    return CGSizeMake(kScreenW, height);
}

#pragma mark - SQDecorationCellPayButtonViewDelegate
- (void)actionView:(SQDecorationCellPayButtonView *)actionView didClickActionType:(WKDecorationOrderActionType)actionType forStage:(NSInteger)stage {
    if ([self.delegate respondsToSelector:@selector(decorationCell:tapedOrderActionType:forStage:)]) {
        [self.delegate decorationCell:self tapedOrderActionType:actionType forStage:stage];
    }
}

#pragma mark - public
+ (CGFloat)cellHeight {
    return KSCAL(88.0) + KSCAL(180) + 3 * KSCAL(KSPACE) + singleLineHeight();
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation SQDecorationOrderCellWithThreeStage {
    UIView  *oneStageBgView;
    UIView  *oneStageLine;
    UILabel *oneStageLabel;
    UILabel *oneStagePrice;
    SQDecorationCellPayButtonView    *oneStageState;
    
    UIView  *twoStageBgView;
    UIView  *twoStageLine;
    UILabel *twoStageLabel;
    UILabel *twoStagePrice;
    SQDecorationCellPayButtonView    *twoStageState;
    
    UIView  *threeStageBgView;
    UIView  *threeStageLine;
    UILabel *threeStageLabel;
    UILabel *threeStagePrice;
    SQDecorationCellPayButtonView    *threeStageState;
}


- (void)sqlayoutSubviews {
    [super sqlayoutSubviews];
    
    {
        oneStageBgView = [UIView new];
        [self.contentView addSubview:oneStageBgView];
        
        oneStageLine = [UIView new];
        oneStageLine.backgroundColor = colorWithLine;
        [oneStageBgView addSubview:oneStageLine];
        
        oneStageLabel = [[UILabel alloc] init];
        oneStageLabel.font = [UIFont systemFontOfSize:KSCAL(28.0)];
        oneStageLabel.textColor = KCOLOR(@"333333");
        [oneStageBgView addSubview:oneStageLabel];
        
        oneStagePrice = [[UILabel alloc] init];
        oneStagePrice.font = [UIFont systemFontOfSize:KSCAL(28.0)];
        oneStagePrice.textColor = KCOLOR(@"e60012");
        [oneStagePrice setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [oneStageBgView addSubview:oneStagePrice];
        
        oneStageState = [[SQDecorationCellPayButtonView alloc] init];
        oneStageState.actionDelegate = self;
        [oneStageBgView addSubview:oneStageState];
    }
    
    {
        twoStageBgView = [UIView new];
        [self.contentView addSubview:twoStageBgView];
        
        twoStageLine = [UIView new];
        twoStageLine.backgroundColor = colorWithLine;
        [twoStageBgView addSubview:twoStageLine];
        
        twoStageLabel = [[UILabel alloc] init];
        twoStageLabel.font = [UIFont systemFontOfSize:KSCAL(28.0)];
        twoStageLabel.textColor = KCOLOR(@"333333");
        [twoStageBgView addSubview:twoStageLabel];
        
        twoStagePrice = [[UILabel alloc] init];
        twoStagePrice.font = [UIFont systemFontOfSize:KSCAL(28.0)];
        twoStagePrice.textColor = KCOLOR(@"e60012");
        [twoStagePrice setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [twoStageBgView addSubview:twoStagePrice];
        
        twoStageState = [[SQDecorationCellPayButtonView alloc] init];
        twoStageState.actionDelegate = self;
        [twoStageBgView addSubview:twoStageState];
    }
    
    {
        threeStageBgView = [UIView new];
        [self.contentView addSubview:threeStageBgView];
        
        threeStageLine = [UIView new];
        threeStageLine.backgroundColor = colorWithLine;
        [threeStageBgView addSubview:threeStageLine];
        
        threeStageLabel = [[UILabel alloc] init];
        threeStageLabel.font = [UIFont systemFontOfSize:KSCAL(28.0)];
        threeStageLabel.textColor = KCOLOR(@"333333");
        [threeStageBgView addSubview:threeStageLabel];
        
        threeStagePrice = [[UILabel alloc] init];
        threeStagePrice.font = [UIFont systemFontOfSize:KSCAL(28.0)];
        threeStagePrice.textColor = KCOLOR(@"e60012");
        [threeStagePrice setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [threeStageBgView addSubview:threeStagePrice];
        
        threeStageState = [[SQDecorationCellPayButtonView alloc] init];
        threeStageState.actionDelegate = self;
        [threeStageBgView addSubview:threeStageState];
    }
    
    
    UIView *lastView = [super valueForKey:@"paymentBgView"];
    UIView *orderImageView = [super valueForKey:@"orderImage"];
    
    [oneStageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(lastView);
        make.top.equalTo(lastView.mas_bottom);
    }];
    [oneStageLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1.0);
    }];
    [oneStageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.equalTo(orderImageView);
    }];
    [oneStagePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneStageLabel.mas_right).offset(KSCAL(KSPACE));
        make.top.equalTo(oneStageLabel);
    }];
    [oneStageState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneStagePrice);
        make.right.mas_equalTo(0);
        make.left.equalTo(oneStagePrice.mas_right).offset(KSCAL(KSPACE));
        make.height.equalTo(oneStagePrice);
    }];
    
    
    ////////////////////////////////////////////////////////////////////////
    [twoStageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(lastView);
        make.top.equalTo(oneStageBgView.mas_bottom);
    }];
    [twoStageLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1.0);
    }];
    [twoStageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.equalTo(orderImageView);
    }];
    [twoStagePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(twoStageLabel.mas_right).offset(KSCAL(KSPACE));
        make.top.equalTo(twoStageLabel);
    }];
    [twoStageState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoStagePrice);
        make.right.mas_equalTo(0);
        make.left.equalTo(twoStagePrice.mas_right).offset(KSCAL(KSPACE));
        make.height.equalTo(twoStagePrice);
    }];
    
    ////////////////////////////////////////////////////////////////////////
    [threeStageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(lastView);
        make.top.equalTo(twoStageBgView.mas_bottom);
    }];
    [threeStageLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1.0);
    }];
    [threeStageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.equalTo(orderImageView);
    }];
    [threeStagePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(threeStageLabel.mas_right).offset(KSCAL(KSPACE));
        make.top.equalTo(threeStageLabel);
    }];
    [threeStageState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeStagePrice);
        make.right.mas_equalTo(0);
        make.left.equalTo(threeStagePrice.mas_right).offset(KSCAL(KSPACE));
        make.height.equalTo(threeStagePrice);
    }];
}

- (void)setModel:(id)model {
    [super setModel:model];
    oneStageLabel.text = @"1阶段:";
    oneStagePrice.text = @"300000元";
    oneStageState.backgroundColor = colorWithMainColor;
    
    twoStageLabel.text = @"2阶段:";
    twoStagePrice.text = @"500000元";
    twoStageState.backgroundColor = colorWithMainColor;
    
    threeStageLabel.text = @"尾款:";
    threeStagePrice.text = @"300000元";
    threeStageState.backgroundColor = colorWithMainColor;
}

- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {

    [super configOrderInfo:orderInfo];
    oneStageLabel.text = @"1阶段:";
    oneStagePrice.text = @"300000元";
    oneStageState.backgroundColor = colorWithMainColor;
    
    twoStageLabel.text = @"2阶段:";
    twoStagePrice.text = @"500000元";
    twoStageState.backgroundColor = colorWithMainColor;
    
    threeStageLabel.text = @"尾款:";
    threeStagePrice.text = @"300000元";
    threeStageState.backgroundColor = colorWithMainColor;
    
    [oneStageState configOrderInfo:orderInfo stage:1];
    [twoStageState configOrderInfo:orderInfo stage:2];
    [threeStageState configOrderInfo:orderInfo stage:3];
}

- (CGSize)viewSize {
    CGFloat height = 4 * KSCAL(88.0) + 3 * KSCAL(KSPACE) + KSCAL(180) + singleLineHeight();
    return CGSizeMake(kScreenW, height);
}

+ (CGFloat)cellHeight {
    return 4 * KSCAL(88.0) + 3 * KSCAL(KSPACE) + KSCAL(180) + singleLineHeight();
}

@end


@implementation WKDecorationDealingOrderCell
{
    UILabel *dealingTipLabel;
    UIButton *connectServiceBtn;
}
- (void)sqlayoutSubviews {
    [super sqlayoutSubviews];
    
    dealingTipLabel = [UILabel labelWithFont:17.0 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter text:@"系统正在受理您的订单，请耐心等待~"];
    [self.contentView addSubview:dealingTipLabel];
    
    connectServiceBtn = [UIButton new];
    [connectServiceBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [connectServiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [connectServiceBtn sizeToFit];
    [connectServiceBtn addTarget:self action:@selector(click_connectService) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:connectServiceBtn];
    
    UIView  *lastView = [super valueForKey:@"paymentLabel"];
    
    [dealingTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.mas_equalTo(0);
        make.top.equalTo(lastView.mas_bottom).offset(KSPACE);
    }];
    
    [connectServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(dealingTipLabel.mas_bottom).offset(KSPACE);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(30);
    }];
    
    [self layoutIfNeeded];
}

- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {
    [super configOrderInfo:orderInfo];
}

- (CGSize)viewSize {
    return CGSizeMake(kScreenW, [super viewSize].height + dealingTipLabel.height + 30 + 2 * KSPACE);
}

- (void)click_connectService {
    if ([self.delegate respondsToSelector:@selector(decorationCell:tapedOrderActionType:forStage:)]) {
        [self.delegate decorationCell:self tapedOrderActionType:WKDecorationOrderActionTypeCallService forStage:1];
    }
}

+ (CGFloat)cellHeight {
    NSString *singleH = @"系统正在受理您的订单，请耐心等待~";
    CGFloat tipH = [singleH sizeWithFont:[UIFont systemFontOfSize:17.0] andMaxSize:CGSizeMake(kScreenW-30, MAXFLOAT)].height;
    return 5 * KSPACE + 100 + 2 * singleLineHeight() + tipH + 30 + 2 * KSPACE;
}

@end

