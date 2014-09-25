//
//  PCDatabaseCore+Fetching.m
//  ShoobsCheckin
//
//  Created by Paweł Nużka on 05.03.2014.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import "PCDatabaseCore+Fetching.h"
#import "NSError+DatabaseError.h"

@implementation PCDatabaseCore (Fetching)
//*Fetching queries from database;
#pragma mark - Fetching
- (NSFetchRequest *)fetchedManagedObjectsForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
    @synchronized(self)
    {
        return [self fetchedManagedObjectsInContext:self.mainObjectContext forEntity:entityName withPredicate:predicate];
    }
}
- (NSFetchRequest *)fetchedManagedObjectsInContext:(NSManagedObjectContext *)context
                                forEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
    if (!entityName)
        return nil;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    request.fetchBatchSize = self.fetchBatchSize;
    if (predicate != nil)
        request.predicate = predicate;
    [request setIncludesSubentities:NO];

    return request;
}
- (NSFetchRequest *)fetchedManagedObjectsForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortingByKey:(NSString *)key ascending:(BOOL)asc
{
    @synchronized(self)
    {
        if (!entityName)
            return nil;
        
        NSManagedObjectContext *context = [self mainObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:asc];
        NSArray *sortDescriptors = @[sortDescriptor];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setSortDescriptors:sortDescriptors];
        request.entity = entity;
        request.fetchBatchSize = self.fetchBatchSize;
        [request setIncludesSubentities:NO];
        
        if(predicate != nil)
            [request setPredicate:predicate];
        
        return request;
    }
}
- (NSFetchRequest *)fetchedManagedObjectsForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortingByKey:(NSString *)key
{
    return [self fetchedManagedObjectsForEntity:entityName withPredicate:predicate withSortingByKey:key ascending:YES];
}

- (NSFetchRequest *)fetchedManagedObjectsInContext:(NSManagedObjectContext *)context forEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortingByKey:(NSString *)key ascending:(BOOL)asc
{
    
    if (!entityName)
        return nil;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:asc];
    NSArray *sortDescriptors = @[sortDescriptor];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setSortDescriptors:sortDescriptors];
    request.entity = entity;
    request.fetchBatchSize = self.fetchBatchSize;
    [request setIncludesSubentities:NO];
    
    
    if(predicate != nil)
        [request setPredicate:predicate];
    return request;
}

- (NSFetchRequest *)fetchedManagedObjectsInContext:(NSManagedObjectContext *)context
                                  forEntity:(NSString *)entityName
                              forProperties:(NSArray *)properties
                              withPredicate:(NSPredicate *)predicate
                           withSortingByKey:(NSString *)key
                                  ascending:(BOOL)asc
{
    if (!entityName)
        return nil;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:asc];
    NSArray *sortDescriptors = @[sortDescriptor];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setSortDescriptors:sortDescriptors];
    request.entity = entity;
    request.fetchBatchSize = self.fetchBatchSize;
    [request setIncludesSubentities:NO];
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToFetch:properties];
    
    if(predicate != nil)
        [request setPredicate:predicate];
    
    return request;
}

- (NSFetchRequest *)fetchedManagedObjectsInContext:(NSManagedObjectContext *)context
                                  forEntity:(NSString *)entityName
                              withPredicate:(NSPredicate *)predicate
                           withSortingByKey:(NSString *)key
{
    return [self fetchedManagedObjectsInContext:context forEntity:entityName withPredicate:predicate withSortingByKey:key ascending:YES];
}

- (NSFetchRequest *)fetchedManagedObjectsForEntity:(NSString *)entityName
                                     withPredicate:(NSPredicate *)predicate
                                  withSortingByKey:(NSString *)key
                                          selector:(SEL)selector
                                         ascending:(BOOL)asc
{
    return [self fetchedManagedObjectsInContext:self.mainObjectContext
                                      forEntity:entityName
                                  withPredicate:predicate
                               withSortingByKey:key
                                       selector:selector
                                      ascending:asc];
}

- (NSFetchRequest *)fetchedManagedObjectsInContext:(NSManagedObjectContext *)context
                                         forEntity:(NSString *)entityName
                                     withPredicate:(NSPredicate *)predicate
                                  withSortingByKey:(NSString *)key
                                          selector:(SEL)selector
                                         ascending:(BOOL)asc
{
    @synchronized(self)
    {
        if (!entityName)
            return nil;
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        NSSortDescriptor *sortDescriptor;
        if(selector){
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:asc selector:selector];
        }else{
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:asc];
        }
        NSArray *sortDescriptors = @[sortDescriptor];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setSortDescriptors:sortDescriptors];
        request.entity = entity;
        request.fetchBatchSize = self.fetchBatchSize;
        [request setIncludesSubentities:NO];
        
        if(predicate != nil)
            [request setPredicate:predicate];
        
        return request;
    }
}




