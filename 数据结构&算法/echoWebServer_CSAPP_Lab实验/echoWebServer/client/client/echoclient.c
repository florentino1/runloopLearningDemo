//
//  echoclient.c
//  echoWebServer
//
//  Created by 莫玄 on 2021/7/9.
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
    rio_t *rio;
    char *buffer=(char *)calloc(MAXLINE, sizeof(char));

    if(argc!=3)
    {
        printf("usage:%s+<hostname>+<port>\n",argv[0]);
        exit(1);
    }

    clientfd=open_clientfd(argv[1], argv[2]);
    if(clientfd>0)
    {
        printf("client:clientfd=%d\n",clientfd);
        rio=rio_initb(clientfd);
        while(fgets(buffer, MAXLINE,stdin)!=NULL)
        {
            rio_writen(clientfd, buffer, strlen(buffer));
            rio_readlineb(rio, buffer, MAXLINE);
            printf("%s\n",buffer);
        }
        close(clientfd);
    }
        exit(0);
}
