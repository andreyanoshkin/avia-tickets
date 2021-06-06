//
//  LocationManager.h
//  avia-tickets
//
//  Created by Artur Igberdin on 12.03.2021.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kLocationManagerDidUpdateLocation @"kLocationManagerDidUpdateLocation"

@interface LocationManager : NSObject

@property (nonatomic, readonly) CLLocation *currentLocation;

@end

