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
    record = [[NSMutableDictionary alloc] init];
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];
    time = 0;
    
    [SpeechKit setupWithID:@"NMDPTRIAL_Isidorey_kyleroche20110302153959"
                      host:@"sandbox.nmdp.nuancemobility.net"
                      port:443
                    useSSL:NO
                  delegate:nil];
    
	// Set earcons to play
	SKEarcon* earconStart	= [SKEarcon earconWithName:@"earcon_listening.wav"];
	SKEarcon* earconStop	= [SKEarcon earconWithName:@"earcon_done_listening.wav"];
	SKEarcon* earconCancel	= [SKEarcon earconWithName:@"earcon_cancel.wav"];
    [SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
	[SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
	[SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];
    
    
    //start record
    if (transactionState == TS_IDLE) {
        SKEndOfSpeechDetection detectionType;
        NSString* recoType;
        NSString* langType;
        
        transactionState = TS_INITIAL;
        
        detectionType = SKNoEndOfSpeechDetection; /* Dictations tend to be long utterances that may include short pauses. */
        recoType = SKDictationRecognizerType; /* Optimize recognition performance for dictation or message text. */
        langType = @"en_US";
        voiceSearch = [[SKRecognizer alloc] initWithType:recoType
                                               detection:detectionType
                                                language:langType 
                                                delegate:self];
    }
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
    [timer invalidate];
    [voiceSearch stopRecording];
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

#pragma mark SKRecognizerDelegate methods

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording started.");
    transactionState = TS_RECORDING;

}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording finished.");
    transactionState = TS_PROCESSING;

}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    NSLog(@"Got results.");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id 
    
    transactionState = TS_IDLE;
    long numOfResults = [results.results count];
    if (numOfResults > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd, yyyy K:mm:ss a"];
        [record setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"date__c"];
        [record setObject:[results firstResult] forKey:@"text__c"];
        [record setObject:[NSString stringWithFormat:@"%i", time] forKey:@"duration__c"];
        [record setObject:_appManager.accountId forKey:@"Account__c"];
        NSLog(@"Text: %@", record);
        [_appManager.records insertObject:record atIndex:0];
        [self performSegueWithIdentifier:@"meetingLogScreen" sender:self];
    }
    if (results.suggestion) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggestion"
                                                        message:results.suggestion
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];        
        [alert show];
        
    }

	voiceSearch = nil;
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    NSLog(@"Got error.");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id 
    
    transactionState = TS_IDLE;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];        
    [alert show];
    
    if (suggestion) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggestion"
                                                        message:suggestion
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];        
        [alert show];
        
    }
	voiceSearch = nil;
}


@end
