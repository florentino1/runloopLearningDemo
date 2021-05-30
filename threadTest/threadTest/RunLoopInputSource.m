//
//  RunLoopSource.m
//  threadTest
//
//  Created by 莫玄 on 2021/5/23.
//

#import "RunLoopInputSource.h"
#import "RLAppDelegate.h"

@implementation RunLoopInputSource
-(instancetype)init
{
    CFRunLoopSourceContext context={0,(__bridge void *)(self),NULL,NULL,NULL,NULL,NULL,&RunLoopSourceScheduleRoutine,&RunLoopSourcePerformRoutine,&RunLoopSourceCancelRoutine};
    runLoopSource=CFRunLoopSourceCreate(NULL, 0, &context);
    commands=[[NSMutableArray alloc]init];
    return  self;
}

-(void)addToCurrentRunLoop
{
    CFRunLoopRef runloop=CFRunLoopGetCurrent();
    CFRunLoopAddSource(runloop, runLoopSource, kCFRunLoopDefaultMode);
}

-(void)invalidate
{
    CFRunLoopRef runLoop=CFRunLoopGetCurrent();
    CFRunLoopRemoveSource(runLoop, runLoopSource, kCFRunLoopDefaultMode);
}


-(void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop
{
    if(commands.count>0)
    {
        CFRunLoopSourceSignal(runLoopSource);
                NSLog(@"source is signal to fire");
            CFRunLoopWakeUp(runloop);
        [self sourceFired];
    }
    else
        NSLog(@"No command in buffer!");
}

-(void)sourceFired
{
    NSLog(@"正在处理已被signal的source");
}
-(void)addCommandwithData:(id)data
{
    [commands addObject:data];
    RunLoopSourcePerformRoutine((__bridge void * _Nonnull)self);
}

@end

void RunLoopSourceScheduleRoutine (void *info,CFRunLoopRef rl,CFStringRef mode)
{
    RunLoopInputSource *obj=(__bridge RunLoopInputSource *)info;
    RLAppDelegate *del=[RLAppDelegate sharedAppDelegate];
    RunLoopContext *theContext=[[RunLoopContext alloc]initWithSource:obj andLoop:rl];

    [del performSelectorOnMainThread:@selector(registerSource:) withObject:theContext waitUntilDone:NO];

}
void RunLoopSourcePerformRoutine (void *info)
{
    RunLoopInputSource *obj=(__bridge RunLoopInputSource *)info;
    RLAppDelegate *del=[RLAppDelegate sharedAppDelegate];
    RunLoopContext *theContext=[[RunLoopContext alloc]initWithSource:obj andLoop:CFRunLoopGetCurrent()];
    [del performSelectorOnMainThread:@selector(registerSource:) withObject:theContext waitUntilDone:YES];
}
void RunLoopSourceCancelRoutine (void *info,CFRunLoopRef rl,CFStringRef mode)
{
    RunLoopInputSource *obj=(__bridge RunLoopInputSource*)info;
    RLAppDelegate *del=[RLAppDelegate sharedAppDelegate];
    RunLoopContext *theContext=[[RunLoopContext alloc]initWithSource:obj andLoop:rl];

    [del performSelectorOnMainThread:@selector(removeSource:) withObject:theContext waitUntilDone:YES];
}

@implementation RunLoopContext

-(instancetype)initWithSource:(RunLoopInputSource *)src andLoop:(CFRunLoopRef)loop
{
    self=[super init];
    if(self)
    {
        _runloop=loop;
        _source=src;
    }
    return self;
}

@end
