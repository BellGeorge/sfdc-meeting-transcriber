//
//  AccountsListViewController.h
//  Nuance
//
//  Created by Elena on 26.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"

@interface AccountsListViewController : UIViewController <SFRestDelegate, UITableViewDataSource, UITabBarDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UITableView *accountsTable;

@end
