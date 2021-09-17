//
//  runLoopSource.m
//  runloopTestDemo
//
//  Created by 莫玄 on 2021/9/16.
//

#import "runLoopSource.h"
#import "AppDelegate.h"

@implementation runLoopSource
-(id)init
{
    if(self=[super init]){
    CFRunLoopSourceContext context={0,(__bridge void *)self,NULL,NULL,NULL,NULL,NULL,
                RunLoopSourceScheduleRoutine,
                RunLoopSourceCancelRoutine,
                RunLoopSourcePreformRoutine
    };
    self->runloopsource=CFRunLoopSourceCreate(NULL, 0, &context);
    self->command=[[NSMutableArray alloc]init];
    }
    return self;
}
-(void)addToCurrentRunLoop
{
    CFRunLoopRef cfrunloop=CFRunLoopGetCurrent();
    CFRunLoopAddSource(cfrunloop, self->runloopsource, kCFRunLoopDefaultMode);
}
-(void)removeSelf
{
   // CFRunLoopRef cfrunloop=CFRunLoopGetCurrent();
    CFRunLoopSourceInvalidate(self->runloopsource);
   // CFRunLoopRemoveSource(cfrunloop, self->runloopsource, kCFRunLoopDefaultMode);
}
-(void)sourceFired
{
    NSLog(@"%@",self->command[0]);
    NSLog(@"%s",__func__);
}
-(void)fireCommandsOnRunLoop:(CFRunLoopRef)runloop
{
    CFRunLoopSourceSignal(self->runloopsource);
    CFRunLoopWakeUp(runloop);
}
@end

//当runloop source实际上被添加到runloop时进行调用；
void RunLoopSourceScheduleRoutine(void *info,CFRunLoopRef rl,CFStringRef mode)
{
    runLoopSource *runloopsource=(__bridge runLoopSource *)info;
    runLoopSourceContext *context=[[runLoopSourceContext alloc]initWithsource:runloopsource andLoop:rl];
    dispatch_sync(dispatch_get_main_queue(), ^{
        AppDelegate *del=[[UIApplication sharedApplication] delegate];
        [del registerSource:context];
    });
}
//当input source被signal的时候，调用此函数
void RunLoopSourcePreformRoutine(void *info,CFRunLoopRef rl,CFStringRef mode)
{
    runLoopSource *runloopsource=(__bridge runLoopSource *)info;
    [runloopsource sourceFired];
}
//当在子线程中调用CFRunLoopSourceInvalidate()函数时会调用此函数通知客户线程废弃对此runloopsource的引用；
void RunLoopSourceCancelRoutine(void *info,CFRunLoopRef rl,CFStringRef mode)
{
    runLoopSource *runloopsource=(__bridge runLoopSource *)info;
    runLoopSourceContext *context=[[runLoopSourceContext alloc]initWithsource:runloopsource andLoop:rl];
    dispatch_sync(dispatch_get_main_queue(), ^{
        AppDelegate *del=[[UIApplication sharedApplication] delegate];
        [del removeSource:context];
    });
}



@interface runLoopSourceContext()
@property(readwrite)CFRunLoopRef runloop;
@property(strong,nonatomic)runLoopSource *source;
@end

@implementation runLoopSourceContext:NSObject

-(id)initWithsource:(runLoopSource *)src andLoop:(CFRunLoopRef)loop
{
    if(self=[super init])
    {
        self->runloop=loop;
        self->source=src;
        self.runloop=self->runloop;
        self.source=self->source;
    }
    return self;
}

@end
