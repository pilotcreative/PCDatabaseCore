//
//  PCDatabaseCore+CountEntities.m
//  ShoobsCheckin
//
//  Created by Paweł Nużka on 05.03.2014.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import "PCDatabaseCore+CountEntities.h"

@implementation PCDatabaseCore (CountEntities)
- (NSInteger)getCountOfEntities:(NSString *)entityName
{
    return [self getCountOfEntities:entityName matchingPredicate:nil];
}

- (NSInteger)getCountOfEntities:(NSString *)entityName inContext:(NSManagedObjectContext *)context
{
    return [self getCountOfEntities:entityName matchingPredicate:nil inContext:context];
}


- (NSInteger)getCountOfEntities:(NSString *)entityName matchingPredicate:(NSPredicate *)predicate
{
    return [self getCountOfEntities:entityName matchingPredicate:predicate inContext:self.mainObjectContext];
}


- (NSInteger)getCountOfEntities:(NSString *)entityName matchingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    if (predicate != nil)
        request.predicate = predicate;
    NSError *error = nil;
    return [context countForFetchRequest:request error:&error];
}


@end
