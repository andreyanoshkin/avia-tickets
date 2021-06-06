//
//  SearchRequest.h
//  avia-tickets
//
//  Created by Artur Igberdin on 05.03.2021.
//

#import <Foundation/Foundation.h>

typedef struct SearchRequest {
    __unsafe_unretained NSString *origin;
    __unsafe_unretained NSString *destionation;
    __unsafe_unretained NSDate *departDate;
    __unsafe_unretained NSDate *returnDate;
} SearchRequest;
