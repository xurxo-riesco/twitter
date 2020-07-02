//
//  StatsViewController.m
//  twitter
//
//  Created by Xurxo Riesco on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "StatsViewController.h"
#import "UserStats.h"
#import "User.h"
#import "APIManager.h"
#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"


@interface StatsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *user1Tweets;
@property (weak, nonatomic) IBOutlet UILabel *user1Label;
@property (weak, nonatomic) IBOutlet UILabel *user2Tweets;
@property (weak, nonatomic) IBOutlet UILabel *user3Tweets;
@property (weak, nonatomic) IBOutlet UILabel *user3Label;
@property (weak, nonatomic) IBOutlet UILabel *user2Label;
@property (weak, nonatomic) IBOutlet UIImageView *user1View;
@property (weak, nonatomic) IBOutlet UIImageView *user2View;
@property (weak, nonatomic) IBOutlet UIImageView *user3View;
@property (strong, nonatomic) User *user1;
@property (strong, nonatomic) User *user2;
@property (strong, nonatomic) User *user3;
@property (strong, nonatomic) User *user;

@end

@implementation StatsViewController

- (void)viewDidLoad {
    
    self.user1View.userInteractionEnabled = YES;
    self.user2View.userInteractionEnabled = YES;
    self.user3View.userInteractionEnabled = YES;

    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture1:)];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture2:)];
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture3:)];

    tapGesture1.numberOfTapsRequired = 1;
    tapGesture2.numberOfTapsRequired = 1;
    tapGesture3.numberOfTapsRequired = 1;
    
    [tapGesture2 setDelegate:self];
    [tapGesture1 setDelegate:self];
    [tapGesture3 setDelegate:self];

    [self.user1View addGestureRecognizer:tapGesture1];
    [self.user2View addGestureRecognizer:tapGesture2];
    [self.user3View addGestureRecognizer:tapGesture3];
    
    [super viewDidLoad];
    NSDictionary *someDictionary =[UserStats sharedStats].userStats;
    NSArray *keysT = [someDictionary allKeys];
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    NSArray *sortedKeystmp = [keysT sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [someDictionary objectForKey:a];
        NSString *second = [someDictionary objectForKey:b];
        return [first compare:second];
    }];
    NSArray* sortedKeys = [[sortedKeystmp reverseObjectEnumerator] allObjects];
    NSLog(@"SHORTED as Follow%@",sortedKeys);
    NSLog(@"TOP as Follow%@",sortedKeys[0]);
    NSArray* values=[[UserStats sharedStats].userStats allValues];
    NSArray* sortedValues = [values sortedArrayUsingDescriptors:@[highestToLowest]];
    self.user1Label.text = sortedKeys[0];
    self.user2Label.text = sortedKeys[1];
    self.user3Label.text = sortedKeys[2];
    self.user1Tweets.text = [NSString stringWithFormat:@"%@", sortedValues[0]];
    self.user2Tweets.text = [NSString stringWithFormat:@"%@", sortedValues[1]];
    self.user3Tweets.text = [NSString stringWithFormat:@"%@", sortedValues[2]];
    [[APIManager shared] getUser:sortedKeys[0] completion:^(User *user, NSError *error){
    if (user) {
        self.user1 = user;
        NSURL *url = self.user1.profileImageUrl;
        NSString *urlString = url.absoluteString;
        NSLog(@"%@", urlString);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.user1View setImageWithURLRequest:request
                                placeholderImage:nil
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            self.user1View.image = image;
            self.user1View.layer.cornerRadius = 50;
            self.user1View.layer.masksToBounds = YES;
            
        }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
        }];
        
    }
    }];
    [[APIManager shared] getUser:sortedKeys[1] completion:^(User *user, NSError *error){
    if (user) {
        self.user2 = user;
        NSURL *url = self.user2.profileImageUrl;
        NSString *urlString = url.absoluteString;
        NSLog(@"%@", urlString);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.user2View setImageWithURLRequest:request
                                placeholderImage:nil
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            self.user2View.image = image;
            self.user2View.layer.cornerRadius = 50;
            self.user2View.layer.masksToBounds = YES;
        }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
        }];
        
    }
    }];
    [[APIManager shared] getUser:sortedKeys[2] completion:^(User *user, NSError *error){
    if (user) {
        self.user3 = user;
        NSURL *url = self.user3.profileImageUrl;
        NSString *urlString = url.absoluteString;
        NSLog(@"%@", urlString);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.user3View setImageWithURLRequest:request
                                placeholderImage:nil
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            self.user3View.image = image;
            self.user3View.layer.cornerRadius = 50;
            self.user3View.layer.masksToBounds = YES;
        }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
        }];
    }
    }];
}

- (void)tapGesture1: (id)sender{
    self.user = self.user1;
    [self performSegueWithIdentifier:@"toProfileVC" sender:nil];
    
}

- (void)tapGesture2: (id)sender{
    self.user = self.user2;
    [self performSegueWithIdentifier:@"toProfileVC" sender:nil];
    
}

- (void)tapGesture3: (id)sender {
    self.user = self.user3;
    [self performSegueWithIdentifier:@"toProfileVC" sender:nil];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ProfileViewController *profileViewController = [segue destinationViewController];
    profileViewController.user = self.user;
    profileViewController.getUser = 1;
}


@end
