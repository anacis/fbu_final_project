//
//  PlaceListCell.m
//  Travelr
//
//  Created by Ana Cismaru on 7/13/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "PlaceListCell.h"

@implementation PlaceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *placeListTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapList:)];
    [self addGestureRecognizer:placeListTapGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpCell {
    self.titleLabel.text = self.placeList.name;
    self.descriptionLabel.text = self.placeList[@"description"];
    self.image.file = self.placeList.image;
    self.image.layer.cornerRadius = self.image.frame.size.height / 2; //formula to create a circular image
    [self.image loadInBackground];
}

- (void) didTapList:(UITapGestureRecognizer *)sender{
    //TODO:sort List
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [temp addObject:[self.placeList sortPlaces]];

    
    /* NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.placeList.placesUnsorted.count; i += 2) {
        NSMutableArray *inside = [[NSMutableArray alloc] init];
        [inside addObject:self.placeList.placesUnsorted[i]];
        if (i + 1 < self.placeList.placesUnsorted.count) {
            [inside addObject:self.placeList.placesUnsorted[i + 1]];
        }
        [temp addObject:inside];
    }*/
    
    self.placeList.placesSorted = temp;
    [self.delegate placeListCell:self didTap:self.placeList];
}


@end
