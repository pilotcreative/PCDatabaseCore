//
//  NSManagedObject+ImportFromJSON.m
//  ShoobsCheckin
//
//  Created by Paweł Nużka on 05.03.2014.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import "NSManagedObject+ImportFromJSON.h"
#import <objc/runtime.h>

@implementation NSManagedObject (ImportFromJSON)
- (void)setValuesForKeysWithJSONDictionary:(NSDictionary *)keyedValues
{
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    for (int i=0; i<propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        NSString *keyName = [NSString stringWithUTF8String:propertyName];
        
        if ([keyName isEqualToString:@"id"])
            keyName = @"dbId";
        
        id value = [keyedValues objectForKey:keyName];
        if (value != nil) {
            [self setValue:value forKey:keyName];
        }
    }
    free(properties);
}

@end
