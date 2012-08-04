//
//  ImageMapping.h
//  Klout
//
//  Created by Maximilian Gabriel on 8/3/12.
//  Copyright (c) 2012 Maximilian Gabriel. All rights reserved.
//


// Singleton class that functions solely as a shared image cache for topic images (e.g. Apple topic -> Apple logo)

#import <Foundation/Foundation.h>

@interface ImageMapping : NSObject

@property (strong, nonatomic) NSCache *topicImageCache;

+ (ImageMapping *)sharedInstance;

@end
