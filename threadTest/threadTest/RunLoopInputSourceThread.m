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
-(void)main
{
    @autoreleasepool {
        NSLog(@"input-source thread has been launched");
        _count=0;
        NSRunLoop *myRunLoop=[NSRunLoop currentRunLoop];
        CFRunLoopRef cfrunloop=[myRunLoop getCFRunLoop];
        self.source=[[RunLoopInputSource alloc]init];
        [self.source addToCurrentRunLoop];
        BOOL done=NO;
        while (!done) {
            //runloop run!
            NSLog(@"input-source thread will run soon\n");
            NSUInteger result=CFRunLoopRunInMode(kCFRunLoopDefaultMode,5000, YES);
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
