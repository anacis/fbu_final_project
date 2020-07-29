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
#import "SuggestionCollectionCell.h"
#import "SceneDelegate.h"
#import <MBProgressHUD.h>
@import GLCalendarView;
@import Parse;

@interface NewListOnboardingController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NewPlaceCellDelegate, GLCalendarViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) UITextField *titleField;
@property (weak, nonatomic) UITextView *descriptionField;
@property (weak, nonatomic) PFImageView *listImage;


@property (weak, nonatomic) UITextField *daysField;
@property (weak, nonatomic) UILabel *numDaysLabel;
@property (weak, nonatomic) UITextField *hoursField;
@property (weak, nonatomic) UIButton *customDayButton;
@property (weak, nonatomic) GLCalendarView *calendarView;
@property (nonatomic, weak) GLCalendarDateRange *calendarRange;
@property (strong, nonatomic) NSLayoutConstraint *calendarHeight;

@property (weak, nonatomic) UITableView *placeSearchTableView;
@property (weak, nonatomic) UISearchBar *placeSearchBar;
@property (weak, nonatomic) UITextField *cityField;
@property (weak, nonatomic) UICollectionView *suggestionsCollectionView;
@property (weak, nonatomic) UITableView *myPlacesTableView;
@property (strong, nonatomic) NSLayoutConstraint *searchTableHeight;

@property (strong, nonatomic) NSMutableArray *places;
@property (strong, nonatomic) NSMutableArray *timesSpent;
@property (strong, nonatomic) NSArray *citiesSearched;
@property (strong, nonatomic) NSArray *placeSearchResults;
@property (strong, nonatomic) NSArray *suggestions;




@end

@implementation NewListOnboardingController

- (void)viewDidLoad {
    [super viewDidLoad];
    int const numberOfPages = 3;
    self.pageControl.numberOfPages = numberOfPages;
    
    for (int i = 0; i < numberOfPages; i++) {
        [self setUpPage:i];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.pageControl.numberOfPages, self.scrollView.frame.size.height);
    self.scrollView.delegate = self;
    
    self.myPlacesTableView.delegate = self;
    self.myPlacesTableView.dataSource = self;
    self.placeSearchTableView.dataSource = self;
    self.placeSearchTableView.delegate = self;
    [self animateCloseTableView];
    self.suggestionsCollectionView.delegate = self;
    self.suggestionsCollectionView.dataSource = self;
    self.placeSearchTableView.allowsSelection = YES;
    self.placeSearchBar.delegate = self;
    
    self.calendarView.delegate = self;
    //TODO: set calendar's first date and last date
    
    if (self.placeList != nil) {
         NSLog(@"We are editing a list!");
         self.places = self.placeList.placesUnsorted;
         self.timesSpent = self.placeList.timesSpent;
         self.titleField.text = self.placeList.name;
         self.daysField.text = [self.placeList.numDays stringValue];
         self.hoursField.text = [self.placeList.numHours stringValue];
         self.descriptionField.text = self.placeList[@"description"];
         self.listImage.file = self.placeList.image;
         [self.listImage loadInBackground];
         [self.myPlacesTableView reloadData];
     }
     else {
         self.places = [[NSMutableArray alloc] init];
         self.timesSpent = [[NSMutableArray alloc] init];
     }
}

- (void)viewDidAppear:(BOOL)animated {
    [self.placeSearchTableView reloadData];
    [self.myPlacesTableView reloadData];
    [self.calendarView reload];
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
        self.listImage = slide.listImage;
        self.listImage.layer.cornerRadius = self.listImage.frame.size.height / 2; //formula to create a circular image
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage:)];
        [self.listImage addGestureRecognizer:tapImage];
        UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        [slide addGestureRecognizer:tap];
        slideView = (UIView *)slide;
    } else if (index == 1) {
        NewListSlide2 *slide = [[[NSBundle mainBundle] loadNibNamed:@"NewListSlide2" owner:self options:nil] objectAtIndex:0];
        self.daysField = slide.numDaysField;
        self.numDaysLabel = slide.numDaysLabel;
        self.numDaysLabel.alpha = 0;
        self.daysField.alpha = 0;
        self.hoursField = slide.numHoursField;
        self.calendarView = slide.calendarView;
        NSPredicate *heightPredicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", NSLayoutAttributeHeight];
        self.calendarHeight = [self.calendarView.constraints filteredArrayUsingPredicate:heightPredicate][0];
        self.customDayButton = slide.customDayButton;
        UITapGestureRecognizer *tapButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCustomDay:)];
        [self.customDayButton addGestureRecognizer:tapButton];
        //UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        //[slide addGestureRecognizer:tap];
        slideView = (UIView *)slide;
    } else if (index == 2) {
        NewListSlide3 *slide = [[[NSBundle mainBundle] loadNibNamed:@"NewListSlide3" owner:self options:nil] objectAtIndex:0];
        self.cityField = slide.cityField;
        [self.cityField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.placeSearchTableView = slide.placesSearchTableView;
        NSPredicate *heightPredicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", NSLayoutAttributeHeight];
        self.searchTableHeight = [self.placeSearchTableView.constraints filteredArrayUsingPredicate:heightPredicate][0];
        self.placeSearchBar = slide.placeSearchBar;
        self.suggestionsCollectionView =  slide.suggestionsCollectionView;
        UINib *nib = [UINib nibWithNibName:@"SuggestionCollectionCell" bundle:nil];
        [self.suggestionsCollectionView registerNib:nib forCellWithReuseIdentifier:@"SuggestionCollectionCell"];
        self.myPlacesTableView = slide.myPlacesTableView;
        slideView = (UIView *)slide;
    }
    
    slideView.frame = frame;
    [self.scrollView addSubview:slideView];
}

