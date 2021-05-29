//
//  main.m
//  threadTest
//
//  Created by 莫玄 on 2021/5/23.
//

#import <UIKit/UIKit.h>
#import "RLAppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([RLAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
