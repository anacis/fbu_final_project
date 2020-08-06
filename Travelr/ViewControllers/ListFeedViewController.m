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

@interface ListFeedViewController () <UITableViewDelegate, UITableViewDataSource, PlaceListCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *upcomingTripCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *likedCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *completedCollection;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSArray *placeLists;
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
    
    UINib *nib = [UINib nibWithNibName:@"PlaceListCollectionCell" bundle:nil];
    [self.upcomingTripCollection registerNib:nib forCellWithReuseIdentifier:@"PlaceListCollectionCell"];
    [self.likedCollection registerNib:nib forCellWithReuseIdentifier:@"PlaceListCollectionCell"];
    [self.completedCollection registerNib:nib forCellWithReuseIdentifier:@"PlaceListCollectionCell"];
    NSPredicate *heightPredicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", NSLayoutAttributeHeight];
    self.searchTableHeight = [self.tableView.constraints filteredArrayUsingPredicate:heightPredicate][0];
    
    //[self fetchPlaceLists];
    
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

- (void)fetchMyPlaceLists {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ParseManager fetchPlaceLists:^(NSArray * _Nonnull placeLists, NSError * _Nonnull error) {
        if (placeLists != nil) {
            self.placeLists = (NSMutableArray *)placeLists;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } user:[PFUser currentUser]];
}

- (void)fetchFavorites {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ParseManager fetchFavorites:^(NSArray * _Nonnull placeLists, NSError * _Nonnull error) {
        if (placeLists != nil) {
            self.likedLists = (NSMutableArray *)placeLists;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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
        
    } else if (collectionView == self.completedCollection) {
        
    } else if (collectionView == self.likedCollection) {
        
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
    if (collectionView == self.upcomingTripCollection) {
        return self.upcomingLists.count;
    } else if (collectionView == self.completedCollection) {
        return self.completedLists.count;
    } else {
        return self.likedLists.count;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //NSString *city = self.cityField.text;
    //[self fetchLocationsWithQuery:searchBar.text near:city];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self animateOpenTableView];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        [self animateCloseTableView];
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
    //[self fetchLocationsWithQuery:newText near:city];
    return true;
}



- (void)animateOpenTableView {
    [UIView animateWithDuration:1.2f animations:^{
        self.searchTableHeight.constant = [UIScreen mainScreen].bounds.size.height;
    }];
}

- (void)animateCloseTableView {
    [UIView animateWithDuration:1.2f animations:^{
        self.searchTableHeight.constant = 0;
    }];
}

@end
