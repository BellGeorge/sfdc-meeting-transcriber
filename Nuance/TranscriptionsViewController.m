//
//  TranscriptionsViewController.m
//  Nuance
//
//  Created by Elena on 13.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TranscriptionsViewController.h"
#import "NSDictionary+JSON.h"
#import "DetailsAndTranscriptViewController.h"

@interface TranscriptionsViewController ()

@end

@implementation TranscriptionsViewController
@synthesize transcriptionsTable;
@synthesize searchBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appManager = [AppManager sharedManager];
    transcriptionsArray = [[NSMutableArray alloc] init];
    searchArray = [[NSMutableArray alloc] init];
    currentTranscriptionsArray = transcriptionsArray;
    NSString * refreshQuery = [NSString stringWithFormat:@"select date__c, duration__c, text__c from Transcription__c where Account__c = '%@'",_appManager.accountId];
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:refreshQuery];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

#pragma mark - SFDC Request methods
- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    
    NSDictionary *dict = (NSDictionary *)jsonResponse;
    NSLog(@"Request: %@ | %@", request.path, request.queryParams);
    NSLog(@"Query: %@", [request.queryParams objectForKey:@"q"]);
    NSLog(@"Response: %@", dict);
    NSMutableArray *firstResult = [NSMutableArray arrayWithArray:[dict arrayForKey:@"records"]];
    if (firstResult && firstResult.count > 0) {
        transcriptionsArray = firstResult;
        currentTranscriptionsArray = transcriptionsArray;
        [transcriptionsTable reloadData];

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


- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setTranscriptionsTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return currentTranscriptionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
    cell.textLabel.text = [[currentTranscriptionsArray objectAtIndex:indexPath.row] safeStringForKey:@"text__c"];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchBar resignFirstResponder];
    selectRec = [currentTranscriptionsArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"detailsScreen" sender:self];
}

#pragma mark - Segue support
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"detailsScreen"]) {
        DetailsAndTranscriptViewController *datvc = (DetailsAndTranscriptViewController*)segue.destinationViewController;
        datvc.record = selectRec;
        datvc.newRec = NO;
    }
}

#pragma mark - Search
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchB
{
	[searchB resignFirstResponder];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {

}

- (void)searchBarTextDidEndEditing:(UISearchBar *)theSearchBar {

}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)text {
    searchText = text;

    if ([searchText length] > 0) {
        [searchArray removeAllObjects];
        for (int i=0; i<[transcriptionsArray count]; i++) {
            NSDictionary * transcript = [transcriptionsArray objectAtIndex:i];
            NSLog(@"Dict: %@",transcript);
            if([[[transcript objectForKey:@"text__c"] lowercaseString] rangeOfString: [searchText lowercaseString]].location != NSNotFound) {
                [searchArray addObject:transcript];
            }
        }
            NSLog(@"Search: %@", searchArray);
        currentTranscriptionsArray = searchArray;
        [transcriptionsTable reloadData];
    }
    
}

@end
