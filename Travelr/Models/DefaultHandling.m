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
    
    if ([category containsString:@"Restaurant"]) {
        return 2;
    } else if ([category containsString:@"Shop"] || [category containsString:@"Store"]) {
        return 0.5;
    } else if ([category containsString:@"Museum"]) {
        return 5;
    } else if ([category containsString:@"Park"]) {
        return 1.5;
    } else if ([category containsString:@"Beach"]) {
        return 3;
    } else if ([category containsString:@"Café"]) {
        return 1.5;
    } else if ([category containsString:@"Landmark"]) {
        return 1;
    } else if ([category containsString:@"Station"]) {
        return 0.5;
    } else if ([category containsString:@"Lookout"]) {
        return 0.5;
    } else if ([category containsString:@"Historic"]) {
        return 3;
    } else if ([category containsString:@"Music"] || ([category containsString:@"Theater"])) {
        return 3;
    }
    
    return 1;
}


@end
