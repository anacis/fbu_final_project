//
//  DefaultHandling.m
//  Travelr
//
//  Created by Ana Cismaru on 8/3/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "DefaultHandling.h"

@implementation DefaultHandling

+ (double)getDefaultFromCategory:(NSString *)category {
    if (category == nil) {
        return 1;
    }
    
    category = [category lowercaseString];
    
    if ([category containsString:@"restaurant"]) {
        return 2;
    } else if ([category containsString:@"shop"] || [category containsString:@"store"]) {
        return 0.5;
    } else if ([category containsString:@"museum"]) {
        return 5;
    } else if ([category containsString:@"park"]) {
        return 1.5;
    } else if ([category containsString:@"beach"]) {
        return 3;
    } else if ([category containsString:@"café"]) {
        return 1.5;
    } else if ([category containsString:@"landmark"]) {
        return 1;
    } else if ([category containsString:@"station"]) {
        return 0.5;
    } else if ([category containsString:@"lookout"]) {
        return 0.5;
    } else if ([category containsString:@"historic"]) {
        return 3;
    } else if ([category containsString:@"music"] || ([category containsString:@"theater"])) {
        return 3;
    }
    
    return 1;
}


@end
