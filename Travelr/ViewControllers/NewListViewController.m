//
//  NewListViewController.m
//  Travelr
//
//  Created by Ana Cismaru on 7/13/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "NewListViewController.h"
@import Parse;
#import "NewPlaceCell.h"
#import "PlaceList.h"
#import "SearchPlaceController.h"

@interface NewListViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SearchPlaceControllerDelegate, NewPlaceCellDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *daysField;
@property (weak, nonatomic) IBOutlet UITextField *hoursField;
@property (weak, nonatomic) IBOutlet PFImageView *listImage;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *places;
@property (strong, nonatomic) NSMutableArray *timesSpent;

@end

@implementation NewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (self.placeList != nil) {
        NSLog(@"We are editing a list!");
        self.places = self.placeList.placesUnsorted;
        self.timesSpent = self.placeList.timesSpent;
        self.titleField.text = self.placeList.name;
        self.daysField.text = [self.placeList.numDays stringValue];
        self.hoursField.text = [self.placeList.numHours stringValue];
        self.descriptionField.text = self.placeList[@"description"];
        self.listImage.file = self.placeList.image;
        self.listImage.layer.cornerRadius = self.listImage.frame.size.height / 2; //formula to create a circular image
        [self.listImage loadInBackground];
        [self.tableView reloadData];
    }
    else {
        self.places = [[NSMutableArray alloc] init];
        self.timesSpent = [[NSMutableArray alloc] init];
    }
}

//DONE
- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

//NOT NEEDED
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"searchSegue"]) {
        SearchPlaceController *searchPlaceView = [segue destinationViewController];
        searchPlaceView.delegate = self;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NewPlaceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NewPlaceCell"];
    cell.place = self.places[indexPath.row];
    cell.delegate = self;
    [cell setUpCell];
    return cell;
}

//DONE
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//DONE
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.places removeObjectAtIndex:indexPath.row];
        [self.timesSpent removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

//DONE
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

//NOT SURE IF I WANT
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];

    // Image editing
    UIImage *resizedImage = [self resizeImage:originalImage withSize:CGSizeMake(300, 300)];
    
    self.listImage.image = resizedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

//NOT SURE IF I WANT
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

//NOT SURE IF I WANT
- (IBAction)onTapImage:(id)sender {
    NSLog(@"Tapping on image!");
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

//NEED TO IMPLEMENT EDITING
- (IBAction)saveList:(id)sender {
    if (self.placeList == nil) {
        PlaceList *list = [PlaceList new];
        list.name = self.titleField.text;
        list[@"description"] = self.descriptionField.text;
        list.author = [PFUser currentUser];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        list.numDays = [formatter numberFromString:self.daysField.text];
        list.numHours = [formatter numberFromString:self.hoursField.text];
        list.image = [PlaceList getPFFileFromImage:self.listImage.image];
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
    else {
        self.placeList.name = self.titleField.text;
        self.placeList[@"description"] = self.descriptionField.text;
        self.placeList.author = [PFUser currentUser];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        self.placeList.numDays = [formatter numberFromString:self.daysField.text];
        self.placeList.numHours = [formatter numberFromString:self.hoursField.text];
        self.placeList.image = [PlaceList getPFFileFromImage:self.listImage.image];
        self.placeList.placesUnsorted = self.places;
        self.placeList.timesSpent = self.timesSpent;
        [self.placeList saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Saved list successfully!");
                [self performSegueWithIdentifier:@"newListToFeed" sender:nil];
                
            }
            else {
               NSLog(@"Error: %@", error.localizedDescription);
            }
        }];
    }
    
}

//DONE --> added into selectrowatindexpath
- (void)searchPlaceController:(SearchPlaceController *)controller didPickLocationWithDictionary:(NSDictionary *)dict {
    //[Place createPlaceFromDictionary:dict placeList:self.places];
    [self.timesSpent addObject:@0];
    [self.navigationController popToViewController:self animated:YES];
}

//DONE
- (IBAction)cancel:(id)sender {
    [self performSegueWithIdentifier:@"newListToFeed" sender:nil];
}

//DONE
- (void)newPlaceCell:(NewPlaceCell *)newPlaceCell didSpecifyTimeSpent:(nonnull NSNumber *)time {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:newPlaceCell];
    self.timesSpent[indexPath.row] = time;
}


//DONE
- (void)fetchCities {
    NSDictionary *headers = @{ @"x-rapidapi-host": @"wft-geo-db.p.rapidapi.com",
                               @"x-rapidapi-key": @"47f9918e89msh529c6a696c3b15fp198bc0jsnfdfa59e36cf0" };

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://wft-geo-db.p.rapidapi.com/v1/geo/cities?namePrefix=paris"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    //TODO: get user to input city name and change namePrefix!
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@", responseDictionary);
        }
    }];
    [dataTask resume];
}

@end
