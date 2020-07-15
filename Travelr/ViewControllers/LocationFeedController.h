//
//  LocationFeedController.h
//  Travelr
//
//  Created by Ana Cismaru on 7/14/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceList.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocationFeedController : UIViewController

@property (strong, nonatomic) PlaceList *placeList;

@end

NS_ASSUME_NONNULL_END
