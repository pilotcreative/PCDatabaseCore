//
//  NSManagedObject+SafeSetters.h
//  PCDatabaseCore
//
//  Created by Paweł Nużka on 03/06/14.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (SafeSetters)
- (void)setSafelyValue:(id)object forKeyPath:(NSString *)key;
@end
