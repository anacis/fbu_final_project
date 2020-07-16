//
//  PlaceList.m
//  Travelr
//
//  Created by Ana Cismaru on 7/13/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "PlaceList.h"
#import "Place.h"
#include <math.h>

@implementation PlaceList

@dynamic name;
@dynamic author;
@dynamic description;
@dynamic image;
@dynamic numDays;
@dynamic numHours;
@dynamic placesUnsorted;
@dynamic timesSpent;

//not stored in Parse
@dynamic placesSorted;

+ (nonnull NSString *)parseClassName {
    return @"PlaceList";
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    
}

- (NSArray *)sortPlaces {
    //TODO: implement sorting algorithm
    return nil;
}

+ (double)getDistance:(Place *)place1 place2:(Place *) place2 {
    //convert lat/lon to radians, foursquare gives it in degrees
    double lat1 = [PlaceList convertToRadians:place1.latitude];
    double lat2 = [PlaceList convertToRadians:place2.latitude];
    double long1 = [PlaceList convertToRadians:place1.longitude];
    double long2 = [PlaceList convertToRadians:place2.longitude];
    
    //formula is in radians
    //orthodromic distance formula in miles (units don't really matter I guess):
    double distance = 3963.0 * acos((sin(lat1) * sin(lat2)) + cos(lat1) * cos(lat2) * cos(long2 - long1));
    return distance;
}

+ (double)convertToRadians:(NSNumber *)num {
    return [num doubleValue] / (180/M_PI);
}




@end
