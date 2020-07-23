//
//  NewListSlide1.h
//  Travelr
//
//  Created by Ana Cismaru on 7/22/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface NewListSlide1 : UIView
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet PFImageView *listImage;


@end

NS_ASSUME_NONNULL_END
