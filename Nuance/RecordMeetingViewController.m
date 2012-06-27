//
//  RecordMeetingViewController.m
//  Nuance
//
//  Created by Elena on 27.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecordMeetingViewController.h"
#import "NSDictionary+JSON.h"

const unsigned char SpeechKitApplicationKey[] = {0x4f, 0xd6, 0xf2, 0xc5, 0x30, 0x42, 0xf1, 0x9d, 0x94, 0xf, 0xd6, 0xdb, 0x34, 0xeb, 0xd6, 0x4c, 0xa1, 0xa2, 0xcc, 0x5d, 0x2b, 0x7e, 0x56, 0x3d, 0x72, 0xaa, 0xc0, 0xe, 0x7a, 0x58, 0x1b, 0xc9, 0x2e, 0xd, 0x8e, 0x5e, 0x4f, 0x80, 0xfb, 0xe4, 0x8f, 0xd2, 0xbf, 0xc3, 0xbd, 0x95, 0xf, 0x5f, 0x37, 0xdc, 0xbc, 0x62, 0x5a, 0x12, 0x9f, 0xcc, 0xbc, 0x5f, 0xda, 0x36, 0xb7, 0xf5, 0x0, 0xe5};

@interface RecordMeetingViewController ()

@end

@implementation RecordMeetingViewController
@synthesize timeLabel;
@synthesize contactsTable;

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
	// Do any additional setup after loading the view.
    _appManager = [AppManager sharedManager];
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];
    time = 0;
}

-(void) updateCountdown {
    int hours, minutes, seconds;
    
    time++;
    hours = time / 3600;
    minutes = (time % 3600) / 60;
    seconds = (time %3600) % 60;
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
} 

- (void)viewWillDisappear:(BOOL)animated {
    [timer invalidate];
    timer = nil;
}

- (void)viewDidUnload
{
    [self setTimeLabel:nil];
    [self setContactsTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)endButtonClicked:(id)sender {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Attendees";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _appManager.selectedContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
    cell.textLabel.text = [[_appManager.selectedContacts objectAtIndex:indexPath.row] safeStringForKey:@"Name"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
