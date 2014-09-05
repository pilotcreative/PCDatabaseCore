//
//  NSError+DatabaseError.m
//  ShoobsCheckin
//
//  Created by Paweł Nużka on 05.03.2014.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import "NSError+DatabaseError.h"
NSString *const kDomainErrorDatabase = @"DatabaseError";


@implementation NSError (DatabaseError)
+ (NSError *)fetchRequestError
{
    return [NSError errorWithDomain:kDomainErrorDatabase code:0 userInfo:@{@"message": @"There are no results matching your query."}];
}

+ (NSError *)saveError
{
    return [NSError errorWithDomain:kDomainErrorDatabase code:0 userInfo:@{@"message": @"Could not save your data. Please try again."}];
}

+ (NSError *)removeError
{
    return [NSError errorWithDomain:kDomainErrorDatabase code:2 userInfo:@{@"errorMsg" : @"Remove error  No such entity"}];
}

+ (NSError *)incorrectInstanceError
{
    return [NSError errorWithDomain:kDomainErrorDatabase code:0 userInfo:@{ @"message": @"Unexpected instance given as an argument"}];
}

+ (NSError *)unknownError
{
    return [NSError errorWithDomain:kDomainErrorDatabase code:0 userInfo:@{ @"message": @"An unknown error occured."}];
}


@end
