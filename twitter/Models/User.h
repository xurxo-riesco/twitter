//
//  User.h
//  twitter
//
//  Created by Xurxo Riesco on 6/28/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

//Properties
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSString *userId;
@property(strong, nonatomic) NSURL *profileImageUrl;
@property(nonatomic) int followersCount;
@property(nonatomic) int tweetCount;
@property(nonatomic) int followingCount;


//Methods
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (User *)userWithArray:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
