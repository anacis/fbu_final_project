//
//  DayCell.m
//  Travelr
//
//  Created by Ana Cismaru on 7/14/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "DayCell.h"
#import "LocationCollectionCell.h"

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
    [cell setUpCell];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.places.count;
}

- (void)setUpCell {
    self.dayLabel.text = self.day;
}

- (IBAction)startMaps:(id)sender {
    //GMaps Format: "https://www.google.com/maps/dir/Shoreline+Amphitheatre,+Amphitheatre+Parkway,+Mountain+View,+CA/Facebook,+1+Hacker+Way,+Menlo+Park,+CA+94025"
    //For Latitude/Longitude"https://www.google.com/maps/dir/48.8786722,2.3000998/48.8467008,2.2987277"
    // add as many slashes to add destination points
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self getMapsURLString]] options:nil completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Launched Google Maps");
        }
    }];
}

- (NSString *)getMapsURLString {
    NSString const *baseUrlString = @"https://www.google.com/maps/dir";
    NSString *urlString = @"";
    for (Place *place in self.places) {
        NSString *coordinatePair = [NSString stringWithFormat:@"/%@,%@", place.latitude, place.longitude];
        
        //Call using address/name rather than coordinates (only works for some though :(  )
        /*NSString *temp = [place.address stringByReplacingOccurrencesOfString:@" "withString:@"+"];
        temp = [temp stringByAppendingString:@"/"];*/
        if ([urlString isEqualToString:@""]) {
            urlString  = [baseUrlString stringByAppendingString:coordinatePair];
        } else {
            urlString  = [urlString stringByAppendingString:coordinatePair];
        }
    }
    return urlString;
}


@end
