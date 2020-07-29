//
//  DetailsViewController.m
//  Travelr
//
//  Created by Ana Cismaru on 7/28/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "DetailsViewController.h"
#import "APIConstants.h"
#import "SuggestionCollectionCell.h"
@import Parse;
@import GoogleMaps;

@interface DetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet PFImageView *image;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *suggestions;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPage];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"SuggestionCollectionCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"SuggestionCollectionCell"];
    [self fetchSuggestionsWithVenue:self.place.apiId];
    
}

- (void)setUpPage {
    self.titleLabel.text = self.place.name;
    self.addressLabel.text = [self.place.gMapsAddress stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    self.categoryLabel.text = self.place.locationType;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: [self.place.latitude doubleValue] longitude:[self.place.longitude doubleValue] zoom:12.0];
    self.mapView.camera = camera;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([self.place.latitude doubleValue], [self.place.longitude doubleValue]);
    marker.title = self.place.name;
    marker.map = self.mapView;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SuggestionCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SuggestionCollectionCell" forIndexPath:indexPath];
    NSDictionary *suggestion = self.suggestions[indexPath.item];
    [cell updateWithSuggestion:suggestion];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return MIN(10, [self.suggestions count]);
    return self.suggestions.count;
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
            self.suggestions = [responseDictionary valueForKeyPath:@"response.similarVenues.items"];
            [self.collectionView reloadData];
        }
    }];
    [task resume];
}




@end
