//
//  ViewController.m
//  YJCalendarPicker
//
//  Created by Jake on 17/3/1.
//  Copyright © 2017年 Jake. All rights reserved.
//

#import "ViewController.h"
#import "YJCalendarPickerView.h"

@interface ViewController ()<YJCalendarPickerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)tapButton:(id)sender {
    YJCalendarPickerView *view = [YJCalendarPickerView showCalendarWithCurrentDate:nil completeHandler:^(NSDate * _Nullable date) {
        NSLog(@"block :%@", date);
    }];
    view.delegate = self;
}

- (void)selectedDate:(NSDate *_Nonnull)date sender:(YJCalendarPickerView *_Nonnull)aView {
    NSLog(@"%@", date);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
