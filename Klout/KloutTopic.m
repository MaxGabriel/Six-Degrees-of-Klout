//
//  KloutTopic.m
//  Klout
//
//  Created by Maximilian Gabriel on 8/1/12.
//  Copyright (c) 2012 Maximilian Gabriel. All rights reserved.
//

#import "KloutTopic.h"

@implementation KloutTopic

@synthesize displayName = _displayName;
@synthesize ID = _ID;
@synthesize imageUrl = _imageUrl;
@synthesize name = _name;
@synthesize slug = _slug;


+ (KloutTopic *)kloutTopicWithDictionary:(NSDictionary *)dictionary
{
    KloutTopic *topic = [[KloutTopic alloc] init];
    
    topic.displayName = [dictionary objectForKey:@"displayName"];
    topic.ID = [dictionary objectForKey:@"id"];
    topic.imageUrl = [dictionary objectForKey:@"imageUrl"];
    topic.name = [dictionary objectForKey:@"name"];
    topic.slug = [dictionary objectForKey:@"slug"];
    
    return topic;
}

@end
