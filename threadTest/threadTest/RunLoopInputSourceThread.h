//
//  RunLoopInputSourceThread.h
//  threadTest
//
//  Created by 莫玄 on 2021/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RunLoopInputSource;
@interface RunLoopInputSourceThread : NSThread
@property (nonatomic,strong)RunLoopInputSource *source;
@end

NS_ASSUME_NONNULL_END
