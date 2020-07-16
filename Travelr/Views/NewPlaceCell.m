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
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    int const maxHoursPerDay = 17;
    for (int i = 0; i < maxHoursPerDay; i++) {
        if (i == 0) {
            [temp addObject:@"?"];
        }
        else if (i == 1) {
            [temp addObject:[NSString stringWithFormat:@"%i hour", i]];
        }
        else {
            [temp addObject:[NSString stringWithFormat:@"%i hours", i]];
        }
    }
    self.pickerData = (NSArray *) temp;
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
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //TODO: edit the button and make the picker hidden
    self.timeSpentButton.titleLabel.text = self.pickerData[row];
    [self.timeSpentPicker setHidden:YES];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *time;
    if ([self.pickerData[row] isEqualToString:@"?"]) {
        time = @0;
    }
    else {
        //TODO: implement regex logic here (if time permits), below works but is semi-cheating since the formatter ignores spaces
        time = [f numberFromString:[self.pickerData[row] substringToIndex:2]];
    }
    [self.delegate newPlaceCell:self didSpecifyTimeSpent:time];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel* label = (UILabel*)view;
    if (!label){
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:17]];
    }
    label.text = self.pickerData[row];
    return label;
}


- (IBAction)onTapButton:(id)sender {
   [self.timeSpentPicker setHidden:NO];
}


@end
