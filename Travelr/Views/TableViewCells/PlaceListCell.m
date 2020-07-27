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
    
    if ([[PFUser currentUser][@"favorites"] containsObject:self.placeList]) {
        [self.likeButton setSelected:YES];
    }
}

- (void) didTapList:(UITapGestureRecognizer *)sender{
    [self.placeList separateIntoDays:[self.placeList sortPlaces]];
    
    [self.delegate placeListCell:self didTap:self.placeList];
}

- (IBAction)tapLike:(id)sender {
    PFUser *currUser = [PFUser currentUser];
    if (self.likeButton.isSelected) {
        [self.likeButton setSelected:NO];
        [currUser[@"favorites"] removeObject:self.placeList];
        
    }
    else {
        [self.likeButton setSelected:YES];
        NSLog(@"%@", currUser[@"favorites"]);
        if (currUser[@"favorites"] == nil) {
            currUser[@"favorites"] = [[NSMutableArray alloc] init];
        }
        [currUser[@"favorites"] addObject:self.placeList];
        //TODO: figure out why it isn't updating in Parse
        NSLog(@"%@", currUser[@"favorites"]);
    }
    
    [currUser save];
}

@end
