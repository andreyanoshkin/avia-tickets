//
//  PlaceViewController.h
//  avia-tickets
//
//  Created by Artur Igberdin on 05.03.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

typedef enum PlaceType {
    //Прибытие
    PlaceTypeArrival,
    //Отправление
    PlaceTypeDeparture
} PlaceType;

@protocol PlaceViewControllerDelegate <NSObject>
- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType;
@end

@interface PlaceViewController : UITableViewController

@property (nonatomic, strong) id<PlaceViewControllerDelegate>delegate;

- (instancetype)initWithType:(PlaceType)type;

@end

