//
//  echoservice.c
//  echoWebServer
//
//  Created by 莫玄 on 2021/7/9.
//

#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netdb.h>
#include "wrapSocket.h"
#include "robustIO.h"
#include <string.h>

#define MAXLINE 8192
typedef struct sockaddr SA;
void echodata(int fd)
{
    size_t n=0;
    int sum=0;
    char *buffer=(char *)calloc(MAXLINE, sizeof(char));
    rio_t *rio=rio_initb(fd);

    //while ((n=rio_readnb(rio, buffer, MAXLINE))>0)
    while((n=rio_readlineb(rio, buffer, MAXLINE))>0)
    {
        sum+=n;
        int i;
        //printf("server recieved %d bytes\n",(int)n);
         fprintf(stdout,"server:string from client:%s\n",buffer);
       if((i=rio_writen(fd, buffer, n))>0)
       {
         buffer+=n;
         printf("written to connfd:%d success\n",fd);
       }
    }
    printf("echofunc return,recieved %d bytes total\n",sum);
}

int main(int argc,char **argv)
{
    int listenfd=-3;
    int connfd=-4;

    char *client_hostname=(char *)calloc(MAXLINE,sizeof(char));
    char *client_port=(char *)calloc(MAXLINE, sizeof(char));
    struct sockaddr_storage * clientaddr=(struct sockaddr_storage *)malloc(sizeof(struct sockaddr_storage));
    memset(clientaddr, 0, sizeof(struct sockaddr_storage));

    if(argc!=2)
    {
        printf("usage:%s +<port>\n",argv[0]);
        exit(1);
    }
    listenfd=open_listenfd(argv[1]);
    if(listenfd>0)
    {
        printf("server:listenfd=%d\n",listenfd);
        socklen_t clientaddlen=sizeof(struct sockaddr_storage);
        while(1)
        {
            connfd=accept(listenfd, (SA*)clientaddr, &clientaddlen);
            printf("server:accept success,connfd=%d\n",connfd);
            int error;
           if((error=getnameinfo((SA*)clientaddr, clientaddlen, client_hostname, MAXLINE, client_port, MAXLINE, 0))!=0)
               fprintf(stderr,"getnameinfo error:%s\n",gai_strerror(error));
            printf("connect to (%s  %s)\n",client_hostname,client_port);
            echodata(connfd);
            close(connfd);
            printf("connfd:%d closed\n",connfd);
        }
    }
    exit(0);
}

