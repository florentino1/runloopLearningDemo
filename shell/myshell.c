#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>
#include <signal.h>

#define MAXLINE 1000

volatile int flag=0;                                 //a flag which point to whether there is a child process;

int parseline(char *command,char **argv);  //to parse the commandline and build the argv linktable;
void eval(char *command);                 //to evaluate the commandline in commandbuffer;
int buildincommand(char **argv);          //is a buildin command or not;
void handler(int signum);
int main(int argc,char **argv,char **envn)
{
	// command line buffer;
	char command[MAXLINE];
	
	//command line begin with % to distinguish from bash $/#
	printf("%%");
	while (1)
	{
		if((fgets(command,MAXLINE,stdin)!=NULL))
		{
			if(command[strlen(command)-1]=='\n')
				command[strlen(command)-1]=' ';
			eval(command);
		}
		printf("%%");
	}
}

void eval(char *command)
{
	char buffer[MAXLINE];         //buffer to restore the command
	char *argv[MAXLINE];	      //argv linktable to store parse command argvs;
	strcpy(buffer,command);
	int bg=parseline(buffer,argv); //should run in bg or fore ? 0 means in foreground ;1 means in background ;2 means empty should return;
	if(argv[0]==NULL)
		return;             //empty should ingore;
	printf("bg=%d\n",bg);
	//set signal mask
	sigset_t mask_one,premask;
	sigemptyset(&mask_one);
	sigaddset(&mask_one,SIGCHLD);
	signal(SIGCHLD,handler);

	if(buildincommand(argv)==0)   //is not a buildin command
	{
		int pid;
		//shutoff SIGCHLD
		sigprocmask(SIG_BLOCK,&mask_one,&premask);
		if((pid=fork())==0)   //in the child process
		{
			sigprocmask(SIG_SETMASK,&premask,NULL);
			printf("flag in chile process before=%d\n",flag);
			flag++;
			printf("flag in child process after=%d\n",flag);
			if(execvp(argv[0],argv)<0)         //background child process has'n been recycled;
			{	printf("error: %s not found\n",argv[0]);
				exit(0);
			}
		}
		// in the parent process
		if(bg==0) 	      //in the foreground
		{
			printf("pid:%d is running the foreground now\n",pid);
		}
		else		      //in the background
		{
			printf("pid:%d %s is running in the background now\n",pid,command);
		}
		sigprocmask(SIG_SETMASK,&premask,NULL);
	}
	while(!flag)
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
	for(int j=0;j<i;j++)
	{
		printf("argv[%d]:%s :",j,*argv[j]);
	}
	argv[i]=NULL;             //linktable should end with null;
	if(i==0)
		return 2;        //empty command which should be ignored;
//	printf("argv[i-1]=%s\n",*argv[i-1]);
	if(*argv[i-1]=='&')       //should run in background
	{
	//	argv[i-1]=NULL;
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
	pid_t pid;

	while((pid=waitpid(-1,NULL,0))>0)
	{
		printf("pid:%d has exit\n",pid);
		printf("flag in handler before:%d\n",flag);
		flag--;
		printf("flag in handler after:%d\n",flag);

	}
}

