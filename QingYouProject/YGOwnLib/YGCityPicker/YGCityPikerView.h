//
//  YGCityPikerView.h
//  FindingSomething
//
//  Created by apple on 15/12/24.
//  Copyright © 2015年 韩伟. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YGCityPikerViewDelegate <NSObject>

//点击确定之后的回调方法 参数依次为省市区
- (void)selectedProvince:(NSString *)province city:(NSString*)city district:(NSString*)district;

@end

@interface YGCityPikerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@property (nonatomic,strong) UIPickerView *picker;
@property (nonatomic,strong) NSDictionary *areaDic;
@property (nonatomic,strong) NSArray *province;
@property (nonatomic,strong) NSArray *city;
@property (nonatomic,strong) NSArray *district;
@property (nonatomic,strong) NSString *selectedProvince;
@property (nonatomic,assign) id <YGCityPikerViewDelegate>delegate;
@property (nonatomic,strong) UIView *baseView;

//显示
-(void)show;
- (void)setSelectProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;

@end
