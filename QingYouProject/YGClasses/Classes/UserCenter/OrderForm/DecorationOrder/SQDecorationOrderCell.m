//
//  SQDecorationOrderCell.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/17.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationOrderCell.h"
#import "SQDecorationCellPayButtonView.h"


#define KSPACE 10

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
        [self.contentView addSubview:paymentPrice];
        
        /** 定金状态  */
        paymentState = [[SQDecorationCellPayButtonView alloc] init];
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
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-2*KSPACE);
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
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self);
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
    oneStageState = [[SQDecorationCellPayButtonView alloc] init];
    [self.contentView addSubview:oneStageState];
    
    
    twoStageLabel = [[UILabel alloc] init];
    [self.contentView addSubview:twoStageLabel];
    twoStagePrice = [[UILabel alloc] init];
    [self.contentView addSubview:twoStagePrice];
    twoStageState = [[SQDecorationCellPayButtonView alloc] init];
    [self.contentView addSubview:twoStageState];
    
    threeStageLabel = [[UILabel alloc] init];
    [self.contentView addSubview:threeStageLabel];
    threeStagePrice = [[UILabel alloc] init];
    [self.contentView addSubview:threeStagePrice];
    threeStageState = [[SQDecorationCellPayButtonView alloc] init];
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
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-2*KSPACE);
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


@end










