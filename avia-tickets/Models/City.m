//
//  City.m
//  avia-tickets
//
//  Created by Artur Igberdin on 05.03.2021.
//

#import "City.h"

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
        "zh-CN": "\u963f\u7eb3",
        "pl": "Anaa",
        "pt": "Anaa",
        "pt-BR": "Anaa",
        "lt": "Anaa",
        "jp": "\u30a2\u30ca\u30fc\u5cf6",
        "zh-Hant": "\u963f\u7d0d\u74b0\u7901",
        "tl": "Anaa",
        "ko": "Anaa",
        "ms": "Anaa",
        "vi": "Anaa",
        "zh-TW": "\u963f\u7d0d\u74b0\u7901",
        "id": "Anaa",
        "ar": "\u0623\u0646\u0627",
        "uk": "Anaa"
    },
    "country_code": "PF",
    "code": "AAA",
    "coordinates": {
        "lon": -145.41667,
        "lat": -17.05
    }
}]
*/

@implementation City

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        _timezone = [dictionary valueForKey:@"time_zone"];
        _translations = [dictionary valueForKey:@"name_translations"];
        _name = [dictionary valueForKey:@"name"];
        _countryCode = [dictionary valueForKey:@"country_code"];
        _code = [dictionary valueForKey:@"code"];
        
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
