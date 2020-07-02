//
//  SlideOutViewController.m
//  twitter
//
//  Created by Xurxo Riesco on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "SlideOutViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface SlideOutViewController ()
@property (strong, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UIImageView *userView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;


@end

@implementation SlideOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[APIManager shared] getCurrentUser:^(User *user, NSError *error) {
        if (user) {
            self.currentUser = user;
            [self.userView setImageWithURL:self.currentUser.profileImageUrl];
            self.userView.layer.cornerRadius = 35;
            self.userView.layer.masksToBounds = YES;
            self.userLabel.text = self.currentUser.name;
            self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.currentUser.screenName];
        }
    }];
}

- (IBAction)logOut:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier  isEqual: @"profileSegueSlide"]){
            ProfileViewController *profileViewController = [segue destinationViewController];
    }else{}
    // Pass the selected object to the new view controller.
}
*/

@end
