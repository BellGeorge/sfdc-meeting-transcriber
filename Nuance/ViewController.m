//
//  ViewController.m
//  Nuance
//
//  Created by Elena on 26.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

static NSString *const remoteAccessConsumerKey = @"3MVG99OxTyEMCQ3hGEVHOuhM_VsGwgv5XlCUIm01sK0LP2LSE934imQ8Zf2SQjtoaQSvSbhH8a.eiv8wPySUM";
static NSString *const OAuthRedirectURI = @"https://login.salesforce.com/services/oauth2/success";
static NSString *const OAuthLoginDomain = @"login.salesforce.com";

@interface ViewController ()

@end

@implementation ViewController
@synthesize coordinator = _coordinator;

- (void)viewDidLoad
{
    [super viewDidLoad];
	_appManager = [AppManager sharedManager];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)loginButtonClicked:(id)sender {
    [self login];
}

NSString * const kLoginHostUserDefault = @"login_host_pref";

- (NSString*)oauthLoginDomain {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	NSString *loginHost = [defs objectForKey:kLoginHostUserDefault];
    
    return loginHost;
}

- (NSString*)userAccountIdentifier {
    //OAuth credentials can have an identifier associated with them,
    //such as an account identifier.  For this app we only support one
    //"account" but you could provide your own means (eg NSUserDefaults) of 
    //storing which account the user last accessed, and using that here
    return @"Default";
}

-(void)login {
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    NSString *loginDomain = [self oauthLoginDomain];
    NSString *accountIdentifier = [self userAccountIdentifier];
    
    NSString *fullKeychainIdentifier = [NSString stringWithFormat:@"%@-%@-%@",appName,accountIdentifier,loginDomain];
    SFOAuthCredentials *credentials = [[SFOAuthCredentials alloc] initWithIdentifier:fullKeychainIdentifier clientId:remoteAccessConsumerKey encrypted:NO];
    credentials.domain = OAuthLoginDomain;
    credentials.redirectUri = OAuthRedirectURI;
    self.coordinator = [[SFOAuthCoordinator alloc] initWithCredentials:credentials];
    self.coordinator.delegate = self;
    [self.coordinator authenticate];
}


-(void)relogin {
    [self.coordinator revokeAuthentication];
    [self.coordinator authenticate];
}

#pragma mark - SFOAuthCoordinatorDelegate

- (void)oauthCoordinator:(SFOAuthCoordinator *)coordinator willBeginAuthenticationWithView:(UIWebView *)view {
    NSLog(@"oauthCoordinator:willBeginAuthenticationWithView");
}



- (void)oauthCoordinator:(SFOAuthCoordinator *)coordinator didBeginAuthenticationWithView:(UIWebView *)view {
    NSLog(@"oauthCoordinator:didBeginAuthenticationWithView");
    
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [view setFrame:self.view.bounds];
    [self.view addSubview:view];
}

- (void)oauthCoordinatorDidAuthenticate:(SFOAuthCoordinator *)coordinator {
    NSLog(@"oauthCoordinatorDidAuthenticate");
    [[SFRestAPI sharedInstance] setCoordinator:self.coordinator];
    [self performSegueWithIdentifier:@"accountsScreen" sender:self];
}

- (void)oauthCoordinator:(SFOAuthCoordinator *)coordinator didFailWithError:(NSError *)error {
    NSLog(@"oauthCoordinator:didFailWithError: %@", error);
    [coordinator.view removeFromSuperview];
    
    if(error.code == 672 ) {
        [self relogin];
    } if(error.code == 667 && authenticate == YES) {
        
    }else {
        // show alert and retry
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Salesforce Error" 
                                                        message:[NSString stringWithFormat:@"Can't connect to salesforce: %@", error]
                                                       delegate:self
                                              cancelButtonTitle:@"Retry"
                                              otherButtonTitles: nil];
        [alert show];	
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    authenticate = NO;
    [self login];
}



@end
