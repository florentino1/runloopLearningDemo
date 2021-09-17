#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <limits.h>
int main()
{
	int max=1<<31-1;
	printf("%d\n",max);
	int n=max / (60*60*24*365);
	int res=n+1970;
	printf("%d\n",res);
	exit(0);
}
