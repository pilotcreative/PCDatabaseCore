//
//  PCDatabaseCoreTests.m
//  PCDatabaseCoreTests
//
//  Created by Paweł Nużka on 02/09/14.
//  Copyright (c) 2014 Pilot. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PCDatabaseCore.h"
#import "NSArray+Permutations.h"
#import "PCDatabaseCore+CreateEntity.h"
#import "PCDatabaseCore+CountEntities.h"
#import "PCDatabaseCore+RemoveEntity.h"

#import "DatabaseTestHelperMethods.h"

#import <XCTestCase+AsyncTesting.h>

int kEntityCount = 100;
int kSaveTimeout = 30;

NSString *kEntityName = @"TestEntity";

@interface PCDatabaseCoreTests : XCTestCase
@property (nonatomic, strong) PCDatabaseCore *sharedInstance;
@property (nonatomic, strong) NSManagedObjectContext *testContext;
@end

@implementation PCDatabaseCoreTests

- (void)setUp
{
    [super setUp];
    [DatabaseTestHelperMethods setUpContextsForTesting];
    self.testContext = [DatabaseTestHelperMethods managedObjectContextForTesting];
    self.sharedInstance = [PCDatabaseCore sharedInstanceTest];
}

- (void)tearDown
{
   [self.sharedInstance removeAllEntities:kEntityName inContext:self.testContext];
    self.sharedInstance = nil;
    [super tearDown];
}

- (void)testSharedInstance
{
    PCDatabaseCore *sharedInstance = [PCDatabaseCore sharedInstanceTest];
    XCTAssertNotNil(sharedInstance, @"sharedInstance should not be nil");
}

- (void)testCreateEntity {
    NSManagedObject *event = [[PCDatabaseCore sharedInstanceTest] createEntity:kEntityName inContext:self.testContext];
    XCTAssertNotNil(event, @"createEntity returns an entity");
}


- (void)testDatabaseName
{
    XCTAssertNotNil([self.sharedInstance databaseName], @"database should have name");
}

