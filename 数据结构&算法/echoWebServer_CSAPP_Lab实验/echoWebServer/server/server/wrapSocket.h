//
//  wrapSocket.h
//  echoWebServer
//
//  Created by 莫玄 on 2021/7/9.
//

#ifndef wrapSocket_h
#define wrapSocket_h

#include <stdio.h>

int open_clientfd(char *hostname,char *port);
int open_listenfd(char *port);

#endif /* wrapSocket_h */
