//
//  UserCell.m
//  Travelr
//
//  Created by Ana Cismaru on 8/5/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
    [self.followButton setTitle:@"Following" forState:UIControlStateSelected];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpCell {
    NSLog(@"%@", self.user);
    self.usernameLabel.text = self.user.username;
    
    self.image.file = self.user[@"profilePic"];
    self.image.layer.cornerRadius = self.image.frame.size.height / 2; //formula to create a circular image
    [self.image loadInBackground];
    
    
    if ([[PFUser currentUser][@"following"] containsObject:self.user.objectId]) {
        [self.followButton setSelected:YES];
    }
    else {
         [self.followButton setSelected:NO];
    }
}

@end
