//
//  tinywebserver.c
//  echoWebServer
//
//  Created by 莫玄 on 2021/7/14.
//

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <string.h>
#include <netdb.h>
#include <sys/stat.h>
#include "wrapSocket.h"
#include "robustIO.h"
#define MAXLINE   8192
typedef struct sockaddr SA;
int mylog=0;
void sigchild_handler(int sig)
{
    while (waitpid(-1,0,WNOHANG)>0)
        ;
    return;
}
void server_static(int fd,char *filename,int size)
{
    printf("server_static success\n");
}
void server_dynamic(int fd,char *filename,char *cgiargs)
{
    printf("server_dynatic success\n");
}
void errowriteback(int fd,char *cause,char *errnum,char *shortmsg,char *longmsg)
{
    char buf[MAXLINE];

    /* Print the HTTP response headers,显示的是报头，但是相应的报头好像没有在页面中显示出来 */
    sprintf(buf, "HTTP/1.0 %s %s\r\n", errnum, shortmsg);
    rio_writen(fd, buf, strlen(buf));
    sprintf(buf, "Content-type: text/html\r\n\r\n");
    rio_writen(fd, buf, strlen(buf));

    /* Print the HTTP response body */
    sprintf(buf, "<html><title>Tiny Error</title>");
    rio_writen(fd, buf, strlen(buf));                   //显示的是浏览器标签页的名称；
    sprintf(buf, "<body bgcolor=""ffffff"">\r\n");
    rio_writen(fd, buf, strlen(buf));                   //设置该浏览器错误页的背景颜色；
    sprintf(buf, "%s: %s\r\n", errnum, shortmsg);
    rio_writen(fd, buf, strlen(buf));
    sprintf(buf, "<p>%s: %s\r\n", longmsg, cause);
    rio_writen(fd, buf, strlen(buf));
    sprintf(buf, "<hr><em>The Tiny Web server</em>\r\n");//HR应该表示的是在这一行文字之前加一条横线;
    rio_writen(fd, buf, strlen(buf));
    dprintf(mylog, "%s\n",cause);
    dprintf(mylog, "%s\n",longmsg);
}
int parse_uri(char *uri,char *filename,char *cgiargs)
{
    if(strstr(uri, "test"))//是静态内容
    {
        strcpy(cgiargs,"");//将参数字符串置为空;
        strcpy(filename,"/Users/moxuan/Desktop");
        strcat(filename, uri);
        return 1;
    }
    return 0;
}
void doit(int fd)
{
    int is_static;//判断客户端请求的内容是动态内容还是静态内容;
    char *buf=(char *)calloc(MAXLINE, sizeof(char ));
    rio_t *rio=rio_initb(fd);
    rio_readlineb(rio, buf,MAXLINE);//将客户端输入的命令读取到服务器的缓存区暂存;

            struct stat *sbuf=(struct stat *)malloc(sizeof(struct stat));//文件的stat结构体
            memset(sbuf, 0, sizeof(struct stat));
            char *method=(char *)calloc(MAXLINE, sizeof(char));
            char *uri=(char *)calloc(MAXLINE, sizeof(char));
            char *version=(char *)calloc(MAXLINE, sizeof(char));
            char *filename=(char *)calloc(MAXLINE, sizeof(char));
            char *cgiargs=(char *)calloc(MAXLINE, sizeof(char));

            fprintf(stdout, "request header:\n");//打印客户端输入的请求报头;
            fprintf(stdout, "%s\n",buf);
            sscanf(buf, "%s %s %s",method,uri,version);//将buf中暂存的请求报头以空格为断读入到各缓存区中；
            if(strcasecmp(method, "GET")!=0)//判断请求报头的方法；
            {
                errowriteback(fd,method,"501","Not Implemented","Tiny does not implement this method");
                return;//返回到服务器的主程序
            }

            is_static=parse_uri(uri,filename,cgiargs);//判断文件是否是动态类型


            if(stat(filename, sbuf)<0)//确认服务器是否存在客户端要求的文件
            {
                errowriteback(fd,filename,"404","Not Found","Tiny could not find this file");
                return;
            }

            if(is_static)//是服务器的静态类型时：
            {
                if(!(S_ISREG(sbuf->st_mode)) || !(S_IXUSR &sbuf->st_mode) )//确认服务器是否有权限打开客户端要求的文件
                {
                    errowriteback(fd,filename,"403","Forbidden","Tiny can not read this file");
                    return;
                }
                else
                    server_static(fd,filename,(int )sbuf->st_size);
            }
            else//是服务器的动态类型时
            {
                if(!(S_ISREG(sbuf->st_mode)) || !(S_IXUSR &sbuf->st_mode) )//确认服务器是否有权限打开客户端要求的文件
                {
                    errowriteback(fd,filename,"403","Forbidden","Tiny can not run this file");
                    return;
                }
                else
                    server_dynamic(fd,filename,cgiargs);
            }
    return;
}
int main(int argc,char ** argv)
{
    if(argc!=2)
    {
        fprintf(stderr,"usage:%s +<port>\n",argv[0]);
        exit(1);
    }
    int listenfd=open_listenfd(argv[1]);
    mylog=open("./log", O_CREAT | O_RDWR|O_APPEND,S_IWOTH | S_IROTH);

    if(listenfd>0)
    {
        int connfd=0;
        pid_t pid;
        char *hostname=(char *)calloc(MAXLINE, sizeof(char));
        char *portname=(char*)calloc(MAXLINE, sizeof(char));
        struct sockaddr_storage *addr=(struct sockaddr_storage *)malloc(sizeof(struct sockaddr_storage));
        memset(addr, 0, sizeof(struct sockaddr_storage));
        fprintf(stdout, "Tiny:server now is listening>>>\n");
        socklen_t clientaddrlen=sizeof(struct sockaddr_storage);
        signal(SIGCHLD, sigchild_handler);//回收僵尸子进程
        while (1)
        {
           if((connfd=accept(listenfd, (SA*)addr, &clientaddrlen))>0)
           {
                 if((pid=fork())==0)
                {
                    close(listenfd);//子进程要求关闭它的监听符，保留连接符；
                    getnameinfo((SA*)addr, clientaddrlen, hostname, MAXLINE, portname, MAXLINE, 0);
                    printf("connect to (%s  %s)\n",hostname,portname);
                    pid=getpid();
                    dprintf(mylog, "subprocess :%d  connect to %s:%s \n ",pid,hostname,portname);
                    doit(connfd);
                    dprintf(mylog, "subprocess :%d exit\n ",pid);
                    close(connfd);//子进程完成工作后关闭连接符；
                    exit(0);
                }
           }
            close(connfd);//父进程要求要关闭它的连接符，保留监听符；
        }
    }
}
