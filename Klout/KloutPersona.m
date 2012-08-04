//
//  KloutPersona.m
//  Klout
//
//  Created by Maximilian Gabriel on 8/1/12.
//  Copyright (c) 2012 Maximilian Gabriel. All rights reserved.
//

#import "KloutPersona.h"

@implementation KloutPersona

@synthesize kloutID = _kloutID;
@synthesize twitterName = _twitterName;
@synthesize score = _score;
@synthesize dayChange =_dayChange;
@synthesize monthChange = _monthChange;
@synthesize weekChange = _weekChange;
@synthesize topics = _topics;
@synthesize influencees = _influencees;
@synthesize nick = _nick;


- (void)updateScoresWithData:(NSData *)data
{
    NSDictionary *scoreDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    self.score = [scoreDict objectForKey:@"score"];
    
    NSDictionary *scoreDelta = [scoreDict objectForKey:@"scoreDelta"];
    self.dayChange = [scoreDelta objectForKey:@"dayChange"];
    self.monthChange = [scoreDelta objectForKey:@"monthChange"];
    self.weekChange = [scoreDelta objectForKey:@"weekChange"];
}

- (void)updateTopicsWithArray:(NSArray *)array
{
    NSMutableArray *personaTopics = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in array) {
        [personaTopics addObject:[KloutTopic kloutTopicWithDictionary:dictionary]];
    }
    
    self.topics = [NSArray arrayWithArray:personaTopics];
    
}


#warning sometimes the 'nicks' are junk, need to see if there is a consistent way to tell. might be a ~ as first char?

- (void)updateInfluenceesWithDictionary:(NSDictionary *)dictionary
{
    NSArray *myInfluencees = [dictionary objectForKey:@"myInfluencees"];
    
    NSMutableArray *personaInfluencees = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in myInfluencees) {
        
        NSDictionary *entity = [dictionary objectForKey:@"entity"];

        KloutPersona *persona = [[KloutPersona alloc] init];
        persona.kloutID = [entity objectForKey:@"id"];
        
        NSDictionary *payload = [entity objectForKey:@"payload"];
        persona.nick = [payload objectForKey:@"nick"];
        persona.score =  [[payload objectForKey:@"score"] objectForKey:@"score"];
        
        [personaInfluencees addObject:persona];
    }
    self.influencees = [NSArray arrayWithArray:personaInfluencees];
}

@end
