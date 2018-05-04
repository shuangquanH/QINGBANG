//
//  TakePhotosDetailInfoView.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "TakePhotosDetailInfoView.h"

@implementation TakePhotosDetailInfoView

-(instancetype)initWithFrame:(CGRect)frame andType:(NSString *)infoType andDic:(NSDictionary *)dict
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubViews:frame andType:infoType andDic:dict];
    }
    return self;
}
-(void)createSubViews:(CGRect)frame andType:(NSString *)infoType andDic:(NSDictionary *)dict
{
    CGFloat height = (frame.size.height-16)/3;
    self.topLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 8 , frame.size.width - 30, height)];
    self.middleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 8+height , frame.size.width - 30, height)];
    self.bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 8+height * 2 , frame.size.width - 30, height)];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height - 1, YGScreenWidth, 1)];
    lineLabel.text = @"";
    lineLabel.backgroundColor = colorWithLine;
    [self addSubview:lineLabel];
    
    switch ([infoType integerValue]) {
        case 0:
//
            if ([[dict valueForKey:@"orderState"] isEqualToString:@"1"]) {
                self.topLabel.text = @"服务工单状态：待处理";
            }
            if ([[dict valueForKey:@"orderState"] isEqualToString:@"2"]) {
                self.topLabel.text = @"服务工单状态：处理中";
            }
            if ([[dict valueForKey:@"orderState"] isEqualToString:@"3"]) {
                self.topLabel.text = @"服务工单状态：已结单";
            }
            self.topLabel.attributedText = [self.topLabel.text ld_attributedStringFromNSString:self.topLabel.text startLocation:7 forwardFont:[UIFont systemFontOfSize:16] backFont:[UIFont systemFontOfSize:16] forwardColor:colorWithDeepGray backColor:colorWithBlack];
            self.middleLabel.text = [NSString stringWithFormat:@"服务工单号:%@",[dict valueForKey:@"orderNum"]];
            self.middleLabel.attributedText = [self.middleLabel.text ld_attributedStringFromNSString:self.middleLabel.text startLocation:6 forwardFont:[UIFont systemFontOfSize:16] backFont:[UIFont systemFontOfSize:16] forwardColor:colorWithDeepGray backColor:colorWithBlack];
            self.bottomLabel.text = [NSString stringWithFormat:@"下单时间：%@",[dict valueForKey:@"createDate"]];
            self.bottomLabel.attributedText = [self.bottomLabel.text ld_attributedStringFromNSString:self.bottomLabel.text startLocation:5 forwardFont:[UIFont systemFontOfSize:16] backFont:[UIFont systemFontOfSize:16] forwardColor:colorWithDeepGray backColor:colorWithBlack];
            break;
        case 1:
            self.topLabel.text =  [NSString stringWithFormat:@"发现区域：%@",[dict valueForKey:@"findAddress"]];
            self.topLabel.attributedText = [self.topLabel.text ld_attributedStringFromNSString:self.topLabel.text startLocation:5 forwardFont:[UIFont systemFontOfSize:16] backFont:[UIFont systemFontOfSize:16] forwardColor:colorWithDeepGray backColor:colorWithBlack];
            self.middleLabel.text = [NSString stringWithFormat:@"联系人：%@",[dict valueForKey:@"name"]];
            self.middleLabel.attributedText = [self.middleLabel.text ld_attributedStringFromNSString:self.middleLabel.text startLocation:4 forwardFont:[UIFont systemFontOfSize:16] backFont:[UIFont systemFontOfSize:16] forwardColor:colorWithDeepGray backColor:colorWithBlack];
            self.bottomLabel.text = [NSString stringWithFormat:@"联系人电话：%@",[dict valueForKey:@"phone"]];
            self.bottomLabel.attributedText = [self.bottomLabel.text ld_attributedStringFromNSString:self.bottomLabel.text startLocation:6 forwardFont:[UIFont systemFontOfSize:16] backFont:[UIFont systemFontOfSize:16] forwardColor:colorWithDeepGray backColor:colorWithBlack];
            break;
        default:
            break;
    }
    
    [self addSubview:self.topLabel];
    [self addSubview:self.middleLabel];
    [self addSubview:self.bottomLabel];
}

@end
