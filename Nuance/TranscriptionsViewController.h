//
//  TranscriptionsViewController.h
//  Nuance
//
//  Created by Elena on 13.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"
#import "AppManager.h"

@interface TranscriptionsViewController : UITableViewController <SFRestDelegate> {
    AppManager *_appManager;
    NSMutableArray * transcriptionsArray;
    NSDictionary * selectRec;
}

@property (weak, nonatomic) IBOutlet UITableView *transcriptionsTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end
