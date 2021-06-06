//
//  Airport.m
//  avia-tickets
//
//  Created by Artur Igberdin on 05.03.2021.
//

#import "Airport.h"

/*
[{
    "name": "Anaa",
    "time_zone": "Pacific/Tahiti",
    "name_translations": {
        "en": "Anaa",
        "ru": "\u0410\u043d\u0430\u0430",
        "de": "Anaa",
        "tr": "Anaa",
        "th": "\u0e2d\u0e32\u0e19\u0e48\u0e32",
        "it": "Anaa",
        "fr": "Anaa",
        "es": "Anaa",
        "zh-CN": "\u963f\u7eb3\u673a\u573a",
        "pl": "Anaa",
        "pt": "Anaa",
        "pt-BR": "Anaa",
        "lt": "Anaa",
        "jp": "Anaa",
        "zh-Hant": "Anaa",
        "tl": "Anaa",
        "ko": "Anaa",
        "ms": "Anaa",
        "vi": "Anaa",
        "zh-TW": "Anaa",
        "id": "Anaa",
        "ar": "\u202aAnaa\u202c\u200f",
        "uk": "Anaa"
    },
    "country_code": "PF",
    "city_code": "AAA",
    "code": "AAA",
    "flightable": false,
    "coordinates": {
        "lon": -145.41667,
        "lat": -17.05
    }
}]
*/

@implementation Airport

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        _timezone = [dictionary valueForKey:@"time_zone"];
        _translations = [dictionary valueForKey:@"name_translations"];
        _name = [dictionary valueForKey:@"name"];
        _countryCode = [dictionary valueForKey:@"country_code"];
        _cityCode = [dictionary valueForKey:@"city_code"];
        _code = [dictionary valueForKey:@"code"];
        _flightable = [dictionary valueForKey:@"flightable"];
        
        NSDictionary *coords = [dictionary valueForKey:@"coordinates"];
        if (coords && ![coords isEqual:[NSNull null]]) {
            NSNumber *lon = [coords valueForKey:@"lon"];
            NSNumber *lat = [coords valueForKey:@"lat"];
            
            if (![lon isEqual:[NSNull null]] && ![lat isEqual:[NSNull null]]) {
                _coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
            }
        }
    }
    return self;
}

@end
