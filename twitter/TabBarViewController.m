//
//  TabBarViewController.m
//  twitter
//
//  Created by Xurxo Riesco on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TabBarViewController.h"
#import "User.h"
#import "ProfileViewController.h"
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
        NSLog(@"CURRENT USER: %@", self.currentUser);
    }
    }];

    // Do any additional setup after loading the view.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqual:@"toProfileTab"]){
        ProfileViewController *profileViewController = [segue destinationViewController];
        NSLog(@"SEGUING USER:%@", self.currentUser);
        NSLog(@"SEGUING USER:%@", self.currentUser);
        profileViewController.user = self.currentUser;
    }
}


@end
