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
@import GoogleMaps;

static NSString * const apiKey = @"AIzaSyA0ZUTS5YGFB_Um83afzjHghEgOvTnlRX0";

@implementation Place

@dynamic name;
@dynamic apiId;
@dynamic photoURLString;
@dynamic address;
@dynamic latitude;
@dynamic longitude;
@dynamic locationType;
@dynamic openingHours;
@dynamic gMapsAddress;

+ (nonnull NSString *)parseClassName {
    return @"Place";
}



+ (void)createPlaceFromDictionary: (NSDictionary *)dict placeList:(NSMutableArray *) placeList{
    [GMSServices provideAPIKey:apiKey];
    
    //check if the place does not exist already
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"apiId" equalTo:dict[@"id"]];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable places, NSError * _Nullable error) {
        if (places.count != 0) {
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
            [newPlace reverseGeocode];
            
            [placeList addObject:newPlace];

        }
    }];
    
}

- (void)reverseGeocode {
    CLLocationCoordinate2D coordinatePair = CLLocationCoordinate2DMake(self.latitude.floatValue, self.longitude.floatValue);
    GMSGeocoder *geocoder = [GMSGeocoder geocoder];
    [geocoder reverseGeocodeCoordinate:coordinatePair completionHandler:^(GMSReverseGeocodeResponse * _Nullable response, NSError * _Nullable error) {
        if (response != nil) {
            self.gMapsAddress = [response.firstResult.lines[0] stringByReplacingOccurrencesOfString:@" "withString:@"+"];
        }
        else {
            NSLog(@"Error reverse geocoding: %@", error.localizedDescription);
        }
    }];
}

@end
