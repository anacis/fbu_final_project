//
//  DetailView.h
//  Travelr
//
//  Created by Ana Cismaru on 7/29/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"
#import "PlaceList.h"
@import GoogleMaps;

NS_ASSUME_NONNULL_BEGIN

@class DetailView;

@protocol DetailViewDelegate

- (void)getTimeSpent:(DetailView *)detailView timeGroup:(dispatch_group_t)timeGroup;

@end

@interface DetailView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) Place *place;
@property (strong, nonatomic) PlaceList *placeList;
@property (strong, nonatomic) NSMutableArray *suggestions;

@property (weak, nonatomic) id<DetailViewDelegate> delegate;

- (void)setUpPage;
- (void)fetchSuggestionsWithVenue:(NSString *)venue;

@end

NS_ASSUME_NONNULL_END
