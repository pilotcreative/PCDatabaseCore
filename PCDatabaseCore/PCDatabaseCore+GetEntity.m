//
//  PCDatabaseCore+GetEntity.m
// PCDatabaseCore
//
//  Created by Paweł Nużka on 05.03.2014.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import "PCDatabaseCore+GetEntity.h"
#import "PCDatabaseCore+Fetching.h"

@implementation PCDatabaseCore (GetEntity)
#pragma mark - fetching entity by attributes

- (NSManagedObject *)getEntity:(NSString *)entity
             matchingPredicate:(NSPredicate *)predicate
                     inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self fetchedManagedObjectsInContext:context forEntity:entity
                                                     withPredicate:predicate];
    
    NSError *error;
    NSArray *foundEntity = [self fetchArrayWithRequest:request inContext:context error:&error];
    NSManagedObject *result = nil;
    
    if (error)
    {
                return result;
    }
    
    if (foundEntity != nil && [foundEntity count] > 0)
        result = [foundEntity objectAtIndex:0];
    return result;
}


- (NSManagedObject *)getEntity:(NSString *)entity withID:(NSNumber *)entityId
{
    return [self getEntity:entity withID:entityId inContext:self.mainObjectContext];
}

- (NSManagedObject *)getEntity:(NSString *)entity withID:(NSNumber *)entityId inContext:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = nil;
    if (entityId)
        predicate = [NSPredicate predicateWithFormat:@"dbId == %@", entityId];
    
    return [self getEntity:entity matchingPredicate:predicate inContext:context];
}

- (NSManagedObject *)getEntity:(NSString *)entity byKey:(NSString *)key andValue:(id)value
{
    return [self getEntity:entity byKey:key andValue:value inContext:self.mainObjectContext];
}

- (NSManagedObject *)getEntity:(NSString *)entity byKey:(NSString *)key andValue:(id)value inContext:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = nil;
    
    if (value)
        predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
    return [self getEntity:entity matchingPredicate:predicate inContext:context];
}




@end
