//
//  PCDatabaseCore+CreateEntity.h
// PCDatabaseCore
//
//  Created by Paweł Nużka on 05.03.2014.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import "PCDatabaseCore.h"


@interface PCDatabaseCore (CreateEntity)
#pragma mark - Create entities
/*!
 *  All following funtions do not save objects being returned
 *  It's developers responsibility to save them when appropriate
 */

- (NSError *)saveContext:(NSManagedObjectContext *)context forIndex:(NSInteger)index;
- (NSManagedObject *)createEntity:(NSString *)entityName;

- (NSManagedObject *)createEntity:(NSString *)entityName
                        inContext:(NSManagedObjectContext *)context;

- (NSManagedObject *)createEntity:(NSString *)entityName
                          withKey:(NSString *)key
                         andValue:(id)value;

- (NSManagedObject *)createEntity:(NSString *)entityName
                          withKey:(NSString *)key
                         andValue:(id)value
                        inContext:(NSManagedObjectContext *)context;

- (NSManagedObject *)createEntity:(NSString *)entityName
                           withID:(NSNumber *)entityId;

- (NSManagedObject *)createEntity:(NSString *)entityName
                           withID:(NSNumber *)entityId
                        inContext:(NSManagedObjectContext *)context;

- (NSManagedObject *)createEntity:(NSString *)entityName
                         withJSON:(NSDictionary *)json;

- (NSManagedObject *)createEntity:(NSString *)entityName
                         withJSON:(NSDictionary *)json
                        inContext:(NSManagedObjectContext *)context;

- (NSManagedObject *)createEntity:(NSString *)entityName
                   withUniqueKeys:(NSArray *)uniqueKeys
                        andValues:(NSArray *)values;

- (NSManagedObject *)createEntity:(NSString *)entityName
                   withUniqueKeys:(NSArray *)uniqueKeys
                        andValues:(NSArray *)values
                        inContext:(NSManagedObjectContext *)context;


- (void)createEntity:(NSString *)entityName
            withJSON:(NSDictionary *)json
        inBackground:(void (^)(NSManagedObject *entity))success;

- (void)createEnitites:(NSString *)entityName
         withJSONArray:(NSArray *)jsonArray
          inBackground:(void (^)(NSArray * entities))success;

/*!
 *  All following functions save objects being returned
 *  Please see kPCDatabaseCoreSaveBatchSize
 */

// happens on main context - blocks UI
- (NSArray *)createEntities:(NSString *)entityName
                    withKey:(id)key
                  andValues:(NSArray *)valuesArray
                      error:(NSError **)error;

// WARNING: USE ONLY IN THREAD, IF NOT, WILL DUPLICATE ENTITIES
- (NSArray *)createEntities:(NSString *)entityName
                    withKey:(NSString *)key
                  andValues:(NSArray *)values
                  inContext:(NSManagedObjectContext *)context
                      error:(NSError **)error;


- (void)createEntities:(NSString *)entityName
               withKey:(id)key
             andValues:(NSArray *)valuesArray
          inBackground:(void (^)(NSArray *entities))success
               failure:(ErrorHandleBlock)failure;



@end
