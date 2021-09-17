//
//  singleton.m
//  test
//
//  Created by 莫玄 on 2021/8/21.
//

#import "singleton.h"

@implementation singleton
static singleton *_instance=nil;
+(void)load
{
    _instance=[[self alloc]init];
}
+(instancetype)sharedSingleton
{
    if(_instance==nil)
    {
        NSException *crash=[NSException exceptionWithName:@"singleton unalloced" reason:@"singleton haven't been alloc and init" userInfo:nil];
        @throw crash;
    }
    return _instance;
}
+(instancetype)alloc
{
    if(_instance)
    {
    NSException *crash=[NSException exceptionWithName:@"sharedInstanceTryToAllocAgain" reason:@"singleton instance only can alloc once" userInfo:nil];
    [crash raise];
    }
    NSLog(@"%s",__func__);
    return [super alloc];
}
-(instancetype)init
{
    NSLog(@"%s",__func__);
    if(self=[super init])
        _name=@"moxuan";
    return self;
}
@end
