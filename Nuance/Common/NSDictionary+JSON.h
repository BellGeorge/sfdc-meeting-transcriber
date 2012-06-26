//
//  NSDictionary+JSON.h
//  ringdna
//
//  Created by Kyle Roche on 6/9/12.
//  Copyright (c) 2012 DemandResults. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSDictionary_JSON)

- (NSString*) stringForKey:(id)key;
- (NSString*) safeStringForKey:(id)key;
- (float) floatForKey:(id)key;
- (NSArray *) arrayForKey:(id)key;
- (NSDictionary *) dictionaryForKey:(id)key;
- (NSNumber *) numberForKey:(id)key;
- (id) objectForKey:(id)aKey ofClass:(Class)classType;

@end
