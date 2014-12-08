//
//  NSManagedObject+SafeSetters.m
//  PCDatabaseCore
//
//  Created by Paweł Nużka on 03/06/14.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import "NSManagedObject+SafeSetters.h"

@implementation NSManagedObject (SafeSetters)
- (void)setSafelyValue:(id)object forKeyPath:(NSString *)key
{
    if (object != nil && ![object isKindOfClass:[NSNull class]])
        [self setValue:object forKeyPath:key];
}

@end
