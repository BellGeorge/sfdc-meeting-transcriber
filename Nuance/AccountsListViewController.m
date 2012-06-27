//
//  AccountsListViewController.m
//  Nuance
//
//  Created by Elena on 26.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountsListViewController.h"
#import "AccountViewController.h"
#import "NSDictionary+JSON.h"

@interface AccountsListViewController (){
    BOOL select;
    SFRestRequest *sfRequest;
}
@property (nonatomic, strong) NSString *refreshQuery;
@property (nonatomic, strong) NSMutableArray *companies;
@property (nonatomic, strong) NSString *selectAccount;

@end

@implementation AccountsListViewController
@synthesize accountsTable;
@synthesize refreshQuery;
@synthesize companies;
@synthesize selectAccount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        companies = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _appManager = [AppManager sharedManager];
    self.navigationController.navigationBar.hidden = NO;
    self.refreshQuery = [NSString stringWithFormat:@"select id, name from Account"];
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:self.refreshQuery];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)viewDidUnload
{
    [self setAccountsTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return companies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
    cell.textLabel.text = [[companies objectAtIndex:indexPath.row] safeStringForKey:@"Name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_appManager.selectedContacts removeAllObjects];
    [_appManager.checkedContacts removeAllObjects];
    selectAccount = [[companies objectAtIndex:indexPath.row] safeStringForKey:@"Name"];
    [self performSegueWithIdentifier:@"accountScreen" sender:self];
}

#pragma mark - SFDC Request methods
- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    
    NSDictionary *dict = (NSDictionary *)jsonResponse;
    NSLog(@"Request: %@ | %@", request.path, request.queryParams);
    NSLog(@"Query: %@", [request.queryParams objectForKey:@"q"]);
    NSArray *pathKeys = [request.path componentsSeparatedByString:@"/"];
    NSLog(@"Response: %@", dict);
    
    if ([[pathKeys objectAtIndex:2] isEqualToString:@"query"]) {
        if ([[request.queryParams objectForKey:@"q"] isEqualToString:self.refreshQuery]) {
            if ([[dict valueForKey:@"totalSize"] intValue] > 0) {
                
                NSMutableArray *firstResult = [NSMutableArray arrayWithArray:[dict arrayForKey:@"records"]];
                
                if (firstResult && firstResult.count > 0) {
                    self.companies = firstResult;
                    [accountsTable reloadData];
                    

                }
            }
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

#pragma mark - Segue support
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"accountScreen"]) {
        AccountViewController *acc = (AccountViewController*)segue.destinationViewController;
        acc.accountName = selectAccount;
        
    }
}

@end
