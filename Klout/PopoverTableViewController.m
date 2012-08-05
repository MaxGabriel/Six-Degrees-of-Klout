//
//  PopoverTableViewController.m
//  Klout
//
//  Created by Maximilian Gabriel on 8/1/12.
//  Copyright (c) 2012 Maximilian Gabriel. All rights reserved.
//

#import "PopoverTableViewController.h"
#import "KloutTopic.h"
#import "ImageMapping.h"

@interface PopoverTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSOperationQueue *queue;


@end

@implementation PopoverTableViewController


@synthesize queue = _queue;
@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    _queue = [[NSOperationQueue alloc] init];
    
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
    static NSString *CellIdentifier = @"Topic Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    // Ok, the if statement wasn't in the default impementation, but I needed it. I think its just in iOS 6 that its unncessary.
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Topic Cell"];
    }
    
    
    
    KloutTopic *topic = [_dataSource objectAtIndex:indexPath.row];
    
    cell.textLabel.text = topic.displayName;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    // Storing images in a shared cache will reduce battery usage and speed up Table View Display.
    // There are so few images that tableView didEndDisplayingCell isn't necessary for performance (atleast in my testing, but I'm on wifi). The cache visibly helps here.
    UIImage *image = [[[ImageMapping sharedInstance] topicImageCache] objectForKey:[NSString stringWithFormat:@"%@",topic.imageUrl]];
    
    if (image) {
        cell.imageView.image = image;
    } else {
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:topic.imageUrl]];
            UIImage *topicImage = [UIImage imageWithData:imageData];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [cell.imageView setImage:topicImage];
                
                if (topicImage) {
                    [[[ImageMapping sharedInstance] topicImageCache] setObject:topicImage forKey:topic.imageUrl];
                }
                
            }];
        }];
        
        [_queue addOperation:blockOperation];
        
    }
    // Can set placeholder image here. The ideal placeholder is Klout's placeholder image, which doens't always seem to appear.

    
    
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}



@end
