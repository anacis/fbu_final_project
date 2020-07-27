//
//  SuggestionCollectionCell.h
//  Travelr
//
//  Created by Ana Cismaru on 7/24/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface SuggestionCollectionCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)updateWithSuggestion:(NSDictionary *) suggestion;

@end

NS_ASSUME_NONNULL_END
