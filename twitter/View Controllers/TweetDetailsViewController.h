//
//  TweetDetailsViewController.h
//  twitter
//
//  Created by Xurxo Riesco on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetDetailsViewController : UIViewController
@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, strong) User *user;
@end

NS_ASSUME_NONNULL_END
