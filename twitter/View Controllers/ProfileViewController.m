//
//  ProfileViewController.m
//  twitter
//
//  Created by Xurxo Riesco on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "ProfileTweet.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    
    // Optionally set the number of required taps, e.g., 2 for a double click
    
    // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.nameLabel.text = self.user.name;
    NSURL *url = self.user.profileImageUrl;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.profileView setImageWithURLRequest:request
                            placeholderImage:nil
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileView.image = image;
    }
                                     failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
    }];
    self.followersLabel.text = [NSString stringWithFormat:@"%d", self.user.followersCount];
    self.tweetsLabel.text = [NSString stringWithFormat:@"%d", self.user.tweetCount];
    self.followingLabel.text = [NSString stringWithFormat:@"%d", self.user.followingCount];
    self.bioLabel.text = self.user.bio;
    
    [[APIManager shared] getUserTimelineWithCompletion:self.user.userId completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            NSLog(@"%@", self.tweets);
            self.tweets = [tweets mutableCopy];
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    [self.tableView reloadData];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Tweet *tweet = self.tweets[indexPath.row];
    ProfileTweet *tweetCell = [ tableView dequeueReusableCellWithIdentifier:@"ProfileCell" ];
    [tweetCell loadTweet:tweet];
    return tweetCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}
- (IBAction)didSwipe:(UISwipeGestureRecognizer *)sender {
    NSLog(@"Swipppiing");
    NSString *urlString = self.user.profileImageUrl.absoluteString;
    NSString *qualityUrl = [urlString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSLog(@"%@", qualityUrl);
    NSURL *newUrl = [NSURL URLWithString:qualityUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:newUrl];
    [self.profileView setImageWithURLRequest:request
                            placeholderImage:nil
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [UIView animateWithDuration:0.2 animations:^{
            self.profileView.image = image;
            self.profileView.frame = CGRectMake(self.profileView.frame.origin.x, self.profileView.frame.origin.y, self.profileView.frame.size.width + 50, self.profileView.frame.size.height + 50);
                                      }];
    }
                                     failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
    }];
    
}

@end
