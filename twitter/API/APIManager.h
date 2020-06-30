//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h"

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;
- (void)moreHomeTimelineWithCompletion:(NSString *)max_id completion:(void (^)(NSArray *tweets, NSError *))completion;
- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion;
- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;
- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;
- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;
- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;
- (void)replyStatusWithText:(NSString *)text toID: (NSString*)reply_id completion:(void (^)(Tweet *, NSError *))completion;
- (void)getUserTimelineWithCompletion:(NSString *)user_id completion:(void (^)(NSArray *tweets, NSError *))completion;
- (void)getCurrentUser:(void (^)(User *user, NSError *))completion;
@end
