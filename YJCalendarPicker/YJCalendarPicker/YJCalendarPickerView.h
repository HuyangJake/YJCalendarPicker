//
//  YJCalendarPickerView.h
//  YJCalendarPicker
//
//  Created by Jake on 17/3/1.
//  Copyright © 2017年 Jake. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJCalendarPickerView;

@protocol YJCalendarPickerDelegate <NSObject>

@optional
- (void)selectedDate:(NSDate *_Nonnull)date sender:(YJCalendarPickerView *_Nonnull)aView;

@end

typedef void (^CompleteSelection)(NSDate * _Nullable date);

@interface YJCalendarPickerView : UIView

@property (nonatomic, weak) _Nullable id<YJCalendarPickerDelegate> delegate;

/**
 展示日历选择器

 @param date 当前选择日期
 @param minDate 最小日期
 @param maxDate 最大日期
 @param handler 回调block
 @return 选择器视图（可于使用代理）
 */
+ (YJCalendarPickerView * _Nonnull)showCalendarWithCurrentDate:(NSDate *_Nullable)date minDate:(NSDate * _Nullable)minDate maxDate:(NSDate * _Nullable)maxDate completeHandler:(CompleteSelection _Nonnull)handler;

/**
 展示日历选择器，传入的日期为空默认为今日

 @param date 当前选择日期
 @param handler 回调
 @return 选择器视图（可用于代理）
 */
+ (YJCalendarPickerView * _Nonnull)showCalendarWithCurrentDate:(NSDate *_Nullable)date completeHandler:(CompleteSelection _Nonnull)handler;

@end
