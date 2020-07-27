//
//  ProfileViewController.m
//  Travelr
//
//  Created by Ana Cismaru on 7/27/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "ProfileViewController.h"
#import "FavoritesCell.h"
@import Parse;

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *favoritesTableView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *listNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsNumLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    self.favoritesTableView.delegate = self;
    self.favoritesTableView.dataSource = self;
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
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoritesCell"];
    [cell setUpCell];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


@end
