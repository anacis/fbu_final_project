//
//  NewListOnboardingController.m
//  Travelr
//
//  Created by Ana Cismaru on 7/22/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "NewListOnboardingController.h"
#import "NewListSlide1.h"
#import "NewListSlide2.h"
#import "NewListSlide3.h"
#import "CityCell.h"
#import "NewPlaceCell.h"
#import "SearchPlaceCell.h"
#import "APIConstants.h"
#import "PlaceList.h"

@interface NewListOnboardingController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) UITextField *titleField;
@property (weak, nonatomic) UITextView *descriptionField;
@property (weak, nonatomic) UITableView *cityTableView;
@property (weak, nonatomic) UISearchBar *citySearchBar;

@property (weak, nonatomic) UITextField *daysField;
@property (weak, nonatomic) UITextField *hoursField;

@property (weak, nonatomic) UITableView *placeSearchTableView;
@property (weak, nonatomic) UISearchBar *placeSearchBar;
@property (weak, nonatomic) UICollectionView *suggestionsCollectionView;
@property (weak, nonatomic) UITableView *myPlacesTableView;

@property (strong, nonatomic) NSMutableArray *places;
@property (strong, nonatomic) NSMutableArray *timesSpent;
@property (strong, nonatomic) NSArray *citiesSearched;
@property (strong, nonatomic) NSArray *placeSearchResults;
@property (strong, nonatomic) dispatch_group_t group;


@end

@implementation NewListOnboardingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.places = [[NSMutableArray alloc] init];
    self.timesSpent = [[NSMutableArray alloc] init];
    
    int const numberOfPages = 3;
    self.pageControl.numberOfPages = numberOfPages;
    
    for (int i = 0; i < numberOfPages; i++) {
        [self setUpPage:i];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.pageControl.numberOfPages, self.scrollView.frame.size.height);
    self.scrollView.delegate = self;
    
    self.cityTableView.delegate = self;
    self.cityTableView.dataSource = self;
    //[self.cityTableView registerClass:CityCell.self forCellReuseIdentifier:@"CityCell"];
    self.citySearchBar.delegate = self;
    self.group = dispatch_group_create();
    
    self.myPlacesTableView.delegate = self;
    self.myPlacesTableView.dataSource = self;
    //[self.myPlacesTableView registerClass:NewPlaceCell.self forCellReuseIdentifier:@"NewPlaceCell"];
    self.placeSearchTableView.dataSource = self;
    self.placeSearchTableView.delegate = self;
    //[self.placeSearchTableView registerClass:SearchPlaceCell.self forCellReuseIdentifier:@"SearchPlaceCell"];
    self.placeSearchBar.delegate = self;
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.placeSearchTableView reloadData];
    [self.cityTableView reloadData];
    [self.myPlacesTableView reloadData];
}

