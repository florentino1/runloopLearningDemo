//
//  AppDelegate.h
//  runloopTestDemo
//
//  Created by 莫玄 on 2021/9/16.
//

#import <UIKit/UIKit.h>
#import "runLoopSource.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property(strong,nonatomic)NSThread *mySecondaryThread;
@property(strong,nonatomic)runLoopSourceContext *ipsc;
@property(strong,nonatomic)NSMutableArray *command;
@property(strong,nonatomic)NSMutableArray *port;
-(void)removeSource:(runLoopSourceContext *)srcInfo;
-(void)registerSource:(runLoopSourceContext *)srcInfo;
-(void)commandBufferChanged;
-(void)sendToThirdThead;
@end

