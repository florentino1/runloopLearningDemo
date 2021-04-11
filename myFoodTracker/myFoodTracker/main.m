//
//  main.m
//  myFoodTracker
//
//  Created by 莫玄 on 2021/4/10.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "singleMeal.h"
#import "DBManager.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
/*  数据库测试代码
    DBManager *manager=[DBManager sharedDBManager];
    [manager initDB];
    UIImage *photo=[UIImage imageNamed:@"test"];
    singleMeal *meal=[[singleMeal alloc]initWithName:@"testMeal" Photo:photo andRating:3];
    [manager showDB];
    [manager deleteMeal:@"testMeal"];
    [manager insertMealName:meal.mealName mealRating:meal.mealRating];
    [manager showDB];

*/
    

















    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
