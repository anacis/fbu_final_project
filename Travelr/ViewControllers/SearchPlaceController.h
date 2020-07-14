//
//  PlaceSearchViewController.h
//  Travelr
//
//  Created by Ana Cismaru on 7/14/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "ViewController.h"
#import "Place.h"

NS_ASSUME_NONNULL_BEGIN

@class SearchPlaceController;

@protocol SearchPlaceControllerDelegate

- (void)searchPlaceController:(SearchPlaceController *)controller didPickLocationWithPlace:(Place *)place;

@end

@interface SearchPlaceController : ViewController

@property (weak, nonatomic) id<SearchPlaceControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
