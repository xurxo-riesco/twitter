//
//  UserStats.h
//  twitter
//
//  Created by Xurxo Riesco on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserStats : NSObject {
    NSMutableDictionary *userStats;
}
@property (nonatomic, retain) NSMutableDictionary *userStats;

+ (UserStats*)sharedStats;
@end

NS_ASSUME_NONNULL_END
