//
//  PlaceListCell.m
//  Travelr
//
//  Created by Ana Cismaru on 7/13/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "PlaceListCell.h"

@implementation PlaceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *placeListTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapList:)];
    [self addGestureRecognizer:placeListTapGestureRecognizer];
    UITapGestureRecognizer *usernameTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usernameTapped:)];
    [self.usernameLabel addGestureRecognizer:usernameTapGestureRecognizer];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpCell {
    self.titleLabel.text = self.placeList.name;
    self.descriptionLabel.text = self.placeList[@"description"];
    self.image.file = self.placeList.image;
    self.image.layer.cornerRadius = self.image.frame.size.height / 2; //formula to create a circular image
    [self.image loadInBackground];
    
    if ([[PFUser currentUser][@"favoriteLists"] containsObject:self.placeList.objectId]) {
        [self.likeButton setSelected:YES];
    }
    else {
         [self.likeButton setSelected:NO];
    }
}

- (void)setUpExploreCell {
    self.titleLabel.text = self.placeList.name;
    self.descriptionLabel.text = self.placeList[@"description"];
    PFUser *poster = [self.placeList.author fetchIfNeeded];
    if (![poster.objectId isEqualToString:[PFUser currentUser].objectId]) {
        [self.usernameLabel setHidden:NO];
        self.usernameLabel.text = [@"@" stringByAppendingString:poster.username];
    } else {
        [self.usernameLabel setHidden:YES];
    }
    self.image.file = self.placeList.image;
    self.image.layer.cornerRadius = self.image.frame.size.height / 2; //formula to create a circular image
    [self.image loadInBackground];
    
    if ([[PFUser currentUser][@"favoriteLists"] containsObject:self.placeList.objectId]) {
        [self.likeButton setSelected:YES];
    }
    else {
         [self.likeButton setSelected:NO];
    }
}


- (void) didTapList:(UITapGestureRecognizer *)sender{
    [self.placeList separateIntoDays:[self.placeList sortPlaces]];
    
    [self.delegate placeListCell:self didTap:self.placeList];
}

- (IBAction)tapLike:(id)sender {
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *list = currUser[@"favoriteLists"];
    if (self.likeButton.isSelected) {
        [self.likeButton setSelected:NO];
        [list removeObject:self.placeList.objectId];
        
    }
    else {
        [self.likeButton setSelected:YES];
        if (list == nil) {
            list = [[NSMutableArray alloc] init];
        }
        [list addObject:self.placeList.objectId];
    }
    [currUser setObject:list  forKey:@"favoriteLists"];
    [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Liked list");
        }
    }];
}

- (void)usernameTapped:(UITapGestureRecognizer*)tap {
    NSLog(@"Tapped on username");
    [self.delegate placeListCell:self didTapUsername:self.placeList.author];
}



@end
