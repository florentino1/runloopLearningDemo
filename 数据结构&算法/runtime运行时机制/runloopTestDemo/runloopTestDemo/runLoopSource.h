//
//  runLoopSource.h
//  runloopTestDemo
//
//  Created by 莫玄 on 2021/9/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface runLoopSource : NSObject
{
    @public
    CFRunLoopSourceRef runloopsource;
    NSMutableArray *command;
}
-(id)init;
-(void)addToCurrentRunLoop;
-(void)removeSelf;
-(void)sourceFired;
-(void)fireCommandsOnRunLoop:(CFRunLoopRef)runloop;
@end



void RunLoopSourceScheduleRoutine(void *info,CFRunLoopRef rl,CFStringRef mode);
void RunLoopSourcePreformRoutine(void *info,CFRunLoopRef rl,CFStringRef mode);
void RunLoopSourceCancelRoutine(void *info,CFRunLoopRef rl,CFStringRef mode);




@interface runLoopSourceContext : NSObject
{
    CFRunLoopRef runloop;
    runLoopSource *source;
}
@property(readonly)CFRunLoopRef runloop;
@property(readonly)runLoopSource *source;
-(id)initWithsource:(runLoopSource *)src andLoop:(CFRunLoopRef)loop;
@end






NS_ASSUME_NONNULL_END
