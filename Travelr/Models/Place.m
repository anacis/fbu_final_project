//
//  Place.m
//  Travelr
//
//  Created by Ana Cismaru on 7/13/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "Place.h"

@implementation Place

@dynamic name;
@dynamic apiId;
@dynamic photoURLString;
@dynamic address;
@dynamic latitude;
@dynamic longitude;
@dynamic locationType;
@dynamic openingHours;

+ (nonnull NSString *)parseClassName {
    return @"Place";
}

+ (nonnull Place *)createPlaceFromDictionary: (NSDictionary *)dict {
    Place *place = [Place new];
    place.name = dict[@"name"];
    place.apiId = dict[@"id"];
    NSArray *categories = dict[@"categories"];
    
    if (categories && categories.count > 0) {
        NSDictionary *category = categories[0];
        NSString *urlPrefix = [category valueForKeyPath:@"icon.prefix"];
        NSString *urlSuffix = [category valueForKeyPath:@"icon.suffix"];
        place.photoURLString = [NSString stringWithFormat:@"%@bg_32%@", urlPrefix, urlSuffix];
        place.locationType = category[@"name"];
    }
    
    place.longitude = [dict valueForKeyPath:@"location.lng"];
    place.latitude = [dict valueForKeyPath:@"location.lat"];
    place.address = [dict valueForKeyPath:@"location.address"];
    
    //Question: Do I want to save the place now or only once I save my list?
    /*[place saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Saved place to database");
        }
        else {
            NSLog(@"Error saving place: %@", error.localizedDescription);
        }
    }];*/
    
    return place;
}

@end
