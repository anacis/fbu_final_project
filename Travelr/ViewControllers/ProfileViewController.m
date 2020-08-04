//
//  ProfileViewController.m
//  Travelr
//
//  Created by Ana Cismaru on 7/27/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "ProfileViewController.h"
#import "FavoritesCell.h"
#import <MBProgressHUD.h>
#import "SceneDelegate.h"
#import "LoginViewController.h"
@import Parse;

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *favoritesTableView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *listNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (strong, nonatomic) NSArray *favorites;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPage];
}

- (void)viewDidAppear:(BOOL)animated {
    [self setUpPage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setUpPage {
    UITapGestureRecognizer *tap;
    if (self.user == nil || self.user == [PFUser currentUser]) {
      //my profile page
      self.user = [PFUser currentUser];
      self.button.titleLabel.text = @"Logout";
      tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logout:)];
    } else {
      self.button.titleLabel.text = @"Back";
      tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    }
    [self.button addGestureRecognizer:tap];
    self.favoritesTableView.delegate = self;
    self.favoritesTableView.dataSource = self;
    //TODO: add name field in sign up page
    NSLog(@"%@", self.user);
    self.nameLabel.text = self.user[@"name"];
    self.listNumLabel.text = [self.user[@"numLists"] stringValue];
    self.friendsNumLabel.text = [@([self.user[@"friends"] count]) stringValue];
    self.profilePicView.layer.cornerRadius = self.profilePicView.frame.size.height / 2;
    PFFileObject *image = self.user[@"profilePic"];
    if (image != nil) {
        self.profilePicView.file = image;
        [self.profilePicView loadInBackground];
    }
    else {
        NSLog(@"User does not have a profile pic");
    }
    
    [self fetchFavorites];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoritesCell"];
    cell.placeList = self.favorites[indexPath.row];
    [cell setUpCell];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favorites.count;
}

- (void)fetchFavorites {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"PlaceList"];
    [query orderByDescending:@"updatedAt"];
    //[query whereKey:@"author" equalTo:[PFUser currentUser]];
    NSArray *favorites = [PFUser currentUser][@"favoriteLists"];
    [query whereKey:@"objectId" containedIn:favorites];
    [query includeKey:@"placesUnsorted"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *placeLists, NSError *error) {
        if (placeLists != nil) {
            self.favorites = (NSArray *)placeLists;
            [self.favoritesTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)logout:(UITapGestureRecognizer *)tap {
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

- (void)goBack:(UITapGestureRecognizer *)tap {
    self.user = nil;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SceneDelegate *scene = (SceneDelegate *) self.view.window.windowScene.delegate;
    UITabBarController *tab = [storyboard instantiateViewControllerWithIdentifier:@"Tabbar"];
    scene.window.rootViewController = tab;
    [tab setSelectedIndex:1];
    
}

@end
