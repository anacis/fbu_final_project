//
//  DetailView.m
//  Travelr
//
//  Created by Ana Cismaru on 7/29/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "DetailView.h"
#import "Place.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "SuggestionCollectionCell.h"
#import "APIConstants.h"
#import <MBProgressHUD.h>

@implementation DetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setUpPage {
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    self.titleLabel.text = self.place.name;
    self.addressLabel.text = [self.place.gMapsAddress stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    self.categoryLabel.text = self.place.locationType;

    NSURL *photoURL = [NSURL URLWithString:self.place.photoURLString];
    [self.image setImageWithURL:photoURL];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: [self.place.latitude doubleValue] longitude:[self.place.longitude doubleValue] zoom:12.0];
    self.mapView.camera = camera;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([self.place.latitude doubleValue], [self.place.longitude doubleValue]);
    marker.title = self.place.name;
    marker.map = self.mapView;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"SuggestionCollectionCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"SuggestionCollectionCell"];
    [self fetchSuggestionsWithVenue:self.place.apiId];
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SuggestionCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SuggestionCollectionCell" forIndexPath:indexPath];
    NSDictionary *suggestion = self.suggestions[indexPath.item];
    [cell updateWithSuggestion:suggestion];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN(10, [self.suggestions count]);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_group_t serviceGroup = dispatch_group_create();
    NSDictionary *suggestion = self.suggestions[indexPath.item];
    //create Place Object
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    dispatch_group_enter(serviceGroup);
    [Place createPlaceFromDictionary:suggestion placeList:self.placeList.placesUnsorted group:serviceGroup];
   
    dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),^{
        self.placeList[@"placesUnsorted"] = self.placeList.placesUnsorted;
        //TODO: ask User for time Spent
        [self.placeList.timesSpent addObject:@(-1)];
        self.placeList[@"timesSpent"] = self.placeList.timesSpent;
        self.placeList.placesSorted = nil;
        [self.placeList saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                //remove this suggestion from collectionView
                [self.suggestions removeObject:suggestion];
                [collectionView reloadData];
                [MBProgressHUD hideHUDForView:self animated:YES];

            }
            }];
    });
}

- (void)fetchSuggestionsWithVenue:(NSString *)venue {
    NSString *baseURLString = @"https://api.foursquare.com/v2/venues/";
    NSString *queryString = [NSString stringWithFormat:@"%@/similar?client_id=%@&client_secret=%@&v=20141020", venue, FOURSQUAREID, FOURSQUARESECRET];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //TODO: remove locations already in placelist
            
            NSMutableArray *allSuggestions = [NSMutableArray arrayWithArray:[responseDictionary valueForKeyPath:@"response.similarVenues.items"]];
            self.suggestions = [NSMutableArray arrayWithArray:allSuggestions];
            for (NSDictionary *suggestion in allSuggestions) {
                for (Place *place in self.placeList.placesUnsorted) {
                    if ([suggestion[@"name"] isEqualToString:place.name]) {
                        [self.suggestions removeObject:suggestion];
                        break;
                    }
                }
            }
            [self.collectionView reloadData];
            [MBProgressHUD hideHUDForView:self animated:YES];
        }
    }];
    [task resume];
}

@end
