//
//  AccountViewController.m
//  Nuance
//
//  Created by Elena on 26.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountViewController.h"
#import "ContactsListViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController
@synthesize accountName;
@synthesize numberContactsLabel;

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
    self.title = accountName;
    _appManager = [AppManager sharedManager];
}

-(void)viewWillAppear:(BOOL)animated{
    numberContactsLabel.text = [NSString stringWithFormat:@"%i contacts",[_appManager.selectedContacts count]];
}

- (void)viewDidUnload
{
    [self setNumberContactsLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)selectContacts:(id)sender {
    [self performSegueWithIdentifier:@"contactsScreen" sender:self];
}

- (IBAction)start:(id)sender {
}

#pragma mark - Segue support
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"contactsScreen"]) {
        ContactsListViewController *contacts = (ContactsListViewController*)segue.destinationViewController;
        contacts.account = accountName;
        
    }
}
@end
