//
//  PlaceListCell.h
//  Travelr
//
//  Created by Ana Cismaru on 7/13/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;
#import "PlaceList.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PlaceListCellDelegate;

@interface PlaceListCell : UITableViewCell

@property (strong, nonatomic) PlaceList *placeList;
@property (weak, nonatomic) IBOutlet PFImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (nonatomic, weak) id<PlaceListCellDelegate> delegate;

- (void)setUpCell;
- (void)setUpExploreCell;

@end

@protocol PlaceListCellDelegate
- (void)placeListCell:(PlaceListCell *) placeListCell didTap: (PlaceList *)placeList;

@optional
- (void)placeListCell:(PlaceListCell *) placeListCell didTapUsername: (PFUser *)user;

@end

NS_ASSUME_NONNULL_END
