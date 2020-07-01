//
//  MentionsViewController.m
//  twitter
//
//  Created by Xurxo Riesco on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "MentionsViewController.h"
#import "TweetCell.h"
#import "APIManager.h"

@interface MentionsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweets;

@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getTimeline];
    // Do any additional setup after loading the view.
}
- (void) getTimeline{
    [[APIManager shared] getMentionsTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
