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

- (NSInteger)getCountOfEntities:(NSString *)entityName matchingPredicate:(NSPredicate *)predicate
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.mainObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    if (predicate != nil)
        request.predicate = predicate;
    NSError *error = nil;
    return [self.mainObjectContext countForFetchRequest:request error:&error];
}

@end
