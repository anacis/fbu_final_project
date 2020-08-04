//
//  PickerViewController.m
//  Travelr
//
//  Created by Ana Cismaru on 8/3/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "PickerViewController.h"
#import "SceneDelegate.h"
#import "DefaultHandling.h"

@interface PickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@property (nonatomic, strong) NSArray *pickerData;

@end

@implementation PickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *tempHours = [[NSMutableArray alloc] init];
    int const maxHoursPerDay = 17; //I determined that one would spend at maximum 16 hours in one tourist location (like a hike or a beach)
    for (int i = 0; i < maxHoursPerDay; i++) {
        if (i < 10) {
            [tempHours addObject:[NSString stringWithFormat:@"0%i", i]];
        }
        else {
            [tempHours addObject:[NSString stringWithFormat:@"%i", i]];
        }
    }
    [tempHours insertObject:@"?" atIndex:0];
    
    NSMutableArray *tempMinutes = [[NSMutableArray alloc] init];
    int const maxMinutesPerDay = 60; //incrementing the minutes option by 15 min (ie: 9, 15, 30, 45)
    for (int i = 0; i < maxMinutesPerDay; i += 15) {
        if (i < 10) {
            [tempMinutes addObject:[NSString stringWithFormat:@"0%i", i]];
        }
        else {
            [tempMinutes addObject:[NSString stringWithFormat:@"%i", i]];
        }
    }
    [tempMinutes insertObject:@"?" atIndex:0];
    
    self.pickerData = [NSArray arrayWithObjects:tempHours, tempMinutes, nil];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    //[self.timeSpentButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    //double bottomPadding = myDelegate.window.safeAreaInsets.bottom;
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, 550 - self.tabBarHeight, self.view.frame.size.width, 300)];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerData[component] count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[component][row];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:self completion:nil];
}

- (IBAction)select:(id)sender {
    NSString *hours = self.pickerData[0][[self.pickerView selectedRowInComponent:0]];
    NSString *minutes = self.pickerData[1][[self.pickerView selectedRowInComponent:1]];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *time;
    if ([hours isEqualToString:@"?"] || [minutes isEqualToString:@"?"]) {
        if (self.cell != nil) {
            self.cell.timeSpentButton.titleLabel.text = @"Default time";
        }
        time = @(-1);
    }
    else if ([hours intValue] == 0){
        if (self.cell != nil) {
            self.cell.timeSpentButton.titleLabel.text = [NSString stringWithFormat:@"%@min", minutes];
        }
        double convertedMinutes = [[self.pickerData[1][[self.pickerView selectedRowInComponent:1]] substringToIndex:2] doubleValue] / 60;
        time = @(convertedMinutes);
    }
    else {
        if (self.cell != nil) {
            self.cell.timeSpentButton.titleLabel.text = [NSString stringWithFormat:@"%@h%@min", hours, minutes];
        }
        double convertedMinutes = [[self.pickerData[1][[self.pickerView selectedRowInComponent:1]] substringToIndex:2] doubleValue] / 60;
        double totalTime = [[self.pickerData[0][[self.pickerView selectedRowInComponent:0]] substringToIndex:2] doubleValue] + convertedMinutes;
        time = @(totalTime);
    }
    NSLog(@"Delegate: %@", self.delegate);
    NSLog(@"Time: %@", time);
    
    if (self.cell != nil) {
        [self.delegate time:time didSpecifyTimeSpent:self.cell];
    } else {
        [self.delegate time:time didSpecifyTimeSpent:nil];
    }
    [self dismissViewControllerAnimated:self completion:nil];
}

@end
