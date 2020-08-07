//
//  ParseManager.m
//  Travelr
//
//  Created by Ana Cismaru on 8/6/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "ParseManager.h"
@import Parse;

@implementation ParseManager


+ (void)fetchPlaceLists:(void(^)(NSArray *placeLists, NSError *error))completion user:(PFUser *)user {
    PFQuery *query = [PFQuery queryWithClassName:@"PlaceList"];
    [query orderByDescending:@"updatedAt"];
    [query whereKey:@"author" equalTo:user];
    [query includeKey:@"placesUnsorted"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock: completion];
}

+ (void)fetchFavorites:(void(^)(NSArray *placeLists, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"PlaceList"];
    [query orderByDescending:@"updatedAt"];
    PFUser *user = [PFUser currentUser];
    NSArray *favorites = user[@"favoriteLists"];
    [query whereKey:@"objectId" containedIn:favorites];
    [query includeKey:@"placesUnsorted"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:completion];
}

+ (void)fetchCompleted:(void(^)(NSArray *placeLists, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"PlaceList"];
    [query orderByDescending:@"updatedAt"];
    NSArray *completed = [PFUser currentUser][@"completedLists"];
    [query whereKey:@"objectId" containedIn:completed];
    [query includeKey:@"placesUnsorted"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:completion];
}

+ (void)fetchExplore:(void(^)(NSArray *results, NSError *error))completion index:(NSInteger)index {
    PFQuery *query;
    if (index == 0) {
        query = [PFUser query];
        [query whereKey:@"objectId" notEqualTo:[PFUser currentUser].objectId];
    } else {
        query = [PFQuery queryWithClassName:@"PlaceList"];
        [query includeKey:@"placesUnsorted"];
        [query whereKey:@"author" notEqualTo:[PFUser currentUser]];
    }
    [query orderByDescending:@"updatedAt"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:completion];
}


+ (void)searchMyLists:(void(^)(NSArray *results, NSError *error))completion searchInput:(NSString *)searchInput{
    PFQuery *query = [PFQuery queryWithClassName:@"PlaceList"];
    [query whereKey:@"name" containsString:searchInput];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:completion];
}

+ (void)searchExplore:(void(^)(NSArray *results, NSError *error))completion index:(NSInteger)index searchInput:(NSString *)searchInput{
   PFQuery *query;
   if (index == 0) {
       PFQuery *usernames = [PFUser query];
       [usernames whereKey:@"username" containsString:searchInput]; //matches both uppercase and lowercase
       PFQuery *names = [PFUser query];
       [names whereKey:@"name" containsString:searchInput];
       query = [PFQuery orQueryWithSubqueries:@[usernames,names]];
   } else if (index == 1) {
       query = [PFQuery queryWithClassName:@"PlaceList"];
       [query whereKey:@"name" containsString:searchInput];
   }
    [query findObjectsInBackgroundWithBlock:completion];
}

@end
