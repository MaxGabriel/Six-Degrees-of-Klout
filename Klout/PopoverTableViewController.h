//
//  PopoverTableViewController.h
//  Klout
//
//  Created by Maximilian Gabriel on 8/1/12.
//  Copyright (c) 2012 Maximilian Gabriel. All rights reserved.
//

// A TableViewController that lists the Klout users interests (topics).

// This should really be named "TopicsTableViewController"

#import <UIKit/UIKit.h>

@interface PopoverTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *dataSource;

@end
