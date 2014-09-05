//
//  NSManagedObject+ImportFromJSON.h
//  ShoobsCheckin
//
//  Created by Paweł Nużka on 05.03.2014.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (ImportFromJSON)
- (void)setValuesForKeysWithJSONDictionary:(NSDictionary *)keyedValues;
@end
