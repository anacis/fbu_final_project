//
//  NewListSlide2.m
//  Travelr
//
//  Created by Ana Cismaru on 7/22/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "NewListSlide2.h"
#import <GLCalendarView.h>

@implementation NewListSlide2

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setUpGestureRecognizer {
    self.tap.delegate = self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
   if ([touch.view isDescendantOfView:self.calendarView]) {
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    } else if ([touch.view isDescendantOfView:self.customDayButton]) {
        return NO;
    } else if (self.calendarView.ranges.count != 0) {
        if ([touch.view isDescendantOfView:self.calendarView.ranges[0]]) {
            return NO;
        }
    }
    return YES;
}

- (IBAction)outsideTap:(id)sender {
    [self.numDaysField resignFirstResponder];
    [self.numHoursField resignFirstResponder];
}

@end
