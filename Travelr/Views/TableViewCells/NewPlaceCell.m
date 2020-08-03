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

@end

@implementation NewPlaceCell

- (void)awakeFromNib {
    [super awakeFromNib];
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

- (IBAction)onTapButton:(id)sender {
    [self.delegate getTimeSpent:self];
}


@end
