//
//  TicketsViewController.m
//  avia-tickets
//
//  Created by Artur Igberdin on 08.03.2021.
//

#import "TicketsViewController.h"
#import "TicketTableViewCell.h"
#import "CoreDataManager.h"
#import "NotificationService.h"
#import "Ticket.h"
#import "NSString+Localize.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsViewController ()

@property (nonatomic, assign) BOOL isFavorites;
@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) NSArray *ticketsTempArray;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation TicketsViewController
//{
//    BOOL isFavorites;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.isFavorites ? [@"tickets_title" localize] : [@"favourites_title" localize] ;
    self.navigationController.navigationBar.prefersLargeTitles = self.isFavorites;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    if (self. isFavorites) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.tickets = [[CoreDataManager sharedInstance] favorites];
        self.ticketsTempArray = self.tickets;
        [self.tableView reloadData];
    }
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[[@"from_search" localize], [@"from_map" localize]]];
    [_segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
    [self changeSource];
}


#pragma mark - Public

- (instancetype)initFavoriteTicketsController {
    self = [self initWithTickets:@[]];
    self.isFavorites = YES;
    return self;
    
//    if (self) {
//        self.isFavorites = YES;
//        self.tickets = [NSArray new];
//        self.title = @"Избранное";
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
//    }
}

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self)
    {
        self.tickets = tickets;
        //self.title = @"Билеты";
        //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //[self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    }
    return self;
}

#pragma mark - Actions

- (void)changeSource
{
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            [self setAllFavoriteTicketsAddedFromRequest];
            break;
        case 1:
            [self setAllFavoriteTicketsAddedFromMap];
            break;
         default:
             break;
     }
     [self.tableView reloadData];
 }

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
    
    if (self.isFavorites) {
          cell.favoriteTicket = self.tickets[indexPath.row];
      } else {
          cell.ticket = self.tickets[indexPath.row];
      }

    
    //ОШИБКА!!!
    //cell.ticket = self.tickets[indexPath.row];
    return cell;
}

-(void) tableView:(UITableView *) tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        UIView *myView = [cell.contentView viewWithTag:(1)];
         [UIView animateWithDuration:1.2
                      delay:0
                    options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut animations:^
         {
                   [myView setAlpha:0.0];
         } completion:^(BOOL finished)
         {
                   [myView setAlpha:1.0];
         }];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.isFavorites) return;
    if (self.isFavorites) {
        Ticket *ticket = self.tickets[indexPath.row];
        NSString *body = [NSString stringWithFormat:@"%@ (%@)", ticket.from, ticket.to];
        Notification notification = NotificationMake([@"ticket_reminder" localize], body, ticket.departure);
                [[NotificationService sharedInstance] sendNotification:notification];
        
        NSDate *notificationDate = [ticket.departure dateByAddingTimeInterval:-7*24*60*60];

                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[@"success" localize] message:[NSString stringWithFormat:[@"notification_will_be_sent" localize], notificationDate] preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[@"close" localize] style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[@"actions_with_tickets" localize] message:[@"actions_with_tickets_describe" localize] preferredStyle:UIAlertControllerStyleActionSheet];
    
    Ticket *ticket = self.tickets[indexPath.row];
    
    UIAlertAction *favoriteAction;
    if ([[CoreDataManager sharedInstance] isFavorite: ticket]) {
        
        favoriteAction = [UIAlertAction actionWithTitle:[@"remove_from_favorite" localize] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [[CoreDataManager sharedInstance] removeFromFavorite:ticket];
        }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:[@"add_to_favorite" localize] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[CoreDataManager sharedInstance] addToFavorite:ticket];
        }];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[@"close" localize] style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)setAllFavoriteTicketsAddedFromMap {
    NSMutableArray *array = [NSMutableArray new];
    for (FavoriteTicket *ticket in self.ticketsTempArray) {
        if (ticket.isAddedFromMap == YES) {
            [array addObject: ticket];
        }
        self.tickets = array;
    }
}
  
-(void)setAllFavoriteTicketsAddedFromRequest {
    NSMutableArray *array = [NSMutableArray new];
    for (FavoriteTicket *ticket in self.ticketsTempArray) {
        if (ticket.isAddedFromMap == NO) {
            [array addObject: ticket];
        }
        self.tickets = array;
    }
}
    




@end
