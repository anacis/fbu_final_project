//
//  TestViewController.m
//  Travelr
//
//  Created by Ana Cismaru on 7/21/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "TestViewController.h"
#import "MKDropdownMenu.h"
#import "CityCell.h"
#import "APIConstants.h"

@interface TestViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *citiesSearched;
@property (strong, nonatomic) dispatch_group_t group;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    self.group = dispatch_group_create();
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
    CityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CityCell"];
    cell.cityNameLabel.text = self.citiesSearched[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.citiesSearched.count;
}

/*- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    [self fetchCities:newText];
    dispatch_group_wait(self.group, 3);
    [self.tableView reloadData];
    
    return true;
}*/

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self fetchCities:searchBar.text];
    //TODO: ask jeff about weird asynchness going on
    dispatch_group_wait(self.group, 3);
    [self.tableView reloadData];
}

- (void)fetchCities:(NSString *)name {
    dispatch_group_enter(self.group);
    
    NSDictionary *headers = @{ @"x-rapidapi-host": @"wft-geo-db.p.rapidapi.com",
        @"x-rapidapi-key": RAPIDAPIKEY};
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"https://wft-geo-db.p.rapidapi.com/v1/geo/cities?namePrefix=%@", name]]
        cachePolicy:NSURLRequestUseProtocolCachePolicy
        timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *data = responseDictionary[@"data"];
            NSMutableArray *currentSearch = [[NSMutableArray alloc] init];
            for (NSDictionary *city in data) {
                NSString *cityString = [NSString stringWithFormat:@"%@, %@", city[@"city"], city[@"country"]];
                [currentSearch addObject:cityString];
            }
            self.citiesSearched = currentSearch;
            NSLog(@"%@", self.citiesSearched);
            dispatch_group_leave(self.group);
        }
    }];
    [dataTask resume];
}

@end
