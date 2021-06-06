//
//  City.h
//  avia-tickets
//
//  Created by Artur Igberdin on 05.03.2021.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface City : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *timezone;
@property (nonatomic, strong) NSDictionary *translations;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *code;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
