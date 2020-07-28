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
        NSLog(@"%@", self.placeList.objectId);
        [self.likeButton setSelected:YES];
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
        NSLog(@"Unliked %@", self.placeList.objectId);
        [self.likeButton setSelected:NO];
        [list removeObject:self.placeList.objectId];
        
    }
    else {
        [self.likeButton setSelected:YES];
        NSLog(@"Liked %@", self.placeList.objectId);
        if (list == nil) {
            list = [[NSMutableArray alloc] init];
        }
        [list addObject:self.placeList.objectId];
    }
    [currUser setObject:list  forKey:@"favoriteLists"];
    [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Updated user");
        }
    }];
}

@end
