//
//  Place.m
//  Travelr
//
//  Created by Ana Cismaru on 7/13/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "Place.h"
#import <Parse/Parse.h>
#import "PlaceList.h"

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

+ (void)createPlaceFromDictionary: (NSDictionary *)dict placeList:(NSMutableArray *) placeList{
    
    //check if the place does not exist already
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"apiId" equalTo:dict[@"id"]];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable places, NSError * _Nullable error) {
        if (places.count != 0) {
            NSLog(@"Place exists!");
            [placeList addObject:places[0]];
        }
        else if (error != nil) {
            NSLog(@"Error fetching Place: %@", error.localizedDescription);
        }
        else {
            Place *newPlace = [Place new];
            newPlace.name = dict[@"name"];
            newPlace.apiId = dict[@"id"];
            NSArray *categories = dict[@"categories"];
            
            if (categories && categories.count > 0) {
                NSDictionary *category = categories[0];
                NSString *urlPrefix = [category valueForKeyPath:@"icon.prefix"];
                NSString *urlSuffix = [category valueForKeyPath:@"icon.suffix"];
                newPlace.photoURLString = [NSString stringWithFormat:@"%@bg_32%@", urlPrefix, urlSuffix];
                newPlace.locationType = category[@"name"];
            }
            
            newPlace.longitude = [dict valueForKeyPath:@"location.lng"];
            newPlace.latitude = [dict valueForKeyPath:@"location.lat"];
            newPlace.address = [dict valueForKeyPath:@"location.address"];
            
            [placeList addObject:newPlace];

        }
    }];
    
    
    
    //Question: Do I want to save the place now or only once I save my list?
    /*[place saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Saved place to database");
        }
        else {
            NSLog(@"Error saving place: %@", error.localizedDescription);
        }
    }];*/
}

@end
