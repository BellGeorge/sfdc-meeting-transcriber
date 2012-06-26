//
//  ViewController.h
//  Nuance
//
//  Created by Elena on 26.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFOAuthCoordinator.h"
#import "AppManager.h"
#import "SFRestAPI.h"

@interface ViewController : UIViewController <SFOAuthCoordinatorDelegate> {
    AppManager *_appManager;
    BOOL authenticate;
}

@property (nonatomic, retain) SFOAuthCoordinator *coordinator;

- (IBAction)loginButtonClicked:(id)sender;
@end
