//
//  ProfileViewController.h
//  twitter
//
//  Created by Xurxo Riesco on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileTweet.h"
#import "User.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (nonatomic, strong) User *user;
@property (nonatomic) BOOL getUser;

@end

NS_ASSUME_NONNULL_END
