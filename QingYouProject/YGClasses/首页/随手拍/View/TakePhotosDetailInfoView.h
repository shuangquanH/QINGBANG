//
//  TakePhotosDetailInfoView.h
//  QingYouProject
//
//  Created by zhaoao on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TakePhotosDetailInfoView : UIView

@property(nonatomic,strong)UILabel *topLabel;
@property(nonatomic,strong)UILabel *middleLabel;
@property(nonatomic,strong)UILabel *bottomLabel;

-(instancetype)initWithFrame:(CGRect)frame andType:(NSString *)infoType andDic:(NSDictionary *)dict;

//@property(nonatomic,strong)NSDictionary *dataDic;

@end
