//
//  Country.m
//  avia-tickets
//
//  Created by Artur Igberdin on 05.03.2021.
//

#import "Country.h"

/*
[{
    "name": "Dominica",
    "currency": "XCD",
    "name_translations": {
        "en": "Dominica",
        "ru": "\u0414\u043e\u043c\u0438\u043d\u0438\u043a\u0430",
        "de": "Dominica",
        "tr": "Dominika",
        "th": "\u0e42\u0e14\u0e21\u0e34\u0e19\u0e34\u0e01\u0e32",
        "it": "Dominica",
        "fr": "Dominique",
        "es": "Dominica",
        "zh-CN": "\u591a\u7c73\u5c3c\u514b",
        "pl": "Dominika",
        "pt": "Dom\u00ednica",
        "pt-BR": "Dominica",
        "lt": "Dominica",
        "jp": "\u30c9\u30df\u30cb\u30ab\u56fd",
        "zh-Hant": "\u591a\u7c73\u5c3c\u514b",
        "tl": "Dominica",
        "ko": "\ub3c4\ubbf8\ub2c8\uce74",
        "ms": "Dominika",
        "vi": "Dominica",
        "zh-TW": "\u591a\u7c73\u5c3c\u514b",
        "id": "Dominika",
        "ar": "\u062f\u0648\u0645\u064a\u0646\u064a\u0643\u0627",
        "uk": "\u0414\u043e\u043c\u0456\u043d\u0456\u043a\u0430"
    },
    "code": "DM"
}]
*/

@implementation Country

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _currency = [dictionary valueForKey:@"currency"];
        _translations = [dictionary valueForKey:@"name_translations"];
        _name = [dictionary valueForKey:@"name"];
        _code = [dictionary valueForKey:@"code"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@", _name, _currency, _code];
}

@end
