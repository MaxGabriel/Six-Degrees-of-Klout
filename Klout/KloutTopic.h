//
//  KloutTopic.h
//  Klout
//
//  Created by Maximilian Gabriel on 8/1/12.
//  Copyright (c) 2012 Maximilian Gabriel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KloutTopic : NSObject

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *slug;

+ (KloutTopic *)kloutTopicWithDictionary:(NSDictionary *)dictionary;

@end
