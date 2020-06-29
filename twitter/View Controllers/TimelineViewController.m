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

@interface TimelineViewController () < ComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self getTimeline];
    [refreshControl endRefreshing];
}
- (void) getTimeline{
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
           if (tweets) {
               NSLog(@"😎😎😎 Successfully loaded home timeline");
               NSLog(@"%@", self.tweets);
               self.tweets = [tweets mutableCopy];
               [self.tableView reloadData];
               /*for (NSDictionary *dictionary in tweets) {
                NSString *text = dictionary[@"text"];
                NSLog(@"%@", text);
                
                }
                */
           } else {
               NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
           }
       }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     UINavigationController *navigationController = [segue destinationViewController];
     ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
     composeController.delegate = self;
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


@end
