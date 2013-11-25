//
//  VE_AppDelegate.m
//  ios_presentation
//
//  Created by Vasiliy Erema on 11/24/13.
//  Copyright (c) 2013 Vasil Erema. All rights reserved.
//

#import "VE_AppDelegate.h"
#import "VE_StartVC.h"
#import "VE_SettingsVC.h"
#import "VE_DataBase.h"

@interface VE_AppDelegate ()
@property (nonatomic, strong) UITabBarController *tabBarController;
@end

@implementation VE_AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabBarController = [[UITabBarController alloc] init];
    self.window.rootViewController = self.tabBarController;
    
    NSMutableArray *navControllers = [NSMutableArray array];
    for (Class vcClass in @[[VE_StartVC class], [VE_SettingsVC class]])
    {
        UIViewController *vc = [[vcClass alloc] initWithNibName:nil bundle:nil];
        if ([vc isKindOfClass:[UIViewController class]])
        {
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            [navControllers addObject:nc];
        }
    }
    self.tabBarController.viewControllers = navControllers;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[VE_DataBase sharedDataBase] saveData];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
