//
//  RecordMeetingViewController.h
//  Nuance
//
//  Created by Elena on 27.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpeechKit/SpeechKit.h>
#import "AppManager.h"

@interface RecordMeetingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SpeechKitDelegate, SKRecognizerDelegate> {
    
    AppManager *_appManager;
    SKRecognizer* voiceSearch;
    enum {
        TS_IDLE,
        TS_INITIAL,
        TS_RECORDING,
        TS_PROCESSING,
    } transactionState;
    NSTimer *timer;
    int time;
    NSMutableDictionary * record;
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *contactsTable;
- (IBAction)endButtonClicked:(id)sender;
@end
