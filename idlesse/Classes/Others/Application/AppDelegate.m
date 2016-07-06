//
//  AppDelegate.m
//  idlesse
//
//  Created by 胡知平 on 16/5/29.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "AppDelegate.h"
#import "ZPTabBarController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc] initWithFrame:SCREEN_FRAME];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    ZPTabBarController *tabBarC = [[ZPTabBarController alloc] init];
    _window.rootViewController = tabBarC;
    
    [self setupWebImage];
    
    // ----注册友盟APPKey
    //[UMSocialData setAppKey:UMAPPKey];
    // ----注册SMSAPPKey
    //[SMSSDK registerApp:SMSAPPKey withSecret:SMSAPPSecret];
    // ----注册LeanCloud
    [AVOSCloud setApplicationId:AVCloudAppId
                      clientKey:AVCloudAppKey];
    
//    NSArray *array = @[@"2015年8月-2016年6月", @"2014年10月-2015年7月"];
//    AVObject *todo = [AVObject objectWithClassName:@"userMessage"];
//    [todo setObject:array forKey:@"timeSegment"];
//    [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if(succeeded) return ZPLog(@"成功");
//    }];
    
//    AVQuery *query = [AVQuery queryWithClassName:@"userMessage"];
//    
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        
//        ZPLog(@"%@", objects);
//    }];

    
    
    
    return YES;
}

- (void)setupWebImage {
    
    [[SDImageCache sharedImageCache] setShouldCacheImagesInMemory:NO];
    
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [AVOSCloudSNS handleOpenURL:url];
}

// When Build with IOS 9 SDK
// For application on system below ios 9
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [AVOSCloudSNS handleOpenURL:url];
}
// For application on system equals or larger ios 9
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [AVOSCloudSNS handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
