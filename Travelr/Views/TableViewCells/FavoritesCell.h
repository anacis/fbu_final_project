//
//  FavoritesCell.h
//  Travelr
//
//  Created by Ana Cismaru on 7/27/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceList.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface FavoritesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *listNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *numPlacesLabel;
@property (weak, nonatomic) IBOutlet PFImageView *image;

@property (strong, nonatomic) PlaceList *placeList;


- (void)setUpCell;

@end

NS_ASSUME_NONNULL_END
