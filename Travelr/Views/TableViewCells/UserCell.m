//
//  UserCell.m
//  Travelr
//
//  Created by Ana Cismaru on 8/5/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "UserCell.h"
#import "Colors.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(follow:)];
    [self.followButton addGestureRecognizer:tap];
    [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
    [self.followButton setTitleColor:[Colors lightOrangeT2] forState:UIControlStateNormal];
    [self.followButton setTitle:@"Following" forState:UIControlStateSelected];
    [self.followButton setTitleColor:[Colors whiteT2] forState:UIControlStateSelected];
    self.followButton.layer.cornerRadius = 5;
    UITapGestureRecognizer *userTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUser:)];
    [self addGestureRecognizer:userTapGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpCell {
    self.usernameLabel.text = self.user.username;
    
    self.image.file = self.user[@"profilePic"];
    self.image.layer.cornerRadius = self.image.frame.size.height / 2; //formula to create a circular image
    [self.image loadInBackground];
    
    
    if ([[PFUser currentUser][@"following"] containsObject:self.user.objectId]) {
        [self.followButton setSelected:YES];
        self.followButton.backgroundColor = [Colors lightOrangeT2];
    }
    else {
         [self.followButton setSelected:NO];
        self.followButton.backgroundColor = [Colors creamT2];
    }
}

- (void) didTapUser:(UITapGestureRecognizer *)sender {
    [self.delegate UserCell:self didTapUser:self.user];
}

- (void)follow:(UITapGestureRecognizer *)recognizer {
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *list = currUser[@"following"];
    if (self.followButton.isSelected) {
        [self.followButton setSelected:NO];
        [list removeObject:self.user.objectId];
        self.followButton.backgroundColor = [Colors creamT2];
    }
    else {
        [self.followButton setSelected:YES];
        self.followButton.backgroundColor = [Colors lightOrangeT2];
        if (list == nil) {
            list = [[NSMutableArray alloc] init];
        }
        [list addObject:self.user.objectId];
    }
    [currUser setObject:list  forKey:@"following"];
    [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Updated follow status");
        } else {
            NSLog(@"Error following user: %@", error.localizedDescription);
        }
    }];
}

@end
