//
//  RunLoopSource.h
//  threadTest
//
//  Created by 莫玄 on 2021/5/23.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface RunLoopInputSource : NSObject
{
    @public
    CFRunLoopSourceRef runLoopSource;
    NSMutableArray *commands;
}
-(instancetype)init;
-(void)addToCurrentRunLoop;
-(void)invalidate;

//Handler method
-(void)sourceFired;

//Clients interface for register commands to process
-(void)addCommandwithData:(id)data;
-(void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop;
@end

//CFRunLoopSourceRef callback functions
void RunLoopSourceScheduleRoutine (void *info,CFRunLoopRef rl,CFStringRef mode);
void RunLoopSourcePerformRoutine (void *info);
void RunLoopSourceCancelRoutine (void *info,CFRunLoopRef rl,CFStringRef mode);

//CFRunLoopContext

@interface RunLoopContext : NSObject
{
    CFRunLoopRef _runLoop;
    RunLoopInputSource *_source;
}
@property (readonly)CFRunLoopRef runloop;
@property (readonly)RunLoopInputSource *source;
-(instancetype)initWithSource:(RunLoopInputSource *)src andLoop:(CFRunLoopRef)loop;
@end
NS_ASSUME_NONNULL_END
