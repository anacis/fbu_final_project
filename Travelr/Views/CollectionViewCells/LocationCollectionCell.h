//
//  LocationCollectionCell.h
//  Travelr
//
//  Created by Ana Cismaru on 7/14/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol LocationCollectionCellDelegate;

@interface LocationCollectionCell : UICollectionViewCell

@property (nonatomic, strong) Place *place;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)setUpCell;

@property (nonatomic, weak) id<LocationCollectionCellDelegate> delegate;

@end

@protocol LocationCollectionCellDelegate
- (void)LocationCollectionCell:(LocationCollectionCell *) LocationCollectionCell didTap: (Place *)place;
@end

NS_ASSUME_NONNULL_END
