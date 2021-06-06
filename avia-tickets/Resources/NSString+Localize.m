//
//  NSString+Localize.m
//  avia-tickets
//
//  Created by Andrey on 06/04/2021.
//

#import <Foundation/Foundation.h>
#import "NSString+Localize.h"

@implementation NSString (Localize)

- (NSString *)localize {
    return NSLocalizedString(self, "");
}

@end


