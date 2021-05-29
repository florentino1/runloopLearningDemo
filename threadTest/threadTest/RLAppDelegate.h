//
//  RLAppDelegate.h
//  threadTest
//
//  Created by 莫玄 on 2021/5/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RunLoopContext;
@class RunLoopInputSource;

@interface RLAppDelegate : UIResponder<UIApplicationDelegate>
@property (strong,nonatomic)UIWindow *window;
@property (strong,nonatomic)RunLoopInputSource *source;

-(void)registerSource:(RunLoopContext *)sourceInfo;
-(void)removeSource:(RunLoopContext *)sourceInfo;
-(void)callClientCommand:(id) command;
+(instancetype)sharedAppDelegate;
- (void)fireSource;
@end

NS_ASSUME_NONNULL_END
