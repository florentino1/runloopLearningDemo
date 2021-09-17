//
//  main.m
//  MRCTest
//
//  Created by 莫玄 on 2021/8/21.
//

#import <Foundation/Foundation.h>
#import "Car.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Car * newcar=[[Car alloc]init];
        NSLog(@"rc=%lu",newcar.retainCount);
        
        NSMutableArray  *array=[NSMutableArray array];
        NSLog(@"rc=%lu",array.retainCount);
        [array retain];
        NSLog(@"rc=%lu",array.retainCount);
        
    }
    return 0;
}
