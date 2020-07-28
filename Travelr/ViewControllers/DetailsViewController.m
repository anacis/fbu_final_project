//
//  DetailsViewController.m
//  Travelr
//
//  Created by Ana Cismaru on 7/28/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "DetailsViewController.h"
#import "APIConstants.h"
@import Parse;
@import GoogleMaps;

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet PFImageView *image;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPage];
    
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
   // marker.snippet = @"Australia";
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

@end
