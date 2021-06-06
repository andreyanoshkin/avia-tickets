//
//  CoreDataHelper.m
//  avia-tickets
//
//  Created by Artur Igberdin on 19.03.2021.
//

#import "CoreDataManager.h"
#import "Ticket.h"
#import "MapPrice.h"

@interface CoreDataManager ()

@property (readonly, strong) NSPersistentContainer *persistentContainer;
//@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end

@implementation CoreDataManager

+ (instancetype)sharedInstance
{
    static CoreDataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataManager alloc] init];
        //[instance setup];
    });
    return instance;
}

#pragma mark - Core Data Stack
@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"FavoriteTicket"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
       
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
    
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}



#pragma mark - Private

//- (void)setup {
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FavoriteTicket" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//
//    NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//    NSURL *storeURL = [docsURL URLByAppendingPathComponent:@"base.sqlite"];
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
//
//    NSPersistentStore* store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
//    if (!store) {
//        abort();
//    }
//
//    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
//}

//- (void)save {
//    NSError *error;
//    [_managedObjectContext save: &error];
//    if (error) {
//        NSLog(@"%@", [error localizedDescription]);
//    }
//}

#pragma mark - Public

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket {
    
    NSError *error;
    NSFetchRequest *request = [FavoriteTicket fetchRequest];
    
    NSString *format = @"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld";
    request.predicate = [NSPredicate predicateWithFormat:format, (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
    NSArray *tickets = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
        return nil;
    }
        
    return tickets.firstObject;
    
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
//    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
//    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
    
}

- (FavoriteTicket *)favoriteFromMapPrice:(MapPrice *)mapPrice {
    
    NSError *error;
    NSFetchRequest *request = [FavoriteTicket fetchRequest];
    
    NSString *format = @"price == %ld AND airline == %@ AND departure == %@";
    request.predicate = [NSPredicate predicateWithFormat:format, (long)mapPrice.value, mapPrice.airline,
//                         mapPrice.from, mapPrice.to,
                         mapPrice.departure
//                         mapPrice.expires,
//                         (long)mapPrice.flightNumber.integerValue
                         ];
    NSArray *mapPrices = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
        return nil;
    }
        
    return mapPrices.firstObject;
    
}

- (BOOL)isFavorite:(Ticket *)ticket {
    return [self favoriteFromTicket:ticket] != nil;
}

- (BOOL)isFavoriteMap:(MapPrice *)mapPrice {
    return [self favoriteFromMapPrice:mapPrice] != nil;
}

- (void)addToFavorite:(Ticket *)ticket {

    FavoriteTicket *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:self.persistentContainer.viewContext];
    
    favorite.price = ticket.price.intValue;
    favorite.airline = ticket.airline;
    favorite.departure = ticket.departure;
    favorite.expires = ticket.expires;
    favorite.flightNumber = ticket.flightNumber.intValue;
    favorite.returnDate = ticket.returnDate;
    favorite.from = ticket.from;
    favorite.to = ticket.to;
    favorite.created = [NSDate date];
    favorite.isAddedFromMap = NO;
    
    [self saveContext];
}

- (void)addToFavoriteFromMap:(MapPrice *)mapPrice {

    FavoriteTicket *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:self.persistentContainer.viewContext];
    
    favorite.price = mapPrice.value;
    favorite.airline = mapPrice.airline;
    favorite.departure = mapPrice.departure;
    favorite.expires = [NSDate date];
    favorite.flightNumber = 0;
    favorite.returnDate = mapPrice.returnDate;
    favorite.from = mapPrice.origin.code;
    favorite.to = mapPrice.destination.code;
    favorite.created = [NSDate date];
    favorite.isAddedFromMap = YES;
    
    [self saveContext];
}

- (void)removeFromFavorite:(Ticket *)ticket {
    FavoriteTicket *favorite = [self favoriteFromTicket:ticket];
    if (favorite) {
        [self.persistentContainer.viewContext deleteObject:favorite];
        [self saveContext];
    }
}

- (void)removeMapPriceFromFavorite:(MapPrice *)mapPrice {
    FavoriteTicket *favorite = [self favoriteFromMapPrice:mapPrice];
    if (favorite) {
        [self.persistentContainer.viewContext deleteObject:favorite];
        [self saveContext];
    }
}


- (NSArray *)favorites {
    NSError *error;
    NSFetchRequest *request = [FavoriteTicket fetchRequest];
    request.sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]
    ];
    
    NSArray *tickets = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    return tickets;
    
//    //NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
//    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
//    return [_managedObjectContext executeFetchRequest:request error:nil];
}


@end
