//
//  AllianceMainSignViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/11/29.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceMainSignViewController.h"
#import "FSCalendar.h"

@interface AllianceMainSignViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (weak, nonatomic) FSCalendar *calendar;

@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSDateFormatter *dateFormatter2;

@property (strong, nonatomic) NSDictionary *fillSelectionColors;
@property (strong, nonatomic) NSDictionary *fillDefaultColors;

@property (strong, nonatomic) NSDictionary *titleSelectionColor;
@property (strong, nonatomic) NSDictionary *borderSelectionColors;

//@property (strong, nonatomic) NSArray *datesWithEvent;
//@property (strong, nonatomic) NSArray *datesWithMultipleEvents;
@end

@implementation AllianceMainSignViewController
{
    UIScrollView *_scrollView;
    UIView *_canlenderBaseView;
    BOOL _isSign;
    NSString  *_img;
    NSArray *_awardListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.calendar.accessibilityIdentifier = @"calendar";
    self.naviTitle = @"签到有礼";
    [self loadData];
}

- (void)loadData
{
    
    [YGNetService YGPOST:REQUEST_getAllianceSign parameters:@{@"allianceID":_allianceID,@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        for (NSString *str in responseObject[@"signDate"]) {
            [str stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            [dict setValue:colorWithMainColor forKey:str];
        }
        self.fillDefaultColors = (NSDictionary *)dict;
        _isSign = [responseObject[@"isSign"] boolValue];
        _img = responseObject[@"img"];
        _awardListArray = [NSArray arrayWithArray:responseObject[@"awardList"]];
        [self configUI];
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)configAttribute
{
    
    
//    self.fillDefaultColors = @{@"2017/10/08":[UIColor purpleColor],
//                               @"2017/10/06":[UIColor greenColor],
//                               @"2017/10/18":[UIColor cyanColor],
//                               @"2017/10/22":[UIColor yellowColor],
//                               @"2017/11/08":colorWithMainColor,
//                               @"2017/11/06":colorWithMainColor,
//                               @"2017/11/18":colorWithMainColor,
//                               @"2017/11/22":colorWithMainColor,
//                               @"2017/12/08":colorWithMainColor,
//                               @"2017/12/06":[UIColor greenColor],
//                               @"2017/12/18":[UIColor cyanColor],
//                               @"2017/12/22":[UIColor magentaColor]
//                               };
//
//    self.fillSelectionColors = @{@"2017/10/08":[UIColor greenColor],
//                                 @"2017/10/06":[UIColor purpleColor],
//                                 @"2017/10/17":[UIColor grayColor],
//                                 @"2017/10/21":[UIColor cyanColor],
//                                 @"2017/11/08":colorWithMainColor,
//                                 @"2017/11/06":colorWithMainColor,
//                                 @"2017/11/17":colorWithMainColor,
//                                 @"2017/11/21":colorWithMainColor,
//                                 @"2017/12/08":[UIColor greenColor],
//                                 @"2017/12/06":[UIColor purpleColor],
//                                 @"2017/12/17":[UIColor grayColor],
//                                 @"2017/12/21":[UIColor cyanColor]};
//
//    self.fillSelectionColors = @{@"2017/10/08":[UIColor greenColor],
//                                 @"2017/10/06":[UIColor purpleColor],
//                                 @"2017/10/17":[UIColor grayColor],
//                                 @"2017/10/21":[UIColor cyanColor],
//                                 @"2017/11/08":colorWithYGWhite,
//                                 @"2017/11/06":colorWithYGWhite,
//                                 @"2017/11/17":colorWithYGWhite,
//                                 @"2017/11/21":colorWithYGWhite,
//                                 @"2017/12/08":[UIColor greenColor],
//                                 @"2017/12/06":[UIColor purpleColor],
//                                 @"2017/12/17":[UIColor grayColor],
//                                 @"2017/12/21":[UIColor cyanColor]};
//
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    self.dateFormatter1 = [[NSDateFormatter alloc] init];
    self.dateFormatter1.dateFormat = @"yyyy/MM/dd";
    
    self.dateFormatter2 = [[NSDateFormatter alloc] init];
    self.dateFormatter2.dateFormat = @"yyyy-MM-dd";
}

- (void)configUI
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, YGScreenHeight);
    _scrollView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:_scrollView];
    
    //左线
    UIImageView *bigImageView = [[UIImageView alloc]init];
    bigImageView.frame = CGRectMake(0,0, YGScreenWidth, YGScreenWidth*0.5);
    [bigImageView sd_setImageWithURL:[NSURL URLWithString:_img] placeholderImage:YGDefaultImgTwo_One];
    bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    bigImageView.clipsToBounds = YES;
//    [bigImageView sizeToFit];
    [_scrollView addSubview:bigImageView];
    
    _canlenderBaseView = [[UIView alloc] initWithFrame:CGRectMake(15, YGScreenWidth*0.4, YGScreenWidth-30, YGScreenWidth*0.72)];
    [_scrollView addSubview:_canlenderBaseView];
    

    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(1, 0, YGScreenWidth-32, YGScreenWidth*0.72)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.allowsMultipleSelection = YES;
    calendar.swipeToChooseGesture.enabled = YES;
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.appearance.weekdayTextColor = colorWithDeepGray;
    calendar.appearance.headerTitleColor = colorWithMainColor;
    calendar.appearance.titleDefaultColor = colorWithDeepGray;
    calendar.appearance.titleSelectionColor = colorWithYGWhite;
    calendar.appearance.selectionColor = colorWithMainColor;
    calendar.appearance.todayColor = colorWithMainColor;
    calendar.appearance.titleFont = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    calendar.appearance.headerTitleFont = [UIFont systemFontOfSize:YGFontSizeBigThree];
    calendar.headerHeight = 50;
    calendar.weekdayHeight = 50;
    calendar.scrollDirection = FSCalendarScrollDirectionVertical;
    calendar.userInteractionEnabled = NO;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesDefaultCase|FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    calendar.appearance.headerDateFormat = @"yyyy年MM月";
    [_canlenderBaseView addSubview:calendar];
    [YGAppTool addShadowToView:calendar withOpacity:0.3f shadowRadius:5 andCornerRadius:5];
    self.calendar = calendar;

    
    UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(40,_canlenderBaseView.y+_canlenderBaseView.height+20,YGScreenWidth*0.57,40)];
    [coverButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    coverButton.layer.cornerRadius = 20;
    coverButton.backgroundColor = colorWithMainColor;
    coverButton.clipsToBounds = YES;
    [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [coverButton setTitle:@"签到" forState:UIControlStateNormal];
    [coverButton setTitle:@"已签到" forState:UIControlStateSelected];
    if (_isSign == YES) {
        coverButton.selected = _isSign;
        coverButton.backgroundColor = colorWithPlaceholder;
        coverButton.userInteractionEnabled = NO;
    }
    [_scrollView addSubview:coverButton];
    coverButton.centerx = _scrollView.centerx;

    
    //左线
    UIImageView *caseLeftLineImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    caseLeftLineImageView.frame = CGRectMake(10,coverButton.y+coverButton.height+30, 2, 17);
    caseLeftLineImageView.backgroundColor = colorWithMainColor;
    [_scrollView addSubview:caseLeftLineImageView];
    
    UILabel *caseLeaderLabel = [[UILabel alloc] init];
    caseLeaderLabel.textColor = colorWithBlack;
    caseLeaderLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    caseLeaderLabel.text = @"签到不断，礼物不断";
    caseLeaderLabel.frame = CGRectMake(18, caseLeftLineImageView.y, YGScreenWidth-20, 25);
    [_scrollView addSubview:caseLeaderLabel];
    caseLeaderLabel.centery = caseLeftLineImageView.centery;
    
    CGFloat height = caseLeaderLabel.y+caseLeaderLabel.height+10;
    for (int i = 0; i<_awardListArray.count; i++) {
        UILabel *firstLabel = [[UILabel alloc] init];
        firstLabel.textColor = colorWithDeepGray;
        firstLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        firstLabel.text = _awardListArray[i];
        firstLabel.frame = CGRectMake(18, height, YGScreenWidth-20, 20);
        firstLabel.numberOfLines = 0;
        [firstLabel sizeToFit];
        firstLabel.frame = CGRectMake(18, firstLabel.y, YGScreenWidth-20, firstLabel.height+10);
        [_scrollView addSubview:firstLabel];
        height += firstLabel.height;
    }

    _scrollView.contentSize = CGSizeMake(YGScreenWidth, height+30);
}

- (void)confirmAction:(UIButton *)button
{
    [YGAppTool showToastWithText:@"签到成功"];
    
    [YGNetService YGPOST:REQUEST_AllianceUserSign parameters:@{@"allianceID":_allianceID,@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        [_calendar selectDate:[NSDate date]];
        button.selected = !button.selected;
        if (button.selected) {
            button.backgroundColor = colorWithPlaceholder;
            button.userInteractionEnabled = NO;
        }else
        {
            button.backgroundColor = colorWithMainColor;
        }
    } failure:^(NSError *error) {
        
    }];
}

/*
#pragma mark - Target actions

- (void)todayItemClicked:(id)sender
{
    [_calendar setCurrentPage:[NSDate date] animated:NO];
}


 #pragma mark - <FSCalendarDataSource>
 
 - (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
 {
 NSString *dateString = [self.dateFormatter2 stringFromDate:date];
 if ([_datesWithEvent containsObject:dateString]) {
 return 1;
 }
 if ([_datesWithMultipleEvents containsObject:dateString]) {
 return 3;
 }
 return 0;
 }
 
 #pragma mark - <FSCalendarDelegateAppearance>
 
 - (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorForDate:(NSDate *)date
 {
 NSString *dateString = [self.dateFormatter2 stringFromDate:date];
 if ([_datesWithEvent containsObject:dateString]) {
 return [UIColor purpleColor];
 }
 return nil;
 }
 
 - (NSArray *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
 {
 NSString *dateString = [self.dateFormatter2 stringFromDate:date];
 if ([_datesWithMultipleEvents containsObject:dateString]) {
 return @[[UIColor magentaColor],appearance.eventDefaultColor,[UIColor blackColor]];
 }
 return nil;
 }
 */
//填充色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date
{
    NSString *key = [self.dateFormatter1 stringFromDate:date];
    if ([_fillSelectionColors.allKeys containsObject:key]) {
        return _fillSelectionColors[key];
    }
    return appearance.selectionColor;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
{
    NSString *key = [self.dateFormatter1 stringFromDate:date];
    if ([_fillDefaultColors.allKeys containsObject:key]) {
        return _fillDefaultColors[key];
    }
    return nil;
}
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date
{
    NSString *key = [self.dateFormatter1 stringFromDate:date];
    if ([_titleSelectionColor.allKeys containsObject:key]) {
        return _titleSelectionColor[key];
    }
    return nil;
}
/*
 - (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date
 {
 NSString *key = [self.dateFormatter1 stringFromDate:date];
 if ([_borderDefaultColors.allKeys containsObject:key]) {
 return _borderDefaultColors[key];
 }
 return appearance.borderDefaultColor;
 }
 */
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date
//{
//    NSString *key = [self.dateFormatter1 stringFromDate:date];
//    if ([_borderSelectionColors.allKeys containsObject:key]) {
//        return _borderSelectionColors[key];
//    }
//    return appearance.borderSelectionColor;
//}

//边框弧度
/*
 - (CGFloat)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderRadiusForDate:(nonnull NSDate *)date
 {
 if ([@[@8,@17,@21,@25] containsObject:@([self.gregorian component:NSCalendarUnitDay fromDate:date])]) {
 return 0.0;
 }
 return 1.0;
 }
 */

/*
 #pragma mark - Target action
 //左右按钮上个月和下个月
 - (void)nextClicked:(id)sender
 {
 NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:self.calendar.currentPage options:0];
 [self.calendar setCurrentPage:nextMonth animated:YES];
 }
 
 - (void)prevClicked:(id)sender
 {
 NSDate *prevMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:self.calendar.currentPage options:0];
 [self.calendar setCurrentPage:prevMonth animated:YES];
 }
 */


@end
