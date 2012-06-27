//
//  AccountViewController.h
//  Nuance
//
//  Created by Elena on 26.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"

@interface AccountViewController : UIViewController {
    AppManager *_appManager;
}

@property (nonatomic, retain) NSString * accountName;
@property (weak, nonatomic) IBOutlet UILabel *numberContactsLabel;

- (IBAction)selectContacts:(id)sender;
- (IBAction)start:(id)sender;
@end
