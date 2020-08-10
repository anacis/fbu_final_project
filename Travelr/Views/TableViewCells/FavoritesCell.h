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

@protocol FavoritesCellDelegate;

@interface FavoritesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *listNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet PFImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (strong, nonatomic) PlaceList *placeList;

@property (nonatomic, weak) id<FavoritesCellDelegate> delegate;

- (void)setUpCell;

@end

@protocol FavoritesCellDelegate

- (void)favoritesCell:(FavoritesCell *) favoritesCell didTap: (PlaceList *)placeList;

@end

NS_ASSUME_NONNULL_END

