//
//  AccountViewController.h
//  Nuance
//
//  Created by Elena on 26.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController {
    
}

@property (nonatomic, retain) NSString * accountName;

- (IBAction)selectContacts:(id)sender;
- (IBAction)start:(id)sender;
@end
