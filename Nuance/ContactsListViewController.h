//
//  ContactsListViewController.h
//  Nuance
//
//  Created by Elena on 26.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"
#import "AppManager.h"

@interface ContactsListViewController : UIViewController <SFRestDelegate, UITableViewDataSource, UITabBarDelegate> {
    NSMutableArray * selectedContacts;
    NSMutableArray * checkContacts;
    AppManager *_appManager;
}
@property (weak, nonatomic) IBOutlet UITableView *contactsTable;
@property (nonatomic, retain) NSString* account;

- (IBAction)doneClicked:(id)sender;
@end
