//
//  RunLoopInputSourceThread.m
//  threadTest
//
//  Created by 莫玄 on 2021/5/23.
//

#import "RunLoopInputSourceThread.h"
#import "RunLoopInputSource.h"
@interface RunLoopInputSourceThread()
@property (assign)NSUInteger count;
@end

@implementation RunLoopInputSourceThread
void observerCallBackFunc(CFRunLoopObserverRef observer,CFRunLoopActivity ac,void *info)
{
    switch (ac) {
            //This activity occurs once for each call to CFRunLoopRun and CFRunLoopRunInMode
        case kCFRunLoopEntry:
            NSLog(@"run loop entry");
            break;
            //Inside the event processing loop before any timers are processed
        case kCFRunLoopBeforeTimers:
            NSLog(@"run loop before timers");
            break;
            //Inside the event processing loop before any sources are processed
        case kCFRunLoopBeforeSources:
            NSLog(@"run loop before sources");
            break;
            //Inside the event processing loop before the run loop sleeps, waiting for a source or timer to fire.
            //This activity does not occur if CFRunLoopRunInMode is called with a timeout of 0 seconds.
            //It also does not occur in a particular iteration of the event processing loop if a version 0 source fires
        case kCFRunLoopBeforeWaiting:
            NSLog(@"run loop before waiting");
            break;
            //Inside the event processing loop after the run loop wakes up, but before processing the event that woke it up.
            //This activity occurs only if the run loop did in fact go to sleep during the current loop
        case kCFRunLoopAfterWaiting:
            NSLog(@"run loop after waiting");
            break;
            //The exit of the run loop, after exiting the event processing loop.
            //This activity occurs once for each call to CFRunLoopRun and CFRunLoopRunInMode
        case kCFRunLoopExit:
            NSLog(@"run loop exit");
            break;
            /*
             A combination of all the preceding stages
             case kCFRunLoopAllActivities:
             break;
             */
        default:
            break;
    }
}
-(void)timePass
{
    NSLog(@"time has passed 2s again");
}
-(void)main
{
    @autoreleasepool {
        NSLog(@"input-source thread has been launched");
        _count=0;
        NSRunLoop *myRunLoop=[NSRunLoop currentRunLoop];
        CFRunLoopRef cfrunloop=[myRunLoop getCFRunLoop];
        self.source=[[RunLoopInputSource alloc]init];
        [self.source addToCurrentRunLoop];

        //add a observer
        CFRunLoopObserverContext context={0,(__bridge void *)self,NULL,NULL,NULL};
        CFRunLoopObserverRef observer=CFRunLoopObserverCreate(NULL, kCFRunLoopAllActivities, YES, 0, &observerCallBackFunc, &context);

        if(observer)
        {
            CFRunLoopAddObserver(cfrunloop, observer, kCFRunLoopDefaultMode);
        }

        //add a timer source
        NSDate *date=[NSDate dateWithTimeIntervalSinceNow:1.0];
        NSTimer *timer=[[NSTimer alloc]initWithFireDate:date interval:2 target:self selector:@selector(timePass) userInfo:nil repeats:YES];
        [myRunLoop addTimer:timer forMode:NSDefaultRunLoopMode];

        BOOL done=NO;
        while (!done) {
            //runloop run!
            NSLog(@"input-source thread will run soon\n");
            NSUInteger result=CFRunLoopRunInMode(kCFRunLoopDefaultMode,50, YES);
            _count++;
            if(result==kCFRunLoopRunFinished || result== kCFRunLoopRunStopped)
            NSLog(@"input-source thread exited\n");
            if(_count==30000)
            {
                //run until _count==3;
                CFRunLoopStop(cfrunloop);
                done=YES;
            }
        }
        NSLog(@"finish input-source thread\n");
    }
}
@end
