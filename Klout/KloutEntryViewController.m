//
//  KloutEntryViewController.m
//  Klout
//
//  Created by Maximilian Gabriel on 8/1/12.
//  Copyright (c) 2012 Maximilian Gabriel. All rights reserved.
//

#import "KloutEntryViewController.h"
#import "KloutPersona.h"
#import "KloutInfoViewController.h"
#import "KloutInfo.h"

@interface KloutEntryViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation KloutEntryViewController

@synthesize queue = _queue;
@synthesize titleLabel = _titleLabel;
@synthesize twitterUsernameTextField = _twitterUsernameTextField;



#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete_wall.png"]]];
    
    _titleLabel.font = [UIFont fontWithName:@"DINPro-Bold" size:100];
    _titleLabel.textColor = [UIColor whiteColor];
    
    _queue = [[NSOperationQueue alloc] init];
    _twitterUsernameTextField.delegate = self;
	// Do any additional setup after loading the view.
}


// Don't implement as of WWDC

//- (void)viewDidUnload
//{
//    [self setTwitterUsernameTextField:nil];
//
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark Text Field


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSString *twitterName = textField.text;
    
    // Display a spinner, get the Klout ID from the twitter name, get the relevant klout score, push to a new VC. 
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = self.view.center;
    [spinner startAnimating];
    [self.view addSubview:spinner];
    
    // Model for Klout Users. 
    KloutPersona *persona = [[KloutPersona alloc] init];

    persona.twitterName = twitterName;
    
    NSURL *urlWithTwitterName = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.klout.com/v2/identity.json/twitter?screenName=%@&key=%@", twitterName,KLOUT_KEY]];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:urlWithTwitterName] queue:_queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        

        
        if (error) {
            NSLog(@"Error occured.");
        }

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (!dictionary) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                [[[UIAlertView alloc] initWithTitle:@"Invalid Name" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            });
            
            
        } else {
            NSString *kloutID = [dictionary objectForKey:@"id"];
            persona.kloutID = kloutID;
            //        NSLog(@"%@",dictionary);
            //        NSLog(@"%@",[dictionary objectForKey:@"id"]);
            //        http://api.klout.com/v2/user.json/45598950992084523/score
            
            NSURL *urlWithKloutId = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.klout.com/v2/user.json/%@/score?key=%@",kloutID,KLOUT_KEY]];
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:urlWithKloutId] queue:_queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                
                [persona updateScoresWithData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    KloutInfoViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"KloutInfo"];
                    controller.persona = persona;
                    controller.scoreArray = [NSArray arrayWithObject:controller.persona.score];
                    [spinner stopAnimating];
                    [self.navigationController pushViewController:controller animated:YES];
                });
                
                
                
                
            }];
        }
        
    }];
    
    return YES;
}


@end









