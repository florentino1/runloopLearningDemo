//
//  robustIO.h
//  echoWebServer
//
//  Created by 莫玄 on 2021/7/9.
//

#ifndef robustIO_h
//#define robustIO_h
#include <unistd.h>

#define RIO_BUFSIZE 8192


typedef struct{
    int rio_fd;             //结构体指向的文件描述符，将从文件中填充结构体内部缓冲区;
    int rio_cnt;            //缓冲区中未被进一步读取的字节计数；
    char *rio_bufptr;       //缓冲区当前指针指向的内容地址，指针之前的内容已被读取，指针之后的内容待读取；
    char rio_buf[RIO_BUFSIZE];//内部缓冲区；
}rio_t;
                        
//无缓冲
ssize_t rio_readn(int fd,void *buffer,size_t n);
ssize_t rio_writen(int fd,void *buffer,size_t n);

//有缓冲
rio_t *rio_initb(int fd);
ssize_t rio_read(rio_t *rio,void *userBuffer,size_t n);
ssize_t rio_readlineb(rio_t *rio,void *userBuffer,size_t maxlen);
ssize_t rio_readnb(rio_t *rio,void *userBuffer,size_t n);



#endif /* robustIO_h */
