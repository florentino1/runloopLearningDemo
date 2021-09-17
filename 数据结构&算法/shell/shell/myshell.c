#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/wait.h>
#include <signal.h>
#include "jobs.h"
#include <setjmp.h>

#define MAXLINE 1000
typedef void handler_t(int);
extern char  **environ;
volatile sig_atomic_t exitpid;
sigjmp_buf buffer;

int parseline(char *command,char **argv);  //to parse the commandline and build the argv linktable;
void eval(char *command);                 //to evaluate the commandline in commandbuffer;
int buildincommand(char **argv);          //is a buildin command or not;
void handler(int signum);
void handlerINT(int signum);
void handlerQUIT(int signum);
handler_t *Signal(int signum,handler_t *func);

int main(int argc,char **argv,char **envn)
{
	// command line buffer;
	char command[MAXLINE];
    initJobs();
	//command line begin with % to distinguish from bash $/#
	while (1)
	{
        
        sigsetjmp(buffer, 1);
       {
           Signal(SIGINT, handlerINT);
           Signal(SIGABRT, handlerQUIT);
           printf("%%");
           if((fgets(command,MAXLINE,stdin)!=NULL))
            {
                if(command[strlen(command)-1]=='\n')
                    command[strlen(command)-1]=' ';
                eval(command);
            }
       }
    }
}

void eval(char *command)
{
	char buffer[MAXLINE];         //buffer to restore the command
	char *argv[MAXLINE];	      //argv linktable to store parse command argvs;
	strcpy(buffer,command);
    int pid;
	int bg=parseline(buffer,argv);
	if(argv[0]==NULL)
		return;             //empty should ingore;
    
    
    sigset_t mask_all,mask_one,prev_one;
    sigfillset(&mask_all);
    sigemptyset(&mask_one);
    sigaddset(&mask_one, SIGCHLD);
    Signal(SIGCHLD, handler);

	if(buildincommand(argv)==0)   //is not a buildin command
	{
        //设置信号先屏蔽SIGCHLD
        sigprocmask(SIG_BLOCK, &mask_one, &prev_one);
        
        if((pid=fork())==0)//in the child process
		{
            sigprocmask(SIG_SETMASK, &prev_one, NULL);
			if(execvp(argv[0], argv)<0)
			{
                printf("from childProcess>error: %s not found\n",argv[0]);
				exit(0);
			}
		}
		// in the parent process
        //设置屏蔽所有信号，保证对外部全局变量的读写不会被系统其它信号中断
        sigprocmask(SIG_BLOCK, &mask_all, NULL);
        addjob(pid);
        sigprocmask(SIG_SETMASK, &prev_one, NULL);
		if(bg==0)//run in the foreground
        {
           //前台程序，需要等待handler函数返回；
            while (exitpid!=pid) {
                sigsuspend(&prev_one);
            }
        }
        //后台执行的子线程在handler中已经完成了回收
    }
    return;
}

int parseline(char *command,char **argv)
{
	
	//ignore leading space ' '
	while(*command && (*command)==' ')
		command++;
	//to cut the argv by ' '
	char *p;                    //a pointer which points to ' '
	int i=0;
	while((p=strchr(command,' ')))
	{
		argv[i++]=command;
		*p='\0';
		command=p+1;
		while(*command && (*command==' '))
			command++;
	}
	argv[i]=NULL;             //linktable should end with null;
	if(i==0)
		return 2;        //empty command which should be ignored;
	if(*argv[i-1]=='&')       //should run in background
	{
        argv[i-1]=NULL;
		return 1;
	}
	return 0; //should run in foreground;
}

int buildincommand(char **argv)     //quit to exit;0 means is not a buildin command;1 means is a buildincommand could run;
{
	if(strcmp(argv[0],"quit")==0)
		exit(0);
	if(!strcmp(argv[0],"&"))
		return 1;
	return 0;
}
void handler(int signum)
{
    int myerrono=errno;//保存原有的errno，在handler处理结束后恢复原本的errno以使得handler不影响外部依靠errno的程序；
	pid_t pid;
    
    sigset_t mask_all,prev_all;
    sigfillset(&mask_all);
    while((pid=waitpid(-1,NULL,0))>0)
    {
        sigprocmask(SIG_BLOCK, &mask_all, &prev_all);
        deljob(pid);
        exitpid=pid;
        sigprocmask(SIG_SETMASK, &prev_all, NULL);
    }
    errno=myerrono;//恢复原有的errno
}
void handlerINT(int signum)
{
    siglongjmp(buffer, 1);
}
void handlerQUIT(int signum)
{
    exit(3);
}
handler_t *Signal(int signum, handler_t*func)
{
    struct sigaction action,old_action;
    
    action.sa_handler=func;
    sigemptyset(&action.sa_mask);
    action.sa_flags=SA_RESTART;
    
    if (sigaction(signum, &action, &old_action)<0) {
        printf("Signal error\n");
    }
    return (old_action.sa_handler);
    
}
