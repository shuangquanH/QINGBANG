//
//  YGPikerView.h
//
//  Created by 张楷枫 on 16/3/4.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGPikerView;
@protocol YGPikerViewDelegate <NSObject>

@optional
//点击确定代理
-(void)YGPikerView:(YGPikerView*)pikerView OkButtonClickdidSelectRow:(NSInteger)row withString:(NSString *)titleString;

@end

@interface YGPikerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSArray *pikerViewDataSource;
@property (nonatomic,strong) UIPickerView *pikerView;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,assign) id<YGPikerViewDelegate>delegate;
@property (nonatomic,strong) NSString *titleString;

//初始化方法，需要数据源以及标题
- (instancetype)initWithPikerViewDataSource:(NSArray *)pikerViewDataSource titleString:(NSString *)titleString;
//展示
- (void)show;
//消失
- (void)dismiss;
//选择指定string
- (void)setPikerViewSelectWithTitleString:(NSString *)titleString;
//选择指定row
- (void)setPikerViewSelectWithRow:(int)row;

@end
