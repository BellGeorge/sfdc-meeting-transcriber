//
//  NSDictionary+JSON.m
//  ringdna
//
//  Created by Kyle Roche on 6/9/12.
//  Copyright (c) 2012 DemandResults. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (NSDictionary_JSON)

- (NSString*) stringForKey:(id)key {
    
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [((NSNumber*)value) stringValue];
    }
    
    return nil;
}

- (NSString*) safeStringForKey:(id)key {
    return [self stringForKey:key] ? [self stringForKey:key] : @"";
}

- (float) floatForKey:(id)key {
    
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSString class]]) {
        NSString* v = (NSString*)value;
        return [v floatValue];
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [((NSNumber*)value) floatValue];
    }
    
    return 0.0;
}

- (NSArray *) arrayForKey:(id)key {
    return [self objectForKey:key ofClass:[NSArray class]];
}

- (NSDictionary *) dictionaryForKey:(id)key {
    return [self objectForKey:key ofClass:[NSDictionary class]];
}

- (NSNumber *) numberForKey:(id)key {
    return [self objectForKey:key ofClass:[NSNumber class]];
}

- (id) objectForKey:(id)aKey ofClass:(Class)classType {
    id object = [self objectForKey:aKey];
    
    if ([object isKindOfClass:classType] ) {
        return object;
    }
    
    return nil;
}

@end
