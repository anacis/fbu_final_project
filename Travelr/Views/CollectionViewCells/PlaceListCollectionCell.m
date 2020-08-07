//
//  PlaceListCollectionCell.m
//  Travelr
//
//  Created by Ana Cismaru on 8/6/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "PlaceListCollectionCell.h"
#import "Colors.h"

@implementation PlaceListCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.layer.cornerRadius = 5;
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.backgroundColor = [Colors lightGreenT2];
    // Initialization code
}

- (void)setUpCell {
    self.titleLabel.text = self.placeList.name;
   self.image.file = self.placeList.image;
    self.image.layer.cornerRadius = 10;
   [self.image loadInBackground];
   
   /*if ([[PFUser currentUser][@"favoriteLists"] containsObject:self.placeList.objectId]) {
       [self.likeButton setSelected:YES];
   }
   else {
        [self.likeButton setSelected:NO];
   }*/
}

@end
