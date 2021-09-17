//
//  needAClassToDoSomeWork.m
//  dynamicMethodResolution
//
//  Created by 莫玄 on 2021/9/10.
//

#import "needAClassToDoSomeWork.h"
#import <objc/runtime.h>

@implementation needAClassToDoSomeWork
-(void)dosomework2
{
    NSLog(@"you guys force me to do some-work2!");
}
+(BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString *cmd=NSStringFromSelector(sel);
    if([cmd isEqualToString:@"dosomework1"])
    {
        Method method=class_getInstanceMethod(self, @selector(dosomework2));
        IMP imp=method_getImplementation(method);
        const char *types=method_getTypeEncoding(method);
        class_addMethod(self, sel, imp, types);
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
-(void)work{
    NSLog(@"i have to finish this flow so i give a feedback!");
}
@end