- (IBAction)cancel:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SceneDelegate *scene = (SceneDelegate *) self.view.window.windowScene.delegate;
    scene.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"Tabbar"];
}

- (IBAction)saveList:(id)sender {
    PlaceList *list;
    if (self.placeList == nil) {
        list = [PlaceList new];
    }
    else {
        list = self.placeList;
        self.placeList.placesSorted = nil;
    }
    list.name = self.titleField.text;
    list[@"description"] = self.descriptionField.text;
    list.author = [PFUser currentUser];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    if (self.customDayButton.selected == YES) {
        list.numDays = [formatter numberFromString:self.daysField.text];
    }
    else {
        list.numDays = @([GLDateUtils daysBetween:self.calendarRange.beginDate and:self.calendarRange.endDate] + 1);
    }
    list.numHours = [formatter numberFromString:self.hoursField.text];
    list.image = [PlaceList getPFFileFromImage:self.listImage.image];
    list.placesUnsorted = self.places;
    list.timesSpent = self.timesSpent;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [list saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
       if (succeeded) {
           NSLog(@"Saved list successfully!");
           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
           SceneDelegate *scene = (SceneDelegate *) self.view.window.windowScene.delegate;
           scene.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"Tabbar"];
           [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    if (tableView == self.myPlacesTableView) {
        NewPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewPlaceCell"];
        if (!cell) {
            UINib *nib = [UINib nibWithNibName:@"NewPlaceCellView" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"NewPlaceCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"NewPlaceCell"];
        }
        cell.place = self.places[indexPath.row];
        cell.delegate = self;
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
    if (tableView == self.myPlacesTableView) {
        return self.places.count;
    }
    else {
        return self.placeSearchResults.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.placeSearchTableView) {
        dispatch_group_t placeGroup = dispatch_group_create();
        NSDictionary *venue = self.placeSearchResults[indexPath.row];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_group_enter(placeGroup);
        [Place createPlaceFromDictionary:venue placeList:self.places group:placeGroup];
        dispatch_group_notify(placeGroup,dispatch_get_main_queue(),^{
            [self.timesSpent addObject:@0];
            [self.myPlacesTableView reloadData];
            [self animateCloseTableView];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
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

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SuggestionCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SuggestionCollectionCell" forIndexPath:indexPath];
    NSDictionary *suggestion = self.suggestions[indexPath.item][@"venue"];
    [cell updateWithSuggestion:suggestion];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.suggestions.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_group_t placeGroup = dispatch_group_create();
    NSDictionary *venue = self.suggestions[indexPath.item][@"venue"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_group_enter(placeGroup);
    [Place createPlaceFromDictionary:venue placeList:self.places group:placeGroup];
    dispatch_group_notify(placeGroup,dispatch_get_main_queue(),^{
        [self.timesSpent addObject:@0];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.myPlacesTableView reloadData];
       });
    
    //TODO: remove this suggestion and replace it with the next suggestion available
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar == self.placeSearchBar) {
        NSString *city = self.cityField.text;
        [self fetchLocationsWithQuery:searchBar.text near:city];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self animateOpenTableView];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        [self animateCloseTableView];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.placeSearchBar endEditing:YES];
    [self animateCloseTableView];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (searchBar == self.placeSearchBar) {
        if (self.searchTableHeight.constant == 0) {
            [self animateOpenTableView];
        }
        NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
        NSString *city = self.cityField.text;
        [self fetchLocationsWithQuery:newText near:city];
        return true;
    }
    return false;
}

-(void)textFieldDidChange :(UITextField *) textField{
    [self fetchSuggestionsWithCity:textField.text];
}

- (void)newPlaceCell:(NewPlaceCell *)newPlaceCell didSpecifyTimeSpent:(nonnull NSNumber *)time {
    NSIndexPath *indexPath = [self.myPlacesTableView indexPathForCell:newPlaceCell];
    self.timesSpent[indexPath.row] = time;
}

- (void)animateOpenTableView {
    [UIView animateWithDuration:1.2f animations:^{
        self.searchTableHeight.constant = 200;
    }];
}

- (void)animateCloseTableView {
    [UIView animateWithDuration:1.2f animations:^{
        self.searchTableHeight.constant = 0;
    }];
}

- (void)animateOpenCalendar {
    [UIView animateWithDuration:0 animations:^{
        self.calendarHeight.constant = 220;
        self.calendarView.alpha = 1;
        self.numDaysLabel.alpha = 0;
        self.daysField.alpha = 0;
    }];
}

- (void)animateCloseCalendar {
    [UIView animateWithDuration:0 animations:^{
        self.calendarView.alpha = 0;
        self.calendarHeight.constant = 0;
        self.numDaysLabel.alpha = 1;
        self.daysField.alpha = 1;
    }];
}

-(void)dismissKeyboard {
    [self.titleField endEditing:YES];
    [self.cityField endEditing:YES];
    [self.descriptionField endEditing:YES];
    [self.daysField endEditing:YES];
    [self.hoursField endEditing:YES];
}


- (void)fetchLocationsWithQuery:(NSString *)query near:(NSString *)city {
    NSString *baseURLString = @"https://api.foursquare.com/v2/venues/search?";
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&near=%@&query=%@", FOURSQUAREID, FOURSQUARESECRET, city, query];
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

- (void)fetchSuggestionsWithCity:(NSString *)city {
    NSString *baseURLString = @"https://api.foursquare.com/v2/venues/explore?";
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&near=%@", FOURSQUAREID, FOURSQUARESECRET, city];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSDictionary *group = [responseDictionary valueForKeyPath:@"response.groups"][0];
            self.suggestions = [group[@"items"] subarrayWithRange:NSMakeRange(0, MIN(10, [group[@"items"] count]))];
            [self.suggestionsCollectionView reloadData];
        }
    }];
    [task resume];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];

    // Image editing
    UIImage *resizedImage = [self resizeImage:originalImage withSize:CGSizeMake(300, 300)];
    
    self.listImage.image = resizedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)onTapImage:(UITapGestureRecognizer *)recognizer {
    NSLog(@"Tapping on image!");
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    //TODO: ask user which option they wish to use
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)tapCustomDay:(UITapGestureRecognizer *)recognizer {
    if (self.customDayButton.selected == NO) {
        [self.customDayButton setSelected:YES];
        [self animateCloseCalendar];
        NSLog(@"Using custom day input");
     }
     else {
        [self.customDayButton setSelected:NO];
        [self animateOpenCalendar];
        NSLog(@"Using calendar day input");
     }
}

- (BOOL)calenderView:(GLCalendarView *)calendarView canAddRangeWithBeginDate:(NSDate *)beginDate
{
    // you should check whether user can add a range with the given begin date
    if (self.calendarView.ranges.count != 0){
        for (GLCalendarDateRange *range in self.calendarView.ranges) {
            [self.calendarView removeRange:range];
        }
        self.calendarRange = nil;
    }
    return YES;
}

- (GLCalendarDateRange *)calenderView:(GLCalendarView *)calendarView rangeToAddWithBeginDate:(NSDate *)beginDate
{
    NSDate* endDate = [GLDateUtils dateByAddingDays:1 toDate:beginDate];
    GLCalendarDateRange *range = [GLCalendarDateRange rangeWithBeginDate:beginDate endDate:endDate];
    range.backgroundColor = UIColor.blueColor;
    range.editable = YES;
    self.calendarRange = range;
    return range;
}

- (void)calenderView:(GLCalendarView *)calendarView beginToEditRange:(GLCalendarDateRange *)range
{
    NSLog(@"begin to edit range: %@", range);
}

- (void)calenderView:(GLCalendarView *)calendarView finishEditRange:(GLCalendarDateRange *)range continueEditing:(BOOL)continueEditing
{
    NSLog(@"finish edit range: %@", range);
}

- (BOOL)calenderView:(GLCalendarView *)calendarView canUpdateRange:(GLCalendarDateRange *)range toBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    return YES;
}

- (void)calenderView:(GLCalendarView *)calendarView didUpdateRange:(GLCalendarDateRange *)range toBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    NSLog(@"did update range: %@", range);
}


@end
