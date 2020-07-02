//
//  SearchhViewController.m
//  twitter
//
//  Created by Xurxo Riesco on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "SearchhViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "APIManager.h"

@interface SearchhViewController ()  <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweets;


@end

@implementation SearchhViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate.self;
    self.searchBar.text = self.toSearch;
    if(self.searchBar.text.length > 0){
        [self getTimeline];
    }
    // Do any additional setup after loading the view.
}
-(void)searchBar:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Tweet *tweet = self.tweets[indexPath.row];
    TweetCell *tweetCell = [ tableView dequeueReusableCellWithIdentifier:@"TweetCell" ];
    [tweetCell loadTweet:tweet];
    tweetCell.delegate = self;
    return tweetCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.toSearch = searchBar.text;
    [self getTimeline];
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if(searchText !=0){
        self.toSearch = searchText;
        [self getTimeline];
        
    }
    else{
        self.toSearch = @"25";
        [self getTimeline];
        
    }
        [self.tableView reloadData];
        
    
}
- (void) getTimeline{
    [[APIManager shared] searchTimelineWithCompletion:self.toSearch completion:^(NSArray *tweets, NSError *error) {
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

@end
