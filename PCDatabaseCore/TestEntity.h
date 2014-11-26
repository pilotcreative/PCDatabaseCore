//
//  TestEntity.h
//  PCDatabaseCore
//
//  Created by Paweł Nużka on 26/11/14.
//  Copyright (c) 2014 Pilot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TestEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * dbId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;

@end
