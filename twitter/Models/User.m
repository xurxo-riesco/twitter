//
//  User.m
//  twitter
//
//  Created by Xurxo Riesco on 6/28/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        NSURL *temp = [NSURL URLWithString:dictionary[@"profile_image_url_https"]];
        NSString *qualityUrl = [temp.absoluteString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
        NSURL *newUrl = [NSURL URLWithString:qualityUrl];
        self.profileImageUrl = newUrl;
        self.backgroundUrl = [NSURL URLWithString:dictionary[@"profile_banner_url"]];
        self.followersCount = [dictionary[@"followers_count"] intValue];
        self.followingCount = [dictionary[@"friends_count"] intValue];
        self.tweetCount = [dictionary[@"statuses_count"] intValue];
        self.bio = dictionary[@"description"];
        self.userId = dictionary[@"id_str"];
    }
    return self;
}

+ (User *)userWithArray:(NSDictionary *)dictionary{
    User *user = [[User alloc] initWithDictionary:dictionary];
    return user;
}
@end
