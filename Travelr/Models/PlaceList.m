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

//for now disregard time and days, just sort by distance assuming for one day
- (NSArray *)sortPlaces {
    NSMutableArray *bestSorted = [[NSMutableArray alloc] init];
    double bestTotalDistance = INFINITY;
    
    for (int i = 0; i < self.placesUnsorted.count; i++) {
        NSMutableArray *unsorted = [NSMutableArray arrayWithArray:self.placesUnsorted]; //make a copy as to not disturb orginal data
        NSMutableArray *sorted = [[NSMutableArray alloc] init];
        
        [sorted addObject:unsorted[i]];
        [unsorted removeObjectAtIndex:i];
        
        while (unsorted.count > 0) {
            Place *from = sorted[sorted.count - 1];
            Place *to;
            double bestDistance = INFINITY;
            for (Place *place in unsorted) {
                double distance = [PlaceList getDistance:from place2:place];
                if (distance < bestDistance) {
                    to = place;
                    bestDistance = distance;
                }
            }
        
            [sorted addObject:to];
            [unsorted removeObject:to];
        }
        
        double totalDistance = [PlaceList getTotalDistance:sorted];
        
        if (totalDistance < bestTotalDistance) {
            bestTotalDistance = totalDistance;
            bestSorted = sorted;
        }
       
    }
    
    return bestSorted;
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

+ (double)getTotalDistance:(NSArray *)list {
    double totalDistance = 0;
    for (int i = 1; i < list.count; i++) {
        totalDistance += [PlaceList getDistance:list[i - 1] place2:list[i]];
    }
    return totalDistance;
}

+ (double)convertToRadians:(NSNumber *)num {
    return [num doubleValue] / (180/M_PI);
}

- (void)separateIntoDays:(NSArray *)sorted {
    //We are assuming that the average speed of driving is 35 mph
    int const avgSpeed = 35;
    double daysLeft = [self.numDays doubleValue];
    int sortedIndex = 0;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    while (daysLeft > 0 && sortedIndex < sorted.count) {
        NSMutableArray *dayList = [[NSMutableArray alloc] init];
        double hoursLeft = [self.numHours doubleValue];
        while (hoursLeft > 0 && sortedIndex < sorted.count) {
            double travelTime;
            if (sortedIndex == 0) {
                travelTime = 0;
            }
            else {
                travelTime = [PlaceList getDistance:sorted[sortedIndex - 1] place2:sorted[sortedIndex]] / avgSpeed;
            }
            //get time spent at location
            NSUInteger placeIndex = [self.placesUnsorted indexOfObject:sorted[sortedIndex]];
            double timeSpent = [self.timesSpent[placeIndex] doubleValue];
            
            //TODO: check if default value and retrieve
            
            double totalTime = travelTime + timeSpent;
            if (hoursLeft - totalTime < 0) {
                break;
            }
           
            hoursLeft -= totalTime;
            
            [dayList addObject:sorted[sortedIndex]];
            
            sortedIndex++;
        }
        [result addObject:dayList];
        daysLeft--;
    }
    
    
    self.placesSorted = result;
}



@end
