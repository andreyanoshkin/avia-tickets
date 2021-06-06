//
//  TicketsViewController.h
//  avia-tickets
//
//  Created by Artur Igberdin on 08.03.2021.
//

#import <UIKit/UIKit.h>

@interface TicketsViewController : UITableViewController

- (instancetype)initWithTickets:(NSArray *)tickets;

- (instancetype)initFavoriteTicketsController;

@end

