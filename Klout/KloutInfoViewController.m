//
//  KloutInfoViewController.m
//  Klout
//
//  Created by Maximilian Gabriel on 8/1/12.
//  Copyright (c) 2012 Maximilian Gabriel. All rights reserved.
//

#import "KloutInfoViewController.h"
#import "WEPopoverController.h"
#import "KloutTopic.h"
#import "PopoverTableViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface KloutInfoViewController ()
@property (strong, nonatomic) IBOutlet UILabel *degree;
@property (strong, nonatomic) IBOutlet UIButton *influenceesButton;

@property (strong, nonatomic) IBOutlet UIButton *interestsButton;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UILabel *totalScore;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) WEPopoverController *popoverController;

@end

@implementation KloutInfoViewController

@synthesize popoverController;
@synthesize queue = _queue;

@synthesize username = _username;
@synthesize score = _score;
@synthesize totalScore = _totalScore;

@synthesize persona = _persona;
@synthesize degree = _degree;
@synthesize influenceesButton = _influenceesButton;
@synthesize interestsButton = _interestsButton;
@synthesize scoreArray = _scoreArray;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // BACKGROUND
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete_wall.png"]];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dirty_old_shirt.png"]];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light_noise_diagonal.png"]];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"use_your_illusion.png"]];
    
//    self.view.backgroundColor = [UIColor colorWithRed:1/255.0f green:185/255.0f blue:255/255.0f alpha:1];
    
    if (_persona.twitterName) {
        _username.text = _persona.twitterName;
    } else {
        _username.text = _persona.nick;
    }
    
    // 1, 185, 255
//    _interestsButton.backgroundColor  = [UIColor colorWithRed:1/255.0f green:185/255.0f blue:255/255.0f alpha:1];
    
    _interestsButton.titleLabel.textColor = [UIColor whiteColor];
//    _interestsButton.titleLabel.font = [UIFont fontWithName:@"DINPro-Bold" size:15];
    
    _interestsButton.layer.backgroundColor = [[UIColor colorWithRed:1/255.0f green:185/255.0f blue:255/255.0f alpha:1] CGColor];
    _interestsButton.layer.cornerRadius = 5.0f;
//
    _influenceesButton.layer.backgroundColor = [[UIColor colorWithRed:1/255.0f green:185/255.0f blue:255/255.0f alpha:1] CGColor];
    _influenceesButton.layer.cornerRadius = 5.0f;
    
    _influenceesButton.titleLabel.textColor = [UIColor whiteColor];
    
    _username.textColor = [UIColor whiteColor];
    _username.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:70];
    
    [self.view bringSubviewToFront:_username];
    [self.view bringSubviewToFront:_score];
    [self.view bringSubviewToFront:_degree];
    [self.view bringSubviewToFront:_totalScore];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.roundingMode = NSNumberFormatterRoundCeiling;
    
    
    _score.text = [numberFormatter stringFromNumber:_persona.score];
    _score.font = [UIFont fontWithName:@"DINPro-Bold" size:100];
    _score.textColor = [UIColor whiteColor];

    _degree.font = [UIFont fontWithName:@"DINPro-Bold" size:30];
    _degree.textColor = [UIColor whiteColor];
    
    _degree.text = [[NSString stringWithFormat:@"%i",[_scoreArray count]] stringByAppendingString:@"/6"];
    
    
    int total = 0;
    for (NSNumber *number in _scoreArray) {
        total += ceil([number doubleValue]);
    }
    _totalScore.text = [NSString stringWithFormat: @"Total: %i",total];
    _totalScore.textColor = [UIColor whiteColor];
    _totalScore.font = [UIFont fontWithName:@"DINPro-Bold" size:35];
    
    UILabel *averageScore = [[UILabel alloc] initWithFrame:CGRectMake(_totalScore.frame.origin.x + _totalScore.frame.size.width+5, _totalScore.frame.origin.y+20, 90, 30)];
    
    averageScore.backgroundColor = [UIColor clearColor];
    averageScore.text = [NSString stringWithFormat:@"Avg:%i",total/[_scoreArray count]];
    averageScore.textColor = [UIColor whiteColor];
    averageScore.font = [UIFont fontWithName:@"DINPro-Bold" size:20];
    [self.view addSubview:averageScore];
    [self.view bringSubviewToFront:averageScore];

    
    if ([_scoreArray count] == 6) {
        _degree.textColor = [UIColor blackColor];
    }
    
    _queue = [[NSOperationQueue alloc] init];
}


