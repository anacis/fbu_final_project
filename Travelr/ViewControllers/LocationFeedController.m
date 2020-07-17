//
//  LocationFeedController.m
//  Travelr
//
//  Created by Ana Cismaru on 7/14/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "LocationFeedController.h"
#import "DayCell.h"

@interface LocationFeedController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LocationFeedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self checkListCompletion];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DayCell"];
    cell.places = self.placeList.placesSorted[indexPath.row];
    cell.day = [NSString stringWithFormat: @"Day %ld", (indexPath.row + 1)];
    [cell setUpCell];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.placeList.placesSorted.count;
}

- (void)checkListCompletion {
    NSArray *flatArray = [self.placeList.placesSorted valueForKeyPath: @"@unionOfArrays.self"];
    
    if (self.placeList.placesUnsorted.count != flatArray.count) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incomplete Itinerary"
               message:@"It is impossible to generate a full itinerary given the time constraints, consider editing your list."
        preferredStyle:(UIAlertControllerStyleAlert)];
        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
}

@end
