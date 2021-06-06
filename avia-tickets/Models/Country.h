//
//  Country.h
//  avia-tickets
//
//  Created by Artur Igberdin on 05.03.2021.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSDictionary *translations;
@property (nonatomic, strong) NSString *code;

- (NSString *)description;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
