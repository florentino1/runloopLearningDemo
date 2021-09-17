//
//  thirdThread.h
//  runloopTestDemo
//
//  Created by 莫玄 on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface thirdThread : NSObject

@end


void mythirdthread(void);
void posixthreadsetandstart(void *info);
CFDataRef mainthreadportcallbackhandler(CFMessagePortRef local,SInt32 msgid,CFDataRef data,void *info);
void thirdThreadEntry(void *portname);
CFDataRef processmaintheadrequesthandler(CFMessagePortRef local,SInt32 msgid,CFDataRef data,void *info);






NS_ASSUME_NONNULL_END
