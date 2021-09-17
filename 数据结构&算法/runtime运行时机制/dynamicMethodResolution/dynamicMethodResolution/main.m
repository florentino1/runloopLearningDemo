//
//  main.m
//  dynamicMethodResolution
//
//  Created by 莫玄 on 2021/9/9.
//

#import <Foundation/Foundation.h>
#import "aclass.h"
#import "needAClassToDoSomeWork.h"
extern void instrumentObjcMessageSends(BOOL);
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        aclass *a=[[aclass alloc]init];
        a.firstName=@"mo";
        a.lastName=@"xuan";
        NSLog(@"firstName:%@ lastName:%@ ",a.firstName,a.lastName);
        //instrumentObjcMessageSends(true);
        [a performSelector:@selector(dosomework3)];
       // instrumentObjcMessageSends(false);
        needAClassToDoSomeWork *b=[[needAClassToDoSomeWork alloc]init];
        NSMethodSignature *sig1=[a methodSignatureForSelector:@selector(init)];
        NSMethodSignature *sig2=[b methodSignatureForSelector:@selector(dosomework2)];
        NSMethodSignature *sig3=[b methodSignatureForSelector:@selector(work)];
        NSLog(@"sig1:%@",sig1);
        NSLog(@"sig2:%@",sig2);
        NSLog(@"sig3:%@",sig3);
    }
    return 0;
}
