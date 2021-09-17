//
//  aclass.m
//  dynamicMethodResolution
//
//  Created by 莫玄 on 2021/9/9.
//

#import "aclass.h"
#import <objc/runtime.h>
#import "needAClassToDoSomeWork.h"

@implementation aclass
//声明不要自动合成_firstName _lastName实例变量及相关访问器方法；
@dynamic firstName,lastName;

-(instancetype)init
{
   if(self=[super init])
   {
       _dic=[[NSMutableDictionary alloc]init];
   }
    return self;
    
}
+(BOOL)resolveInstanceMethod:(SEL)sel
{
   // NSLog(@"开始进行动态方法解析");
    NSString *methodName=NSStringFromSelector(sel);
    if([methodName containsString:@"Name"]){
    if([methodName hasPrefix:@"set"])//setter方法
    {
        class_addMethod(self, sel,(IMP)addSetterMethodByDynamic, "v@:@");//将本条注释掉后，此方法会被多调用一次；
        
    }
    else
    {
        class_addMethod(self, sel, (IMP)addGetterMethodByDynamic,"v@@:");
    }
        return YES;
}
    return [super resolveInstanceMethod:sel];
}
-(id)forwardingTargetForSelector:(SEL)aSelector
{
    if(aSelector==@selector(dosomework1))
    {
        return [needAClassToDoSomeWork alloc];
    }
    return [super forwardingTargetForSelector:aSelector];
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if(aSelector==@selector(dosomework3))
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    return [super methodSignatureForSelector:aSelector];
}
-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL selector=anInvocation.selector;
    NSLog(@"%@",anInvocation.methodSignature);
    if([[needAClassToDoSomeWork alloc]respondsToSelector:selector])
        [anInvocation invokeWithTarget:self];
    else
    {
        anInvocation.selector=@selector(work);
        [anInvocation invokeWithTarget:[needAClassToDoSomeWork alloc]];
    }
}




void addSetterMethodByDynamic(id self,SEL _cmd,id value)
{
    aclass *classType=(aclass *)self;
    NSMutableDictionary *dic=classType.dic;
    //获取所需要设置的键；
    NSString *key=NSStringFromSelector(_cmd);//得到的key是以setName:形式的，需要对string进行处理，得到原始的属性名
    NSMutableString *keyToModify=[key mutableCopy];
    NSString *substring=[keyToModify substringWithRange:NSMakeRange(3,keyToModify.length-4)];//得到除开头set和末尾的:之外的字符串，形似Name
    NSString *lower=[substring substringToIndex:1].lowercaseString;//将首字母转化为小写；
   NSString *res=[substring stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:lower];
    if(value)
        [dic setObject:value forKey:res];
    else
        [dic removeObjectForKey:res];
    
}
id addGetterMethodByDynamic(id self,SEL _cmd)
{
    aclass *classType=(aclass *)self;
    NSMutableDictionary *dic=classType.dic;
    NSString *key=NSStringFromSelector(_cmd);
    //使用KVC的方式获得属性对象；
    return [dic objectForKey:key];
}
@end
