//
//  AppManager.m
//  Nuance
//
//  Created by Elena on 26.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppManager.h"

@implementation AppManager
@synthesize checkedContacts;
@synthesize selectedContacts;
@synthesize records;
@synthesize accountId;


static AppManager *sharedManager = nil;

+ (id)sharedManager {
    @synchronized(self) {
        if (sharedManager == nil) {
            sharedManager = [[self alloc] init];
        }
    }
    return sharedManager;
}

-(id)init {
    self = [super init];
    if(self!=nil){
        selectedContacts = [[NSMutableArray alloc] init];
        checkedContacts = [[NSMutableArray alloc] init];
        records = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