// Delegate method for when a klout user is selected from the Influencees popover.

- (void)kloutPersonaSelected:(KloutPersona *)persona
{
    [self.popoverController dismissPopoverAnimated:YES];
    
    if ([_scoreArray count] == 6) {
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"You've already gone six degrees!" delegate:nil cancelButtonTitle:@"Cancel"     otherButtonTitles: nil] show];
        
    } else {
        KloutInfoViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"KloutInfo"];
        controller.persona = persona;
        controller.scoreArray = [_scoreArray arrayByAddingObjectsFromArray:[NSArray arrayWithObject:controller.persona.score]];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

// Display Interests, called from InterestsPressed (below)
- (void)displayInterests:(UIButton *)sender
{
    [self.popoverController dismissPopoverAnimated:YES];
    
    self.popoverController = nil;
    
    if ([_persona.topics count] == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Oh dear!" message:[NSString stringWithFormat:@"%@ doesn't have any topics they're interested in", _persona.nick] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] show];
    } else {
        PopoverTableViewController *controller = [[PopoverTableViewController alloc] init];
        
        controller.dataSource = _persona.topics;
        
        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:controller];
        self.popoverController.passthroughViews = [NSArray arrayWithObject:_influenceesButton];
        
        [self.popoverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    
}



- (IBAction)interestsPressed:(UIButton *)sender
{
    
    if (!_persona.topics) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        
        spinner.center = sender.center;
        [self.view addSubview:spinner];
        [self.view bringSubviewToFront:spinner];
        
        [sender setTitle:@"" forState:UIControlStateNormal];
        
        NSURL *urlWithTopics = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.klout.com/v2/user.json/%@/topics?key=%@",_persona.kloutID,KLOUT_KEY]];
        
        
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:urlWithTopics] queue:_queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            
            
            NSArray *topics = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            
            
            [_persona updateTopicsWithArray:topics];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                [sender setTitle:@"Interests" forState:UIControlStateNormal];
                [[sender titleLabel] setTextColor:[UIColor whiteColor]];
                [self displayInterests:sender];
            });
            
            
        }];
    } else {
        [self displayInterests:sender];
    }
    
}

- (void)displayInfluencees:(UIButton *)sender
{
    [self.popoverController dismissPopoverAnimated:YES];
    
    self.popoverController = nil;
    
    if ([_persona.influencees count] == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Oh dear!" message:[NSString stringWithFormat:@"%@ doesn't influence anyone", _persona.nick] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] show];
    } else {
        InfluenceesTableViewController *controller = [[InfluenceesTableViewController alloc] init];
        
        controller.dataSource = _persona.influencees;
        controller.delegate = self;
        
        self.popoverController = [[WEPopoverController alloc] initWithContentViewController:controller];
        self.popoverController.passthroughViews = [NSArray arrayWithObject:_interestsButton];
        [self.popoverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    
    
}

- (IBAction)influenceesPressed:(UIButton *)sender
{
    if (!_persona.influencees) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        spinner.center = sender.center;
        [self.view addSubview:spinner];
        [self.view bringSubviewToFront:spinner];
        
        [sender setTitle:@"" forState:UIControlStateNormal];
        
        NSURL *urlWithInfluencees = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.klout.com/v2/user.json/%@/influence?key=%@",_persona.kloutID,KLOUT_KEY]];
        
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:urlWithInfluencees] queue:_queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            
            
            // There HAS to be a better word that influencees....
            NSDictionary *influenceesAndInfluencers = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];


            [_persona updateInfluenceesWithDictionary:influenceesAndInfluencers];
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                [sender setTitle:@"Influencees" forState:UIControlStateNormal];
                [[sender titleLabel] setTextColor:[UIColor whiteColor]];
                [self displayInfluencees:sender];
            });
            
        }];
        
    } else {
        [self displayInfluencees:sender];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
