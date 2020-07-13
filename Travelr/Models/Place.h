//
//  Place.h
//  Travelr
//
//  Created by Ana Cismaru on 7/13/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Place : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *apiId;
@property (nonatomic, strong) NSString *placeDescription;
@property (nonatomic, strong) PFFileObject *photo;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *locationType;
@property (nonatomic, strong) NSString *openingHours;

@end

NS_ASSUME_NONNULL_END
