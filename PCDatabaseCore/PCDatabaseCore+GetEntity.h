//
//  PCDatabaseCore+GetEntity.h
//  ShoobsCheckin
//
//  Created by Paweł Nużka on 05.03.2014.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import "PCDatabaseCore.h"

@interface PCDatabaseCore (GetEntity)
#pragma mark - fetching entity by attributes
- (NSManagedObject *)getEntity:(NSString *)entity
                        withID:(NSNumber *)entityId;


- (NSManagedObject *)getEntity:(NSString *)entity
                        withID:(NSNumber *)entityId
                     inContext:(NSManagedObjectContext *)context;


- (NSManagedObject *)getEntity:(NSString *)entity
                         byKey:(NSString *)key
                      andValue:(id)value;

- (NSManagedObject *)getEntity:(NSString *)entity
                         byKey:(NSString *)key
                      andValue:(id)value
                     inContext:(NSManagedObjectContext *)context;


- (NSManagedObject *)getEntity:(NSString *)entity
             matchingPredicate:(NSPredicate *)predicate
                     inContext:(NSManagedObjectContext *)context;


@end
