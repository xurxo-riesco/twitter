//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey = @"UmCpxNcdHD0vkPP7mT4Ke7zGr";// Enter your consumer key here
static NSString * const consumerSecret = @"MqrN7xiB2bBRPqs5nhbM4vv78gOkdzGy13p7f81dEPOhFPt8wS"; // Enter your consumer secret here
@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}
- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    /*
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
       
       // Manually cache the tweets. If the request fails, restore from cache if possible.
       NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
       [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"hometimeline_tweets"];
       completion(tweetDictionaries, nil);
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       NSArray *tweetDictionaries = nil;
       
       // Fetch tweets from cache if possible
       NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
       if (data != nil) {
           tweetDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:data];
       }
       
       completion(tweetDictionaries, error);
   }];
     */
     [self GET:@"1.1/statuses/home_timeline.json"
         parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
             // Success
             NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
             completion(tweets, nil);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             // There was a problem
             completion(nil, error);
         }];
}
- (void)getMentionsTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
     [self GET:@"1.1/statuses/mentions_timeline.json"
         parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
             // Success
             NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
             completion(tweets, nil);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             // There was a problem
             completion(nil, error);
         }];
}
- (void)moreHomeTimelineWithCompletion:(NSString *)max_id completion:(void (^)(NSArray *tweets, NSError *))completion {
     NSDictionary *parameters = @{@"max_id": max_id};
     [self GET:@"1.1/statuses/home_timeline.json"
         parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
             // Success
             NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
             completion(tweets, nil);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             // There was a problem
             completion(nil, error);
         }];
}
- (void)getUserTimelineWithCompletion:(NSString *)user_id completion:(void (^)(NSArray *tweets, NSError *))completion {
     NSDictionary *parameters = @{@"user_id": user_id};
     [self GET:@"1.1/statuses/user_timeline.json"
         parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
             // Success
             NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
             completion(tweets, nil);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             // There was a problem
             completion(nil, error);
         }];
}
- (void)searchTimelineWithCompletion:(NSString *)q completion:(void (^)(NSArray *tweets, NSError *))completion {
     NSDictionary *parameters = @{@"q": q};
     [self GET:@"1.1/search/tweets.json"
         parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionaries) {
             // Success
         NSArray *tweetArray =tweetDictionaries[@"statuses"];
             NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetArray];
             completion(tweets, nil);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             // There was a problem
             completion(nil, error);
         }];
}
- (void)getCurrentUser:(void (^)(User *user, NSError *))completion {
     [self GET:@"1.1/account/verify_credentials.json"
         parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable userDict) {
             // Success
             User *user  = [User userWithArray:userDict];
         NSLog(@"USERS: %@", user);
             completion(user, nil);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             // There was a problem
             completion(nil, error);
         }];
}
- (void)getUser:(NSString*) screename completion:(void (^)(User *user, NSError *))completion {
    NSDictionary *parameters = @{@"screen_name": screename};
    [self GET:@"1.1/users/show.json"
         parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable userDict) {
             // Success
             User *user  = [User userWithArray:userDict];
         NSLog(@"USERS: %@", user);
        NSLog(@"USERS: %@", userDict);
             completion(user, nil);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             // There was a problem
             completion(nil, error);
         }];
}
- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)replyStatusWithText:(NSString *)text toID: (NSString*)reply_id completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text,@"in_reply_to_status_id": reply_id };
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{

    NSString *urlString = @"1.1/favorites/create.json";
    NSLog(@"Tweet: %@", tweet.text);
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    
    NSString *urlString = @"1.1/favorites/destroy.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}


- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    
    NSString *urlString = @"1.1/statuses/retweet.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    //NSDictionary *parameters =[NSDictionary dictionaryWithObjectsAndKeys: tweet.idStr,@"id",nil];
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}


- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    
    NSString *urlString = @"1.1/statuses/unretweet.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

@end
