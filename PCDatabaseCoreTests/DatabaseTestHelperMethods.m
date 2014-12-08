//
//  DatabaseTestHelperMethods.m
//  PCDatabaseCore
//
//  Created by Paweł Nużka on 25/04/14.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import "PCDatabaseCore.h"
#import "DatabaseTestHelperMethods.h"
#import <objc/runtime.h>
#import <objc/message.h>

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


+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    static NSPersistentStoreCoordinator *_persistentStoreCoordinator = nil;
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSBundle *mainBundle = [NSBundle bundleForClass: [self class]];
    NSURL *modelURL = [mainBundle URLForResource:@"TestDataModel" withExtension:@"momd"];
    
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    
    NSString *testDatabaseName = [[PCDatabaseCore sharedInstance] databaseName];
    NSString *storePath = [[modelURL.path stringByDeletingLastPathComponent] stringByAppendingPathComponent:testDatabaseName];
    
    NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
    [storeUrl setResourceValue:@(NO) forKey:@"NSURLIsExcludedFromBackupKey" error:nil];
    
    NSError *error = nil;
    NSDictionary *options = nil;
    options = @{ NSSQLitePragmasOption : @{@"journal_mode" : @"DELETE"} };
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error])
    {
        return nil;
    }
    return _persistentStoreCoordinator;
}


+ (void)setUpContextsForTesting
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class PCDatabaseClass = [PCDatabaseCore class];
        Class DatabaseHelperTestsClass = [self class];
        Method orig = class_getInstanceMethod(PCDatabaseClass, @selector(persistentStoreCoordinator));
        Method new = class_getClassMethod(DatabaseHelperTestsClass, @selector(persistentStoreCoordinator));
        method_exchangeImplementations(orig, new);
        
    });
}


@end
