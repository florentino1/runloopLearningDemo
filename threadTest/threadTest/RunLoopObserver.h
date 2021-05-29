//
//  threadTesClass.h
//  threadTest
//
//  Created by 莫玄 on 2021/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunLoopObserver : NSObject
@property (assign,nonatomic)NSUInteger i;
-(void)threadMian;
@end

NS_ASSUME_NONNULL_END
