//
//  DatabaseHelper+Event.h
//  PCDatabaseCoreExampleApp
//
//  Created by Paweł Nużka on 05/09/14.
//  Copyright (c) 2014 Pilot. All rights reserved.
//

#import "DatabaseHelper.h"
@class Event;

extern NSString *const kEventEntityName;
@interface DatabaseHelper (Event)

#pragma mark - Create
- (Event *)createEventWithId:(NSNumber *)dbId;
- (void)createEventsWithIdsFromArray:(NSArray *)dbIds
                             success:(void (^)(NSArray *events))success
                             failure:(ErrorHandleBlock)failure;

#pragma mark - Get
- (Event *)getEventById:(NSNumber *)dbId;
- (Event *)getEventById:(NSNumber *)dbId inContext:(NSManagedObjectContext *)context;

#pragma mark - Fetch
- (NSFetchedResultsController *)getAllEvents;
- (NSArray *)getAllEventsArray;
- (NSFetchedResultsController *)getAllEventsMatchingPredicate:(NSPredicate *)predicate;
- (NSArray *)getAllEventsArrayMatchingPredicate:(NSPredicate *)predicate;

#pragma mark - Delete
- (NSError *)removeEvent:(Event *)event;
- (void)removeAllEvents;
- (void)removeEvents:(NSArray *)events
        inBackground:(void (^)())success
             failure:(ErrorHandleBlock)failure;
- (void)removeEventsByIds:(NSArray *)eventsID
             inBackground:(void (^)())success
                  failure:(ErrorHandleBlock)failure;

@end
