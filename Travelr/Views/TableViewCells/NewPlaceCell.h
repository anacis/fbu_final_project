//
//  NewPlaceCell.h
//  Travelr
//
//  Created by Ana Cismaru on 7/13/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

NS_ASSUME_NONNULL_BEGIN
@class NewPlaceCell;

@protocol NewPlaceCellDelegate

- (void)newPlaceCell:(NewPlaceCell *)newPlaceCell didSpecifyTimeSpent:(nonnull NSNumber *)time;

@end

@interface NewPlaceCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) Place *place;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeSpentButton;
@property (weak, nonatomic) IBOutlet UIPickerView *timeSpentPicker;

- (void)setUpCell;

@property (weak, nonatomic) id<NewPlaceCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
