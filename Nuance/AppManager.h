//
//  AppManager.h
//  Nuance
//
//  Created by Elena on 26.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppManager : NSObject {
    
}

@property (nonatomic, retain) NSMutableArray * selectedContacts;
@property (nonatomic, retain) NSMutableArray * checkedContacts;
@property (nonatomic, retain) NSMutableArray * records;


+ (id)sharedManager;

@end
