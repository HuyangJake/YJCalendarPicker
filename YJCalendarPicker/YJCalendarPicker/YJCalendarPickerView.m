//
//  YJCalendarPickerView.m
//  YJCalendarPicker
//
//  Created by Jake on 17/3/1.
//  Copyright © 2017年 Jake. All rights reserved.
//

#import "YJCalendarPickerView.h"
#import "AppDelegate.h"
#import "FSCalendar.h"
#define kRootWindow  ((AppDelegate*)([UIApplication sharedApplication].delegate)).window

static CGFloat mainViewHeight, screenHeight;
static CGFloat mainViewWidth, screenWidth;

@interface YJCalendarPickerView ()<FSCalendarDataSource, FSCalendarDelegate>

@property (nonatomic, copy) void (^selectDate)(NSDate *date);

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) FSCalendar *calendarView;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
@end

@implementation YJCalendarPickerView

#pragma mark - 初始化视图

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        screenHeight = [UIScreen mainScreen].bounds.size.height;
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        mainViewHeight = screenHeight * 0.42;
        if (mainViewWidth < 347) {
            mainViewWidth = 347;
        }
        mainViewWidth = screenWidth;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (YJCalendarPickerView * _Nonnull)showCalendarWithCurrentDate:(NSDate *)date minDate:(NSDate * _Nullable)minDate maxDate:(NSDate * _Nullable)maxDate completeHandler:(CompleteSelection _Nonnull)handler {
    YJCalendarPickerView *view = [[YJCalendarPickerView alloc] initWithFrame:kRootWindow.bounds];
    view.minDate = minDate;
    view.maxDate = maxDate;
    view.selectDate = handler;
    [view.calendarView selectDate:date];
    [view.calendarView setCurrentPage:date];
    [kRootWindow addSubview:view];
    [view displayView];
    return view;
}

+ (YJCalendarPickerView * _Nonnull)showCalendarWithCurrentDate:(NSDate *)date completeHandler:(CompleteSelection)handler {
    return [self showCalendarWithCurrentDate:date minDate:nil maxDate:nil completeHandler:handler];
}

#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar {
    return self.minDate;
}


- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar {
    return self.maxDate;
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    if (self.selectDate) {
        self.selectDate(date);
    }
    if ([self.delegate respondsToSelector:@selector(selectedDate:sender:)]){
        [self.delegate selectedDate:date sender:self];
    }
    [self dissmissView];
}

#pragma mark - 控制视图的展示

- (void)displayView {
    self.bgView.alpha = 0;
    self.mainView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0.6;
        self.mainView.frame = CGRectMake(0, screenHeight - mainViewHeight, mainViewWidth, mainViewHeight);
    }];
}

- (void)dissmissView {
    [UIView animateWithDuration:0.5 animations:^{
        self.mainView.frame = CGRectMake(0, screenHeight, mainViewWidth, mainViewHeight);
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 构建视图

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , screenWidth, screenHeight)];
        _bgView.backgroundColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:0.6];
        [self addSubview:_bgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissView)];
        [_bgView addGestureRecognizer:tap];
        
    }
    return _bgView;
}


- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight, mainViewWidth, mainViewHeight)];
        _mainView.backgroundColor = [UIColor whiteColor];
        [_mainView addSubview:self.calendarView];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setFrame:CGRectMake(0, 0, 50, 40)];
        [cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [cancelBtn setTintColor:[UIColor lightGrayColor]];
        [cancelBtn addTarget:self action:@selector(dissmissView) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:cancelBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, screenWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
        [_mainView addSubview:line];

        [self addSubview:_mainView];
    }
    return _mainView;
}

- (FSCalendar *)calendarView {
    if (!_calendarView) {
        _calendarView = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0.5, mainViewWidth, mainViewHeight - 0.5)];
        _calendarView.dataSource = self;
        _calendarView.delegate = self;
        _calendarView.backgroundColor = [UIColor whiteColor];
        _calendarView.appearance.headerMinimumDissolvedAlpha = 0;
        _calendarView.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
        [self configTheme];
    }
    return _calendarView;
}

- (void)configTheme {
    _calendarView.appearance.weekdayTextColor = [UIColor colorWithRed:0.98 green:0.46 blue:0.42 alpha:1.00];
    _calendarView.appearance.headerTitleColor = [UIColor darkGrayColor];
    _calendarView.appearance.eventDefaultColor = [UIColor greenColor];
    _calendarView.appearance.selectionColor = [UIColor colorWithRed:0.98 green:0.46 blue:0.42 alpha:1.00];
    _calendarView.appearance.headerDateFormat = @"yyyy年MM月";
    _calendarView.appearance.todayColor = [UIColor lightGrayColor];
    _calendarView.appearance.borderRadius = 1.0;
    _calendarView.appearance.headerMinimumDissolvedAlpha = 0.0;
}
@end
