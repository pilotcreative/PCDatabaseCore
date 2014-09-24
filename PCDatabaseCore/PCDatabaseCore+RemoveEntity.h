//
//  PCDatabaseCore+RemoveEntity.h
//  ShoobsCheckin
//
//  Created by Paweł Nużka on 05.03.2014.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import "PCDatabaseCore.h"

@interface PCDatabaseCore (RemoveEntity)
#pragma mark - Remove entities
- (NSError *)removeEntity:(NSManagedObject *)entity;

- (NSError *)removeEntity:(NSManagedObject *)entity inContext:(NSManagedObjectContext *)context;
- (NSError *)removeEntities:(NSArray *)entities inContext:(NSManagedObjectContext *)context;
- (void)removeEntity:(NSString *)entityName
   matchingPredicate:(NSPredicate *)predicate
        inBackground:(void (^)())success
             failure:(ErrorHandleBlock)failure;
- (void)removeEntities:(NSArray *)events
        inBackground:(void (^)())success
               failure:(ErrorHandleBlock)failure;
- (NSError *)removeAllEntities:(NSString *)entityName;
- (NSError *)removeAllEntities:(NSString *)entityName inContext:(NSManagedObjectContext *)context;
- (void)removeAllEntities:(NSString *)entityName
             inBackground:(void (^)())success
                  failure:(ErrorHandleBlock)failure;

@end
