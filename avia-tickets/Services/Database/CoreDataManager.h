//
//  CoreDataHelper.h
//  avia-tickets
//
//  Created by Artur Igberdin on 19.03.2021.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FavoriteTicket+CoreDataClass.h"
#import "DataManager.h"

@class Ticket;
@class MapPrice;

@interface CoreDataManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (BOOL)isFavoriteMap:(MapPrice *)mapPrice;
- (NSArray <FavoriteTicket *> *)favorites;

- (void)addToFavorite:(Ticket *)ticket;
- (void)addToFavoriteFromMap:(MapPrice *)mapPrice;
- (void)removeFromFavorite:(Ticket *)ticket;
- (void)removeMapPriceFromFavorite:(MapPrice *)mapPrice;

@end
