//
//  PlaceListCollectionCell.h
//  Travelr
//
//  Created by Ana Cismaru on 8/6/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceList.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface PlaceListCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PFImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) PlaceList *placeList;

- (void)setUpCell;

@end

NS_ASSUME_NONNULL_END
