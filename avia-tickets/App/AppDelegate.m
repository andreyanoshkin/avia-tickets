//
//  AppDelegate.m
//  avia-tickets
//
//  Created by Artur Igberdin on 05.03.2021.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "TabBarController.h"
#import "NotificationService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame: frame];
    
    //MainViewController *viewController = [MainViewController new];
//    MapViewController *mapViewController = [MapViewController new];
//    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
//    [self.window setRootViewController:navigationViewController];
    
    TabBarController *tabBarController = [[TabBarController alloc] init];
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    
    [[NotificationService sharedInstance] registerService];
    
    return YES;
}


@end
