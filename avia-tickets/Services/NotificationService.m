//
//  NotificationCenter.m
//  avia-tickets
//
//  Created by Andrey on 29/03/2021.
//

// NotificationService.m

#import "NotificationService.h"
#import <UserNotifications/UserNotifications.h>

@interface NotificationService () <UNUserNotificationCenterDelegate>

@end

@implementation NotificationService

+ (instancetype)sharedInstance {
    static NotificationService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[NotificationService alloc] init];
    });
    return service;
}

- (void)registerService {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setDelegate:self];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Access hasn't been granted.");
        }
    }];
}

- (void)sendNotification:(Notification)notification {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = notification.title;
    content.body = notification.body;
    content.sound = [UNNotificationSound defaultSound];
    
//    if (notification.imageUrl) {
//        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"image"
//                                                                                              URL:notification.imageUrl
//                                                                                          options:nil
//                                                                                            error:nil];
//        if (attachment) {
//            content.attachments = @[attachment];
//        }
//    }
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar componentsInTimeZone:[NSTimeZone systemTimeZone] fromDate:notification.date];
    NSDateComponents *newComponents = [[NSDateComponents alloc] init];
    newComponents.calendar = calendar;
    newComponents.timeZone = [NSTimeZone defaultTimeZone];
    newComponents.month = components.month;
    newComponents.day = components.day;
    newComponents.hour = components.hour;
    newComponents.minute = components.minute;
    newComponents.second = components.second;
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:newComponents repeats:NO];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Notification" content:content trigger:trigger];
    [center addNotificationRequest:request withCompletionHandler:nil];
}

Notification NotificationMake(NSString* _Nullable title, NSString* _Nonnull body, NSDate* _Nonnull date) {
    Notification notification;
    notification.title = title;
    notification.body = body;
    notification.date = date;
//    notification.imageUrl = url;
    
    return notification;
}

@end


