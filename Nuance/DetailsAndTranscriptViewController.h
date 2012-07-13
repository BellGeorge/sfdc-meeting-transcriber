//
//  DetailsAndTranscriptViewController.h
//  Nuance
//
//  Created by Elena on 28.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "SFRestAPI.h"

@interface DetailsAndTranscriptViewController : UIViewController <SFRestDelegate> {
    AppManager *_appManager;
}
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UITextView *transcriptView;
@property (nonatomic, retain) NSDictionary * record;
@property (nonatomic) BOOL newRec;
@property (weak, nonatomic) IBOutlet UIButton *postButton;

- (IBAction)postButtonClicked:(id)sender;
@end
