

# About
**PCDatabaseCore** is a core Data wrapper written in Objective-C. The library supplies you with many convienient methods to create, fetch and delete entities. It supports concurency and it's very easy to use.    


# Database structure

The database structure is based on Florian Kugler's context scheme as described in his
[article](http://floriankugler.com/blog/2013/4/2/the-concurrent-core-data-stack)


# Instalation

Install the library with CocoaPods.

If you encounter linking problems for the test target, please see this [post](http://stackoverflow.com/questions/14512792/libraries-not-found-when-using-cocoapods-with-ios-logic-tests)



# Library usage  

### Accesing library

To access **PCDatabaseCore** simply add the following lines to your header file:
    
	#import <PCDatabaseCore.h>
	#import <PCDatabaseCore_Categories.h>
	


For most convienient use of the **PCDatabaseCore** library, create your own class that subclasses **PCDatabaseCore**. **PCDatabaseCore** is implemented as singleton so should your subclass. For further reference please see an example app.

Place the following piece of code in AppDelegate didFinishLaunchingWithOptions method

    [PCDatabaseCore initWithName:@"DatabaseName"]

This will create "DatabaseName.sqlite" database.
If you would like to change the type of the database to xml or plist, in your subclass override the following function:

	- (void)setDatabaseName:(NSString *)databaseName
  
 
In all places of application you can easily access the database by calling:

    [PCDatabaseCore sharedInstance]

### Swift Integration

Simply use cocoapods and add following lines to Objective-C bridging header:

	#import <PCDatabaseCore.h>
	#import <PCDatabaseCore_Categories.h>
   
To create Swift sublcass create new class:

```Swift

import Foundation

class PCDatabase : PCDatabaseCore {
	private class var sharedInstance : PCDatabase {
	        struct Singleton {
	            static let databaseInstance = PCDatabase.initWithName("<#DatabaseName#>")
	        }
	        return Singleton.databaseInstance
	    }
    
    override public class func sharedInstance() -> PCDatabase{
        return sharedInstance
    }
}
```
   
### Creating entities
#### Main thread
To implemenent a method that creates your custom entities use:
     
	 [PCDatabaseCore sharedInstance] createEntity:@"EntityNameAsDefinedInModel"]

or in your subclass of PCDatabaseCore: 

    [self createEntity:@"EntityNameAsDefinedInModel"]

This method call will create an entity of class *EntityNameAsDefinedInModel* on the main context in the main thread. 

To instantiante an entity in a specified context use:
    
	- (NSManagedObject *)createEntity:(NSString *)entityName inContext:(NSManagedObjectContext *)context 

#### Saving entities to the database

The methods above create entities in context memory but they are not saving it on the local database. It's your's responsibility to save them by calling

    - (NSError)saveDatabase 

e.g.
   
    [[PCDataseCore sharedInstance] saveDatabase] 

for objects saved in main context.

If you used your own contexts, remember to call 

	[context save:&error]
	

#### Background thread

For better performance it's recommended to save bigger chunk of data, e.g. array of objects that came as a response from the server. 

If the entities you wish to create have an unique index key, to create an array of those entities and automaticaly save them to the local datebase asynchronously on the background thread, please use the following convienient method:

	- (void)createEnitites:(NSString *)entityName
	            withValues:(NSArray *)valuesArray
	                forKey:(id)key
	          inBackground:(void (^)(NSArray *))success
	               failure:(ErrorHandleBlock)failure;


e.g.
     
	 PCDatabaseCore *sharedInstance = [PCDatabaseCore sharedInstance];
	 [sharedInstance createEntities:@"EntityNameAsDefinedInModel"
	 					 withValues:@[@1, @2, @3]
						 	 forKey:@"index"
					   inBackground:^(NSArray *) {
        <#code#>
    } failure:^(NSError *error) {
        <#code#>
    }];


This function implements *insert or update algorithm* as described by Apple [here](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreData/Articles/cdImporting.html)   

There are many others convienient methods to create entities. Please see  *PCDatabaseCore+CreateEntity.h*

### Fetching entities
In order to fetch data from the database you can use convienient methods defined in *PCDatabaseCore+Fetching.h* 

####Fetching on the main thread

Firstly you have to define your search conditions and create a fetch request

    - (NSFetchRequest *)fetchedManagedObjectsForEntity:(NSString *)entityName
	                                     withPredicate:(NSPredicate *)predicate
	                                  withSortingByKey:(NSString *)key;

Then pass the resulting fetchRequest to create *NSFetchedResultController*
	
	- (NSFetchedResultsController *)performFetchWithRequest:(NSFetchRequest *)fetchRequest
	                                                  error:(NSError **)error;

or *NSArray*
  
	- (NSArray *)fetchArrayWithRequest:(NSFetchRequest *)fetchRequest error:(NSError **)error;
    

#### Asynchronous fetch

To perform a fetch in the background, use the following method

    - (void)fetchedManagedObjectsForEntity:(NSString *)entityName
                             withPredicate:(NSPredicate *)predicate
                          withSortingByKey:(NSString *)key
                                 ascending:(BOOL)asc
                              inBackground:(void(^)(NSFetchedResultsController *results))success
                                     error:(ErrorHandleBlock)failure;
    

### Deleting entities

Please see *PCDatabaseCore+RemoveEntity.h* for full list of functions that delete entities.

#### Deleting on the main thread

To delete an entity on the main thread:
	
	- (NSError *)removeEntity:(NSManagedObject *)entity;
    

#### Deleting on the background thread

    - (void)removeEntities:(NSArray *)events
       	 	  inBackground:(void (^)())success
              	   failure:(ErrorHandleBlock)failure;


### Testing

To obtain an instance of **PCDatabaseCore** for tests please use the following method:

    
	[PCDatabase sharedInstanceForTests];

It creates a dedicated database for test target. Remember to clear the database and remove all the data in the tear down method to make sure that each test is performed in the same environment.   

e.g.

	 - (void)setUp
	 {
	     [super setUp];
	     self.pcSharedInstance = [PCDatabaseCore sharedInstanceForTests];
	 }
	 - (void)tearDown
	 {
	     [self.pcSharedInstance removeAllDataFromDatabase];
	     self.pcSharedInstance = nil;
	     [super tearDown];
	 }
