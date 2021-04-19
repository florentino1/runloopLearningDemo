//
//  AppDelegate.m
//  myWhitePonyWeather
//
//  Created by 莫玄 on 2021/4/13.
//

#import "AppDelegate.h"
#import <PKRevealController.h>
#import "leftViewController/leftViewController.h"
#import "mainViewController.h"
#import "DBManager.h"


@interface AppDelegate ()<PKRevealing>
@property (strong,nonatomic)PKRevealController *revealViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];

    mainViewController *viewController=[[mainViewController alloc]initWithNibName:@"mainViewController" bundle:[NSBundle mainBundle]];
    
    UINavigationController *mainNavigationController=[[UINavigationController alloc]initWithRootViewController:viewController];
    leftViewController *sideviewController=[self creatLeftViewController];
    self.revealViewController=[PKRevealController revealControllerWithFrontViewController:mainNavigationController leftViewController:sideviewController];
    self.revealViewController.delegate=self;
    self.window.rootViewController=self.revealViewController;
    [self.window makeKeyAndVisible];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^
                   {
        DBManager *manager=[DBManager sharedDB];
        [manager initDB];
    });
    return YES;
}
-(leftViewController *)creatLeftViewController
{
    leftViewController *ViewController=[[leftViewController alloc]initWithNibName:@"leftViewController" bundle:[NSBundle mainBundle]];
    return ViewController;

}
-(void)showLeftViewController
{
    [self.revealViewController showViewController:self.revealViewController.leftViewController animated:true completion:nil];
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
