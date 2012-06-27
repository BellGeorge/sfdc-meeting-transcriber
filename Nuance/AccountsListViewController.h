//
//  AccountsListViewController.h
//  Nuance
//
//  Created by Elena on 26.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"
#import "AppManager.h"

@interface AccountsListViewController : UIViewController <SFRestDelegate, UITableViewDataSource, UITabBarDelegate> {
     AppManager *_appManager;
}
@property (weak, nonatomic) IBOutlet UITableView *accountsTable;

@end
