//
//  InfluenceesTableViewController.m
//  Klout
//
//  Created by Maximilian Gabriel on 8/2/12.
//  Copyright (c) 2012 Maximilian Gabriel. All rights reserved.
//

#import "InfluenceesTableViewController.h"

@interface InfluenceesTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation InfluenceesTableViewController

@synthesize dataSource = _dataSource;
@synthesize tableView = _tableView;
@synthesize delegate = _delegate;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentSizeForViewInPopover = CGSizeMake(300, 300);
    
    
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _tableView.delegate = self;
}

// Don't implement as of WWDC
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Persona Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    // Ok, the if statement wasn't in the default impementation, but I needed it. I think its just in iOS 6 that its unncessary.
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Topic Cell"];
    }
    
    
    KloutPersona *persona = [_dataSource objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text = persona.nick;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    KloutPersona *persona = [_dataSource objectAtIndex:indexPath.row];
    [self.delegate kloutPersonaSelected:persona];
    
}

@end
