//
//  MeetingChildBookingViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MeetingChildBookingViewController.h"
#import "FSCalendar.h"
#import "ReservationController.h"
#import "LoginViewController.h"

@interface MeetingChildBookingViewController()<FSCalendarDataSource,FSCalendarDelegate>

@property (weak, nonatomic) FSCalendar *calendar;
@property (weak, nonatomic) UIButton *previousButton;
@property (weak, nonatomic) UIButton *nextButton;

@property (strong, nonatomic) NSCalendar *gregorian;

@property (nonatomic,strong)NSMutableArray *reservedMutableArray;//已经预定的时间数组

- (void)previousClicked:(id)sender;
- (void)nextClicked:(id)sender;

@end

@implementation MeetingChildBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (instancetype)init
{
    self = [super init];
    if (self) {
       
        self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
    }
    return self;
}


-(void)loadData
{
    [YGNetService YGPOST:REQUEST_getHasOrderDateByRoomId parameters:@{@"roomId":self.idString} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        self.reservedMutableArray = [responseObject valueForKey:@"aList"];
        
        [self.calendar reloadData];
    } failure:^(NSError *error) {
        
    }];
}


- (void)loadView
{
    self.reservedMutableArray = [NSMutableArray array];
    [self loadData];
    NSInteger toTop = 10;
    NSInteger toLeft = 10;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(toLeft, 10, YGScreenWidth-20, YGScreenHeight-50)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.view = view;
    // 450 for iPad and 300 for iPhone
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 270;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(toLeft, toTop, view.frame.size.width, height)];
    
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    calendar.layer.cornerRadius = 10;
    calendar.clipsToBounds = YES;
    //修改样式
    calendar.appearance.selectionColor = colorWithMainColor;
    calendar.appearance.todayColor = colorWithTable;
    calendar.appearance.headerTitleColor = colorWithMainColor;
    calendar.appearance.weekdayTextColor = [UIColor darkGrayColor];
    calendar.appearance.titleDefaultColor = [UIColor darkGrayColor];
    calendar.appearance.headerDateFormat = @"yyyy年MM月";
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    calendar.locale = locale;  // 设置周次是中文显示
    
    calendar.scrollEnabled = NO;
    
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, calendar.y + calendar.height + 10, YGScreenWidth - 30, 20)];
    tipLabel.textColor = [UIColor lightGrayColor];
    [tipLabel addAttributedWithString:@"* 红色字体日期,表示当日所有时间已被预定" lineSpace:8];
    [tipLabel addAttributedWithString:@"* 红色字体日期,表示当日所有时间已被预定" range:NSMakeRange(0, 1) color:[UIColor redColor]];
    tipLabel.font = [UIFont systemFontOfSize:13.0];

    [self.view addSubview:tipLabel];
    
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(toLeft+10, toTop+5, 85, 34);
    previousButton.backgroundColor = [UIColor whiteColor];
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setImage:[UIImage imageNamed:@"steward_left_green"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousButton];
    previousButton.hidden = YES;
    self.previousButton = previousButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)-95, toTop+5, 95, 34);
    nextButton.backgroundColor = [UIColor whiteColor];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setImage:[UIImage imageNamed:@"steward_right_green"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    self.nextButton = nextButton;
}

- (void)previousClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    //比较时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *systemDateStr = [formatter stringFromDate:date];
    NSString *currentDateStr = [formatter stringFromDate:currentMonth];
    
    NSString *systemYearStr = [systemDateStr substringWithRange:NSMakeRange(0, 4)];
    NSInteger systemYear = [systemYearStr integerValue];
    NSString *systemMonthStr = [systemDateStr substringWithRange:NSMakeRange(5,2)];
    NSInteger systemMonth = [systemMonthStr integerValue];
    
    NSString *myYearStr = [currentDateStr substringWithRange:NSMakeRange(0, 4)];
    NSInteger myYear = [myYearStr integerValue];
    NSString *myMonthStr = [currentDateStr substringWithRange:NSMakeRange(5,2)];
    NSInteger myMonth = [myMonthStr integerValue];
    
    if((myYear - 1) == systemYear && (myMonth - 1) == systemMonth)
    {
        self.previousButton.hidden = YES;
    }
    else if ((myYear == systemYear) && ((myMonth-1) <= systemMonth)) {
        self.previousButton.hidden = YES;
    }
    
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
   
}

- (void)nextClicked:(id)sender
{
    self.previousButton.hidden = NO;

    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}

//代理方法 选中某日期
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *string = [format stringFromDate:date];
    
    //系统时间
    NSDate *systemdate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *systemDateStr = [formatter stringFromDate:systemdate];
    
    //比较时间
    NSString *systemYearStr = [systemDateStr substringWithRange:NSMakeRange(0, 4)];
    NSInteger systemYear = [systemYearStr integerValue];
    NSString *systemMonthStr = [systemDateStr substringWithRange:NSMakeRange(5,2)];
    NSInteger systemMonth = [systemMonthStr integerValue];
    NSString *systemDayStr = [systemDateStr substringWithRange:NSMakeRange(8, 2)];
    NSInteger systemDay = [systemDayStr integerValue];
    
    NSString *myYearStr = [string substringWithRange:NSMakeRange(0, 4)];
    NSInteger myYear = [myYearStr integerValue];
    NSString *myMonthStr = [string substringWithRange:NSMakeRange(5,2)];
    NSInteger myMonth = [myMonthStr integerValue];
    NSString *myDayStr = [string substringWithRange:NSMakeRange(8, 2)];
    NSInteger myDay = [myDayStr integerValue];
    
    if(myYear < systemYear)
    {
        [YGAppTool showToastWithText:@"不能选择当前日期以前的日期哦"];
    }
    else if(myYear == systemYear && myMonth < systemMonth)
    {
        [YGAppTool showToastWithText:@"不能选择当前日期以前的日期哦"];
    }
    else if(myYear == systemYear && myMonth == systemMonth && myDay < systemDay)
    {
        [YGAppTool showToastWithText:@"不能选择当前日期以前的日期哦"];
    }
    else
    {
        if (![self loginOrNot])
        {
            return;
        }
            ReservationController *vc = [[ReservationController alloc]init];
            vc.dateString = string;
            vc.idString = self.idString;
            vc.unitPriceString = self.unitPriceString;
            [self.navigationController pushViewController:vc animated:YES];
    }
}

//- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
//{
//    return NO;
//}
//- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date
//{
//    return [UIColor lightGrayColor];
//}
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    for (int i = 0; i < self.reservedMutableArray.count; i++) {
        NSDate *selectdate =[format dateFromString:self.reservedMutableArray[i]];
        if (selectdate == date) {
            return [UIColor redColor];
        }
    }
    return colorWithLightGray;
}


-(void)configAttribute
{
    self.view.frame = self.controllerFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
