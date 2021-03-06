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
#import "PickerViewController.h"
@import GLCalendarView;
@import Parse;

@interface NewListOnboardingController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NewPlaceCellDelegate, GLCalendarViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, PickerViewDelegate, UITextViewDelegate>

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
@property (weak, nonatomic) UILabel *suggestionsLabel;
@property (weak, nonatomic) UIButton *selectStartButton;

@property (strong, nonatomic) NSMutableArray *places;
@property (strong, nonatomic) NSMutableArray *timesSpent;
@property (strong, nonatomic) NSArray *placeSearchResults;
@property (strong, nonatomic) NSMutableArray *suggestions;
@property (strong, nonatomic) NSMutableArray *allSuggestions;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

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
    
    self.descriptionField.delegate = self;
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
    
    if (self.placeList != nil) {
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
         self.descriptionField.text = @"Write your description here!";
         self.descriptionField.textColor = UIColor.opaqueSeparatorColor;
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
        
        NSDate *today = [[NSDate alloc] init];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setYear:1];
        NSDate *nextYear = [calendar dateByAddingComponents:offsetComponents toDate:today options:0];
        self.calendarView.firstDate = today;
        self.calendarView.lastDate = nextYear;
        
        NSPredicate *heightPredicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", NSLayoutAttributeHeight];
        self.calendarHeight = [self.calendarView.constraints filteredArrayUsingPredicate:heightPredicate][0];
        self.customDayButton = slide.customDayButton;
        UITapGestureRecognizer *tapButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCustomDay:)];
        [self.customDayButton addGestureRecognizer:tapButton];
        [slide setUpGestureRecognizer];
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
        self.suggestionsLabel = slide.suggestionsLabel;
        
        self.selectStartButton = slide.selectStartButton;
        UITapGestureRecognizer *tapButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelectStart:)];
        [self.selectStartButton addGestureRecognizer:tapButton];
       
        
        self.placeSearchTableView.alpha = 0;
        self.placeSearchBar.alpha = 0;
        self.suggestionsCollectionView.alpha = 0;
        self.suggestionsLabel.alpha = 0;
        
        [slide setUpGestureRecognizer];
        
        slideView = (UIView *)slide;
    }
    
    slideView.frame = frame;
    [self.scrollView addSubview:slideView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"pickerSegue"]) {
        PickerViewController *destination = [segue destinationViewController];
        destination.tabBarHeight = self.tabBarController.tabBar.frame.size.height;
        destination.modalPresentationStyle = UIModalPresentationCustom;
        destination.cell = sender;
        destination.delegate = self;
    }
}

- (IBAction)cancel:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SceneDelegate *scene = (SceneDelegate *) self.view.window.windowScene.delegate;
    scene.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"Tabbar"];
}

