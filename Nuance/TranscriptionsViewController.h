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

@interface TranscriptionsViewController : UITableViewController <SFRestDelegate, UISearchBarDelegate> {
    AppManager *_appManager;
    NSMutableArray * transcriptionsArray;
    NSMutableArray * searchArray;
    NSMutableArray * currentTranscriptionsArray;
    NSDictionary * selectRec;
    NSString * searchText;
}

@property (weak, nonatomic) IBOutlet UITableView *transcriptionsTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end
