//
//  ProfileTweet.m
//  twitter
//
//  Created by Xurxo Riesco on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ProfileTweet.h"
#import "UIImageView+AFNetworking.h"

@implementation ProfileTweet

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    self.usernameLabel.text = [[tweet user] name];
    self.accountLabel.text = [NSString stringWithFormat:@"@%@", [[tweet user] screenName] ];
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
    self.dateLabel.text =[tweet timeAgoString];
    self.retweetsLabel.text = [NSString stringWithFormat:@"%d", [tweet retweetCount]];
    self.favoritesLabel.text = [NSString stringWithFormat:@"%d", [tweet favoriteCount]];
    
    
}

@end
