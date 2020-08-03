//
//  NewPlaceCell.h
//  Travelr
//
//  Created by Ana Cismaru on 7/13/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

NS_ASSUME_NONNULL_BEGIN
@class NewPlaceCell;

@protocol NewPlaceCellDelegate

- (void)getTimeSpent:(NewPlaceCell *)newPlaceCell;

@end

@interface NewPlaceCell : UITableViewCell

@property (strong, nonatomic) Place *place;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeSpentButton;

- (void)setUpCell;

@property (weak, nonatomic) id<NewPlaceCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