- (void)onTimer {
    [self.placeSearchTableView reloadData];
    [self.cityTableView reloadData];
    [self.myPlacesTableView reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = pageNumber;
   
}

- (void)setUpPage:(int) index {
    CGRect frame = CGRectMake(0, 0, 0, 0);
    frame.origin.x = self.scrollView.frame.size.width * index;
    frame.size = self.scrollView.frame.size;
    UIView *slideView;
    if (index == 0) {
        NewListSlide1 *slide = [[[NSBundle mainBundle]
        loadNibNamed:@"NewListSlide1"
        owner:self options:nil] objectAtIndex:0];
        self.titleField = slide.titleField;
        self.descriptionField = slide.descriptionField;
        self.cityTableView = slide.cityTableView;
        self.citySearchBar = slide.citySearchBar;
        slideView = (UIView *)slide;
    } else if (index == 1) {
        NewListSlide2 *slide = [[[NSBundle mainBundle] loadNibNamed:@"NewListSlide2" owner:self options:nil] objectAtIndex:0];
        self.daysField = slide.numDaysField;
        self.hoursField = slide.numHoursField;
        slideView = (UIView *)slide;
    } else if (index == 2) {
        NewListSlide3 *slide = [[[NSBundle mainBundle] loadNibNamed:@"NewListSlide3" owner:self options:nil] objectAtIndex:0];
        self.placeSearchTableView = slide.placesSearchTableView;
        self.placeSearchBar = slide.placeSearchBar;
        self.suggestionsCollectionView =  slide.suggestionsCollectionView;
        self.myPlacesTableView = slide.myPlacesTableView;
        slideView = (UIView *)slide;
    }
    slideView.frame = frame;
    [self.scrollView addSubview:slideView];
}

- (IBAction)cancel:(id)sender {
     [self performSegueWithIdentifier:@"newListToFeed" sender:nil];
}

- (IBAction)saveList:(id)sender {
    PlaceList *list = [PlaceList new];
    list.name = self.titleField.text;
    list[@"description"] = self.descriptionField.text;
    list.author = [PFUser currentUser];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    list.numDays = [formatter numberFromString:self.daysField.text];
    list.numHours = [formatter numberFromString:self.hoursField.text];
    //list.image = [PlaceList getPFFileFromImage:self.listImage.image];
    list.placesUnsorted = self.places;
    list.timesSpent = self.timesSpent;

    [list saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
       if (succeeded) {
           NSLog(@"Saved list successfully!");
           [self performSegueWithIdentifier:@"newListToFeed" sender:nil];
           
       }
       else {
          NSLog(@"Error: %@", error.localizedDescription);
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView == self.cityTableView) {
        CityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
        if (!cell) {
            UINib *nib = [UINib nibWithNibName:@"CityCellView" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"CityCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
        }
        cell.cityNameLabel.text = self.citiesSearched[indexPath.row];
        return cell;
    }
    else if (tableView == self.myPlacesTableView) {
        NewPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewPlaceCell"];
        if (!cell) {
            UINib *nib = [UINib nibWithNibName:@"NewPlaceCellView" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"NewPlaceCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"NewPlaceCell"];
        }
        cell.place = self.places[indexPath.row];
        //cell.delegate = self;
        [cell setUpCell];
        return cell;
    }
    else {
        SearchPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchPlaceCell"];
        if (!cell) {
            UINib *nib = [UINib nibWithNibName:@"SearchPlaceCellView" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"SearchPlaceCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"SearchPlaceCell"];
        }
        NSDictionary *location = self.placeSearchResults[indexPath.row];
        [cell updateWithLocation:location];
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.cityTableView) {
        return self.citiesSearched.count;
    }
    else if (tableView == self.myPlacesTableView) {
        return self.places.count;
    }
    else {
        return self.placeSearchResults.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.placeSearchTableView) {
        // This is the selected venue
        NSDictionary *venue = self.placeSearchResults[indexPath.row];
        [Place createPlaceFromDictionary:venue placeList:self.places];
        [self.timesSpent addObject:@0];
        [self.myPlacesTableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.myPlacesTableView) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.myPlacesTableView) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [self.places removeObjectAtIndex:indexPath.row];
            [self.timesSpent removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar == self.citySearchBar) {
        [self fetchCities:searchBar.text];
        //TODO: create animation that makes the table view appear and disappear
        //TODO: ask jeff about weird asynchness going on
        dispatch_group_wait(self.group, 3);
        [self.cityTableView reloadData];
    }
    else if (searchBar == self.placeSearchBar) {
        [self fetchLocationsWithQuery:searchBar.text near:@"Lausanne"];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (searchBar == self.citySearchBar) {
        [self fetchCities:searchBar.text];
        //TODO: create animation that makes the table view appear and disappear
        //TODO: ask jeff about weird asynchness going on
        dispatch_group_wait(self.group, 3);
        [self.cityTableView reloadData];
    }
    else if (searchBar == self.placeSearchBar) {
        NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
        //TODO: find a way to specify the near parameter
        [self fetchLocationsWithQuery:newText near:@"Lausanne"];
        return true;
    }
    return false;
}


- (void)newPlaceCell:(NewPlaceCell *)newPlaceCell didSpecifyTimeSpent:(nonnull NSNumber *)time {
    NSIndexPath *indexPath = [self.myPlacesTableView indexPathForCell:newPlaceCell];
    self.timesSpent[indexPath.row] = time;
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

- (void)fetchLocationsWithQuery:(NSString *)query near:(NSString *)city {
    NSString *baseURLString = @"https://api.foursquare.com/v2/venues/search?";
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&near=%@&query=%@", FOURSQUAREID, FOURSQUARESECRET, city, query]; //TODO: change this call to remove the near
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.placeSearchResults = [responseDictionary valueForKeyPath:@"response.venues"];
            [self.placeSearchTableView reloadData];
        }
    }];
    [task resume];
}

@end
