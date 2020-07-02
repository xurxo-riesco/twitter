//
//  UserStats.m
//  twitter
//
//  Created by Xurxo Riesco on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "UserStats.h"

@implementation UserStats
@synthesize userStats;

static UserStats *sharedStats = nil;

+(UserStats*)sharedStats {
    if (sharedStats == nil) {
        sharedStats = [[super allocWithZone:NULL] init];
 
    // initialize your variables here
        //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        sharedStats.userStats = [[NSMutableDictionary alloc]initWithCapacity:10];
        //sharedStats.userStats = [[defaults objectForKey:@"stats"] mutableCopy];

    }
    return sharedStats;
}
 
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self)
    {
        if (sharedStats == nil)
        {
            sharedStats = [super allocWithZone:zone];
            return sharedStats;
        }
    }
    return nil;
}
@end
