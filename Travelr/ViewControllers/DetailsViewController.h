//
//  DetailsViewController.h
//  Travelr
//
//  Created by Ana Cismaru on 7/28/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"
#import "PlaceList.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) Place *place;
@property (strong, nonatomic) PlaceList *placeList;


@end

NS_ASSUME_NONNULL_END
