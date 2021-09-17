//
//  tinywebclient.c
//  echoWebServer
//
//  Created by 莫玄 on 2021/7/17.
//
#include <stdio.h>
#include "wrapSocket.h"
#include "robustIO.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>


#define  MAXLINE  8192
int main(int argc,char **argv)
{
    int clientfd;
    char buf[MAXLINE]={};
    char *buffer=buf;
    char *bufferread=(char *)calloc(MAXLINE, sizeof(char));
    if(argc!=3)
    {
        printf("usage:%s+<hostname>+<port>\n",argv[0]);
        exit(1);
    }

    clientfd=open_clientfd(argv[1], argv[2]);

    if(clientfd>0)
    {
        printf("client:clientfd=%d\n",clientfd);
        
        int n,i;
        while(1)
        {
            printf("request header: GET + <filename>+version\n ");
            while(fgets(buffer, MAXLINE, stdin)!=NULL)
            {
                if(strcmp(buffer, "quit")==0)
                    break;
                else
                {
                    if((n=rio_writen(clientfd, buffer, strlen(buffer)))>0)
                        buffer+=n;
                    break;
                }
            }
            while(1)
            {
                if((i=read(clientfd, bufferread, MAXLINE))>0)
                {
                    printf("%s\n",bufferread);
                    bufferread+=i;
                    break;
                }
            }
        }
    }
    exit(0);
}

