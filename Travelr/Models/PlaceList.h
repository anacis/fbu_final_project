//
//  PlaceList.h
//  Travelr
//
//  Created by Ana Cismaru on 7/13/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <Parse/Parse.h>
#import "Place.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlaceList : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *numDays;
@property (nonatomic, strong) NSNumber *numHours;
@property (nonatomic, strong) NSMutableArray *placesUnsorted;
@property (nonatomic, strong) NSMutableArray *timesSpent;
@property (nonatomic, strong) NSArray *placesSorted;
@property (nonatomic, strong) Place *start;
@property (nonatomic) BOOL completed;
@property (nonatomic, strong) NSDate *startDate;

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

- (NSArray *)sortPlaces;
- (void)separateIntoDays:(NSArray *)sorted;


@end

NS_ASSUME_NONNULL_END
