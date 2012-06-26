//
//  ContactsListViewController.m
//  Nuance
//
//  Created by Elena on 26.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactsListViewController.h"
#import "NSDictionary+JSON.h"

@interface ContactsListViewController ()
@property (nonatomic, strong) NSString *refreshQuery;
@property (nonatomic, strong) NSMutableArray *contactList;
@end

@implementation ContactsListViewController
@synthesize contactsTable;
@synthesize  refreshQuery;
@synthesize account;
@synthesize contactList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        contactList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:[NSString stringWithFormat:@"select id, name, lastname, account.id, account.name, phone, email from contact where account.name = '%@'", account]];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)viewDidUnload
{
    [self setContactsTable:nil];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return contactList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
    cell.textLabel.text = [[contactList objectAtIndex:indexPath.row] safeStringForKey:@"Name"];
    return cell;
}

#pragma mark - SFDC Request methods
- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSDictionary *dict = (NSDictionary *)jsonResponse;
    NSLog(@"Request: %@ | %@", request.path, request.queryParams);
    NSLog(@"Query: %@", [request.queryParams objectForKey:@"q"]);
    //NSArray *pathKeys = [request.path componentsSeparatedByString:@"/"];
    NSLog(@"Response: %@", dict);
    
    if ([[dict valueForKey:@"totalSize"] intValue] > 0) {
        
        NSMutableArray *firstResult = [NSMutableArray arrayWithArray:[dict arrayForKey:@"records"]];
        
        if (firstResult && firstResult.count > 0) {
            self.contactList = firstResult;
            [contactsTable reloadData]; 
            
        }
    }

}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    // handle error
    NSLog(@"ERROR");
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    // handle error
    NSLog(@"CANCEL");
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    // handle error
    NSLog(@"TIMEOUT");
}

@end
