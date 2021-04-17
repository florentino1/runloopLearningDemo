//
//  AppDelegate.m
//  myWhitePonyWeather
//
//  Created by 莫玄 on 2021/4/13.
//

#import "AppDelegate.h"
#import <PKRevealController.h>
#import "leftViewController/leftViewController.h"

@interface AppDelegate ()<PKRevealing>
@property (strong,nonatomic)PKRevealController *revealViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];

    UIViewController *mainViewController=[[UIViewController alloc]init];
    mainViewController.view.backgroundColor=[UIColor whiteColor];
    mainViewController.navigationItem.title=@"开始进行定位...";

    UINavigationController *mainNavigationController=[[UINavigationController alloc]initWithRootViewController:mainViewController];
    leftViewController *viewController=[self creatLeftViewController];
    self.revealViewController=[PKRevealController revealControllerWithFrontViewController:mainNavigationController leftViewController:viewController];
    self.revealViewController.delegate=self;
    self.window.rootViewController=self.revealViewController;
    [self.window makeKeyAndVisible];
    return YES;
}
-(leftViewController *)creatLeftViewController
{
    leftViewController *ViewController=[[leftViewController alloc]initWithNibName:@"leftViewController" bundle:[NSBundle mainBundle]];
    return ViewController;

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