- (void)testCreateMultipleEntities
{
    NSArray *dbIds = @[@12, @75, @121, @243, @258, @274, @294, @309, @332, @365, @382, @386, @428, @441, @473, @529, @645, @668, @681, @747, @756, @773, @801, @809, @867, @872, @897, @935, @942, @1033];
    NSArray *savedEntities = [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:dbIds inContext:self.testContext error:nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dbId in %@", dbIds];
    NSArray *savedDbIds = [savedEntities filteredArrayUsingPredicate:predicate];
    XCTAssertEqual(savedDbIds.count, dbIds.count, @"it should create all entities");
    
    savedEntities = [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:dbIds inContext:self.testContext error:nil];
    XCTAssertTrue(savedEntities.count == dbIds.count, @"it should return all created entities");
}
- (void)testUnorderdMultipleEntites
{
    NSArray *dbIds = @[@1, @2, @3, @4];
    NSArray *allPermutations = [dbIds allPermutations];
    [allPermutations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:obj inContext:self.testContext error:nil];
    }];
    NSInteger entityCounter = [self.sharedInstance getCountOfEntities:kEntityName inContext:self.testContext];
    XCTAssertTrue(entityCounter == dbIds.count, @"should not duplicate events");
}
- (void)testOverlappingIdsCreation
{
    NSArray *dbIds = @[@1, @2, @5];
    
    NSArray *savedEntities = [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:dbIds inContext:self.testContext error:nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dbId in %@", dbIds];
    NSArray *savedDbIds = [savedEntities filteredArrayUsingPredicate:predicate];
    XCTAssertEqual(savedEntities.count, dbIds.count, @"it should create all entities");
    NSArray *duplicatedDbIds = @[@2, @4, @5];
    savedEntities = [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:duplicatedDbIds inContext:self.testContext error:nil];
    predicate = [NSPredicate predicateWithFormat:@"dbId in %@", duplicatedDbIds];
    savedDbIds = [savedEntities filteredArrayUsingPredicate:predicate];
    XCTAssertEqual(savedDbIds.count, duplicatedDbIds.count, @"it should create all entities");
    NSInteger entityCounter = [self.sharedInstance getCountOfEntities:kEntityName inContext:self.testContext];
    NSInteger uniqueCount = [[NSSet setWithArray:[dbIds arrayByAddingObjectsFromArray:duplicatedDbIds]] count];
    XCTAssertTrue(entityCounter == uniqueCount, @"should not duplicate events");
}
- (void)testCreateDuplicates
{
    NSArray *dbIds = @[@5, @5, @5, @5];
    NSArray *savedEntities = [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:dbIds inContext:self.testContext error:nil];
    XCTAssertTrue(savedEntities.count == 1, @"it should not create duplicates");
}

- (void)testCreateDuplicatesInBackground
{
    NSMutableArray *dbIds = [NSMutableArray arrayWithCapacity:kEntityCount];
    for (int i = 0; i < kEntityCount; i++) {
        [dbIds addObject:@(i)];
    }
    NSManagedObjectContext *context = [DatabaseTestHelperMethods backgroundObjectContextForTesting];
    __block int counter = 0;
    int allThreads = 4;
    
    
    [context performBlock:^{
        [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:dbIds inContext:context error:nil];
        if (counter == allThreads)
            [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
        else
            counter++;
    }];
    
    [context performBlock:^{
        [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:dbIds inContext:context error:nil];
        if (counter == allThreads)
            [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
        else
            counter++;
    }];
    
    [context performBlock:^{
        [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:dbIds inContext:context error:nil];
        if (counter == allThreads)
            [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
        else
            counter++;
    }];
    
    [context performBlock:^{
        [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:dbIds inContext:context error:nil];
        if (counter == allThreads)
            [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
        else
            counter++;
    }];
    
    [context performBlock:^{
        [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:dbIds inContext:context error:nil];
        if (counter == allThreads)
            [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
        else
            counter++;
    }];
    
    [self XCA_waitForTimeout:kSaveTimeout];
    NSInteger entityCounter = [self.sharedInstance getCountOfEntities:kEntityName inContext:self.testContext];
    XCTAssertTrue(entityCounter == kEntityCount, @"should not duplicate events");
}

- (void)testCreateDuplicatesInParallel
{
    
    NSManagedObjectContext *context = [DatabaseTestHelperMethods backgroundObjectContextForTesting];
    __block int counter = 0;
    int allThreads = 64;
    
    NSMutableArray *dbIds = [NSMutableArray arrayWithCapacity:kEntityCount];
    for (int i = 0; i < kEntityCount; i++) {
        [dbIds addObject:@(i)];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_apply(allThreads, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(size_t idx) {
            
            [context performBlock:^{
                [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:dbIds inContext:context error:nil];
                if (counter == allThreads - 1)
                    [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
                else
                    counter++;
            }];
        });
    });
    [self XCA_waitForTimeout:kSaveTimeout];
    NSInteger entityCounter = [self.sharedInstance getCountOfEntities:kEntityName inContext:self.testContext];
    XCTAssertTrue(entityCounter == kEntityCount, @"should not duplicate events");
}

- (NSManagedObjectContext *)backgroundObjectContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setParentContext:self.testContext];
    [context setUndoManager:nil];
    return context;
}

- (void)testCreatePartialyDuplicatesInParallel
{
    __block int counter = 0;
    int allThreads = 4;
    NSArray *contexts = @[[self backgroundObjectContext], [self backgroundObjectContext], [self backgroundObjectContext], [self backgroundObjectContext]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_apply(allThreads, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(size_t idx) {
            [contexts[idx] performBlock:^{
                NSArray *dbIds = [DatabaseTestHelperMethods prepareDbIdArrayWithStartingIndex:idx endIndex:kEntityCount + idx];
                [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:dbIds inContext:contexts[idx] error:nil];
                if (counter == allThreads - 1)
                    [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
                else
                    counter++;
            }];
        });
    });
    [self XCA_waitForTimeout:kSaveTimeout];
    NSInteger entityCounter = [self.sharedInstance getCountOfEntities:kEntityName inContext:self.testContext];
    XCTAssertTrue(entityCounter == kEntityCount + allThreads - 1, @"should get %d events instead got %ld",kEntityCount + allThreads - 1, (long)entityCounter);
}
- (void)testCreatePartialyDuplicates
{
    NSManagedObjectContext *context = [DatabaseTestHelperMethods backgroundObjectContextForTesting];
    int allThreads = 5;
    
    NSArray *dbIds = [DatabaseTestHelperMethods prepareDbIdArrayWithStartingIndex:0 endIndex:kEntityCount + 0];
    [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:dbIds inContext:context error:nil];
    
    dbIds = [DatabaseTestHelperMethods prepareDbIdArrayWithStartingIndex:1 endIndex:kEntityCount + 1];
    [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:dbIds inContext:context error:nil];
    
    dbIds = [DatabaseTestHelperMethods prepareDbIdArrayWithStartingIndex:2 endIndex:kEntityCount + 2];
    [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:dbIds inContext:context error:nil];
    
    dbIds = [DatabaseTestHelperMethods prepareDbIdArrayWithStartingIndex:3 endIndex:kEntityCount + 3];
    [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:dbIds inContext:context error:nil];
    
    dbIds = [DatabaseTestHelperMethods prepareDbIdArrayWithStartingIndex:4 endIndex:kEntityCount + 4];
    [self.sharedInstance createEntities:kEntityName withKey:@"dbId" andValues:dbIds inContext:context error:nil];
    
    NSInteger entityCounter = [self.sharedInstance getCountOfEntities:kEntityName inContext:self.testContext];
    XCTAssertTrue(entityCounter == kEntityCount + allThreads - 1 , @"should not duplicate events");
}


@end
