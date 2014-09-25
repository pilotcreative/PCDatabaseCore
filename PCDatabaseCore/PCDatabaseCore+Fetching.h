//
//  PCDatabaseCore+Fetching.h
//  ShoobsCheckin
//
//  Created by Paweł Nużka on 05.03.2014.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import "PCDatabaseCore.h"

@interface PCDatabaseCore (Fetching)
#pragma mark - Preparing request
- (NSFetchRequest *)fetchedManagedObjectsForEntity:(NSString *)entityName
                              withPredicate:(NSPredicate *)predicate;

- (NSFetchRequest *)fetchedManagedObjectsInContext:(NSManagedObjectContext *)context
                                         forEntity:(NSString *)entityName
                                     withPredicate:(NSPredicate *)predicate;

- (NSFetchRequest *)fetchedManagedObjectsForEntity:(NSString *)entityName
                                     withPredicate:(NSPredicate *)predicate
                                  withSortingByKey:(NSString *)key ascending:(BOOL)asc;

- (NSFetchRequest *)fetchedManagedObjectsForEntity:(NSString *)entityName
                                     withPredicate:(NSPredicate *)predicate
                                  withSortingByKey:(NSString *)key;

- (NSFetchRequest *)fetchedManagedObjectsInContext:(NSManagedObjectContext *)context
                                         forEntity:(NSString *)entityName
                                     withPredicate:(NSPredicate *)predicate
                                  withSortingByKey:(NSString *)key
                                         ascending:(BOOL)asc;


- (NSFetchRequest *)fetchedManagedObjectsInContext:(NSManagedObjectContext *)context
                                         forEntity:(NSString *)entityName
                                     forProperties:(NSArray *)properties
                                     withPredicate:(NSPredicate *)predicate
                                  withSortingByKey:(NSString *)key
                                         ascending:(BOOL)asc;


- (NSFetchRequest *)fetchedManagedObjectsInContext:(NSManagedObjectContext *)context
                                         forEntity:(NSString *)entityName
                                     withPredicate:(NSPredicate *)predicate
                                  withSortingByKey:(NSString *)key;

- (NSFetchRequest *)fetchedManagedObjectsForEntity:(NSString *)entityName
                                     withPredicate:(NSPredicate *)predicate
                                  withSortingByKey:(NSString *)key
                                          selector:(SEL)selector
                                         ascending:(BOOL)asc;

- (NSFetchRequest *)fetchedManagedObjectsInContext:(NSManagedObjectContext *)context
                                         forEntity:(NSString *)entityName
                                     withPredicate:(NSPredicate *)predicate
                                  withSortingByKey:(NSString *)key
                                          selector:(SEL)selector
                                         ascending:(BOOL)asc;


#pragma mark - Fetching
- (NSArray *)fetchedManagedObjectsInContext:(NSManagedObjectContext *)context
                                  forEntity:(NSString *)entityName
                              withPredicate:(NSPredicate *)predicate
                             withGroupByKey:(NSString *)key
                               withRelation:(NSString *)relation
                                  ascending:(BOOL)asc;


- (NSArray *)fetchArrayWithRequest:(NSFetchRequest *)fetchRequest error:(NSError **)error;

- (NSArray *)fetchArrayWithRequest:(NSFetchRequest *)fetchRequest
                         inContext:(NSManagedObjectContext *)context
                             error:(NSError **)error;

- (NSFetchedResultsController *)performFetchWithRequest:(NSFetchRequest *)fetchRequest
                                                  error:(NSError **)error;

- (NSFetchedResultsController *)performFetchWithRequest:(NSFetchRequest *)fetchRequest
                                              inContext:(NSManagedObjectContext *)context
                                                  error:(NSError **)error;


- (void)fetchedManagedObjectsForEntity:(NSString *)entityName
                         withPredicate:(NSPredicate *)predicate
                      withSortingByKey:(NSString *)key
                             ascending:(BOOL)asc
                          inBackground:(void(^)(NSFetchedResultsController *results))success
                                 error:(ErrorHandleBlock)failure;

- (NSFetchedResultsController *)perfromFetchWithRequest:(NSFetchRequest *)fetchRequest
                                  forSectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                  error:(NSError *__autoreleasing *)error;


- (NSFetchedResultsController *)perfromFetchWithRequest:(NSFetchRequest *)fetchRequest
                                              inContext:(NSManagedObjectContext *)context
                                  forSectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                  error:(NSError *__autoreleasing *)error;

@end
