//
//  MeetingLogTableViewController.m
//  Nuance
//
//  Created by Elena on 28.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MeetingLogTableViewController.h"
#import "DetailsAndTranscriptViewController.h"

@interface MeetingLogTableViewController ()

@end

@implementation MeetingLogTableViewController

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

    _appManager = [AppManager sharedManager];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_appManager.records count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
    NSDictionary * rec = [_appManager.records objectAtIndex:indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"Date: %@", [rec objectForKey:@"date__c"]];
    
    int hours, minutes, seconds;
    int time = [[rec objectForKey:@"duration__c"] intValue];
    hours = time / 3600;
    minutes = (time % 3600) / 60;
    seconds = (time %3600) % 60;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Duration: %02d:%02d:%02d", hours, minutes, seconds];
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectRec = [_appManager.records objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"detailsScreen" sender:self];
}

#pragma mark - Segue support
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"detailsScreen"]) {
        DetailsAndTranscriptViewController *datvc = (DetailsAndTranscriptViewController*)segue.destinationViewController;
        datvc.record = selectRec;
        datvc.newRec = YES;
    }
}

@end
