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




@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSArray *upcomingLists;
@property (strong, nonatomic) NSArray *likedLists;
@property (strong, nonatomic) NSArray *completedLists;
@property (strong, nonatomic) Place *latestTrip;

@property (strong, nonatomic) NSLayoutConstraint *searchTableHeight;

@end

@implementation ListFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.completedCollection.delegate = self;
    self.completedCollection.dataSource = self;
    self.upcomingTripCollection.delegate = self;
    self.upcomingTripCollection.dataSource = self;
    self.likedCollection.delegate = self;
    self.likedCollection.dataSource = self;
    self.searchBar.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"PlaceListCollectionCell" bundle:nil];
    [self.upcomingTripCollection registerNib:nib forCellWithReuseIdentifier:@"PlaceListCollectionCell"];
    [self.likedCollection registerNib:nib forCellWithReuseIdentifier:@"PlaceListCollectionCell"];
    [self.completedCollection registerNib:nib forCellWithReuseIdentifier:@"PlaceListCollectionCell"];
    NSPredicate *heightPredicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", NSLayoutAttributeHeight];
    self.searchTableHeight = [self.tableView.constraints filteredArrayUsingPredicate:heightPredicate][0];
    
    [self fetchFavorites];
    [self fetchMyPlaceLists];
    [self fetchCompleted];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self fetchFavorites];
    [self fetchMyPlaceLists];
    [self fetchCompleted];
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
        NSLog(@"Placelist: %@", sender);
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
            self.searchResults = (NSMutableArray *)placeLists;
            [self.tableView reloadData];
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
            self.likedLists = (NSMutableArray *)placeLists;
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
            self.completedLists = (NSMutableArray *)placeLists;
            [self.completedCollection reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//TODO: create fetchUpcoming method

- (IBAction)onTapNewList:(id)sender {
    [self performSegueWithIdentifier:@"newListSegue" sender:nil];
}

- (void)placeListCell:(nonnull PlaceListCell *)placeListCell didTap:(nonnull PlaceList *)placeList {
    [self performSegueWithIdentifier:@"listToLocationSegue" sender:placeList];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PlaceListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlaceListCollectionCell" forIndexPath:indexPath];
    if (collectionView == self.upcomingTripCollection) {
        
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
    if (collectionView == self.completedCollection) {
        [self.completedLists[indexPath.item] separateIntoDays:[self.completedLists[indexPath.item] sortPlaces]];
        [self performSegueWithIdentifier:@"listToLocationSegue" sender:self.completedLists[indexPath.item]];
    } else if (collectionView == self.likedCollection) {
        [self.likedLists[indexPath.item] separateIntoDays:[self.likedLists[indexPath.item] sortPlaces]];
        [self performSegueWithIdentifier:@"listToLocationSegue" sender:self.likedLists[indexPath.item]];
    }
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
    [self fetchMyPlaceLists];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        [self fetchMyPlaceLists];
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
    }];
}

@end
