//
//  DayCell.m
//  Travelr
//
//  Created by Ana Cismaru on 7/14/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "DayCell.h"
#import "LocationCollectionCell.h"
#import "DetailsViewController.h"

@implementation DayCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LocationCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"LocationCollectionCell" forIndexPath:indexPath];
    cell.place = self.places[indexPath.item];
    cell.delegate = self;
    [cell setUpCell];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.places.count;
}

- (void)setUpCell {
    self.dayLabel.text = self.day;
}

- (void)LocationCollectionCell:(LocationCollectionCell *)LocationCollectionCell didTap:(Place *)place {
    [self.delegate LocationCollectionCell:LocationCollectionCell didTapLocation:place];
}


- (IBAction)startMaps:(id)sender {
    //GMaps Format: "https://www.google.com/maps/dir/Shoreline+Amphitheatre,+Amphitheatre+Parkway,+Mountain+View,+CA/Facebook,+1+Hacker+Way,+Menlo+Park,+CA+94025"
    //For Latitude/Longitude"https://www.google.com/maps/dir/48.8786722,2.3000998/48.8467008,2.2987277"
    // add as many slashes to add destination points
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self getMapsURLString]] options:nil completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Launched Google Maps");
        }
        else {
            NSLog(@"GMaps with address didn't work, trying with coordinates");
            [self startMapsWithCoordinates];
        }
    }];
}

- (void)startMapsWithCoordinates {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self getMapsURLStringWithCoordinates]] options:nil completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Launched Google Maps using coordinates");
        }
        else {
            NSLog(@"GMaps with address didn't work :( ");
        }
    }];
}


- (NSString *)getMapsURLString {
    NSString const *baseUrlString = @"https://www.google.com/maps/dir/";
    NSString *urlString = @"";
    for (Place *place in self.places) {
        if ([urlString isEqualToString:@""]) {
            urlString = [baseUrlString stringByAppendingString:place.gMapsAddress];
        }
        else {
            NSString *urlAddress = [@"/" stringByAppendingString:place.gMapsAddress];
            urlString = [urlString stringByAppendingString:urlAddress];
        }
    }
    NSLog(@"URL STRING: %@", urlString);
    return urlString;
}

- (NSString *)getMapsURLStringWithCoordinates {
    NSString const *baseUrlString = @"https://www.google.com/maps/dir";
    NSString *urlString = @"";
    for (Place *place in self.places) {
        NSString *temp = [NSString stringWithFormat:@"/%@,%@", place.latitude, place.longitude];
        if ([urlString isEqualToString:@""]) {
            urlString = [baseUrlString stringByAppendingString:temp];
        }
        else {
            urlString = [urlString stringByAppendingString:temp];
        }
    }
    NSLog(@"URL STRING COOR: %@", urlString);
    return urlString;
}


@end
