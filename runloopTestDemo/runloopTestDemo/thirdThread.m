//
//  thirdThread.m
//  runloopTestDemo
//
//  Created by 莫玄 on 2021/9/17.
//

#import "thirdThread.h"
#import <pthread/pthread.h>
#import "AppDelegate.h"

@implementation thirdThread

@end

void mythirdthread(void)
{
    Boolean shouldfreeinfo;
    CFMessagePortContext context={0,NULL,NULL,NULL,NULL};
    CFStringRef myportname=CFStringCreateWithFormat(NULL, NULL, CFSTR("mainthreadlocalport"));
    
    CFMessagePortRef myport=CFMessagePortCreateLocal(NULL, myportname, mainthreadportcallbackhandler, &context, &shouldfreeinfo);
    if(myport!=NULL)
    {
        CFRunLoopSourceRef rlsrc=CFMessagePortCreateRunLoopSource(NULL, myport, 0);
        if(rlsrc)
        {
            CFRunLoopAddSource(CFRunLoopGetCurrent(), rlsrc, kCFRunLoopDefaultMode);
            CFRelease(myport);
            CFRelease(rlsrc);
        }
    }
    void *info=myportname;
    posixthreadsetandstart(info);
}

void posixthreadsetandstart(void *info)
{
    pthread_t tid;
    pthread_attr_t attr;
    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    pthread_create(&tid, &attr, thirdThreadEntry, info);
    pthread_attr_destroy(&attr);
}

CFDataRef mainthreadportcallbackhandler(CFMessagePortRef local,SInt32 msgid,CFDataRef data,void *info)
{
    if(msgid==100)
    {
        CFIndex bufferlength=CFDataGetLength(data);
        UInt8 *buffer=CFAllocatorAllocate(NULL, bufferlength, 0);
        CFDataGetBytes(data, CFRangeMake(0, bufferlength), buffer);
        CFStringRef thirdthreadportname=CFStringCreateWithBytes(NULL, buffer, bufferlength, kCFStringEncodingASCII, FALSE);
        
        CFMessagePortRef remoteport=CFMessagePortCreateRemote(NULL, thirdthreadportname);
        if(remoteport)
        {
            NSLog(@"maint thread have recieve thirdthread message");
            AppDelegate *del=[[UIApplication sharedApplication]delegate];
            NSMessagePort *remoteMessagePort=(__bridge NSMessagePort*)remoteport;
            [del.port addObject:remoteMessagePort];
            CFRelease(remoteport);
        }
        CFRelease(thirdthreadportname);
        CFAllocatorDeallocate(NULL, buffer);
    }
    else
    {
        NSLog(@"dosome other work");
    }
    return  NULL;
}

void thirdThreadEntry(void *portname)
{
    CFStringRef mainthreadportname=(CFStringRef)portname;
    CFMessagePortRef mainthreadport=CFMessagePortCreateRemote(NULL, mainthreadportname);
    CFRelease(mainthreadportname);
    
    Boolean shouldfreeinfo;
    CFMessagePortContext context={0,mainthreadport,NULL,NULL,NULL};
    CFStringRef myportname=CFStringCreateWithFormat(NULL, NULL, CFSTR("mythirdThreadlocalport"));
    CFMessagePortRef myport=CFMessagePortCreateLocal(NULL, myportname, processmaintheadrequesthandler, &context, &shouldfreeinfo);
    
    if(shouldfreeinfo)
    {
        NSLog(@"can't create thirdthreadlocalport");
        pthread_exit((void *)1);
    }
    CFRunLoopSourceRef rlsrc=CFMessagePortCreateRunLoopSource(NULL, myport, 0);
    if(rlsrc==NULL)
    {
        NSLog(@"can't create thirdthreadrunloopsource");
        pthread_exit((void *)2);
    }
    CFRunLoopAddSource(CFRunLoopGetCurrent(), rlsrc, kCFRunLoopDefaultMode);
    CFRelease(myport);
    CFRelease(rlsrc);
    
    //打包本地端口名然后给主线程发送check_in消息
    CFIndex stringlength=CFStringGetLength(myportname);
    UInt8 *buffer=CFAllocatorAllocate(NULL, stringlength, 0);
    CFStringGetBytes(myportname, CFRangeMake(0, stringlength), kCFStringEncodingASCII, 0, FALSE, buffer, stringlength, NULL);
    CFDataRef outData=CFDataCreate(NULL, buffer, stringlength);
    CFMessagePortSendRequest(mainthreadport, (SInt8)100, outData, 0.1, 00.0, NULL, NULL);
    CFRelease(outData);
    CFAllocatorDeallocate(NULL, buffer);
    int loopcount=10;
    do{
        CFRunLoopRun();
        loopcount--;
    }while(loopcount);
    CFRelease(mainthreadport);
    NSLog(@"pthread exit");
    pthread_exit((void *)0);
}
CFDataRef processmaintheadrequesthandler(CFMessagePortRef local,SInt32 msgid,CFDataRef data,void *info)
{
    NSLog(@"recieve something from mainthread");
    return NULL;
}
