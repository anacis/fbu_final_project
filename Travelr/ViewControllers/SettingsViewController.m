//
//  SettingsViewController.m
//  Travelr
//
//  Created by Ana Cismaru on 8/7/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "SettingsViewController.h"
@import Parse;

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *museumsControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *outdoorsControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *foodControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *entertainmentControl;

//store preferences as array in order [museums, outdoors, food, entertainment]
// -1 = n/a, 0 = AM, 1 = PM
@property (strong, nonatomic) NSArray *preferences;


@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpControl];
}

- (void)viewDidAppear:(BOOL)animated {
    [self setUpControl];
}

- (void)setUpControl {
    PFUser *currUser = [PFUser currentUser];
    NSArray *preferences = currUser[@"preferences"];
    if (preferences != nil) {
        self.museumsControl.selectedSegmentIndex = [preferences[0] integerValue] + 1;
        [self.outdoorsControl setSelectedSegmentIndex:([preferences[1] integerValue] + 1)];
        [self.foodControl setSelectedSegmentIndex:([preferences[2] integerValue] + 1)];
        [self.entertainmentControl setSelectedSegmentIndex:([preferences[3] integerValue] + 1)];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *list = currUser[@"preferences"];
    if (list == nil) {
              list = [[NSMutableArray alloc] init];
    }
    //museum
    [list addObject:@(self.museumsControl.selectedSegmentIndex - 1)];
    //outdoors
    [list addObject:@(self.outdoorsControl.selectedSegmentIndex - 1)];
    //food
    [list addObject:@(self.foodControl.selectedSegmentIndex - 1)];
    //entertainment
    [list addObject:@(self.entertainmentControl.selectedSegmentIndex - 1)];
       
    [currUser setObject:list forKey:@"preferences"];
    [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Updated user");
        }
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
