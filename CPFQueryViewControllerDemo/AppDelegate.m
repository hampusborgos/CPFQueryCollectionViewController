//
//  AppDelegate.m
//  CPFQueryViewControllerDemo
//
//  Created by Hampus Nilsson on 10/8/12.
//  Copyright (c) 2012 FreedomCard. All rights reserved.
//

#import "AppDelegate.h"

#import "ParseAppInfo.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *error = nil;
    
    if (ParseApplicationID.length == 0)
        error = @"Please provide a Parse.com application identifier";
    if (ParseClientKey.length == 0)
        error = @"Please provide a Parse.com client key.";
    
    
    if (error)
    {
        [[NSAssertionHandler currentHandler]
            handleFailureInFunction:@(__PRETTY_FUNCTION__)
                               file:@(__FILE__)
                         lineNumber:__LINE__
                        description:@"%@", error];
        return NO;
    }
    
    // Login to Parse.com
    [Parse setApplicationId:[ParseApplicationID copy]
                  clientKey:[ParseClientKey copy]];
    
    // Create some dummy objects if there are none
    if ([[PFQuery queryWithClassName:@"Foo"] countObjects] == 0)
    {
        for (int i = 0; i < 25; ++i)
        {
            PFObject *testObject = [PFObject objectWithClassName:@"Foo"];
            [testObject setObject:@"Marklar" forKey:@"name"];
            [testObject setObject:@{
                @"red":   @(arc4random_uniform(50) / 100. + 0.5),
                @"green": @(arc4random_uniform(100) / 100.),
                @"blue":  @(arc4random_uniform(100) / 100.)
                } forKey:@"color"];
            [testObject save];
        }
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
