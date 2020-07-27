//
//  SuggestionCollectionCell.m
//  Travelr
//
//  Created by Ana Cismaru on 7/24/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "SuggestionCollectionCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation SuggestionCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateWithSuggestion:(NSDictionary *) suggestion {
    NSDictionary *venue = suggestion[@"venue"];
    
    self.nameLabel.text = venue[@"name"];
    
    NSArray *categories = venue[@"categories"];
    if (categories && categories.count > 0) {
        NSDictionary *category = categories[0];
        NSString *urlPrefix = [category valueForKeyPath:@"icon.prefix"];
        NSString *urlSuffix = [category valueForKeyPath:@"icon.suffix"];
        NSString *photoURLString = [NSString stringWithFormat:@"%@bg_32%@", urlPrefix, urlSuffix];
        NSURL *photoURL = [NSURL URLWithString:photoURLString];
        [self.imageView setImageWithURL:photoURL];
    }
}
    
   

@end
