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
@property (strong, nonatomic) NSArray *days;

@end

@implementation LocationFeedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    cell.places = self.days[indexPath.row];
    cell.day = [NSString stringWithFormat: @"Day %ld", indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.days.count;
}

@end
