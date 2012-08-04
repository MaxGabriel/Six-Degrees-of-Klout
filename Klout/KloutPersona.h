//
//  KloutPersona.h
//  Klout
//
//  Created by Maximilian Gabriel on 8/1/12.
//  Copyright (c) 2012 Maximilian Gabriel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KloutInfo.h"
#import "KloutTopic.h"

// Model for a Klout user.

// I use an Objective-C class to avoid 'Stringly typed' objectForKey:@"random mispeled name" methods.

@interface KloutPersona : NSObject


// Maybe a 'display name' property because the nick is unreliable. 

@property (nonatomic, strong) NSString *kloutID;
@property (nonatomic, strong) NSString *twitterName;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSNumber *dayChange;
@property (nonatomic, strong) NSNumber *monthChange;
@property (nonatomic, strong) NSNumber *weekChange;
@property (nonatomic, strong) NSArray *topics;
@property (nonatomic, strong) NSString *nick;

@property (nonatomic, strong) NSArray *influencees;



- (void)updateScoresWithData:(NSData *)data;

- (void)updateTopicsWithArray:(NSArray *)array;

- (void)updateInfluenceesWithDictionary:(NSDictionary *)dictionary;

@end
