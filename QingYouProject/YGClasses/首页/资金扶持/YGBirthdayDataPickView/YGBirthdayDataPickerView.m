//
//  YGBirthdayDataPickerView.m
//  NiXiSchool
//
//  Created by 郭松阳的Mac on 2016/12/22.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGBirthdayDataPickerView.h"

@implementation YGBirthdayDataPickerView
{
    UIDatePicker *datePicker;

}
- (instancetype)initWithTitleString:(NSString *)titleString withDefultDateString:(NSString *)defultDateString
{
    self = [super init];
    if (self)
    {
        self.hidden = YES;
        self.frame = CGRectMake(0, YGScreenHeight, YGScreenWidth, 240);
        self.backgroundColor  = colorWithYGWhite;
        self.titleString = titleString;
        self.defultDateString = defultDateString;
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * mindateStr = @"1900-01-01";
    NSString * maxdateStr = @"2099-01-01";
    NSDate * mindate = [formatter dateFromString:mindateStr];
    NSDate * maxdate = [formatter dateFromString:maxdateStr];
    
    //    选项view
    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    selectView.hidden = NO;
    selectView.tag = 500;
    selectView.backgroundColor = colorWithYGWhite;
    [self addSubview:selectView];

    
    //    取消btn
    UIButton *dateCancleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    dateCancleBtn.frame = CGRectMake(10, 10, 45, 20);
    [dateCancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    dateCancleBtn.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [dateCancleBtn setTitleColor:colorWithLightGray forState:UIControlStateNormal];
    [dateCancleBtn addTarget:self action:@selector(dateCancle) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:dateCancleBtn];
    
    
    //title
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = self.titleString;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = colorWithBlack;
    [selectView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(selectView);
        make.centerY.mas_equalTo(selectView);
    }];
    
    //    确定按钮
    UIButton *dateRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectView addSubview:dateRightBtn];
    [dateRightBtn setTitle:@"确定" forState:UIControlStateNormal];
    dateRightBtn.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [dateRightBtn setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [dateRightBtn addTarget:self action:@selector(dateRight) forControlEvents:UIControlEventTouchUpInside];
    [dateRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(selectView.mas_right).offset(-10);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(selectView.mas_top).offset(10);
    }];
    
    
    //    日期选择器
    NSArray *defultDateArray = [self.defultDateString componentsSeparatedByString:@"-"];
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    [comp setMonth:[defultDateArray[1] intValue]];
    [comp setDay:[defultDateArray[2] intValue]];
    [comp setYear:[defultDateArray[0] intValue]];
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *myDate1 = [myCal dateFromComponents:comp];
    NSLog(@"myDate1 = %@",myDate1);
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, YGScreenWidth, 200)];
    [datePicker setValue:[UIColor blackColor] forKey:@"textColor"];
    datePicker.tintColor  = colorWithBlack;
    datePicker.date = myDate1;
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor  = colorWithYGWhite;
    datePicker. locale = [ NSLocale localeWithLocaleIdentifier:@"zh"];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents : UIControlEventValueChanged];
    datePicker.minimumDate = mindate;
    datePicker.maximumDate = maxdate;
    
    //获取当前时间
//    NSDate *nowDate = [NSDate date];
    NSString *nowStr = [formatter stringFromDate:myDate1];
    self.birStr =  nowStr;
    

    [self addSubview:datePicker];
    
    //    先隐藏
    self.hidden = YES;
    
}

//确定
-(void)dateRight
{

    [UIView animateWithDuration:0.25 animations:^{
        
        self.frame = CGRectMake(0, YGScreenHeight,YGScreenWidth, 240);

    } completion:^(BOOL finished) {
        
       [self removeFromSuperview];

    }];
    
    
    [self.delegate clickOptionsButton:self.birStr buttonIndex:1];
}
//取消
-(void)dateCancle
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.frame = CGRectMake(0, YGScreenHeight,YGScreenWidth, 240);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
    [self.delegate clickOptionsButton:@"" buttonIndex:0];

}
-(void)show
{
    self.hidden = NO;
    [YGAppDelegate.window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^
     {
         self.frame = CGRectMake(0, YGScreenHeight-240,YGScreenWidth, 240);
         self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
     }];
}

-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* _date = control.date;
    /*添加你自己响应代码*/
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //    使用日期格式器个会话日期，时间
    NSString *destDateString = [formatter stringFromDate:_date];
    self.birStr = destDateString;
}
@end
