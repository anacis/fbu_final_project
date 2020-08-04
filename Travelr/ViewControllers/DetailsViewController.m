//
//  DetailsViewController.m
//  Travelr
//
//  Created by Ana Cismaru on 7/28/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "DetailsViewController.h"
#import "APIConstants.h"
#import "SuggestionCollectionCell.h"
#import <MBProgressHUD.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "DetailView.h"
#import "PickerViewController.h"
@import Parse;
@import GoogleMaps;

@interface DetailsViewController () <UIScrollViewDelegate, UINavigationControllerDelegate, DetailViewDelegate, PickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) UIView *currentView;
@property (strong, nonatomic) NSMutableArray *suggestions;
@property (strong, nonatomic) NSArray *flattenedPlacesSorted;
@property (strong, nonatomic) dispatch_group_t group;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.flattenedPlacesSorted = [self.placeList.placesSorted valueForKeyPath: @"@unionOfArrays.self"];
    
    self.pageControl.numberOfPages = self.flattenedPlacesSorted.count;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.pageControl.numberOfPages, self.scrollView.frame.size.height);
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:self.pageControl.numberOfPages constant:0];
    [self.view addConstraint:width];
    
    for (int i = 0; i < self.pageControl.numberOfPages; i++) {
        [self setUpPage:i];
    }
    
    self.scrollView.delegate = self;
    NSUInteger index = [self.flattenedPlacesSorted indexOfObject:self.place];
    self.pageControl.currentPage = index;
    [self.scrollView scrollRectToVisible:CGRectMake((self.scrollView.frame.size.width * index), 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
    
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:66.0/255.0f green:179.0/255.0f blue:111.0/255.0f alpha:1.0];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:151.0/255.0f green:195.0/255.0f blue:157.0/255.0f alpha:0.5];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = pageNumber;
    
}

- (void)setUpPage:(int) index {
   
    CGRect frame = CGRectMake(0, 0, 0, 0);
    frame.origin.x = self.scrollView.frame.size.width * index;
    frame.size = self.scrollView.frame.size;
    
    DetailView *detail = [[[NSBundle mainBundle] loadNibNamed:@"DetailView" owner:self options:nil] objectAtIndex:0];
    detail.placeList = self.placeList;
    detail.place = self.flattenedPlacesSorted[index];
    [detail setUpPage];    
    detail.frame = frame;
    detail.delegate = self;
    [self.scrollView addSubview:(UIView *)detail];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        //resort placelist --> no only when segue back!
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.placeList separateIntoDays:[self.placeList sortPlaces]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    [super viewWillDisappear:animated];
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PickerViewController *destination = [segue destinationViewController];
    destination.delegate = self;
    
}


- (void)getTimeSpent:(nonnull dispatch_group_t)timeGroup {
    self.group = timeGroup;
    dispatch_group_enter(self.group);
    [self performSegueWithIdentifier:@"pickerSegue" sender:nil];
}

- (void)time:(NSNumber *)time didSpecifyTimeSpent:(UIView *)view {
    [self.placeList.timesSpent addObject:time];
    self.placeList[@"timesSpent"] = self.placeList.timesSpent;
    self.placeList.placesSorted = nil;
    dispatch_group_leave(self.group);
}


@end
