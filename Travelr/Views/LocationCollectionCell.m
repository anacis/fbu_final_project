//
//  LocationCollectionCell.m
//  Travelr
//
//  Created by Ana Cismaru on 7/14/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "LocationCollectionCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation LocationCollectionCell

- (void)setUpCell {
    self.nameLabel.text = self.place.name;
    NSURL *photoURL = [NSURL URLWithString:self.place.photoURLString];
    [self.image setImageWithURL:photoURL];
}

@end
