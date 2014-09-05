//
//  NSError+DatabaseError.h
//  ShoobsCheckin
//
//  Created by Paweł Nużka on 05.03.2014.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (DatabaseError)
+ (NSError *)fetchRequestError;
+ (NSError *)saveError;
+ (NSError *)unknownError;
+ (NSError *)removeError;
+ (NSError *)incorrectInstanceError;

@end
