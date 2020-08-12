//
//  LocationFeedController.m
//  Travelr
//
//  Created by Ana Cismaru on 7/14/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "LocationFeedController.h"
#import "DayCell.h"
#import "NewListOnboardingController.h"
#import "LocationCollectionCell.h"
#import "DetailsViewController.h"
#import "Colors.h"

@interface LocationFeedController () <UITableViewDelegate, UITableViewDataSource, DayCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *listNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation LocationFeedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.listNameLabel.text = self.placeList.name;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    if (self.placeList.startDate != nil && [self.placeList.author.objectId isEqualToString:[PFUser currentUser].objectId]) {
        NSString *startDateString = [dateFormatter stringFromDate:self.placeList.startDate];
        NSDate *endDate = [self.placeList.startDate dateByAddingTimeInterval:([self.placeList.numDays intValue] - 1)*24*60*60];
        NSString *endDateString = [dateFormatter stringFromDate:endDate];
        if ([startDateString isEqualToString:endDateString]) {
            self.dateLabel.text = startDateString;
        } else {
            self.dateLabel.text = [NSString stringWithFormat:@"%@ - %@", startDateString, endDateString];
        }
    } else {
        self.dateLabel.text = @"date unavailable";
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeTrip:)];
    [self.completeButton addGestureRecognizer:tap];
    [self.completeButton setTitle:@"Complete Trip" forState:UIControlStateNormal];
    [self.completeButton setTitleColor:[Colors whiteT2] forState:UIControlStateNormal];
    
    [self.completeButton setTitle:@"Trip Completed" forState:UIControlStateSelected];
    [self.completeButton setTitleColor:[Colors whiteT2] forState:UIControlStateSelected];
    
    if ([self.placeList.author.objectId isEqualToString:[PFUser currentUser].objectId]) {
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [self.editButton setTitle:@"Edit" forState:UIControlStateSelected];
    } else {
        [self.editButton setTitle:@"Clone" forState:UIControlStateNormal];
        [self.editButton setTitle:@"Clone" forState:UIControlStateSelected];
    }
    
    
    if ([[PFUser currentUser][@"completedLists"] containsObject:self.placeList.objectId]) {
        [self.completeButton setSelected:YES];
        self.completeButton.backgroundColor = [Colors lightOrangeT2];
    }
    else {
        [self.completeButton setSelected:NO];
        self.completeButton.backgroundColor = [Colors lightGreenT2];
    }
    
    if ([[PFUser currentUser][@"favoriteLists"] containsObject:self.placeList.objectId]) {
        [self.likeButton setSelected:YES];
    }
    else {
         [self.likeButton setSelected:NO];
    }
    
    [self checkListCompletion];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"editList"]) {
        UINavigationController *destination = [segue destinationViewController];
        NewListOnboardingController *newListController = (NewListOnboardingController *) destination.topViewController;
        newListController.placeList = self.placeList;
    }
    else if ([[segue identifier] isEqualToString:@"detailsSegue"]) {
        DetailsViewController *destination = [segue destinationViewController];
        destination.place = sender;
        destination.placeList = self.placeList;
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DayCell"];
    cell.places = self.placeList.placesSorted[indexPath.row];
    cell.day = [NSString stringWithFormat: @"Day %ld", (indexPath.row + 1)];
    cell.delegate = self;
    [cell setUpCell];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.placeList.placesSorted.count;
}

- (void)checkListCompletion {
    NSArray *flatArray = [self.placeList.placesSorted valueForKeyPath: @"@unionOfArrays.self"];
    
    if (self.placeList.placesUnsorted.count != flatArray.count) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Itinerary Mismatch"
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

- (IBAction)onTapEdit:(id)sender {
    [self performSegueWithIdentifier:@"editList" sender:nil];
}

- (void)LocationCollectionCell:(nonnull LocationCollectionCell *)LocationCollectionCell didTapLocation:(nonnull Place *)place {
    [self performSegueWithIdentifier:@"detailsSegue" sender:place];
}

- (void)completeTrip:(UITapGestureRecognizer *)recognizer {
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *list = currUser[@"completedLists"];
    if (!self.completeButton.isSelected) {
           NSLog(@"Completed Trip");
           [self.completeButton setSelected:YES];
           self.completeButton.backgroundColor = [Colors lightOrangeT2];
            if (list == nil) {
                      list = [[NSMutableArray alloc] init];
            }
            [list addObject:self.placeList.objectId];
       } else {
           NSLog(@"UnCompleted Trip");
           [self.completeButton setSelected:NO];
           self.completeButton.backgroundColor = [Colors lightGreenT2];
           [list removeObject:self.placeList.objectId];
       }
    [currUser setObject:list forKey:@"completedLists"];
    [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Updated user");
        }
    }];

}

- (IBAction)like:(id)sender {
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *list = currUser[@"favoriteLists"];
    if (self.likeButton.isSelected) {
        [self.likeButton setSelected:NO];
        [list removeObject:self.placeList.objectId];
        
    }
    else {
        [self.likeButton setSelected:YES];
        if (list == nil) {
            list = [[NSMutableArray alloc] init];
        }
        [list addObject:self.placeList.objectId];
    }
    [currUser setObject:list  forKey:@"favoriteLists"];
    [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Liked list");
        }
    }];
}

@end
