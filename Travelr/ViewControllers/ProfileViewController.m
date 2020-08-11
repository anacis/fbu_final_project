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
#import "ParseManager.h"
#import "LocationFeedController.h"
#import "Colors.h"
@import Parse;

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, FavoritesCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *favoritesTableView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *listNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *listLabel;

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

- (void)setUpPage {
    [self.favoritesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITapGestureRecognizer *tapFollow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(follow:)];
    [self.followButton addGestureRecognizer:tapFollow];
    [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
    [self.followButton setTitleColor:[Colors lightOrangeT2] forState:UIControlStateNormal];
    [self.followButton setTitle:@"Following" forState:UIControlStateSelected];
    [self.followButton setTitleColor:[Colors whiteT2] forState:UIControlStateSelected];
    self.followButton.layer.cornerRadius = 5;
    
    
    UITapGestureRecognizer *tap;
    if (self.user == nil || [self.user.objectId isEqualToString:[PFUser currentUser].objectId]) {
        //my profile page
        self.user = [PFUser currentUser];
        self.button.titleLabel.text = @"Logout";
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logout:)];
        [self.button addGestureRecognizer:tap];
        [self.followButton setHidden:YES];
        self.listLabel.text = @"My Favorites";
    } else {
        self.listLabel.text = [NSString stringWithFormat:@"%@'s Lists", self.user[@"name"]];
        [self.followButton setHidden:NO];
        if ([[PFUser currentUser][@"following"] containsObject:self.user.objectId]) {
            [self.followButton setSelected:YES];
            self.followButton.backgroundColor = [Colors lightOrangeT2];
            self.followButton.tintColor = [Colors whiteT2];
        }
        else {
            [self.followButton setSelected:NO];
            self.followButton.backgroundColor = [Colors creamT2];
            self.followButton.tintColor = [Colors lightOrangeT2];
        }
    }
    self.favoritesTableView.delegate = self;
    self.favoritesTableView.dataSource = self;
    self.nameLabel.text = self.user[@"name"];
    self.listNumLabel.text = [self.user[@"numLists"] stringValue];
    self.friendsNumLabel.text = [@([self.user[@"following"] count]) stringValue];
    self.profilePicView.layer.cornerRadius = self.profilePicView.frame.size.height / 2;
    PFFileObject *image = self.user[@"profilePic"];
    if (image != nil) {
        self.profilePicView.file = image;
        [self.profilePicView loadInBackground];
    }
    else {
        NSLog(@"User does not have a profile pic");
    }
    
    
    if ([self.user.objectId isEqualToString:[PFUser currentUser].objectId]) {
        [self fetchFavorites];
    } else {
        [self fetchLists];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoritesCell"];
    cell.placeList = self.favorites[indexPath.row];
    cell.delegate = self;
    [cell setUpCell];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favorites.count;
}

- (void)fetchFavorites {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ParseManager fetchFavorites:^(NSArray * _Nonnull placeLists, NSError * _Nonnull error) {
        if (placeLists != nil) {
            self.favorites = (NSArray *)placeLists;
            [self.favoritesTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)fetchLists {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ParseManager fetchPlaceLists:^(NSArray * _Nonnull placeLists, NSError * _Nonnull error) {
        if (placeLists != nil) {
            self.favorites = (NSArray *)placeLists;
            NSLog(@"Placelists: %@", placeLists);
            [self.favoritesTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } user:self.user];
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

- (void)follow:(UITapGestureRecognizer *)recognizer {
    NSLog(@"Tapped on follow");
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *list = currUser[@"following"];
    if (self.followButton.isSelected) {
        [self.followButton setSelected:NO];
        [list removeObject:self.user.objectId];
        self.followButton.backgroundColor = [Colors creamT2];
        self.followButton.tintColor = [Colors lightOrangeT2];
    }
    else {
        [self.followButton setSelected:YES];
        self.followButton.backgroundColor = [Colors lightOrangeT2];
        self.followButton.tintColor = [Colors whiteT2];
        if (list == nil) {
            list = [[NSMutableArray alloc] init];
        }
        [list addObject:self.user.objectId];
    }
    [currUser setObject:list forKey:@"following"];
    [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Updated follow status");
        } else {
            NSLog(@"Error following user: %@", error.localizedDescription);
        }
    }];
}


- (IBAction)tapSettings:(id)sender {
    [self performSegueWithIdentifier:@"profileToSettings" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"profileToList"]) {
        LocationFeedController *dest = [segue destinationViewController];
        dest.placeList = sender;
    }
}


- (void)favoritesCell:(nonnull FavoritesCell *)favoritesCell didTap:(nonnull PlaceList *)placeList {
    [self performSegueWithIdentifier:@"profileToList" sender:placeList];
}

@end
