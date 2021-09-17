//
//  robustIO.c
//  echoWebServer
//
//  Created by 莫玄 on 2021/7/9.
//

#include "robustIO.h"
#include <sys/errno.h>
#include <string.h>
#include <malloc/_malloc.h>

#pragma mark-无缓冲的读写函数

ssize_t rio_readn(int fd,void *buffer,size_t n)
{
    ssize_t nread;      //已读入的字节数量；
    size_t nleft=n;     //待读入的字节数量;
    char *buf=buffer;   //缓冲池

    while(nleft>0)
    {
        if((nread=read(fd, buf, nleft))<0)   //read函数出错为-1时，设置errno，其中EINTR为中断，需要重新调用read函数;
        { if(errno==EINTR)       //中断的情况下将nread设置为0，待下次重新调用read;
                nread=0;
            else                 //其他情况为完全出错时，直接返回-1;
                return -1;
        }
        else if (nread==0)       //EOF
            break;               //break跳出结束循环，执行return语句；
        nleft-=nread;            //read函数返回值大于等于0，此时nread为read函数读取的字节数;
        buf+=nread;
    }
    return (n-nleft);
}

ssize_t rio_writen(int fd,void *buffer,size_t n)
{
    ssize_t nwritten;//已写入的字节数
    size_t nleft=n;//未写入的字节数
    char *buf=buffer;//缓冲池

    while(nleft>0)
    {
        if((nwritten=write(fd, buf, nleft))<=0)//write函数返回错误值或是0时
        {
            if(errno==EINTR)                   //write函数被系统中断时将nwrite设为0，使nleft的值不发生变化;
                nwritten=0;
            else
                return -1;
        }                                       //在进行写操作时不会遇到EOF，所以不用特别判定nwritten为0时的情况；
        nleft-=nwritten;
        buf+=nwritten;
    }
    return n;

}
#pragma mark-带缓冲的读写函数

//内部init函数：返回一个已经分配好的struct rio_t型的结构体，并完成初始化;
rio_t *rio_initb(int fd)
{
    rio_t *rio;
    rio=(rio_t *)malloc(sizeof(rio_t *));//此处分配内存空间时就已经为缓冲区分配好了内存，不需要进行再一次的calloc；
    rio->rio_fd=fd;
    rio->rio_cnt=0;
    memset(rio->rio_buf, 0, sizeof(rio->rio_buf));
    rio->rio_bufptr=rio->rio_buf;//此处的指针赋值只能将数组的地址放在右侧
    return rio;
}

//内部read函数：先将文件内容按照结构体内部缓冲区的大小将其读入内部缓冲区，然后按照n的大小将其读取到用户缓存userBuffer中；
ssize_t rio_read(rio_t *rio,void *userBuffer,size_t n)
{
    while(rio->rio_cnt<=0)
    {
        rio->rio_cnt=read(rio->rio_fd, rio->rio_buf, sizeof(rio->rio_buf));//rio->cnt 小于0时表示read函数出错，等于0时表示遇到EOF或者缓存已空需要再次read到内部缓存区;
        if (rio->rio_cnt==0)//当从文件fd读取遇到EOF时，直接返回0，表明fd为空文件
            return 0;
        else if(rio->rio_cnt<0)//当read函数读取出错时，分为两种：系统中断时则再一次进行循环条件判定，不是系统中断则返回-1；
        {
            if(errno!=EINTR)//此时为出错的情况；
                return -1;
        }
        else
            rio->rio_bufptr=rio->rio_buf;
    }

    int cnt=(rio->rio_cnt<n) ? rio->rio_cnt : n;//将rio->cnt与n进行比较，将较小的值赋值给cnt;
    memcpy(userBuffer,rio->rio_bufptr,cnt);//将数据从内部缓冲区复制到用户缓冲区；

    rio->rio_bufptr+=cnt; //更新结构体数据，为下一次调用本函数时做准备；
    rio->rio_cnt-=cnt;

    return cnt;
}

//按行对文件fd进行读取的函数：按字节对内部缓冲区中的数据进行读取，找到换行符后将其置为null
ssize_t rio_readlineb(rio_t *rio,void *userBuffer,size_t maxlen)
{
    int n;//表示已经读取到userBuffer中的字节数
    int rc;
    char c='o';//用来当做临时缓冲区储存一个字符
    char *buf=userBuffer;
    for(n=1;n<maxlen;n++)//不断调用rio_read函数从内部缓冲区读取单个字符
    {
        if((rc=(int )rio_read(rio,&c,1))==1)//从rio中成功读取出一个字节时
        {
            *buf++=c;
            if(c=='\n')//当取出的字符是换行符时，要求退出循环
            {
                n++;
                break;
            }
        }
        else if(rc==0)
        {
            if(n==1)
                return 0;//表示EOF，该文件为空,一个字符都没读取到；
            else//已经读取到了一些字符
                break;
        }
        else//rc小于0时，表示出错；
            return -1;
    }
    *buf='\0';//将最后一个字节设为null
    return n-1;
}

//带缓冲区的rio_readn函数
ssize_t rio_readnb(rio_t *rio,void *userBuffer,size_t n)
{
    size_t nleft=n;
    ssize_t nread;
    while (nleft>0)
    {
       if( (nread=(int)rio_read(rio, userBuffer, nleft))<0)//rio_read函数的返回值-1，0，else，-1只为出错的情况，中断在其函数内部已经完成处理；
           return -1;
        else if(nread==0)//表明rio-read函数遇到了EOF
            break;
        nleft-=nread;
        userBuffer +=nread;
    }
    return n-nleft;//nread在每一次调用rio_read函数时都返回不同的值，所以此处不可直接返回nread作为返回值;
}
