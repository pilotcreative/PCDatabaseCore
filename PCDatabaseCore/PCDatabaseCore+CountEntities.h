//
//  PCDatabaseCore+CountEntities.h
//  ShoobsCheckin
//
//  Created by Paweł Nużka on 05.03.2014.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import "PCDatabaseCore.h"

@interface PCDatabaseCore (CountEntities)
#pragma mark - Count
- (NSInteger)getCountOfEntities:(NSString *)entityName;
- (NSInteger)getCountOfEntities:(NSString *)entityName matchingPredicate:(NSPredicate *)predicate;

@end