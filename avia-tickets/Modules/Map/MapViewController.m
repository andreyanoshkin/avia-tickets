//
//  MapViewController.m
//  avia-tickets
//
//  Created by Artur Igberdin on 12.03.2021.
//

#import "MapViewController.h"

#import "LocationManager.h"
#import "APIManager.h"
#import "MapPrice.h"
#import "CoreDataManager.h"
#import "NSString+Localize.h"

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [@"map_tab" localize];
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate=self;
    [self.view addSubview:self.mapView];
    
    [[DataManager sharedInstance] loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationManagerDidUpdateLocation object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)dataLoadedSuccessfully {
    self.locationManager = [[LocationManager alloc] init];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    MKPointAnnotation *tappedAnnotation = (MKPointAnnotation *)view.annotation;
    
    for (MapPrice *mapPrice in self.prices) {
        NSString* priceId = [NSString stringWithFormat:@"%@ (%@)", mapPrice.destination.name, mapPrice.destination.code];
        
        
        
//        if (priceId == tappedAnnotation.title) {
        if ([tappedAnnotation.title containsString: priceId]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[@"actions_with_tickets" localize] message:[@"actions_with_tickets_describe" localize] preferredStyle:UIAlertControllerStyleActionSheet];
            
//            Ticket *ticket = self.tickets[indexPath.row];
            
            UIAlertAction *favoriteAction;
            if ([[CoreDataManager sharedInstance] isFavoriteMap: mapPrice]) {
                
                favoriteAction = [UIAlertAction actionWithTitle:[@"remove_from_favorite" localize] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                    [[CoreDataManager sharedInstance] removeMapPriceFromFavorite:mapPrice];
                }];
            } else {
                favoriteAction = [UIAlertAction actionWithTitle:[@"add_to_favorite" localize] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [[CoreDataManager sharedInstance] addToFavoriteFromMap:mapPrice];
                }];
            }
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[@"close" localize] style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:favoriteAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    
    
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion: region animated: YES];
    
    if (currentLocation) {
        _origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
        if (_origin) {
            
            [[APIManager sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    static NSString *identifier = @"AnnotationIdentifer";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (annotationView) {
        annotationView.annotation = annotation;
    } else {
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(0.0, 5.0);
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    return annotationView;
}

- (void)setPrices:(NSArray *)prices {
    _prices = prices;
    [self.mapView removeAnnotations: self.mapView.annotations];
 
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld руб.", (long)price.value];
            annotation.coordinate = price.destination.coordinate;
            [self.mapView addAnnotation: annotation];
        });
    }
}


@end
