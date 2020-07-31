//
//  NewListSlide2.h
//  Travelr
//
//  Created by Ana Cismaru on 7/22/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLCalendarView/GLCalendarView.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewListSlide2 : UIView <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numDaysField;
@property (weak, nonatomic) IBOutlet UILabel *numDaysLabel;
@property (weak, nonatomic) IBOutlet UITextField *numHoursField;
@property (weak, nonatomic) IBOutlet GLCalendarView *calendarView;
@property (weak, nonatomic) IBOutlet UIButton *customDayButton;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tap;

- (void)setUpGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
