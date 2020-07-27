//
//  ProfileViewController.h
//  Travelr
//
//  Created by Ana Cismaru on 7/27/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) PFUser *user;

@end

NS_ASSUME_NONNULL_END
