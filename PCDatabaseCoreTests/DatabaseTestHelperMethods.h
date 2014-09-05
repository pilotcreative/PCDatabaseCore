//
//  DatabaseTestHelperMethods.h
//  Shoobs
//
//  Created by Paweł Nużka on 25/04/14.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DatabaseTestHelperMethods : NSObject
+ (NSArray *)prepareDbIdArrayWithStartingIndex:(NSInteger)start endIndex:(NSInteger)endIndex;
@end
