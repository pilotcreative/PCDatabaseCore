//
//  TestEntity.h
//  PCDatabaseCore
//
//  Created by Paweł Nużka on 13/04/15.
//  Copyright (c) 2015 Pilot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TestEntity : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * dbId;
@property (nonatomic, retain) NSString * name;

@end
