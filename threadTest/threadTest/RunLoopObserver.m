//
//  threadTesClass.m
//  threadTest
//
//  Created by 莫玄 on 2021/5/23.
//

#import "RunLoopObserver.h"
#import <math.h>

@implementation RunLoopObserver
-(void)threadMian
{
    _i=0;
    BOOL done=NO;
    NSRunLoop *myRunLoop=[NSRunLoop currentRunLoop];

    CFRunLoopObserverContext context={0,CFBridgingRetain(self),NULL,NULL,0};
    CFRunLoopObserverRef observer=CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0,&observerGetMessage, &context);

    if(observer)
    {
        CFRunLoopRef cfRunLoop=[myRunLoop getCFRunLoop];
        CFRunLoopAddObserver(cfRunLoop, observer, kCFRunLoopDefaultMode);
    }
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(sendMessage) userInfo:nil repeats:YES];
   // [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    do {
        SInt32 result=CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, YES);
        if ((result==kCFRunLoopRunStopped)|| (result==kCFRunLoopRunFinished)) {
            done=YES;
            NSLog(@"runloop has stopped");
        }
    } while (!done);
}
-(void)sendMessage
{
    NSLog(@"这是第%lu次发送定时器消息\n",_i);
    _i++;
    if(_i==3)
    {
        NSRunLoop *MyRunLoop=[NSRunLoop currentRunLoop];
        CFRunLoopRef cfrunloop=[MyRunLoop getCFRunLoop];
        CFRunLoopStop(cfrunloop);
    }
}
void observerGetMessage(CFRunLoopObserverRef observer,CFRunLoopActivity ac,void *info)
{
    NSLog(@"observer's running\n");
}
@end
