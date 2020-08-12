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
#import <MBProgressHUD.h>
#import "PlaceListCollectionCell.h"
#import "ParseManager.h"

@interface ListFeedViewController () <UITableViewDelegate, UITableViewDataSource, PlaceListCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *upcomingTripCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *likedCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *completedCollection;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UILabel *upcomingLabel;
@property (weak, nonatomic) IBOutlet UILabel *likedLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedLabel;
@property (weak, nonatomic) IBOutlet UIView *latestView;
@property (weak, nonatomic) IBOutlet UILabel *latestLabel;
@property (weak, nonatomic) IBOutlet PFImageView *latestImage;
@property (weak, nonatomic) IBOutlet UILabel *latestNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestDescriptionLabel;


@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSArray *myPlaceLists;
@property (strong, nonatomic) NSArray *upcomingLists;
@property (strong, nonatomic) NSArray *likedLists;
@property (strong, nonatomic) NSArray *completedLists;
@property (strong, nonatomic) PlaceList *latestTrip;

@property (strong, nonatomic) NSLayoutConstraint *searchTableHeight;

@end

@implementation ListFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.completedCollection.delegate = self;
    self.completedCollection.dataSource = self;
    self.upcomingTripCollection.delegate = self;
    self.upcomingTripCollection.dataSource = self;
    self.likedCollection.delegate = self;
    self.likedCollection.dataSource = self;
    self.searchBar.delegate = self;
    
    UITapGestureRecognizer *tapLatest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLatest:)];
    [self.latestView addGestureRecognizer:tapLatest];
    self.latestImage.layer.cornerRadius = 10.0;
    
    UINib *nib = [UINib nibWithNibName:@"PlaceListCollectionCell" bundle:nil];
    [self.upcomingTripCollection registerNib:nib forCellWithReuseIdentifier:@"PlaceListCollectionCell"];
    [self.likedCollection registerNib:nib forCellWithReuseIdentifier:@"PlaceListCollectionCell"];
    [self.completedCollection registerNib:nib forCellWithReuseIdentifier:@"PlaceListCollectionCell"];
    NSPredicate *heightPredicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", NSLayoutAttributeHeight];
    self.searchTableHeight = [self.tableView.constraints filteredArrayUsingPredicate:heightPredicate][0];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self fetchFavorites];
    [self fetchMyPlaceLists];
    [self fetchCompleted];
    [self setUpLatest];
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
        [[PFUser currentUser] setObject:sender  forKey:@"latestTrip"];
        [[PFUser currentUser] saveInBackground];
    } else if ([segue.identifier isEqualToString:@"latestToLocation"]) {
        LocationFeedController *locationFeed = [segue destinationViewController];
        locationFeed.placeList = sender;
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PlaceListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PlaceListCell"];
    cell.placeList = self.searchResults[indexPath.row];
    cell.delegate = self;
    [cell setUpCell];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (void)fetchMyPlaceLists {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ParseManager fetchPlaceLists:^(NSArray * placeLists, NSError * error) {
        if (placeLists != nil) {
            self.myPlaceLists = placeLists;
            [self.tableView reloadData];
            [self fetchUpcoming];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } user:[PFUser currentUser]];
}

- (void)fetchFavorites {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ParseManager fetchFavorites:^(NSArray * placeLists, NSError * error) {
        if (placeLists != nil) {
            self.likedLists = placeLists;
            [self.likedCollection reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)fetchCompleted {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ParseManager fetchCompleted:^(NSArray * placeLists, NSError * error) {
        if (placeLists != nil) {
            self.completedLists = placeLists;
            [self.completedCollection reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)fetchUpcoming {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    double const upperBound = 31 * 86400; //days to be considered an upcoming trip, measured in seconds since timeIntervalSinceNow is in secs
                                         //idk if this number is too large? should I divide by 86400 when comparing the time interval instead?
    if (self.myPlaceLists != nil) {
        NSMutableArray *constructorArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.myPlaceLists.count; i++) {
            PlaceList *list = self.myPlaceLists[i];
            if (list.startDate != nil && [list.startDate timeIntervalSinceNow] <= upperBound && [list.startDate timeIntervalSinceNow] >= 0) {
                [constructorArray addObject:list];
                
            }
        }
        self.upcomingLists = (NSArray *) constructorArray;
        [self.upcomingTripCollection reloadData];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)setUpLatest {
    if ([PFUser currentUser][@"latestTrip"] != nil) {
        self.latestTrip = [PFUser currentUser][@"latestTrip"];
        [self.latestTrip fetchIfNeeded];
        self.latestImage.file = self.latestTrip.image;
        [self.latestImage loadInBackground];
        self.latestNameLabel.text = self.latestTrip.name;
        self.latestDescriptionLabel.text = self.latestTrip[@"description"];
    } else {
        NSLog(@"No Latest Trip");
    }
}

- (void)tapLatest:(UITapGestureRecognizer *)tap {
    [self performSegueWithIdentifier:@"latestToLocation" sender:self.latestTrip];
}

- (IBAction)onTapNewList:(id)sender {
    [self performSegueWithIdentifier:@"newListSegue" sender:nil];
}

- (void)placeListCell:(nonnull PlaceListCell *)placeListCell didTap:(nonnull PlaceList *)placeList {
    [self performSegueWithIdentifier:@"listToLocationSegue" sender:placeList];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PlaceListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlaceListCollectionCell" forIndexPath:indexPath];
    if (collectionView == self.upcomingTripCollection) {
        cell.placeList = self.upcomingLists[indexPath.item];
    } else if (collectionView == self.completedCollection) {
        cell.placeList = self.completedLists[indexPath.item];
    } else if (collectionView == self.likedCollection) {
        cell.placeList = self.likedLists[indexPath.row];
    }
    [cell setUpCell];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.upcomingTripCollection) {
        return self.upcomingLists.count;
    } else if (collectionView == self.completedCollection) {
        return self.completedLists.count;
    } else {
        return self.likedLists.count;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PlaceList *list;
    if (collectionView == self.completedCollection) {
        list = self.completedLists[indexPath.item];
    } else if (collectionView == self.likedCollection) {
        list = self.likedLists[indexPath.item];
    } else if (collectionView == self.upcomingTripCollection) {
        list = self.upcomingLists[indexPath.item];
    }
    [list separateIntoDays:[list sortPlaces]];
    [self performSegueWithIdentifier:@"listToLocationSegue" sender:list];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ParseManager searchMyLists:^(NSArray * results, NSError * error) {
        if (results != nil) {
            self.searchResults = results;
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } searchInput:searchBar.text];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self animateOpenTableView];
    self.searchResults = self.myPlaceLists;
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        self.searchResults = self.myPlaceLists;
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar endEditing:YES];
    [self animateCloseTableView];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.searchTableHeight.constant == 0) {
        [self animateOpenTableView];
    }
    NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ParseManager searchMyLists:^(NSArray * results, NSError * error) {
        if (results != nil) {
            self.searchResults = results;
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } searchInput:newText];
    return true;
}

- (void)animateOpenTableView {
    [UIView animateWithDuration:0.0f animations:^{
        self.searchTableHeight.constant = self.view.safeAreaLayoutGuide.layoutFrame.size.height;

        self.latestLabel.alpha = 0;
        self.latestView.alpha = 0;
        self.upcomingLabel.alpha = 0;
        self.upcomingTripCollection.alpha = 0;
        self.likedLabel.alpha = 0;
        self.likedCollection.alpha = 0;
        self.completedLabel.alpha = 0;
        self.completedCollection.alpha = 0;
        self.latestImage.alpha = 0;
        
    }];
}

- (void)animateCloseTableView {
    [UIView animateWithDuration:0.2f animations:^{
        self.searchTableHeight.constant = 0;
        self.searchBar.text = @"";
        
        self.latestLabel.alpha = 1;
        self.latestView.alpha = 1;
        self.upcomingLabel.alpha = 1;
        self.upcomingTripCollection.alpha = 1;
        self.likedLabel.alpha = 1;
        self.likedCollection.alpha = 1;
        self.completedLabel.alpha = 1;
        self.completedCollection.alpha = 1;
        self.latestImage.alpha = 1;
    }];
}

@end
