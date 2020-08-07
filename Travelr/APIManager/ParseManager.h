//
//  ParseManager.h
//  Travelr
//
//  Created by Ana Cismaru on 8/6/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ParseManager : NSObject

+ (void)fetchPlaceLists:(void(^)(NSArray *placeLists, NSError *error))completion user:(PFUser *) user;
+ (void)fetchFavorites:(void(^)(NSArray *placeLists, NSError *error))completion;
+ (void)fetchCompleted:(void(^)(NSArray *placeLists, NSError *error))completion;
+ (void)fetchExplore:(void(^)(NSArray *placeLists, NSError *error))completion index:(NSInteger)index;
+ (void)searchMyLists:(void(^)(NSArray *results, NSError *error))completion searchInput:(NSString *)searchInput;
+ (void)searchExplore:(void(^)(NSArray *placeLists, NSError *error))completion index:(NSInteger)index searchInput:(NSString *)searchInput;

@end

NS_ASSUME_NONNULL_END