- (NSArray *)fetchedManagedObjectsInContext:(NSManagedObjectContext *)context
                                  forEntity:(NSString *)entityName
                              withPredicate:(NSPredicate *)predicate
                             withGroupByKey:(NSString *)key
                               withRelation:(NSString *)relation
                                  ascending:(BOOL)asc
{
    if (!entityName)
        return nil;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"group_by" ascending:asc];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    request.fetchBatchSize = self.fetchBatchSize;
    [request setIncludesSubentities:NO];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:[NSString stringWithFormat:@"%@.%@", relation, key]];
    NSExpression *earliestExpression = [NSExpression
                                        expressionForFunction:@"min:"
                                        arguments:[NSArray arrayWithObject:keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName: @"group_by"];
    [expressionDescription setExpression: earliestExpression];
    [expressionDescription setExpressionResultType: NSDateAttributeType];
    
    
    NSExpressionDescription* objectIdDesc = [[NSExpressionDescription alloc] init];
    objectIdDesc.name = @"objectID";
    objectIdDesc.expression = [NSExpression expressionForEvaluatedObject];
    objectIdDesc.expressionResultType = NSObjectIDAttributeType;
    
    [request setRelationshipKeyPathsForPrefetching:@[key]];
    [request setPropertiesToFetch:@[objectIdDesc , expressionDescription]];
    [request setResultType:NSDictionaryResultType];
    
    if(predicate != nil)
        [request setPredicate:predicate];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    if ((results != nil) && ([results count] == 0))
        results = nil;
    results = [results sortedArrayUsingDescriptors:sortDescriptors];
    
    NSMutableArray *finalResults = [NSMutableArray arrayWithCapacity:results.count];
    for (NSDictionary *object in results)
        [finalResults addObject:@{
                                  @"object":[context existingObjectWithID:[object objectForKey:@"objectID"] error:nil],
                                  @"date":[object objectForKey:@"group_by"]}
         ];
    return finalResults;
}


- (NSArray *)fetchArrayWithRequest:(NSFetchRequest *)fetchRequest error:(NSError *__autoreleasing *)error
{
    return [self fetchArrayWithRequest:fetchRequest inContext:self.mainObjectContext error:error];
}

- (NSArray *)fetchArrayWithRequest:(NSFetchRequest *)fetchRequest inContext:(NSManagedObjectContext *)context error:(NSError *__autoreleasing *)error
{
    NSArray *results = [context executeFetchRequest:fetchRequest error:error];
    
    if ((results != nil) && ([results count] == 0))
        results = nil;
    return results;
}

- (NSFetchedResultsController *)performFetchWithRequest:(NSFetchRequest *)fetchRequest error:(NSError *__autoreleasing *)error
{
    @synchronized (fetchRequest)
    {
        return [self perfromFetchWithRequest:fetchRequest inContext:self.mainObjectContext forSectionNameKeyPath:nil error:error];
    }
}

- (NSFetchedResultsController *)performFetchWithRequest:(NSFetchRequest *)fetchRequest
                                              inContext:(NSManagedObjectContext *)context
                                                  error:(NSError *__autoreleasing *)error
{
    return [self perfromFetchWithRequest:fetchRequest inContext:context forSectionNameKeyPath:nil error:error];
}

- (NSFetchedResultsController *)perfromFetchWithRequest:(NSFetchRequest *)fetchRequest
                                  forSectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                  error:(NSError *__autoreleasing *)error
{
    return [self perfromFetchWithRequest:fetchRequest inContext:self.mainObjectContext forSectionNameKeyPath:sectionNameKeyPath error:error];
}

- (NSFetchedResultsController *)perfromFetchWithRequest:(NSFetchRequest *)fetchRequest
                                              inContext:(NSManagedObjectContext *)context
                                  forSectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                  error:(NSError *__autoreleasing *)error

{
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:sectionNameKeyPath
                                                                                            cacheName:nil];
    [controller performFetch:error];
    return controller;
}

- (void)fetchedManagedObjectsForEntity:(NSString *)entityName
                         withPredicate:(NSPredicate *)predicate
                      withSortingByKey:(NSString *)key
                             ascending:(BOOL)asc
                          inBackground:(void(^)(NSFetchedResultsController *results))success
                                 error:(ErrorHandleBlock)failure
{
    NSManagedObjectContext *context = [self backgroundObjectContext];
    [context performBlock:^{
        NSFetchRequest *request = [self fetchedManagedObjectsInContext:context
                                                             forEntity:entityName
                                                         withPredicate:predicate
                                                      withSortingByKey:key
                                                             ascending:asc];
        NSError *error = nil;
        NSFetchedResultsController *results = [self performFetchWithRequest:request inContext:context error:&error];
        if (error)
        {
            if (failure)
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure([NSError fetchRequestError]);
                });
        }
        else
            dispatch_async(dispatch_get_main_queue(), ^{
                success(results);
            });
    }];
}


@end
