//
//  ContactsListViewController.m
//  Nuance
//
//  Created by Elena on 26.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactsListViewController.h"

@interface ContactsListViewController ()

@end

@implementation ContactsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end