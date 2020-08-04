//
//  ExploreViewController.m
//  Travelr
//
//  Created by Ana Cismaru on 7/29/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "ExploreViewController.h"
#import "PlaceListCell.h"
#import "LocationFeedController.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "ProfileViewController.h"
#import <MBProgressHUD.h>

@interface ExploreViewController () <UITableViewDelegate, UITableViewDataSource, PlaceListCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *placeLists;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchPlaceLists];
}

- (IBAction)logout:(id)sender {
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
    }
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"User is logged out");
            SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavController"];
            myDelegate.window.rootViewController = loginViewController;
        }
        else {
            NSLog(@"Error logging out: %@", error.localizedDescription);
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"listToLocationSegue"]) {
        LocationFeedController *locationFeed = [segue destinationViewController];
        locationFeed.placeList = sender;
    } else if ([segue.identifier isEqualToString:@"listToProfile"]) {
        ProfileViewController *destination = [segue destinationViewController];
        destination.user = sender;
        
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PlaceListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PlaceListCell"];
    cell.placeList = self.placeLists[indexPath.row];
    cell.delegate = self;
    [cell setUpExploreCell];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.placeLists.count;
}

- (void)fetchPlaceLists {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"PlaceList"];
    [query orderByDescending:@"updatedAt"];
    //[query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query includeKey:@"placesUnsorted"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *placeLists, NSError *error) {
        if (placeLists != nil) {
            self.placeLists = (NSMutableArray *)placeLists;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)placeListCell:(nonnull PlaceListCell *)placeListCell didTap:(nonnull PlaceList *)placeList {
    [self performSegueWithIdentifier:@"listToLocationSegue" sender:placeList];
}

- (void)placeListCell:(PlaceListCell *) placeListCell didTapUsername: (PFUser *)user {
    [self performSegueWithIdentifier:@"listToProfile" sender:user];
}

@end
