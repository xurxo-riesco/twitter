//
//  TweetCell.m
//  twitter
//
//  Created by Xurxo Riesco on 6/28/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapLike:(id)sender {
    self.favoriteButton.selected = !self.favoriteButton.selected;
    if(self.tweet.favorited)
    {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
        
        
    }
    else{
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self refreshData];
}

- (IBAction)didTapRetweet:(id)sender {
    self.retweetButton.selected = !self.retweetButton.selected;
    if(self.tweet.retweeted)
    {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    else{
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self refreshData];
}

- (void) refreshData
{
    self.retweetsLabel.text  =[NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favoritesLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
}

- (void) loadTweet:(Tweet *) tweet {
    self.tweet = tweet;
    if(self.tweet.retweeted)
    {
        self.retweetButton.selected = YES;
    }
    if(self.tweet.favorited)
    {
        self.favoriteButton.selected = YES;
    }
    self.accountLabel.text = [[tweet user] name];
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", [[tweet user] screenName] ];
    self.contentLabel.text = [tweet text];
    NSURL *url = [[tweet user] profileImageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.profileView setImageWithURLRequest:request
                            placeholderImage:nil
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileView.image = image;
    }
                                     failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
    }];
    self.dateLabel.text = [tweet createdAtString];
    self.retweetsLabel.text = [NSString stringWithFormat:@"%d", [tweet retweetCount]];
    self.favoritesLabel.text = [NSString stringWithFormat:@"%d", [tweet favoriteCount]];
    self.responsesLabel.text = [NSString stringWithFormat:@"%d", [tweet replyCount]];
    
    
}

@end
