//
//  DatabaseHelper+Event.m
//  PCDatabaseCoreExampleApp
//
//  Created by Paweł Nużka on 05/09/14.
//  Copyright (c) 2014 Pilot. All rights reserved.
//

#import "DatabaseHelper+Event.h"
#import "Event.h"

NSString *const kEventEntityName = @"Event";
@implementation DatabaseHelper (Event)
#pragma mark - Create
- (Event *)createEventWithId:(NSNumber *)dbId
{
    Event *event = (Event *)[self createEntity:kEventEntityName withID:dbId];
    [self saveDatabase];
    return event;
}

- (void)createEventsWithIdsFromArray:(NSArray *)dbIds
                             success:(void (^)(NSArray *events))success
                             failure:(ErrorHandleBlock)failure;
{
    [self createEnitites:kEventEntityName withValues:dbIds forKey:@"dbId" inBackground:success failure:failure];
}

#pragma mark - Get
- (Event *)getEventById:(NSNumber *)dbId
{
    return (Event *)[self getEntity:kEventEntityName withID:dbId];
}
- (Event *)getEventById:(NSNumber *)dbId inContext:(NSManagedObjectContext *)context
{
    return (Event *)[self getEntity:kEventEntityName withID:dbId inContext:context];
}

#pragma mark - Fetch
- (NSFetchedResultsController *)getAllEvents
{
    return [self getAllEventsMatchingPredicate:nil];
}
- (NSArray *)getAllEventsArray
{
    return [self getAllEventsArrayMatchingPredicate:nil];
}
- (NSFetchedResultsController *)getAllEventsMatchingPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [self fetchedManagedObjectsForEntity:kEventEntityName
                                                          withPredicate:predicate
                                                       withSortingByKey:@"dbId"
                                                              ascending:YES];
                                    
    [fetchRequest setIncludesPropertyValues:YES];
    NSError *error;
    NSFetchedResultsController *controller = [self performFetchWithRequest:fetchRequest error:&error];
    return controller;
}
- (NSArray *)getAllEventsArrayMatchingPredicate:(NSPredicate *)predicate
{
    return [[self getAllEventsMatchingPredicate:predicate] fetchedObjects];
}

#pragma mark - Delete
- (NSError *)removeEvent:(Event *)event
{
    return [self removeEntity:event];
}
- (void)removeAllEvents
{
    NSArray *events = [self getAllEventsArray];
    [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeEvent:obj];
    }];
}

- (void)removeEvents:(NSArray *)events
        inBackground:(void (^)())success
             failure:(ErrorHandleBlock)failure
{
    [self removeEntities:events inBackground:success failure:failure];
}
- (void)removeEventsByIds:(NSArray *)eventsID
             inBackground:(void (^)())success
                  failure:(ErrorHandleBlock)failure
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dbId IN %@", eventsID];
    [self removeEntity:kEventEntityName matchingPredicate:predicate inBackground:success failure:failure];
}


@end
