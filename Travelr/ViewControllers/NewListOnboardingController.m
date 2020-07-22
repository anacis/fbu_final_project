//
//  NewListOnboardingController.m
//  Travelr
//
//  Created by Ana Cismaru on 7/22/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "NewListOnboardingController.h"

@interface NewListOnboardingController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

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
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = pageNumber;
   
}

- (void)setUpPage:(int) index {
    CGRect frame = CGRectMake(0, 0, 0, 0);
    frame.origin.x = self.scrollView.frame.size.width * index;
    frame.size = self.scrollView.frame.size;
    UIView *slide = [[[NSBundle mainBundle]
                      loadNibNamed:[NSString stringWithFormat:@"NewListSlide%d", index+1]
                      owner:self options:nil] objectAtIndex:0];
    slide.frame = frame;
    [self.scrollView addSubview:slide];
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
