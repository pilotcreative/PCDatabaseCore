//
//  Event.h
//  PCDatabaseCoreExampleApp
//
//  Created by Paweł Nużka on 05/09/14.
//  Copyright (c) 2014 Pilot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * dbId;
@property (nonatomic, retain) NSString * name;

@end
