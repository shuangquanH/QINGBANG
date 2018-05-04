//
// Created by zhangkaifeng on 2017/10/25.
// Copyright (c) 2017 ccyouge. All rights reserved.
//

#import "YGDatePickerView.h"

#define baseViewHeight YGScreenHeight/3.0

@implementation YGDatePickerView
{
    UIDatePicker *_datePicker;
    UIView *_baseView;
    NSDate *_startDate;
    NSDate *_endDate;
    NSString *_titleString;
    UIDatePickerMode _datePickerMode;

    void(^_handler)(NSDate *selectedDate);
}

+ (instancetype)showWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate titleString:(NSString *)titleString datePickerMode:(UIDatePickerMode)datePickerMode handler:(void (^)(NSDate *selectedDate))handler
{
    YGDatePickerView *datePickerView = [[YGDatePickerView alloc] initWithStartDate:startDate endDate:endDate titleString:titleString datePickerMode:datePickerMode handler:handler];
    [datePickerView show];
    return datePickerView;
}

- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate titleString:(NSString *)titleString datePickerMode:(UIDatePickerMode)datePickerMode handler:(void (^)(NSDate *))handler
{
    self = [super init];
    if (self)
    {
        _startDate = startDate;
        _endDate = endDate;
        _titleString = titleString;
        _datePickerMode = datePickerMode;
        _handler = handler;
        [self configUI];
    }

    return self;
}


- (void)configUI
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];

    UIButton *dismissBigButton = [[UIButton alloc] initWithFrame:self.frame];
    [dismissBigButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchDown];
    [self addSubview:dismissBigButton];

    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, baseViewHeight)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_baseView];

    UIView *topBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    [_baseView addSubview:topBaseView];


    UIButton *OkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [OkButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    OkButton.frame = CGRectMake(topBaseView.width - 0 - 40 - 10, 7, 45, topBaseView.height - 14);
    [OkButton setTitle:@"确定" forState:UIControlStateNormal];
    [OkButton addTarget:self action:@selector(OkButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topBaseView addSubview:OkButton];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitleColor:colorWithLightGray forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(10, OkButton.y, OkButton.width, OkButton.height);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [topBaseView addSubview:cancelButton];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    titleLabel.text = _titleString;
    titleLabel.textColor = colorWithBlack;
    [topBaseView addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.centerX.centerY.mas_equalTo(topBaseView);
    }];

    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, topBaseView.y + topBaseView.height, self.width, _baseView.height - topBaseView.height - topBaseView.y)];
    [_datePicker setValue:colorWithBlack forKey:@"textColor"];
    _datePicker.tintColor = colorWithBlack;
    _datePicker.datePickerMode = _datePickerMode;
    _datePicker.backgroundColor = colorWithYGWhite;
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    _datePicker.timeZone = [NSTimeZone localTimeZone];
    _datePicker.minimumDate = _startDate;
    if (_endDate != nil) {
        _datePicker.maximumDate = _endDate;
    }
    [_baseView addSubview:_datePicker];
}

- (void)selectWithDate:(NSDate *)selectDate
{
    if(!selectDate)
    {
        return;
    }
    [_datePicker setDate:selectDate animated:YES];
}

- (void)OkButtonClick
{
    [self dismiss];

    if (_handler)
    {
        _handler(_datePicker.date);
        _handler = nil;
    }
}

- (void)show
{
    self.hidden = NO;
    [YGAppDelegate.window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^
    {
        _baseView.y = self.height - _baseView.height;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^
            {
                _baseView.y = self.height;
                self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            }
                     completion:^(BOOL finished)
                     {
                         [self removeFromSuperview];
                     }];
}

@end
