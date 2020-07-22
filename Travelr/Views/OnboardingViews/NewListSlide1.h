//
//  NewListSlide1.h
//  Travelr
//
//  Created by Ana Cismaru on 7/22/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewListSlide1 : UIView
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *citySearchBar;

@end

NS_ASSUME_NONNULL_END
