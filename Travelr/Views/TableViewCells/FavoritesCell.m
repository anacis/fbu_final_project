//
//  FavoritesCell.m
//  Travelr
//
//  Created by Ana Cismaru on 7/27/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "FavoritesCell.h"

@implementation FavoritesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapList:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpCell {
    self.listNameLabel.text = self.placeList.name;
    self.descriptionLabel.text = self.placeList[@"description"];
    if ([[PFUser currentUser][@"favoriteLists"] containsObject:self.placeList.objectId]) {
        [self.likeButton setSelected:YES];
    }
    else {
         [self.likeButton setSelected:NO];
    }
    [self.placeList.author fetchIfNeeded];
    self.authorLabel.text = self.placeList.author.username;
    self.image.file = self.placeList.image;
    self.image.layer.cornerRadius = self.image.frame.size.height / 2; //formula to create a circular image
    [self.image loadInBackground];
    
}

- (void) didTapList:(UITapGestureRecognizer *)sender{
    [self.placeList separateIntoDays:[self.placeList sortPlaces]];
    
    [self.delegate favoritesCell:self didTap:self.placeList];
}

- (IBAction)like:(id)sender {
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *list = currUser[@"favoriteLists"];
    if (self.likeButton.isSelected) {
        [self.likeButton setSelected:NO];
        [list removeObject:self.placeList.objectId];
        //TODO: remove from tableview if on my profile page
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

@end
