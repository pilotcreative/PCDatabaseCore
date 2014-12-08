//
//  PCDatabaseCore_Categories.h
// PCDatabaseCore
//
//  Created by Paweł Nużka on 05.03.2014.
//  Copyright (c) 2014 GoRailsGo. All rights reserved.
//

#import "PCDatabaseCore.h"
#import "PCDatabaseCore+CountEntities.h"
#import "PCDatabaseCore+CreateEntity.h"
#import "PCDatabaseCore+Fetching.h"
#import "PCDatabaseCore+GetEntity.h"
#import "PCDatabaseCore+RemoveEntity.h"
#import "NSError+DatabaseError.h"
#import "NSManagedObject+SafeSetters.h"



/*!
 * All methods that do not take NSManagedContext as a parameter
 * use main context (on main thread) as default
 *
 */

