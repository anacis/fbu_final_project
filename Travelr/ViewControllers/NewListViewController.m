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
@property (weak, nonatomic) IBOutlet UIImageView *listImage;
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
    self.places = [[NSMutableArray alloc] init];
    self.timesSpent = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

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

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
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

- (IBAction)saveList:(id)sender {
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
    NSLog(@"%@", self.timesSpent);
    
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

- (void)searchPlaceController:(SearchPlaceController *)controller didPickLocationWithDictionary:(NSDictionary *)dict {
    [Place createPlaceFromDictionary:dict placeList:self.places];
    [self.timesSpent addObject:@0];
    NSLog(@"%@", self.timesSpent);
    [self.navigationController popToViewController:self animated:YES];
}

- (IBAction)cancel:(id)sender {
    [self performSegueWithIdentifier:@"newListToFeed" sender:nil];
}

- (void)newPlaceCell:(NewPlaceCell *)newPlaceCell didSpecifyTimeSpent:(nonnull NSNumber *)time {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:newPlaceCell];
    self.timesSpent[indexPath.row] = time;
}

@end
