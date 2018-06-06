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

    @public
    WKDecorationStageView *paymentStageView;//订金阶段视图
    SQDecorationDetailModel *_orderInfo;//订单信息
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        orderStateLabel = [[UILabel alloc] init];
        [self.contentView addSubview:orderStateLabel];
        
        orderImage = [[UIImageView alloc] init];
        orderImage.contentMode = UIViewContentModeScaleAspectFill;
        orderImage.clipsToBounds = YES;
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
        
        paymentStageView = [[WKDecorationStageView alloc] init];
        [self.contentView addSubview:paymentStageView];
        
        [self sqlayoutSubviews];
        
        orderImage.backgroundColor = [UIColor orangeColor];
        
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
    
    [paymentStageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderImage);
        make.centerX.mas_equalTo(0);
        make.top.equalTo(orderImage.mas_bottom).offset(KSCAL(KSPACE));
        make.height.mas_equalTo(KSCAL(88));
    }];
}


- (void)setModel:(id)model {
    orderStateLabel.text = @"装修中,待付款";
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
    
    orderStateLabel.text = orderInfo.orderTitle;
    orderDesc.text = orderInfo.decorateDescribe;
    orderPrice.text = [NSString stringWithFormat:@"¥ %@（预估价）", orderInfo.estimate];
    [orderImage sd_setImageWithURL:[NSURL URLWithString:orderInfo.decorate_icon] placeholderImage:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [paragraphStyle setMinimumLineHeight:0.0];
    NSAttributedString *decorateName = [[NSAttributedString alloc] initWithString:orderInfo.decorateName attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    orderTitle.attributedText = decorateName;
    orderTitle.lineBreakMode = NSLineBreakByTruncatingTail;

    [paymentStageView configStageModel:orderInfo.stage_list.firstObject withStage:0 canRefund:orderInfo.canRefund inRefund:orderInfo.isInRefund inDetail:NO];
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
+ (CGFloat)cellHeightWithOrderInfo:(SQDecorationDetailModel *)orderInfo {
    return KSCAL(88.0) + KSCAL(180) + 3 * KSCAL(KSPACE) + singleLineHeight();
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
            [self.contentView addSubview:view];
            [stageViewArray addObject:view];
        }
        
        WKDecorationStageModel *stageInfo = [orderInfo.stage_list objectAtIndex:i+1];
        [view configStageModel:stageInfo withStage:i+1 canRefund:orderInfo.canRefund inRefund:orderInfo.isInRefund inDetail:NO];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(lastView);
            make.top.equalTo(lastView.mas_bottom);
        }];
        
        lastView = view;
    }
}

- (CGSize)viewSize {
    CGFloat height = MAX(0, _orderInfo.stage_list.count-1) * KSCAL(88.0) + [super viewSize].height;
    return CGSizeMake(kScreenW, height);
}

+ (CGFloat)cellHeightWithOrderInfo:(SQDecorationDetailModel *)orderInfo {
    return orderInfo.stage_list.count * KSCAL(88.0) + 3 * KSCAL(KSPACE) + KSCAL(180) + singleLineHeight();
}

@end


@implementation WKDecorationDealingOrderCell
{
    UILabel *dealingTipLabel;
    UIButton *connectServiceBtn;
}
- (void)sqlayoutSubviews {
    
    [super sqlayoutSubviews];
    
    dealingTipLabel = [UILabel labelWithFont:KSCAL(34.0) textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter text:@"系统正在受理您的订单，请耐心等待~"];
    [self.contentView addSubview:dealingTipLabel];
    
    connectServiceBtn = [UIButton new];
    [connectServiceBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [connectServiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [connectServiceBtn sizeToFit];
    [connectServiceBtn addTarget:self action:@selector(click_connectService) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:connectServiceBtn];
    
    UIView *lastView;
    
    if (stageViewArray.count) {
        lastView = stageViewArray.lastObject;
    }
    else {
        lastView = paymentStageView;
    }
    
    [dealingTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(paymentStageView);
        make.top.equalTo(lastView.mas_bottom).offset(KSCAL(KSPACE));
    }];
    
    [connectServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(paymentStageView);
        make.top.equalTo(dealingTipLabel.mas_bottom).offset(KSCAL(KSPACE));
        make.height.mas_equalTo(KSCAL(30));
    }];
    
    [self layoutIfNeeded];
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
    
    [dealingTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(paymentStageView);
        make.top.equalTo(lastView.mas_bottom).offset(KSCAL(KSPACE));
    }];
}

- (CGSize)viewSize {
    return CGSizeMake(kScreenW, [super viewSize].height + dealingTipLabel.height + KSCAL(30) + 2 * KSCAL(KSPACE));
}

- (void)click_connectService {
    if ([self.delegate respondsToSelector:@selector(decorationCell:tapedOrderActionType:forStage:)]) {
        [self.delegate decorationCell:self tapedOrderActionType:WKDecorationOrderActionTypeCallService forStage:1];
    }
}

+ (CGFloat)cellHeightWithOrderInfo:(SQDecorationDetailModel *)orderInfo {
    NSString *singleH = @"系统正在受理您的订单，请耐心等待~";
    CGFloat tipH = [singleH sizeWithFont:[UIFont systemFontOfSize:17.0] andMaxSize:CGSizeMake(kScreenW-KSCAL(60), MAXFLOAT)].height;
    return orderInfo.stage_list.count * KSCAL(88.0) + 3 * KSCAL(KSPACE) + KSCAL(180) + singleLineHeight() + tipH + KSCAL(30) + 2 * KSCAL(KSPACE);
}

@end

