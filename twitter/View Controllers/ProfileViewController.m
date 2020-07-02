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
#import "JGProgressHUD.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)UIVisualEffectView *blurEffectView;


@end

@implementation ProfileViewController
- (void)viewDidAppear:(BOOL)animated {
    self.getUser = 0;
    UITapGestureRecognizer *swipeGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeGestureRecognizer.numberOfTapsRequired = 1;
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:swipeGestureRecognizer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *swipeGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeGestureRecognizer.numberOfTapsRequired = 1;
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:swipeGestureRecognizer];
    //UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    //[self.imageView setUserInteractionEnabled:YES];
    //[self.imageView addGestureRecognizer:swipeGestureRecognizer];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    if(self.getUser == 0){
        [[APIManager shared] getCurrentUser:^(User *user, NSError *error) {
            if (user) {
                self.user = user;
                [self loadUser];
                [self getTimeline];
            }
        }];
        self.getUser = 0;
    }else{
        [self getTimeline];
        [self loadUser];
    }
    
    
}
- (void) loadUser{
    self.nameLabel.text = self.user.name;
    [self.imageView setImageWithURL:self.user.backgroundUrl];
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
    
}
- (void) getTimeline{
    NSLog(@"%@", self.user.userId);
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
#pragma mark - Navigationx

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
    NSLog(@"DID SWIPEEE");
    [UIView animateWithDuration:0.8 animations:^{
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.blurEffectView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height - 75);
        self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.imageView addSubview:self.blurEffectView];
        self.blurEffectView.alpha = 0.9;
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width + 30, self.imageView.frame.size.height+ 30);
        }];
    [UIView animateWithDuration:4 animations:^{
          self.blurEffectView.alpha = 0.0;
          }];
    [self getTimeline];
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"Loading more Tweets";
    [HUD showInView:self.view];
    [HUD dismissAfterDelay:1.0];
    
}

@end
