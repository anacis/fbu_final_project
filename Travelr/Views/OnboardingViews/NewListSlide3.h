//
//  NewListSlide3.h
//  Travelr
//
//  Created by Ana Cismaru on 7/22/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewListSlide3 : UIView
@property (weak, nonatomic) IBOutlet UITableView *placesSearchTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *suggestionsCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *myPlacesTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *placeSearchBar;

@end

NS_ASSUME_NONNULL_END