- (IBAction)saveList:(id)sender {
    PlaceList *list;
    //new list or clone of list
    if (self.placeList == nil || self.placeList.author != [PFUser currentUser]) {
        list = [PlaceList new];
        list.author = [PFUser currentUser];
        [[PFUser currentUser] incrementKey:@"numLists"];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
          if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
          }
        }];
    }
    else {
        list = self.placeList;
        self.placeList.placesSorted = nil;
    }
    list.name = self.titleField.text;
    list[@"description"] = self.descriptionField.text;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    if (self.customDayButton.selected == YES) {
        list.numDays = [formatter numberFromString:self.daysField.text];
    }
    else {
        list.numDays = @([GLDateUtils daysBetween:self.calendarRange.beginDate and:self.calendarRange.endDate] + 1);
        list.startDate = self.calendarRange.beginDate;
    }
    list.numHours = [formatter numberFromString:self.hoursField.text];
    list.image = [PlaceList getPFFileFromImage:self.listImage.image];
    list.placesUnsorted = self.places;
    list.timesSpent = self.timesSpent;
    
    if (self.selectedIndexPath != nil) {
        list[@"start"] = self.places[self.selectedIndexPath.row];
    }

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
        if (indexPath == self.selectedIndexPath) {
            if (cell.accessoryType == UITableViewCellAccessoryNone) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                self.selectedIndexPath = nil;
            }
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        [cell setUpCell];
        //TODO: check if we are editing a list and if so, make the button text equal to the timeSpent value
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
    } else if (tableView == self.myPlacesTableView) {
        if ([self.selectStartButton isSelected]) {
            self.selectedIndexPath = indexPath;
            NSLog(@"Selected INdex Path: %@", self.selectedIndexPath);
            [tableView reloadData];
        }
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
            if (self.selectedIndexPath == indexPath) {
                self.selectedIndexPath = nil;
            }
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
        [self.suggestions removeObjectAtIndex:indexPath.item];
        if (self.allSuggestions.count > 0) {
            [self.suggestions addObject:self.allSuggestions[0]];
            [self.allSuggestions removeObjectAtIndex:0];
        }        
        [self.suggestionsCollectionView reloadData];
        [self.myPlacesTableView reloadData];
       });
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar == self.placeSearchBar) {
        NSString *city = self.cityField.text;
        [self fetchLocationsWithQuery:searchBar.text near:city];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if (searchBar == self.placeSearchBar) {
        [self animateOpenTableView];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar == self.placeSearchBar) {
        if ([searchText isEqualToString:@""]) {
            [self animateCloseTableView];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (searchBar == self.placeSearchBar) {
        [self.placeSearchBar endEditing:YES];
        [self animateCloseTableView];
    }
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
    if (textField == self.cityField) {
        if ([textField.text isEqualToString:@""]) {
            [self animateSearchDisAppear];
        }
        else {
            [self fetchSuggestionsWithCity:textField.text];
            [self animateSearchAppear];
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView == self.descriptionField) {
        textView.text = @"";
        textView.textColor = UIColor.blackColor;
    }
}

- (void)getTimeSpent:(NewPlaceCell *)newPlaceCell {
    [self performSegueWithIdentifier:@"pickerSegue" sender:newPlaceCell];
}

- (void)time:(NSNumber *)time didSpecifyTimeSpent:(UIView *)view {
    NewPlaceCell *newPlaceCell = (NewPlaceCell *) view;
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

- (void)animateSearchAppear {
    [UIView animateWithDuration:0 animations:^{
        self.placeSearchBar.alpha = 1;
        self.suggestionsCollectionView.alpha = 1;
        self.placeSearchTableView.alpha = 1;
        self.suggestionsLabel.alpha = 1;
    }];
}

- (void)animateSearchDisAppear {
    [UIView animateWithDuration:0 animations:^{
        self.placeSearchBar.alpha = 0;
        self.suggestionsCollectionView.alpha = 0;
        self.placeSearchTableView.alpha = 0;
        self.suggestionsLabel.alpha = 0;
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
    NSString *queryString = [NSString stringWithFormat:SEARCHQUERY, FOURSQUAREID, FOURSQUARESECRET, city, query];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[BASEURLSEARCH stringByAppendingString:queryString]];
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
    NSString *queryString = [NSString stringWithFormat:EXPLOREQUERY, FOURSQUAREID, FOURSQUARESECRET, city];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[BASEURLEXPLORE stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSDictionary *group = [responseDictionary valueForKeyPath:@"response.groups"][0];
            self.allSuggestions = [NSMutableArray arrayWithArray:group[@"items"]];
            NSUInteger index = MIN(self.allSuggestions.count, 10);
            self.suggestions = [NSMutableArray arrayWithArray:[self.allSuggestions subarrayWithRange:NSMakeRange(0, index)]];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, index)];
            [self.allSuggestions removeObjectsAtIndexes:indexSet];
            
            
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
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [alertController dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }];
    }];
    UIAlertAction *cameraRoll = [UIAlertAction actionWithTitle:@"Use Camera Roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [alertController dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }];
    }];
    
    [alertController addAction:camera];
    [alertController addAction:cameraRoll];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}

- (void)tapCustomDay:(UITapGestureRecognizer *)recognizer {
    if (self.customDayButton.selected == NO) {
        [self.customDayButton setSelected:YES];
        [self animateCloseCalendar];
     }
     else {
        [self.customDayButton setSelected:NO];
        [self animateOpenCalendar];
     }
}

- (void)tapSelectStart:(UITapGestureRecognizer *)recognizer {
    if (self.selectStartButton.selected == NO) {
        NSLog(@"Selected Button");
        [self.selectStartButton setSelected:YES];
        [self.selectStartButton setTitle:@"Done" forState:UIControlStateSelected];
        self.selectStartButton.backgroundColor = [UIColor whiteColor];
        [self.selectStartButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateSelected];
     }
     else {
        NSLog(@"UnSelected Button");
        [self.selectStartButton setSelected:NO];
        [self.selectStartButton setTitle:@"Select Starting Point" forState:UIControlStateNormal];
        self.selectStartButton.backgroundColor = [UIColor systemBlueColor];
        [self.selectStartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
