//
//  NewListOnboardingController.h
//  Travelr
//
//  Created by Ana Cismaru on 7/22/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NewListOnboardingController;

@protocol SearchPlaceDelegate

- (void)searchPlace:(NewListOnboardingController *)controller didPickLocationWithDictionary:(NSDictionary *)dict;

@end

@interface NewListOnboardingController : UIViewController

@property (weak, nonatomic) id<SearchPlaceDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
