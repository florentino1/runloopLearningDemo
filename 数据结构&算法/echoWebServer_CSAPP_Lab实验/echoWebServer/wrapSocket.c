//
//  wrapSocket.c
//  echoWebServer
//
//  Created by 莫玄 on 2021/7/9.
//

#include "wrapSocket.h"
#include <sys/socket.h>
#include <netdb.h>
#include <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>


int open_clientfd(char *hostname,char *port)
{
    int clientfd=-2;
    struct addrinfo *hints,**listp,*p;


//#warning listp & hints may cause bugs    到底应不应该进行内存分配以及如何初始化可能会导致问题出现；
    hints=(struct addrinfo *)malloc(sizeof(struct addrinfo));
    listp=(struct addrinfo **)malloc(sizeof(struct addrinfo *));
    memset(hints,0,sizeof(struct addrinfo));
    memset(listp,0,sizeof(struct addrinfo *));///必须将hints的各个位置为0，并只能可选的设置其中几个位；
    hints->ai_socktype=SOCK_STREAM;
    hints->ai_flags=AI_ADDRCONFIG | AI_NUMERICSERV;
    getaddrinfo(hostname, port, hints, listp);

    for(p=*listp;p;p=p->ai_next)//循环遍历返回的listp中的addrinfo结构体直到socket 和connect成功
    {
        if((clientfd=socket(p->ai_family, p->ai_socktype, p->ai_protocol))>0)//返回值为-1 或者文件描述符；
            printf("client:socket success...\n");
        else
            continue;//socket函数失败，跳出本次循环，p指向下一个addrinfo结构体;
        if(connect(clientfd, p->ai_addr, p->ai_addrlen)==0)//0表示conne函数成功返回
        {
            printf("client:connect success...\n");
            break;//connect函数成功，结束循环；不能关闭client描述符文件；
        }
        close(clientfd);//connect失败，此时需要关闭文件描述符client 然后检索p->next；
    }

    freeaddrinfo(*listp);
    if(p==NULL)//如果listp遍历之后还是未能建立链接
    {
        printf("client_error:cannot socket-connect\n");
        return -1;
    }
    else
    {
        printf("client_congratulations!socket-connect success\n");
        return clientfd;
    }
}

int open_listenfd(char *port)
{
    int listenfd=-2;
    int optval=-3;
    struct addrinfo *hints,**listp,*p;
    hints=(struct addrinfo *)malloc(sizeof(struct addrinfo));
    listp=(struct addrinfo **)malloc(sizeof(struct addrinfo *));
    memset(hints,0,sizeof(struct addrinfo));
    memset(listp,0,sizeof(struct addrinfo *));
    hints->ai_socktype=SOCK_STREAM;
    hints->ai_flags=AI_ADDRCONFIG | AI_PASSIVE | AI_NUMERICSERV;
    getaddrinfo(NULL, port, hints, listp);

    for(p=*listp;p;p=p->ai_next)
    {
        if((listenfd=socket(p->ai_family, p->ai_socktype, p->ai_protocol))<0)//socket函数失败，结束本次循环；
            continue;
        printf("server:socket success\n");
        setsockopt(listenfd, SOL_SOCKET, SO_REUSEADDR, (const void *)&optval, sizeof(int));//配置服务器端可以终止、重启、立即接受链接请求；

        if(bind(listenfd, p->ai_addr, p->ai_addrlen)==0)//bind函数成功，结束循环；
        {
            printf("server:bind success\n");
            break;
        }
        close(listenfd);//BIND函数失败，p指向p->next；
    }

    freeaddrinfo(*listp);
    if(p==NULL)
    {
        printf("service_error:cannot socket-binned\n");
        return -1;
    }

    if(listen(listenfd,128)<0)
    {
        close(listenfd);
        printf("service_error:listen failure\n");
        return -1;
    }
    printf("server:server is listening\n");
    return listenfd;

    
}
