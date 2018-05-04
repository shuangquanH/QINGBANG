//
//  YGBirthdayDataPickerView.h
//  NiXiSchool
//
//  Created by 郭松阳的Mac on 2016/12/22.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YGBirthdayDataPickerViewDelegate <NSObject>


-(void)clickOptionsButton:(NSString *)dateStr buttonIndex:(int)index;

@end

@interface YGBirthdayDataPickerView : UIView


@property (nonatomic,assign) id <YGBirthdayDataPickerViewDelegate> delegate;

@property (nonatomic,strong) NSString * titleString;
@property (nonatomic,strong)NSString *birStr;
@property (nonatomic,strong)NSString *defultDateString;

//展示
- (void)show;
- (instancetype)initWithTitleString:(NSString *)titleString withDefultDateString:(NSString *)defultDateString;
@end
