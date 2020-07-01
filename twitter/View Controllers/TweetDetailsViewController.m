//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by Xurxo Riesco on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "ComposeViewController.h"
#import <ResponsiveLabel.h>

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIImageView *mediaView;

@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setupAttributedLabel];
    
    self.usernameLabel.text = [[self.tweet user] name];
    self.screennameLabel.text = [NSString stringWithFormat:@"@%@", [[self.tweet user] screenName] ];
    self.tweetLabel.text = [self.tweet text];
    self.tweetLabel.userInteractionEnabled = YES;
    PatternTapResponder hashTagTapAction = ^(NSString *tappedString) {
    NSLog(@"HashTag Tapped = %@",tappedString);
    };
    [self.tweetLabel enableHashTagDetectionWithAttributes:
    @{NSForegroundColorAttributeName:[UIColor blueColor], RLTapResponderAttributeName:hashTagTapAction}];
    PatternTapResponder userHandleTapAction = ^(NSString *tappedString){
    NSLog(@"Username Handler Tapped = %@",tappedString);
    };
    [self.tweetLabel enableUserHandleDetectionWithAttributes:
    @{NSForegroundColorAttributeName:[UIColor blueColor],RLTapResponderAttributeName:userHandleTapAction}];
    PatternTapResponder urlTapAction = ^(NSString *tappedString) {
    NSLog(@"URL Tapped = %@",tappedString);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tappedString]];
    };
    [self.tweetLabel enableURLDetectionWithAttributes:@{NSForegroundColorAttributeName:[UIColor cyanColor],NSUnderlineStyleAttributeName:[NSNumber
    numberWithInt:1],RLTapResponderAttributeName:urlTapAction}];
    
    NSURL *url = [[self.tweet user] profileImageUrl];
    NSString *urlString = url.absoluteString;
    NSLog(@"%@", urlString);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.profileView setImageWithURLRequest:request
                            placeholderImage:nil
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileView.image = image;
    }
                                     failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
    }];
    NSURL *mediaUrl = [self.tweet mediaURL];
    NSString *mediaUrlString = url.absoluteString;
    NSLog(@"%@", mediaUrlString);
    NSURLRequest *mediaRequest = [NSURLRequest requestWithURL:mediaUrl];
    [self.mediaView setImageWithURLRequest:mediaRequest
                            placeholderImage:nil
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.mediaView.image = image;
    }
                                     failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
    }];
    if(self.tweet.retweeted)
    {
        self.retweetButton.selected = YES;
    }
    if(self.tweet.favorited)
    {
        self.favoriteButton.selected = YES;
    }
    // Do any additional setup after loading the view.
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
    }


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ComposeViewController *composeViewController = [segue destinationViewController];
    composeViewController.isResponse = true;
    composeViewController.tweet = self.tweet;
}

@end
