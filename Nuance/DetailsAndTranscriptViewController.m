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
@synthesize newRec;
@synthesize postButton;

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
    dateLabel.text = [record objectForKey:@"date__c"];
    int hours, minutes, seconds;
    int time = [[record objectForKey:@"duration__c"] intValue];
    hours = time / 3600;
    minutes = (time % 3600) / 60;
    seconds = (time %3600) % 60;
    durationLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    transcriptView.text = [record objectForKey:@"text__c"];
}

-(void)viewWillAppear:(BOOL)animated {
    if (newRec) {
        postButton.hidden = NO;
    } else {
        postButton.hidden = YES;
    }
}
- (void)viewDidUnload
{
    [self setDateLabel:nil];
    [self setDurationLabel:nil];
    [self setTranscriptView:nil];
    [self setPostButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)postButtonClicked:(id)sender {
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Transcription__c" fields:record];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

#pragma mark - SFDC Request methods
- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    
    NSDictionary *dict = (NSDictionary *)jsonResponse;
    NSLog(@"Request: %@ | %@", request.path, request.queryParams);
    NSLog(@"Query: %@", [request.queryParams objectForKey:@"q"]);

    NSLog(@"Response: %@", dict);
    
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    // handle error
    NSLog(@"ERROR");
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    // handle error
    NSLog(@"CANCEL");
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    // handle error
    NSLog(@"TIMEOUT");
}



@end
