//
//  InfluenceesTableViewController.h
//  Klout
//
//  Created by Maximilian Gabriel on 8/2/12.
//  Copyright (c) 2012 Maximilian Gabriel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KloutPersona.h"


@protocol InfluenceesTableViewControllerDelegate <NSObject>

- (void)kloutPersonaSelected:(KloutPersona *)persona;

@end

@interface InfluenceesTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) id <InfluenceesTableViewControllerDelegate> delegate;

@end
