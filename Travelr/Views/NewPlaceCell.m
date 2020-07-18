//
//  NewPlaceCell.m
//  Travelr
//
//  Created by Ana Cismaru on 7/13/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "NewPlaceCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface NewPlaceCell ()
@property (nonatomic, strong) NSArray *pickerData;
@end

@implementation NewPlaceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSMutableArray *tempHours = [[NSMutableArray alloc] init];
    int const maxHoursPerDay = 17;
    for (int i = 0; i < maxHoursPerDay; i++) {
        if (i < 10) {
            [tempHours addObject:[NSString stringWithFormat:@"0%i", i]];
        }
        else {
            [tempHours addObject:[NSString stringWithFormat:@"%i", i]];
        }
    }
    [tempHours insertObject:@"?" atIndex:0];
    
    NSMutableArray *tempMinutes = [[NSMutableArray alloc] init];
    int const maxMinutesPerDay = 46;
    for (int i = 0; i < maxMinutesPerDay; i += 15) {
        if (i < 10) {
            [tempMinutes addObject:[NSString stringWithFormat:@"0%i", i]];
        }
        else {
            [tempMinutes addObject:[NSString stringWithFormat:@"%i", i]];
        }
    }
    [tempMinutes insertObject:@"?" atIndex:0];
    
    self.pickerData = [NSArray arrayWithObjects:tempHours, tempMinutes, nil];
    self.timeSpentPicker.delegate = self;
    self.timeSpentPicker.dataSource = self;
    [self.timeSpentPicker setHidden:YES];
    [self.timeSpentButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpCell {
    self.titleLabel.text = self.place.name;
    self.addressLabel.text = self.place.address;
    NSURL *photoURL = [NSURL URLWithString:self.place.photoURLString];
    [self.image setImageWithURL:photoURL];
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerData[component] count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *hours = self.pickerData[0][[pickerView selectedRowInComponent:0]];
    NSString *minutes = self.pickerData[1][[pickerView selectedRowInComponent:1]];
    self.timeSpentButton.titleLabel.text = [NSString stringWithFormat:@"%@:%@", hours, minutes];
    [self.timeSpentPicker setHidden:YES];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *time;
    if ([hours isEqualToString:@"?"] || [hours isEqualToString:@"?"]) {
        time = @(-1);
    }
    else {
        double convertedMinutes = [[self.pickerData[1][row] substringToIndex:2] doubleValue] / 60;
        double totalTime = [[self.pickerData[0][row] substringToIndex:2] doubleValue] + convertedMinutes;
        time = @(totalTime);
    }
    [self.delegate newPlaceCell:self didSpecifyTimeSpent:time];
}

/*- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel* labelHours = (UILabel*)view;
    UILabel* labelMinutes = (UILabel*)view;
    if (!labelHours){
        labelHours = [[UILabel alloc] init];
        [labelHours setFont:[UIFont systemFontOfSize:17]];
    }
    if (!labelMinutes){
        labelMinutes = [[UILabel alloc] init];
        [labelMinutes setFont:[UIFont systemFontOfSize:17]];
    }
    labelHours.text = self.pickerData[0][row];
    labelMinutes.text = self.pickerData[1][row];
    return view;
}*/


- (IBAction)onTapButton:(id)sender {
   [self.timeSpentPicker setHidden:NO];
}


@end
