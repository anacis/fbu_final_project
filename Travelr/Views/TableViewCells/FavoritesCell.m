//
//  FavoritesCell.m
//  Travelr
//
//  Created by Ana Cismaru on 7/27/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "FavoritesCell.h"

@implementation FavoritesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpCell {
    
    self.listNameLabel.text = self.placeList.name;
    [self.placeList.author fetchIfNeeded];
    self.authorLabel.text = self.placeList.author.username;
    self.numPlacesLabel.text =  [@(self.placeList.placesUnsorted.count) stringValue];
    self.image.file = self.placeList.image;
    self.image.layer.cornerRadius = self.image.frame.size.height / 2; //formula to create a circular image
    [self.image loadInBackground];
    
}

@end
