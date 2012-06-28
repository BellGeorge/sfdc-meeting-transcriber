//
//  DetailsAndTranscriptViewController.m
//  Nuance
//
//  Created by Elena on 28.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailsAndTranscriptViewController.h"

@interface DetailsAndTranscriptViewController ()

@end

@implementation DetailsAndTranscriptViewController
@synthesize dateLabel;
@synthesize durationLabel;
@synthesize transcriptView;
@synthesize record;

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
    _appManager = [AppManager sharedManager];
	// Do any additional setup after loading the view.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy K:mm:ss a"];
    dateLabel.text = [dateFormatter stringFromDate:[record objectForKey:@"date"]];
    int hours, minutes, seconds;
    int time = [[record objectForKey:@"duration"] intValue];
    hours = time / 3600;
    minutes = (time % 3600) / 60;
    seconds = (time %3600) % 60;
    durationLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    transcriptView.text = [record objectForKey:@"text"];
}

- (void)viewDidUnload
{
    [self setDateLabel:nil];
    [self setDurationLabel:nil];
    [self setTranscriptView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)postButtonClicked:(id)sender {
}


@end
