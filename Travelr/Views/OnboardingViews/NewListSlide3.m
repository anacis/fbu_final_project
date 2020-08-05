//
//  NewListSlide3.m
//  Travelr
//
//  Created by Ana Cismaru on 7/22/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "NewListSlide3.h"

@implementation NewListSlide3

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
    if ([touch.view isDescendantOfView:self.myPlacesTableView]) {
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    else if ([touch.view isDescendantOfView:self.placesSearchTableView]) {
        return NO;
    }
    else if ([touch.view isDescendantOfView:self.suggestionsCollectionView]) {
        return NO;
    }
    else if ([touch.view isDescendantOfView:self.selectStartButton]) {
        return NO;
    }
    return YES;
}

- (IBAction)outsideTap:(id)sender {
    [self.placeSearchBar resignFirstResponder];
    [self.cityField resignFirstResponder];
}

@end
