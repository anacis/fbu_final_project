//
//  LoginViewController.m
//  Travelr
//
//  Created by Ana Cismaru on 7/13/20.
//  Copyright © 2020 anacismaru. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <PFFacebookUtils.h>
#import "SceneDelegate.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FBSDKLoginButton *fbLoginButton = [[FBSDKLoginButton alloc] init];
    CGRect screen = [[UIScreen mainScreen] bounds];
    fbLoginButton.center = CGPointMake(screen.size.width / 2, self.signUpButton.frame.origin.y + 100);
    fbLoginButton.permissions = @[@"public_profile", @"email"];
    UITapGestureRecognizer *facebookTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(facebookLogin:)];
    [fbLoginButton addGestureRecognizer:facebookTap];
    [self.view addSubview:fbLoginButton];
}

- (IBAction)onTapLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    //check all fields are entered
    if ([username isEqual:@""]
        || [password isEqual:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Data"
               message:@"Please enter a username and password"
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
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (void)facebookLogin:(UITapGestureRecognizer *)recognizer {
    FBSDKLoginButton *button = (FBSDKLoginButton *) recognizer.view;
    [PFFacebookUtils logInInBackgroundWithReadPermissions:button.permissions block:^(PFUser *user, NSError *error) {
      if (!user) {
          NSLog(@"Uh oh. The user cancelled the Facebook login.");
      }
      else if (user.isNew) {
          NSLog(@"User signed up and logged in through Facebook!");
          [self performSegueWithIdentifier:@"loginSegue" sender:nil];
      }
      else {
          NSLog(@"User logged in through Facebook!");
          [self performSegueWithIdentifier:@"loginSegue" sender:nil];
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
          SceneDelegate *scene = self.view.window.windowScene.delegate;
          scene.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"ListFeedNav"];
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

@end
