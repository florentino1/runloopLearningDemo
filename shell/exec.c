#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <stdlib.h>

#define MAXSIZE 1000
int main()
{
	char buffer[MAXSIZE];
	pid_t pid;
	int stat;
	printf("%% ");
	while(fgets(buffer,MAXSIZE,stdin)!=NULL)
	{
		if(buffer[strlen(buffer)-1]=='\n')
			buffer[strlen(buffer)-1]=0;
		if((pid =fork())<0)
		{
			fprintf(stderr,"fork func erro\n");
			exit(1);
		}
		else if(pid==0)//子进程中
		{
			execlp(buffer,buffer,(char *)0);
			exit(2);
		}
		
		if((pid=waitpid(pid,&stat,0))<0)
			fprintf(stderr,"waitpid error\n");
		printf("%% ");
	}
	exit(0);
}
