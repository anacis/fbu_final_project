//
//  PickerViewController.h
//  Travelr
//
//  Created by Ana Cismaru on 8/3/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPlaceCell.h"
#import "DetailView.h"

NS_ASSUME_NONNULL_BEGIN

@class PickerViewController;

@protocol PickerViewDelegate

- (void)time:(nonnull NSNumber *)time didSpecifyTimeSpent:(UIView *)view;

@end

@interface PickerViewController : UIViewController

@property (nonatomic) double tabBarHeight;
@property (strong, nonatomic) NewPlaceCell *cell;
//@property (strong, nonatomic) DetailView *detailView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) id<PickerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
