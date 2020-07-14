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

@interface LocationCollectionCell : UICollectionViewCell

@property (nonatomic, strong) Place *place;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)setUpCell;

@end

NS_ASSUME_NONNULL_END
