//
//  PCDatabaseCore+CreateEntity.m
//  ShoobsCheckin
//
//  Created by Paweł Nużka on 05.03.2014.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import "NSManagedObject+ImportFromJSON.h"
#import "PCDatabaseCore_Categories.h"
#import <pthread.h>

@implementation PCDatabaseCore (CreateEntity)

#pragma mark - Create entities
- (NSManagedObject *)createEntity:(NSString *)entityName
{
    return [self createEntity:entityName inContext:self.mainObjectContext];
}

- (NSManagedObject *)createEntity:(NSString *)entityName inContext:(NSManagedObjectContext *)context
{
    if ([entityName isKindOfClass:[NSString class]])
    {
        NSManagedObject * entity = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        return entity;
    }
    return nil;
}

- (NSManagedObject *)createEntity:(NSString *)entityName withID:(NSNumber *)entityId
{
    return [self createEntity:entityName withID:entityId inContext:self.mainObjectContext];
}
- (NSManagedObject *)createEntity:(NSString *)entityName withID:(NSNumber *)entityId inContext:(NSManagedObjectContext *)context
{
    if ([entityId isKindOfClass:[NSNumber class]])
    {
//TODO - THINK IT OVER LATER - might couse a serious BUG
//        static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
//        pthread_mutex_lock(&mutex);
        NSManagedObject *objectFromDb = [self getEntity:entityName withID:entityId inContext:context];
        
        if (!objectFromDb)
        {
            objectFromDb = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
            [objectFromDb setValue:entityId forKey:@"dbId"];
        }
//        pthread_mutex_unlock(&mutex);
        return objectFromDb;
    }
    DLog(@"DB create entity error %@ %@", entityName, entityId);
    return nil;
}

- (NSManagedObject *)createEntity:(NSString *)entityName withKey:(NSString *)key andValue:(id)value
{
    return [self createEntity:entityName withKey:key andValue:value inContext:self.mainObjectContext];
}
- (NSManagedObject *)createEntity:(NSString *)entityName withKey:(NSString *)key andValue:(id)value inContext:(NSManagedObjectContext *)context
{
    if ([key isKindOfClass:[NSString class]] && value != nil)
    {
//        static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
//        pthread_mutex_lock(&mutex);
        NSManagedObject *objectFromDb = [self getEntity:entityName byKey:key andValue:value inContext:context];
        
        if (!objectFromDb)
        {
            objectFromDb = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
            [objectFromDb setValue:value forKey:key];
        }
//        pthread_mutex_unlock(&mutex);
        return objectFromDb;
    }
    DLog(@"DB create entity error %@", entityName);
    return nil;
}


- (NSManagedObject *)createEntity:(NSString *)entityName
                         withJSON:(NSDictionary *)json
{
    return [self createEntity:entityName withJSON:json inContext:self.mainObjectContext];
}

- (NSManagedObject *)createEntity:(NSString *)entityName
                         withJSON:(NSDictionary *)json
                        inContext:(NSManagedObjectContext *)context
{
    NSManagedObject *entity = nil;
    id dbId = json[@"id"];
    BOOL entityWithId = [entity respondsToSelector:NSSelectorFromString(@"dbId")];
    if (dbId != nil && entityWithId)
        entity = [self createEntity:entityName withID:dbId inContext:context];
    else
        entity = [self createEntity:entityName inContext:context];
    [entity setValuesForKeysWithJSONDictionary:json];
    return entity;
}


- (void)createEntity:(NSString *)entityName
            withJSON:(NSDictionary *)json
        inBackground:(void (^)(NSManagedObject *entity))success
{
    NSManagedObjectContext *context = [self backgroundObjectContext];
    dispatch_queue_t main = dispatch_get_main_queue();
    [context performBlock:^{
        NSManagedObject *entity = [self createEntity:entityName withJSON:json inContext:context];
        dispatch_async(main, ^{ success(entity); });
    }];
}

- (void)createEnitites:(NSString *)entityName
         withJSONArray:(NSArray *)jsonArray
          inBackground:(void (^)(NSArray * entities))success
{
    NSManagedObjectContext *context = [self backgroundObjectContext];
    dispatch_queue_t main = dispatch_get_main_queue();
    [context performBlock:^{
        
        NSMutableArray *entitiesArray = [NSMutableArray array];
        [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSManagedObject *entity = [self createEntity:entityName withJSON:obj inContext:context];
            [entitiesArray addObject:entity];
        }];
        dispatch_async(main, ^{ success(entitiesArray); });
    }];
}

/*!
 * Efficient create or update
 * https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreData/Articles/cdImporting.html
 * values must be sorted
 * we do not save errors because they will apear if there
 * is more than one required property
 */
- (NSArray *)createEntities:(NSString *)entityName
                    withKey:(NSString *)key
                  andValues:(NSArray *)values
                  inContext:(NSManagedObjectContext *)context
{
    static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    
    NSSet *uniqueValues = [NSSet setWithArray:values];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K in %@", key, uniqueValues];
    NSFetchRequest *request = [self fetchedManagedObjectsInContext:context forEntity:entityName withPredicate:predicate withSortingByKey:key ascending:YES];
    pthread_mutex_lock(&mutex);
    NSArray *fetchedEntities = [self fetchArrayWithRequest:request inContext:context error:nil];
    NSMutableArray *uniqueValuesArray = [NSMutableArray arrayWithArray:[uniqueValues.allObjects sortedArrayUsingSelector:@selector(compare:)]];

    NSArray *dbIdsFromDatabase = [fetchedEntities valueForKey:key];
    
    NSMutableArray *resultingEntities = [NSMutableArray arrayWithCapacity:uniqueValuesArray.count];
    if (fetchedEntities.count > 0)
    {
        [uniqueValuesArray removeObjectsInArray:dbIdsFromDatabase];
        [resultingEntities addObjectsFromArray:fetchedEntities];
    }
    
    [uniqueValuesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSManagedObject *createdObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        [createdObject setValue:obj forKey:key];
        [self saveContext:context forIndex:idx];
        [resultingEntities addObject:createdObject];
    }];
    [context save:nil];

    pthread_mutex_unlock(&mutex);
    return [resultingEntities sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key ascending:YES]]];
}
- (NSError *)saveContext:(NSManagedObjectContext *)context forIndex:(NSInteger)idx
{
    NSError *error = nil;
    if (idx > 0 && idx % kSaveBatchSize == 0)
        [context save:&error];
    return error;
}

@end
