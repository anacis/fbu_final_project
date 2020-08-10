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
    self.nameLabel.layer.cornerRadius = 5;
    self.nameLabel.layer.masksToBounds = YES;
    NSURL *photoURL = [NSURL URLWithString:self.place.photoURLString];
    [self.imageView setImageWithURL:photoURL];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapLocation:)];
    [self addGestureRecognizer:tap];
}

- (void) didTapLocation:(UITapGestureRecognizer *)sender {
    NSLog(@"Tapping on Cell");
    [self.delegate LocationCollectionCell:self didTap:self.place];
}

@end
