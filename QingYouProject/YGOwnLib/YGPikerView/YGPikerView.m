//
//  YGPikerView.m
//
//  Created by 张楷枫 on 16/3/4.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGPikerView.h"
#import "UIView+LG.h"
#import "AppDelegate.h"
#define baseViewHeight 240
@implementation YGPikerView

- (instancetype)initWithPikerViewDataSource:(NSArray *)pikerViewDataSource titleString:(NSString *)titleString
{
    self = [super init];
    if (self)
    {
        self.hidden = YES;
        self.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight);
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        self.titleString = titleString;
        self.pikerViewDataSource = pikerViewDataSource;
        [self configUI];
    }
    return self;
}


-(void)configUI
{
    UIButton *dismissBigButton = [[UIButton alloc]initWithFrame:self.frame];
    [dismissBigButton addTarget:self action:@selector(dismissBtnClick) forControlEvents:UIControlEventTouchDown];
    [self addSubview:dismissBigButton];
    
    self.baseView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, baseViewHeight)];
    self.baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.baseView];
    
    UIView *topBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    [self.baseView addSubview:topBaseView];
    
    UILabel  *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(YGScreenWidth/2-60,0 , 120, 45)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    nameLabel.textColor = colorWithDeepGray;
    nameLabel.text = _titleString;
    [topBaseView addSubview:nameLabel];
    
    UIButton * OkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [OkButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    OkButton.frame = CGRectMake(topBaseView.width-0-40-10, 7, 45, topBaseView.height-14);
    [OkButton setTitle:@"确定" forState:UIControlStateNormal];
    [OkButton addTarget:self action:@selector(OkButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topBaseView addSubview:OkButton];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitleColor:colorWithLightGray forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(10,OkButton.y,OkButton.width, OkButton.height);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismissBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topBaseView addSubview:cancelButton];
    
    
    
    self.pikerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, topBaseView.y+topBaseView.height, self.width, self.baseView.height-topBaseView.height-topBaseView.y)];
    self.pikerView.dataSource = self;
    self.pikerView.delegate = self;
    [self.baseView addSubview:self.pikerView];
    
    
}

-(void)OkButtonClick
{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(YGPikerView:OkButtonClickdidSelectRow:withString:)])
    {
        [self.delegate YGPikerView:self OkButtonClickdidSelectRow:[self.pikerView selectedRowInComponent:0] withString:self.pikerViewDataSource[[self.pikerView selectedRowInComponent:0]]];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pikerViewDataSource.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pikerViewDataSource[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, YGScreenWidth, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = _pikerViewDataSource[row];
    myView.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    myView.textColor = colorWithMainColor;
    myView.backgroundColor = [UIColor clearColor];
    return myView;
}

- (void)setPikerViewSelectWithTitleString:(NSString *)titleString
{
    if ([titleString isEqualToString:@""])
    {
        return;
    }
    int i = 0;
    for (NSString *title in self.pikerViewDataSource)
    {
        if ([titleString isEqualToString:title])
        {
            [self.pikerView selectRow:i inComponent:0 animated:YES];
            break;
        }
        i++;
    }
}

- (void)setPikerViewSelectWithRow:(int)row
{
    [self.pikerView selectRow:row inComponent:0 animated:YES];
}

-(void)show
{
    self.hidden = NO;
    [YGAppDelegate.window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^
    {
        _baseView.y = self.height - _baseView.height;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    }];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^
     {
         _baseView.y = self.height;
         self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
     }
     completion:^(BOOL finished) {
         [self removeFromSuperview];
     }];
}

-(void)dismissBtnClick
{
    [self dismiss];
}

@end
