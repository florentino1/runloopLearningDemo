//
//  mmlib.c
//  mymalloc
//
//  Created by 莫玄 on 2021/9/6.
//

#include "mmlib.h"
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>

//私有的全局变量：
static char *mem_heap; // 堆底的序言块的地址；
static char *mem_brk;  //指向堆顶加1的地址；
static char *mem_max_addr;// 能够分配的最大的地址空间;


#define MAX_HEAP  (20*(1<<20))  //最大的地址空间可分配20MB；

void mem_init(void)
{
    mem_heap=(char *)malloc(MAX_HEAP *sizeof(char));
    mem_brk=mem_heap;
    mem_max_addr=mem_heap+MAX_HEAP;
}

void *mem_sbrk(int incr)
{
    char *old_brk=mem_brk;
    if(incr <0 || (incr + mem_brk)>mem_max_addr)
    {
        errno=ENOMEM;
        fprintf(stderr, "error:%s failed,ran out of mems\n",__func__);
        return (void *)-1;
    }
    mem_brk+=incr;
    return (void *)old_brk;
}
