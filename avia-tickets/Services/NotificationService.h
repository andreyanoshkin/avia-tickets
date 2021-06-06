//
//  NotificationService.h
//  avia-tickets
//
//  Created by Andrey on 29/03/2021.
//

#import <Foundation/Foundation.h>

typedef struct Notification {
    __unsafe_unretained NSString *_Nullable title;
    __unsafe_unretained NSString *_Nonnull body;
    __unsafe_unretained NSDate *_Nonnull date;
//    __unsafe_unretained NSURL *_Nullable imageUrl;
} Notification;

NS_ASSUME_NONNULL_BEGIN

@interface NotificationService : NSObject

+(instancetype _Nonnull)sharedInstance;
- (void)registerService;
- (void)sendNotification:(Notification)notification;
Notification NotificationMake(NSString* _Nullable title, NSString* _Nonnull body, NSDate* _Nonnull date);

@end

NS_ASSUME_NONNULL_END

