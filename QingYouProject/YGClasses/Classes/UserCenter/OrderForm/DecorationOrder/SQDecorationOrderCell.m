//
//  SQDecorationOrderCell.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/17.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationOrderCell.h"
#import "NSString+SQStringSize.h"

#define KSPACE 10

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
        [self.contentView addSubview:orderImage];
        
        orderTitle = [[UILabel alloc] init];
        orderTitle.numberOfLines = 2;
        [self.contentView addSubview:orderTitle];
        
        orderDesc = [[UILabel alloc] init];
        orderDesc.numberOfLines = 1;
        [self.contentView addSubview:orderDesc];
        
        orderPrice = [[UILabel alloc] init];
        [self.contentView addSubview:orderPrice];
        
        /** 定金  */
        paymentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:paymentLabel];
        
        /** 定金金额  */
        paymentPrice = [[UILabel alloc] init];
        [paymentPrice setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.contentView addSubview:paymentPrice];
        
        /** 定金状态  */
        paymentState = [[SQDecorationCellPayButtonView alloc] init];
        paymentState.actionDelegate = self;
        [self.contentView addSubview:paymentState];
        
        [self sqlayoutSubviews];
        
    }
    return self;
}


- (void)sqlayoutSubviews {
    [orderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-2*KSPACE);;
        make.top.equalTo(self.contentView).offset(KSPACE);
    }];
    
    [orderImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(KSPACE);
        make.top.equalTo(orderStateLabel.mas_bottom).offset(KSPACE);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    [orderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderImage.mas_right).offset(KSPACE);
        make.top.equalTo(orderImage);
        make.right.equalTo(self.contentView).offset(-KSPACE);
    }];
    
    [orderDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(orderTitle);
        make.top.equalTo(orderTitle.mas_bottom).offset(KSPACE);
    }];
    
    [orderPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(orderTitle);
        make.bottom.equalTo(orderImage.mas_bottom);
    }];
    
    [paymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderImage.mas_bottom).offset(KSPACE);
        make.right.equalTo(orderImage);
    }];
    [paymentPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paymentLabel);
        make.left.equalTo(paymentLabel.mas_right).offset(KSPACE);;
    }];
    
    [paymentState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paymentPrice);
        make.left.equalTo(paymentPrice.mas_right).offset(KSPACE);
        make.right.equalTo(self.contentView).offset(-KSPACE);
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

- (CGSize)intrinsicContentSize {
    return [self viewSize];
}

#pragma mark - SQDecorationDetailViewProtocol
- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {
    [paymentState configOrderInfo:orderInfo stage:0];
    
    orderStateLabel.text = orderInfo.orderTitle;
    orderImage.backgroundColor = [UIColor orangeColor];
    orderImage.image = [UIImage imageNamed:@"mine_instashot"];
    orderTitle.text = @"产品名称产品名称产品名称产品名称产品名称产品名称产品名称";
    orderDesc.text = @"产品描述产品描述产品描述产品描述产品描述产品描述产品描述";
    orderPrice.text = @"189230元";
    paymentLabel.text = @"定金:";
    paymentPrice.text = @"100元";
    paymentState.backgroundColor = colorWithMainColor;
}

- (CGSize)viewSize {
    CGFloat height = 5 * KSPACE + 100 + 2 * singleLineHeight();
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
    return 5 * KSPACE + 100 + 2 * singleLineHeight();
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation SQDecorationOrderCellWithThreeStage {
    UILabel *oneStageLabel;
    UILabel *oneStagePrice;
    SQDecorationCellPayButtonView    *oneStageState;
    
    UILabel *twoStageLabel;
    UILabel *twoStagePrice;
    SQDecorationCellPayButtonView    *twoStageState;
    
    
    UILabel *threeStageLabel;
    UILabel *threeStagePrice;
    SQDecorationCellPayButtonView    *threeStageState;
}


- (void)sqlayoutSubviews {
    [super sqlayoutSubviews];
    
    oneStageLabel = [[UILabel alloc] init];
    [self.contentView addSubview:oneStageLabel];
    oneStagePrice = [[UILabel alloc] init];
    [self.contentView addSubview:oneStagePrice];
    [oneStagePrice setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    oneStageState = [[SQDecorationCellPayButtonView alloc] init];
    oneStageState.actionDelegate = self;
    [self.contentView addSubview:oneStageState];
    
    twoStageLabel = [[UILabel alloc] init];
    [self.contentView addSubview:twoStageLabel];
    twoStagePrice = [[UILabel alloc] init];
    [self.contentView addSubview:twoStagePrice];
    [twoStagePrice setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    twoStageState = [[SQDecorationCellPayButtonView alloc] init];
    twoStageState.actionDelegate = self;
    [self.contentView addSubview:twoStageState];
    
    threeStageLabel = [[UILabel alloc] init];
    [self.contentView addSubview:threeStageLabel];
    threeStagePrice = [[UILabel alloc] init];
    [self.contentView addSubview:threeStagePrice];
    [threeStagePrice setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    threeStageState = [[SQDecorationCellPayButtonView alloc] init];
    threeStageState.actionDelegate = self;
    [self.contentView addSubview:threeStageState];
    
    UIView  *lastView = [super valueForKey:@"paymentLabel"];
    UIView  *orderImage = [super valueForKey:@"orderImage"];
    
    [lastView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderImage.mas_bottom).offset(KSPACE);
        make.right.equalTo(orderImage);
    }];
    
    [oneStageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(KSPACE);
        make.right.equalTo(lastView);
    }];
    [oneStagePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneStageLabel.mas_right).offset(KSPACE);
        make.top.equalTo(oneStageLabel);
    }];
    [oneStageState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneStagePrice);
        make.left.equalTo(oneStagePrice.mas_right).offset(KSPACE);
        make.right.equalTo(self.contentView).offset(-KSPACE);
        make.height.equalTo(oneStagePrice);
    }];
    
    
    ////////////////////////////////////////////////////////////////////////
    [twoStageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneStageLabel.mas_bottom).offset(KSPACE);
        make.right.equalTo(lastView);
    }];
    [twoStagePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(twoStageLabel.mas_right).offset(KSPACE);
        make.top.equalTo(twoStageLabel);
    }];
    [twoStageState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoStagePrice);
        make.left.equalTo(twoStagePrice.mas_right).offset(KSPACE);
        make.right.equalTo(self.contentView).offset(-KSPACE);
        make.height.equalTo(twoStagePrice);
    }];
    
    ////////////////////////////////////////////////////////////////////////
    [threeStageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoStageLabel.mas_bottom).offset(KSPACE);
        make.right.equalTo(lastView);
    }];
    [threeStagePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(threeStageLabel.mas_right).offset(KSPACE);
        make.top.equalTo(threeStageLabel);
    }];
    [threeStageState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeStagePrice);
        make.left.equalTo(threeStagePrice.mas_right).offset(KSPACE);
        make.right.equalTo(self.contentView).offset(-KSPACE);
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
    CGFloat height = 8 * KSPACE + 100 + 5 * singleLineHeight();
    return CGSizeMake(kScreenW, height);
}

+ (CGFloat)cellHeight {
    return 8 * KSPACE + 100 + 5 * singleLineHeight();
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

