//
//  ListFeedViewController.m
//  Travelr
//
//  Created by Ana Cismaru on 7/13/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "ListFeedViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "PlaceListCell.h"
#import "LocationFeedController.h"

@interface ListFeedViewController () <UITableViewDelegate, UITableViewDataSource, PlaceListCellDelegate>

@property (strong, nonatomic) NSArray *placeLists;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ListFeedViewController

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
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PlaceListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PlaceListCell"];
    cell.placeList = self.placeLists[indexPath.row];
    cell.delegate = self;
    [cell setUpCell];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.placeLists.count;
}

- (void)fetchPlaceLists {
    PFQuery *query = [PFQuery queryWithClassName:@"PlaceList"];
    [query orderByDescending:@"updatedAt"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
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
    }];
}

- (IBAction)onTapNewList:(id)sender {
    [self performSegueWithIdentifier:@"newListSegue" sender:nil];
}

- (void)placeListCell:(nonnull PlaceListCell *)placeListCell didTap:(nonnull PlaceList *)placeList {
    [self performSegueWithIdentifier:@"listToLocationSegue" sender:placeList];
}

@end
