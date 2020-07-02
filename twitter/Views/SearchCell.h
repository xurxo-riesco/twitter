//
//  TweetCell.h
//  twitter
//
//  Created by Xurxo Riesco on 6/28/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "ResponsiveLabel.h"


NS_ASSUME_NONNULL_BEGIN

@interface SearchCell : UITableViewCell
@property (strong, nonatomic) Tweet* tweet;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *responsesLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *favoritesLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;
- (void)loadTweet:(Tweet *) tweet;
@end


NS_ASSUME_NONNULL_END
