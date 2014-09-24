//
//  DatabaseHelper+EventTests.m
//  PCDatabaseCoreExampleApp
//
//  Created by Paweł Nużka on 05/09/14.
//  Copyright (c) 2014 Pilot. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DatabaseHelper+Event.h"
#import "Event.h"

@interface DatabaseHelper_EventTests : XCTestCase
@property (nonatomic, strong) DatabaseHelper *databaseHelper;
@end

@implementation DatabaseHelper_EventTests

- (void)setUp
{
    [super setUp];
    self.databaseHelper = [DatabaseHelper initWithName:@"XCTests"];
}
- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [self.databaseHelper removeAllEvents];
    self.databaseHelper = nil;
    [super tearDown];
}

- (void)testCreateEvent
{
    int eventId = 1;
    Event *event = [self.databaseHelper createEventWithId:@(eventId)];
    NSString *eventName = @"name";
    event.name = eventName;
    [self.databaseHelper saveDatabase];
    XCTAssertNotNil(event, @"event should not be nil");
    XCTAssertTrue(event.dbId.intValue == 1, @"db id should be equal to %d, got %@ instead", eventId, event.dbId);
    XCTAssertTrue([event.name isEqualToString:eventName], @"event name should be equal to %@, got %@ instead", eventName, event.name);
}



@end
