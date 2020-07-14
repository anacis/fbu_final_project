//
//  DayCell.m
//  Travelr
//
//  Created by Ana Cismaru on 7/14/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "DayCell.h"
#import "LocationCollectionCell.h"

@implementation DayCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.dayLabel.text = self.day;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LocationCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"LocationCollectionCell" forIndexPath:indexPath];
    cell.place = self.places[indexPath.item];
    [cell setUpCell];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.places.count;
}


@end
