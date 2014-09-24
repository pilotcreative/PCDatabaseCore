//
//  DatabaseTestHelperMethods.m
//  Shoobs
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


+ (NSPersistentStoreCoordinator *)persistentStoreCoordinatorForModel:(NSManagedObjectModel *)managedObjectModel withStorePath:(NSString *)path
{
    static NSPersistentStoreCoordinator *_persistentStoreCoordinator = nil;
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSString *testDatabaseName = [[PCDatabaseCore sharedInstanceTest] databaseName];
    NSString *storePath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:testDatabaseName];
    
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

+ (NSManagedObjectContext *)managedObjectContextForTesting
{
    static NSManagedObjectContext *_managedObjectContextForTesting = nil;
    if (_managedObjectContextForTesting != nil)
        return _managedObjectContextForTesting;
    _managedObjectContextForTesting = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContextForTesting setParentContext:[self writerContextForTesting]];
    [_managedObjectContextForTesting setUndoManager:nil];
    
    return _managedObjectContextForTesting;
}

+ (NSManagedObjectContext *)writerContextForTesting
{
    static NSManagedObjectContext *_writerManagedObjectContext = nil;
    if (_writerManagedObjectContext == nil) {
        
        NSBundle *mainBundle = [NSBundle bundleForClass: [self class]];
        NSURL *modelURL = [mainBundle URLForResource:@"TestDataModel" withExtension:@"momd"];
        
        NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        _writerManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_writerManagedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinatorForModel:managedObjectModel withStorePath:modelURL.path]];
    }
    
    return _writerManagedObjectContext;
}

+ (NSManagedObjectContext *)backgroundObjectContextForTesting
{
    static NSManagedObjectContext *_backgroundManagedObjectContext = nil;
    if (_backgroundManagedObjectContext != nil)
        return _backgroundManagedObjectContext;
    
    _backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_backgroundManagedObjectContext setParentContext:[self managedObjectContextForTesting]];
    [_backgroundManagedObjectContext setUndoManager:nil];
    return _backgroundManagedObjectContext;

}


+ (void)setUpContextsForTesting
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method orig = class_getInstanceMethod([PCDatabaseCore class], @selector(mainObjectContext));
        Method new = class_getInstanceMethod([self class], @selector(managedObjectContextForTesting));
        method_exchangeImplementations(orig, new);
    });
}


@end
