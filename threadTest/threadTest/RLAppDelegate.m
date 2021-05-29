//
//  RLAppDelegate.m
//  threadTest
//
//  Created by 莫玄 on 2021/5/29.
//

#import "RLAppDelegate.h"
#import "RunLoopInputSource.h"
#import "RunLoopInputSourceThread.h"
#import "ViewController.h"

@interface RLAppDelegate ()<UITextViewDelegate>
@property (nonatomic,strong)NSMutableArray* sourcesToPing;//装载sources的数组
@end

@implementation RLAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *viewController = [[ViewController alloc] init];


    viewController.view.backgroundColor=[UIColor redColor];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];

//开始启动InputSource线程；
   [self lauchInputSource];


    return YES;
}

//need to lock安装apple document的书法，此处可能存在数据竞争
+(instancetype)sharedAppDelegate
{
    static RLAppDelegate *del=nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        del=[[RLAppDelegate alloc]init];
    }
                  );
    return del;
}
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        _sourcesToPing=[[NSMutableArray alloc]init];
        _source=[[RunLoopInputSource alloc]init];
    }
    return self;
}
//向sources数组中注册源
-(void)registerSource:(RunLoopContext *)sourceInfo
{
    [_sourcesToPing addObject:sourceInfo];
    NSLog(@"input-source has been registered!");
    [self fireSource];
}
//在sources数组中移除源
-(void)removeSource:(RunLoopContext *)sourceInfo
{
    id objToRemove=nil;
    for(RunLoopContext *context in _sourcesToPing)
    {
        if([context isEqual:sourceInfo])
        {
            objToRemove=context;
            break;
        }
    }
    if(objToRemove)
        [_sourcesToPing removeObject:objToRemove];
}

-(void)lauchInputSource
{
    RunLoopInputSourceThread *IST=[[RunLoopInputSourceThread alloc]init];
    [IST setName:@"myIST"];
    [IST start];
}
- (void)fireSource
{
    if (self.sourcesToPing.count > 0)
    {
        RunLoopContext *context = [self.sourcesToPing lastObject];
        RunLoopInputSource *source = context.source;
        CFRunLoopRef runloop = context.runloop;
        [source fireAllCommandsOnRunLoop:runloop];
        
    }
}
-(void)callClientCommand:(id) command
{
    [self.source addCommandwithData:command];
}
@end
