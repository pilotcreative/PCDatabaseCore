//
//  DatabaseTestHelperMethods.m
//  Shoobs
//
//  Created by Paweł Nużka on 25/04/14.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import "DatabaseTestHelperMethods.h"

@implementation DatabaseTestHelperMethods
+ (NSArray *)prepareDbIdArrayWithStartingIndex:(NSInteger)start endIndex:(NSInteger)endIndex
{
    NSLog(@"Create dbIds array:[%ld, %ld]", (long)start, (long)endIndex);
    NSMutableArray *dbIdArray = [NSMutableArray array];
    if (start < endIndex)
    {
        for (NSInteger i = start; i < endIndex; i++)
        {
            [dbIdArray addObject:@(i)];
        }
    }
    return dbIdArray;
}


@end
