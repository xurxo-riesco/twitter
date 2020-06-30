//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "ComposeViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "TweetDetailsViewController.h"
#import "ProfileViewController.h"

@interface TimelineViewController () < ComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) User *currentUser;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) BOOL ownProfile;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[APIManager shared] getCurrentUser:^(User *user, NSError *error) {
    if (user) {
        self.currentUser = user;
    }
    }];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self getTimeline];
    
    // Get timeline
    
    
    NSLog(@"%@", self.tweets);
    NSLog(@"TWEETS: %@", self.tweets);
    [self.tableView reloadData];
}
- (IBAction)onProfileTap:(id)sender {
    self.ownProfile = true;
    [self performSegueWithIdentifier:@"profileSegue" sender: sender];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self getTimeline];
    [refreshControl endRefreshing];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height - 20;
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            NSLog(@"More data!");
            [self getMore];
        }
    }
}

- (void) getTimeline{
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            NSLog(@"%@", self.tweets);
            self.tweets = [tweets mutableCopy];
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}
- (void) getMore{
    NSString *lastTweetIdStr = ((Tweet *)[self.tweets lastObject]).idStr;
    long long maxIdToLoad = [lastTweetIdStr longLongValue] - 1;
    [[APIManager shared] moreHomeTimelineWithCompletion: [@(maxIdToLoad) stringValue] completion:^(NSArray *tweets, NSError *error) {
        if (tweets.count > 0) {
            int prevNumTweets = self.tweets.count;
            self.tweets = [self.tweets arrayByAddingObjectsFromArray:tweets];
            NSMutableArray *newIndexPaths = [NSMutableArray array];
            for (int i = prevNumTweets; i < self.tweets.count; i++) {
                [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        self.isMoreDataLoading = false;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier  isEqual: @"toTweetDetailsVC"]){

        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath =[self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.tweets[indexPath.row];
        NSLog(@"%@", tweet);
        UINavigationController *navigationController = [segue destinationViewController];
        TweetDetailsViewController *tweetDetailsViewController = (TweetDetailsViewController*)navigationController.topViewController;
        tweetDetailsViewController.tweet = tweet;
    }
    else if([segue.identifier  isEqual: @"toComposeVC"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }else{
        if(self.ownProfile){
            self.ownProfile = false;
            ProfileViewController *profileViewController = [segue destinationViewController];
            profileViewController.user = self.currentUser;
        }else{
            ProfileViewController *profileViewController = [segue destinationViewController];
            profileViewController.user = self.user;
        }
    }

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
- (void) didTweet:(Tweet *)tweet{
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
    NSLog(@"Here");
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //UITableViewCell *cell = [[UITableViewCell alloc] init];
    //TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    TweetCell *tweetCell = [ tableView dequeueReusableCellWithIdentifier:@"TweetCell" ];
    [tweetCell loadTweet:tweet];
    tweetCell.delegate = self;
    return tweetCell;
    
    /*
     cell.usernameLabel.text = [[tweet user] name];
     cell.accountLabel.text = [NSString stringWithFormat:@"@%@", [[tweet user] screenName] ];
     cell.contentLabel.text = [tweet text];
     NSURL *url = [[tweet user] profileImageUrl];
     NSURLRequest *request = [NSURLRequest requestWithURL:url];
     [cell.profileView setImageWithURLRequest:request
     placeholderImage:nil
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
     cell.profileView.image = image;
     }
     failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
     // do something for the failure condition
     }];
     //TweetCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"TweetViewCell"];
     //[tweetCell loadTweet:tweet];
     
     cell.dateLabel.text = [tweet createdAtString];
     return cell;
     */
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}
- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    self.user = user;
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}



@end
