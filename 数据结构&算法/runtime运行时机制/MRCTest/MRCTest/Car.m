//
//  Car.m
//  MRCTest
//
//  Created by 莫玄 on 2021/8/21.
//

#import "Car.h"
#import "Engine.h"

@implementation Car
/*-(void)setengine:(Engine *)newEngine
{
    [newEngine retain];//先retain一次传入的新值，以免传入的新值与属性原有的旧值为同一对象时，赋值给属性指针的值为nil；
    [engine release];
    NSLog(@"car engine.rc before=%lu",(unsigned long)[engine retainCount]);
    engine=newEngine;
    NSLog(@"car engine.rc after=%lu",(unsigned long)[engine retainCount]);
}*/

@end
