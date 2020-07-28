//
//  DayCell.h
//  Travelr
//
//  Created by Ana Cismaru on 7/14/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"
#import "LocationCollectionCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DayCellDelegate;

@interface DayCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate, LocationCollectionCellDelegate>
 
@property (strong, nonatomic) NSArray *places;
@property (strong, nonatomic) NSString *day;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIButton *mapsButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, weak) id<DayCellDelegate> delegate;

- (void)setUpCell;

@end

@protocol DayCellDelegate
- (void)LocationCollectionCell:(LocationCollectionCell *) LocationCollectionCell didTapLocation: (Place *)place;
@end



NS_ASSUME_NONNULL_END
