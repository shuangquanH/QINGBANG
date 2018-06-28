//
//  SQDecorationDetailStagesView.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationDetailStagesView.h"

static const CGFloat kCircleWidth = 26;

@implementation SQDecorationDetailStagesView
{
    UIView *_leftCircleView;
    UIView *_centerCircleView;
    UIView *_rightCircleView;

    UILabel *_leftStateLabel;
    UILabel *_centerStateLabel;
    UILabel *_rightStateLabel;

    UIImageView *_bottomLineImageView;
    
    UIView *_shadowView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = KCOLOR_MAIN;
        [self setupSubviews];
    }
    return self;
}
 
- (void)setupSubviews {
    CAGradientLayer *line_layer = [CAGradientLayer layer];
    line_layer.colors = @[((__bridge id)[UIColor colorWithWhite:1.0 alpha:0.3].CGColor),
                          ((__bridge id)[UIColor colorWithWhite:1.0 alpha:1.0].CGColor),
                          ((__bridge id)[UIColor colorWithWhite:1.0 alpha:1.0].CGColor),
                          ((__bridge id)[UIColor colorWithWhite:1.0 alpha:0.3].CGColor)];
    line_layer.locations = @[@(0.0), @(1.0/6), @(5.0/6), @(1.0)];
    line_layer.startPoint = CGPointZero;
    line_layer.endPoint = CGPointMake(1.0, 0);
    [self.layer addSublayer:line_layer];
    line_layer.frame = CGRectMake(KSCAL(30), KSCAL(40), KAPP_WIDTH-KSCAL(60), 1);

    CGFloat perW = (KAPP_WIDTH - 2 * KSCAL(30)) / 6.0;

    UIImageView *leftArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"orderdetails_flowchart_triangle"]];
    leftArrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    leftArrowImageView.frame = CGRectMake(0, 0, KSCAL(35), KSCAL(20));
    leftArrowImageView.center = CGPointMake(KSCAL(30)+perW*2, KSCAL(40)+0.5);
    [self addSubview:leftArrowImageView];
    
    UIImageView *rightArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"orderdetails_flowchart_triangle"]];
    rightArrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    rightArrowImageView.frame = CGRectMake(0, 0, KSCAL(35), KSCAL(20));
    rightArrowImageView.center = CGPointMake(KSCAL(30)+perW*4, KSCAL(40)+0.5);
    [self addSubview:rightArrowImageView];
    
    [self stageViewWithTitle:@"定金"   state:@"已支付" centerX:KSCAL(30)+perW tag:0];
    [self stageViewWithTitle:@"阶段款" state:@"已支付" centerX:KSCAL(30)+perW*3 tag:1];
    [self stageViewWithTitle:@"尾款"   state:@"已支付" centerX:KSCAL(30)+perW*5 tag:2];

    _bottomLineImageView = [UIImageView new];
    _bottomLineImageView.frame = CGRectMake(KSCAL(30.0), 0, KAPP_WIDTH-KSCAL(60.0), 2.0);
    _bottomLineImageView.image = [[UIImage imageNamed:@"orderdetails_horizontalline"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    [self addSubview:_bottomLineImageView];
    [_bottomLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.left.mas_equalTo(KSCAL(30));
    }];
    
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 0.1)];
    _shadowView.layer.shadowOpacity = 0.4;
    _shadowView.layer.shadowOffset = CGSizeZero;
    _shadowView.layer.shadowColor = [UIColor whiteColor].CGColor;
    CGFloat x = -KSCAL(30.0)+0.05;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, x, KSCAL(60), KSCAL(60)) cornerRadius:KSCAL(30)];
    _shadowView.layer.shadowPath = shadowPath.CGPath;
    [self addSubview:_shadowView];
    _shadowView.center = CGPointMake(KSCAL(30)+perW*3, KSCAL(40)+0.5);
    
}

- (UIView *)circleView {
    UIView *circle = [UIView new];
    circle.backgroundColor = KCOLOR_MAIN;
    circle.size = CGSizeMake(KSCAL(kCircleWidth), KSCAL(kCircleWidth));
    circle.layer.cornerRadius = KSCAL(kCircleWidth / 2.0);
    circle.layer.borderColor = [UIColor whiteColor].CGColor;
    circle.layer.borderWidth = KSCAL(8);
    return circle;
}

- (void)stageViewWithTitle:(NSString *)title state:(NSString *)state centerX:(CGFloat)centerX tag:(NSInteger)tag {

    UIView *circle = [self circleView];
    CGPoint circleCneter = CGPointMake(centerX, KSCAL(40)+0.5);
    circle.center = circleCneter;
    [self addSubview:circle];
    
    UILabel *titleLabel = [UILabel labelWithFont:KSCAL(28) textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter text:title];
    [self addSubview:titleLabel];
    
    UILabel *stateLabel = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_999 textAlignment:NSTextAlignmentCenter text:state];
    stateLabel.backgroundColor = [UIColor whiteColor];
    stateLabel.layer.masksToBounds = YES;
    stateLabel.layer.cornerRadius = KSCAL(17.5);
    [self addSubview:stateLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(centerX);
        make.top.mas_equalTo(KSCAL(66));
    }];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(3);
        make.size.mas_equalTo(CGSizeMake(KSCAL(130), KSCAL(35)));
    }];
    
    if (tag == 0) {
        _leftCircleView = circle;
        _leftStateLabel = stateLabel;
    }
    else if (tag == 1) {
        _centerCircleView = circle;
        _centerStateLabel = stateLabel;
    }
    else {
        _rightCircleView = circle;
        _rightStateLabel = stateLabel;
    }
}

#pragma mark - SQDecorationDetailViewProtocol

- (void)configOrderDetailInfo:(WKDecorationOrderDetailModel *)orderDetailInfo {
    CGFloat perW = (KAPP_WIDTH - 2 * KSCAL(30)) / 6.0;
    
    if (orderDetailInfo.orderInfo.status == 3) {//受理中，订金已支付
        _shadowView.center = CGPointMake(KSCAL(30)+perW*1, KSCAL(40)+0.5);
        _centerStateLabel.text = @"待支付";
        _rightStateLabel.text = @"待支付";
        return;
    }
    
    if (orderDetailInfo.orderInfo.status == 4) {//阶段款待支付
        _centerStateLabel.text = @"待支付";
        _shadowView.center = CGPointMake(KSCAL(30)+perW*3, KSCAL(40)+0.5);
        _rightStateLabel.text = @"待支付";
        return;
    }
    
    if (orderDetailInfo.orderInfo.status == 5) {//尾款已支付
        _centerStateLabel.text = @"已支付";
        _shadowView.center = CGPointMake(KSCAL(30)+perW*5, KSCAL(40)+0.5);
        _rightStateLabel.text = @"已支付";
    }
}

- (CGSize)viewSize {
    return CGSizeMake(KAPP_WIDTH, KSCAL(160));
}

@end
