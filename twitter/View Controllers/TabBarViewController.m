//
//  TabBarViewController.m
//  twitter
//
//  Created by Xurxo Riesco on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TabBarViewController.h"
#import "ProfileViewController.h"
#import "User.h"
#import "APIManager.h"
@interface TabBarViewController ()
@property (nonatomic, strong) User *currentUser;

@end

@implementation TabBarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [[APIManager shared] getCurrentUser:^(User *user, NSError *error) {
    if (user) {
        self.currentUser = user;
    }
    }];
    // Do any additional setup after loading the view.
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"HAPPENING!");
    ProfileViewController *profileViewController = (ProfileViewController *) [tabBarController.viewControllers objectAtIndex:1];
    profileViewController.user = self.currentUser;
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
