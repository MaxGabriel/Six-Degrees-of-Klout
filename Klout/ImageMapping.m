//
//  ImageMapping.m
//  Klout
//
//  Created by Maximilian Gabriel on 8/3/12.
//  Copyright (c) 2012 Maximilian Gabriel. All rights reserved.
//

#import "ImageMapping.h"

@implementation ImageMapping

@synthesize topicImageCache = _topicImageCache;

static ImageMapping *instance = nil;

+ (ImageMapping *)sharedInstance
{
    
    
    if (!instance) {
        instance = [[ImageMapping alloc] init];
        instance.topicImageCache = [[NSCache alloc] init];
    }
    
    return instance;
}

@end
