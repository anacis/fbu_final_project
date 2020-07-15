//
//  PlaceList.m
//  Travelr
//
//  Created by Ana Cismaru on 7/13/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "PlaceList.h"

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



@end
