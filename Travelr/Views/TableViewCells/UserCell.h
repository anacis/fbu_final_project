//
//  UserCell.h
//  Travelr
//
//  Created by Ana Cismaru on 8/5/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol UserCellDelegate;

@interface UserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) PFUser *user;

@property (nonatomic, weak) id<UserCellDelegate> delegate;

- (void)setUpCell;

@end

@protocol UserCellDelegate
- (void)UserCell:(UserCell *) userCell didTapUser: (PFUser *)user;

@end

NS_ASSUME_NONNULL_END
