//
//  ComposeViewController.h
//  twitter
//
//  Created by Xurxo Riesco on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"


@protocol ComposeViewControllerDelegate
- (void) didTweet: (Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (nonatomic) BOOL isResponse;
@property (nonatomic,strong) Tweet *tweet;


@end
