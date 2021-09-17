//
//  AppDelegate.m
//  runloopTestDemo
//
//  Created by 莫玄 on 2021/9/16.
//

#import "AppDelegate.h"
#import "runLoopSource.h"
#import <pthread/pthread.h>
#import "thirdThread.h"
@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.command=[[NSMutableArray alloc]init];
    self.port=[[NSMutableArray alloc]init];
    [self launchSecondaryThread];
    mythirdthread();
  
    return YES;
}
-(void)launchSecondaryThread{
    
    _mySecondaryThread=[[NSThread alloc]initWithTarget:self selector:@selector(mySecondaryThreadEntry) object:nil];
    _mySecondaryThread.name=@"mysecondarythread";
    [_mySecondaryThread setThreadPriority:DISPATCH_QUEUE_PRIORITY_DEFAULT];
    _mySecondaryThread.stackSize=1024*1024;
    [_mySecondaryThread start];
}

-(void)mySecondaryThreadEntry
{
    @autoreleasepool {
       /* NSThread *thread=[NSThread currentThread];
        NSNumber *number=[thread.threadDictionary objectForKey:@"isrunnning"];
       bool isrunning=number.integerValue;
        if(!isrunning)
        {
            NSLog(@"threadDic wrong");
            return;
        }*/
        NSRunLoop *myRunLoop=[NSRunLoop currentRunLoop];
        CFRunLoopRef cfrunloop=[myRunLoop getCFRunLoop];
        //添加observer
        CFRunLoopObserverRef observerForEntry=[self setMyObserverForEntry];
        CFRunLoopAddObserver(cfrunloop, observerForEntry, kCFRunLoopDefaultMode);
        //添加source
        runLoopSource *src=[[runLoopSource alloc]init];
        int loopcount=10;
        [src addToCurrentRunLoop];
        //添加timer
       NSTimer *timer=[[NSTimer alloc]initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0] interval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [myRunLoop addTimer:timer forMode:NSDefaultRunLoopMode];
        do
       {
            [myRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:DISPATCH_TIME_FOREVER]];
            loopcount--;
       }while (loopcount);
        CFRunLoopRemoveSource(cfrunloop, (__bridge CFRunLoopSourceRef)src, kCFRunLoopDefaultMode);
    }
}
//timer callback func
-(void)timerAction
{
    NSLog(@"60 frames pass in 1 sec");
}
-(CFRunLoopObserverRef)setMyObserverForEntry
{
    CFRunLoopObserverContext contex={0,(__bridge void *)(self),NULL,NULL,NULL};
    CFRunLoopObserverRef observerForEntry=CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopEntry, YES, 0, runLoopObserverCallBack, &contex);
    return observerForEntry;
}
void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    NSLog(@"runloop is about to entry");
}

-(void)registerSource:(runLoopSourceContext *)srcInfo
{
    self.ipsc=srcInfo;
}

-(void)removeSource:(runLoopSourceContext *)srcInfo
{
    if(self.ipsc)
        self.ipsc=nil;
}
-(void)commandBufferChanged
{
    if(self.ipsc){
    runLoopSourceContext *context=self.ipsc;
    context.source->command=self.command;
        [context.source fireCommandsOnRunLoop:context.runloop];}
    else
    {
        NSException *exption=[NSException exceptionWithName:@"runloop_erro" reason:@"runloopsource have been removed" userInfo:nil];
        [exption raise];
    }
}
-(void)sendToThirdThead
{
    CFMessagePortRef remoteport=(__bridge CFMessagePortRef)self.port.firstObject;
    CFStringRef stringtotransport=CFStringCreateWithFormat(NULL, NULL,CFSTR("something to show to third thread"));
    CFIndex size=CFStringGetLength(stringtotransport);
    UInt8 *buffer=CFAllocatorAllocate(NULL, size, 0);
    CFStringGetBytes(stringtotransport, CFRangeMake(0, size), kCFStringEncodingASCII, 0, FALSE, buffer, size, NULL);
    CFDataRef data=CFDataCreate(NULL, buffer, size);
    CFMessagePortSendRequest(remoteport, (SInt8)101, data, 0.0, 0.0, NULL, NULL);
    CFRelease(stringtotransport);
    CFAllocatorDeallocate(NULL, buffer);
}







#pragma mark - UISceneSession lifecycle


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


@end
