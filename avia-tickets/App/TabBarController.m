//
//  TabBarController.m
//  avia-tickets
//
//  Created by Artur Igberdin on 15.03.2021.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "TicketsViewController.h"
#import "NSString+Localize.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewControllers = [self createViewControllers];
        self.tabBar.tintColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Private

- (NSArray<UIViewController *> *)createViewControllers {
    
    NSMutableArray<UIViewController *> *controllers = [NSMutableArray new];
    
    MainViewController *mainViewController = [MainViewController new];
    mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle: [@"search_tab" localize] image:[UIImage imageNamed:@"search"] selectedImage:[UIImage imageNamed:@"search_selected"]];
    UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
   
    [controllers addObject:mainNavigationController];
    
    MapViewController *mapViewController = [MapViewController new];
    mapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@"map_tab" localize] image:[UIImage imageNamed:@"map"] selectedImage:[UIImage imageNamed:@"map_selected"]];
    UINavigationController *mapNavigationViewController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
   
    [controllers addObject:mapNavigationViewController];
    
    TicketsViewController *favoriteViewController = [[TicketsViewController alloc] initFavoriteTicketsController];
    favoriteViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@"favorites_tab"localize] image:[UIImage imageNamed:@"favorite"] selectedImage:[UIImage imageNamed:@"favorite_selected"]];
    
    UINavigationController *favoriteNavigationController = [[UINavigationController alloc] initWithRootViewController:favoriteViewController];
    [controllers addObject:favoriteNavigationController];
    
    return controllers;
}



@end
