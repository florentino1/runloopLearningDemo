
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

//lock 总是被初始化为false。以下三种形式的基于软件的锁均采用类似于自旋或是忙等的方式实现;
//考虑以下三种形式的算法时需要考虑两个或是多个进程之间的竞争问题;
BOOL test_and_set(BOOL *lock)
{
	BOOL tmp=*lock;
	*lock=true;
	return tmp;
}

int compare_and_swap(int *lock,int exept,int new_value)
{
	int tmp=*lock;
	if(tmp==exept)
	  *lock=new_value;
	
	return tmp;
}

/* peterson 方案，仅仅限制于两个进程之间的同步问题，需要两个进程共享两个全局变量，turn和flag【2】;
eg:
	do
	{
	  flag[i]=ture;
	  turn=j;
	  while(flag[j] && turn==j);   //当满足while循环条件时，进程被阻塞在while循环的位置，而另一个进程得以继续执行，并更新while循环的条件;
	  
	  临界区

	  flag[i]=false;   //在另一个进程中，while(flag[i] && turn=i);    此时当flag[i]=false后，该进程得以继续执行;

	  剩余区
        }while(true);
*/


/* 基于test_and_set（）的算法，满足互斥、有限等待以及进步要求：此时假设需要执行的进程是一个队列的形式，排布在waiting【】数组里,并初始化为false；index表示进行的pid等；同理，全局变脸lock被初始化为false
	do
	{
	 waiting[i]=ture;
	 BOOL key=true;
	 while(waiting[i] && key)//当标号为i、j的进程到达时，发生key的数据竞争，i进程执行一遍while循环后 key被设为false，lock被设为ture，此时第二次while循环时，进程i因为不满足循环条件得以继续执行；
	   {                    //当进程j执行第一次while到达 test——and——set时，因为全局变量lock被进程i设为ture，所以返回值key将一直为ture，j被阻塞在while循环里；
	     key=test_and_set(&lock);
	   }
	waiting[i]=false;

	临界区

	
	int j=(i+1)%n;    //n为waiting[]数组中的元素个数，即排队待执行的进程数量；
	while(!waiting[j] && j!=i)//遍历数组waiting 找到waiting【j】为ture的进程j，或是该队列只含有一个进程时，此时waiting队列已经全部执行完毕，需要将全局变脸lock恢复；
	{
	 j=(j+1)%n;
	}

	if(j==i)
	  lock=false;
	else 
	  waiting[j]=false;   //在j中，进程被阻塞在while(waiting[j] && key),此时waiting[j]为true，在进程i中解循环：设置waiting[j]=false，进程j得以继续执行   ;

	剩余区
       }while(true);
	  
