//
//  PCDatabaseCore+RemoveEntity.m
// PCDatabaseCore
//
//  Created by Paweł Nużka on 05.03.2014.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import "PCDatabaseCore+RemoveEntity.h"
#import "PCDatabaseCore+Fetching.h"
#import "NSError+DatabaseError.h"

@implementation PCDatabaseCore (RemoveEntity)
#pragma mark - removing entities
- (NSError *)removeEntity:(NSManagedObject *)entity
{
    if(entity)
        return [self removeEntity:entity inContext:self.mainObjectContext];
    else
        return [NSError fetchRequestError];
}
- (NSError *)removeEntity:(NSManagedObject *)entity inContext:(NSManagedObjectContext *)context
{
    if(entity)
    {
        [context deleteObject:entity];
        NSError *error = nil;
        [context processPendingChanges];
        [context save:&error];
        error = [self saveDatabase];
        if (error)
        {
                        return error;
        }
        else
            return nil;
    }
    return [NSError removeError];
}

- (NSError *)removeEntities:(NSArray *)entities inContext:(NSManagedObjectContext *)context
{
    
    NSError *error = nil;
    for (NSManagedObject *entity in entities)
    {
        NSManagedObject *deletedEntity = [context existingObjectWithID:entity.objectID error:&error];
        if (!error)
            [context deleteObject:deletedEntity];
        else
            break;
    }
    if (!error)
    {
        [context save:&error];
        error = [self saveDatabase];
    }
    if (error)
    {
                return [NSError removeError];
    }
    else
        return nil;
}

- (void)removeEntity:(NSString *)entityName
   matchingPredicate:(NSPredicate *)predicate
        inBackground:(void (^)())success
             failure:(ErrorHandleBlock)failure
{
    NSManagedObjectContext *context = [self backgroundObjectContext];
    dispatch_queue_t main = dispatch_get_main_queue();
    [context performBlock:^{
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [self fetchedManagedObjectsInContext:context forEntity:entityName withPredicate:predicate];
        NSArray *entitiesToRemove = [self fetchArrayWithRequest:fetchRequest inContext:context error:&error];
        
        if (error)
        {
                        if(failure)
                dispatch_async(main, ^{ failure([NSError fetchRequestError]); });
            return;
        }
        
        for (NSManagedObject *entity in entitiesToRemove)
        {
            NSError *error = nil;
            NSManagedObject *deletedEntity = [context existingObjectWithID:entity.objectID error:&error];
            if (!error)
            {
                [context deleteObject:deletedEntity];
                [context save:&error];
                error = [self saveDatabase];
            }
            
            if (error)
            {
                                if(failure)
                    dispatch_async(main, ^{ failure([NSError saveError]); });
                return;
            }
        }
        if (success)
            dispatch_async(main, ^{ success(); });
    }];
    
}

- (void)removeEntities:(NSArray *)entities
          inBackground:(void (^)())success
               failure:(ErrorHandleBlock)failure
{
    NSManagedObjectContext *context = [self backgroundObjectContext];
    dispatch_queue_t main = dispatch_get_main_queue();
    [context performBlock:^{
        for (NSManagedObject *entity in entities)
        {
            NSError *error = nil;
            NSManagedObject *deletedEntity = [context objectWithID:entity.objectID];
            if (error == nil)
            {
                [context deleteObject:deletedEntity];
                [context processPendingChanges];
                [context save:&error];
                error = [self saveDatabase];
            }
            
            if (error)
            {
                                if(failure)
                {
                    dispatch_async(main, ^{ failure([NSError saveError]); });
                }
                return;
            }
        }
        if (success)
            dispatch_async(main, ^{ success(); });
    }];
}
- (NSError *)removeAllEntities:(NSString *)entityName
{
    return [self removeAllEntities:entityName inContext:self.mainObjectContext];
}

- (NSError *)removeAllEntities:(NSString *)entityName inContext:(NSManagedObjectContext *)context
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [self fetchedManagedObjectsInContext:context forEntity:entityName withPredicate:nil];
    NSArray *entitiesToRemove = [self fetchArrayWithRequest:fetchRequest inContext:context error:&error];
    if (error != nil)
        return error;
    
    return [self removeEntities:entitiesToRemove inContext:context];
}


- (void)removeAllEntities:(NSString *)entityName
             inBackground:(void (^)())success
                  failure:(ErrorHandleBlock)failure
{
    return [self removeEntity:entityName matchingPredicate:nil inBackground:success failure:failure];
}


- (NSError *)removeAllDataFromDatabase
{
    [self.mainObjectContext rollback];
    [self.backgroundObjectContext rollback];
    [self.writerObjectContext rollback];
    NSError *__block error = nil;
    NSDictionary *allEntities = self.persistentStoreCoordinator.managedObjectModel.entitiesByName;
    [allEntities enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"key");
        error = [self removeAllEntities:key];
    }];
    
    return error;
}



@end
