//
//  KloutInfoViewController.h
//  Klout
//
//  Created by Maximilian Gabriel on 8/1/12.
//  Copyright (c) 2012 Maximilian Gabriel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KloutPersona.h"
#import "InfluenceesTableViewController.h"

// Class used to display a user's score, name, buttons for influencees/topics.
// This class is reused for each additional user shown. 

@interface KloutInfoViewController : UIViewController <InfluenceesTableViewControllerDelegate>

@property (nonatomic, strong) KloutPersona *persona;
@property (strong, nonatomic) NSArray *scoreArray;

- (IBAction)interestsPressed:(UIButton *)sender;

- (void)kloutPersonaSelected:(KloutPersona *)persona;

@end
