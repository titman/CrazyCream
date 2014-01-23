//
//  AppDelegate.m
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-7.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import "AppDelegate.h"
#import "CICGameEntry.h"

@implementation AppDelegate
{
    SPView * _sparrowView;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [SPAudioEngine start];
    [SPStage setSupportHighResolutions:YES];
    
    self.gameEntry = [CICGameEntry build];
    
    float deviceHeight = LC_DEVICE_HEIGHT + 20;
    
    _sparrowView = [[SPView alloc] initWithFrame:CGRectMake(0, deviceHeight/2 - 480/2, 320, 480)];
    _sparrowView.backgroundColor = [UIColor clearColor];
    _sparrowView.multipleTouchEnabled = YES;
    _sparrowView.frameRate = 60;
    _sparrowView.stage = self.gameEntry;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self.window addSubview:_sparrowView];
    [_sparrowView release];
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [_sparrowView stop];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [_sparrowView start];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [SPPoint purgePool];
    [SPRectangle purgePool];
    [SPMatrix purgePool];
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

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
