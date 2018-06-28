//
//  OfficePurchaseCollectionViewCell.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OfficePurchaseCollectionViewCell.h"
#import "OfficePurchaseModel.h"//模型
#import "NSString+SQAttributeString.h"
@interface OfficePurchaseCollectionViewCell()

/**顶部图片*/
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
/**顶部图片高度约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImgeViewHeight;
/**商品名称*/
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
/**商品价格*/
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;


@end


@implementation OfficePurchaseCollectionViewCell
- (void)setModel:(OfficePurchaseModel *)model{
    
    _model = model;
    
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.commodityImg] placeholderImage:YGDefaultImgSquare];
    self.goodsNameLabel.text = model.commodityName;
    NSString * goosPrice = [NSString stringWithFormat:@"¥%@",model.commodityPrice];
    if ([model.commodityPrice containsString:@"."]) {
        goosPrice = [NSString stringWithFormat:@"¥%.2f",[model.commodityPrice floatValue]];
    }
    self.goodsPriceLabel.attributedText = [goosPrice attributedStringFromNSString:goosPrice startLocation:1 forwardFont:KFONT(26) backFont:KFONT(30) forwardColor:[UIColor redColor] backColor:[UIColor redColor]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    //修改高度约束
     CGFloat W = (KAPP_WIDTH - 45) / 2;
    self.topImgeViewHeight.constant = W;
    
    //假数据
//    [self.topImageView sd_setImageWithURL:nil placeholderImage:LDImage(@"1")];
//    self.goodsNameLabel.text = @"碳素笔";
//
//    NSString * goosPrice = @"￥275.00";
//    self.goodsPriceLabel.attributedText = [goosPrice ld_attributedStringFromNSString:goosPrice startLocation:1 forwardFont:LDFont(13) backFont:LDFont(15) forwardColor:kRedColor backColor:kRedColor];
}

@end




















