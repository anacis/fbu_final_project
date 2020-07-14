//
//  DayCell.h
//  Travelr
//
//  Created by Ana Cismaru on 7/14/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DayCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>
 
@property (strong, nonatomic) NSArray *places;
@property (strong, nonatomic) NSString *day;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIButton *mapsButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
