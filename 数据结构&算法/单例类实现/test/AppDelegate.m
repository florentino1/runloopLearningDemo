//
//  AppDelegate.m
//  test
//
//  Created by 莫玄 on 2021/8/21.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions
{
    printf("1\n");
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    printf("2\n");
    return YES;
}
-(void)applicationWillEnterForeground:(UIApplication *)application
{
    printf("3\n");
}
-(void)applicationDidBecomeActive:(UIApplication *)application
{

}
-(void)applicationWillResignActive:(UIApplication *)application
{}
-(void)applicationDidEnterBackground:(UIApplication *)application
{}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{

}
#pragma mark - UISceneSession lifecycle
/*

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

*/
@end
