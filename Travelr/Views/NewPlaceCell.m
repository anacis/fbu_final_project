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
    for (int i = 0; i < 17; i++) {
        if (i == 0) {
            [temp addObject:@"?"];
        }
        else {
            [temp addObject:[NSString stringWithFormat:@"%i", i]];
        }
    }
    self.pickerData = (NSArray *) temp;
    self.timeSpentPicker.delegate = self;
    self.timeSpentPicker.dataSource = self;
    [self.timeSpentPicker setHidden:YES];
    
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
}

- (IBAction)onTapButton:(id)sender {
   [self.timeSpentPicker setHidden:NO];
}


@end
