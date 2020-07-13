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
@dynamic placeDescription;
@dynamic photo;
@dynamic latitude;
@dynamic longitude;
@dynamic locationType;
@dynamic openingHours;

+ (nonnull NSString *)parseClassName {
    return @"Place";
}

@end
