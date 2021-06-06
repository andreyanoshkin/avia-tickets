//
//  TicketTableViewCell.h
//  avia-tickets
//
//  Created by Artur Igberdin on 08.03.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"

@class FavoriteTicket, Ticket;

@interface TicketTableViewCell : UITableViewCell

@property (nonatomic, strong) Ticket *ticket;

@property (nonatomic, strong) FavoriteTicket *favoriteTicket;

//+ (NSString *)identifier;

@end

