//
//  mm.c
//  mymalloc
//
//  Created by 莫玄 on 2021/9/6.
//

#include "mm.h"
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include "mmlib.h"

#define WSIZE 4
#define DSIZE 8  //定义单字为4字节，双字为8字节；
#define CHUNKSIZE (1<<12) //定义页大小为4KB

#define MAX(x,y) ((x)>(y)?(x):(y))

//定义一些宏用于便捷操作

#define PACK(size,alloc) ((size) | (alloc))

#define GET(p) (*(unsigned long *)(p)) //p为块头部指针地址，将指针地址p强制装换为unit形式并进行解引用；
#define PUT(p,val) (*(unsigned long *)(p)=(val))//指针p为块头部地址，强制转为unit形式然后对指针p进行赋值；

#define GET_SIZE(p) (GET(p) & ~0x7) //将0x000作为掩码与p指针所指向的值进行&运算，将p指针所指向值的二进制低3位置为0；
#define GET_ALLOC(p) (GET(p) & 0X1) //将头部块的最后一个标志位设置为1，表示该块已被分配；

#define HDRP(bp) ((char *)(bp-WSIZE)) //此处定义的bp为指向块中有效载荷地址的指针；减去块头部字节，此宏用于求块起始地址；
#define FTRP(bp) ((char *)(bp-DSIZE+GET_SIZE(HDRP(bp))))

#define NEXT_BLKP(bp) ((char *)(bp)+GET_SIZE((char *)(bp)-WSIZE))
#define PREV_BLKP(bp) ((char *)(bp)-GET_SIZE(((char *)(bp)-DSIZE)))


static char *heap_listp=0;

static void *extend_heap(size_t words);
static void *coalesce(void *bp);
static void *findfit(size_t size_needed);
static void place(void *bp,size_t size);
//在进行分配空间之前，必须进行初始化；
int mm_init(void)
{
    if((heap_listp=mem_sbrk(4*WSIZE))==(void *)-1)//为链表p分配四个单字的内存空间，分别为头部对齐块，序言块头部、序言块的尾部和结尾块；对齐块和结尾块均为0填充
        return -1;
    PUT(heap_listp, 0);
    PUT(heap_listp+WSIZE, PACK(DSIZE, 1));
    PUT(heap_listp+(2*WSIZE), PACK(DSIZE, 1));
    PUT(heap_listp+(3*WSIZE), 0);
    heap_listp+=2*WSIZE;
    
    //为已经初始化好的链表分配更多的初始化空间;
    if(extend_heap(CHUNKSIZE/WSIZE)==NULL)
        return -1;
    return 0;
}

void *mm_malloc(size_t size)
{
    size_t asize;     //实际需要分配给用户的字节大小；
    void *bp;         //所分配地址空间的有效载荷地址；
    if(size==0)
        return NULL;
    if (size <DSIZE)
        asize=4*WSIZE;//最小为双字，即需要保存脚部和头部信息；
    else
        asize=DSIZE*(size +DSIZE+(DSIZE-1)/DSIZE); //进行8字节对齐，size为需要的有效载荷，加上一个DSIZE用于保存块的头部和脚部，后续的为对齐要求，是的asize为8的倍数
    
    //遍历链表，使用首次适配的方式获取可分配的空间；
    if((bp=findfit(asize))!=NULL)//返回的bp指向的是块的有效载荷地址
    {
        place(bp,asize);
        return bp;
    }
    return NULL;
}
//释放已分配的内存块；
void mm_free(void *ptr)
{
    size_t size=GET_SIZE(HDRP(ptr));
    //需要获取当前块的头部指针；
    PUT(HDRP(ptr),PACK(size, 0));
    //获取脚部指针；
    PUT(FTRP(ptr),PACK(size, 0));
    coalesce(ptr);
}
//申请额外的内存空间；
static void *extend_heap(size_t words)
{
    void *bp;
    size_t size;
    
    //需要保证分配的空间是一定双字对齐的；
    size=(words %2)?(words+1)*WSIZE :words *WSIZE;
    if((bp=mem_sbrk(size))==(void *)-1)
        return NULL;
    //设置已分配的块的头部脚部为未分配给程序使用的状态
    PUT(HDRP(bp), PACK(size, 0));
    PUT(FTRP(bp), PACK(size, 0));
    //设置下一个块，即结尾块为已分配
    PUT(NEXT_BLKP(bp), PACK(0, 1));
    return coalesce(bp);
}

//空闲区域的合并操作；
static void *coalesce(void *bp)
{
    //确认上一个块脚部中的位是否标识上一个块已经进行了分配;
    size_t prev_alloc=GET_ALLOC(FTRP(PREV_BLKP(bp)));
    //确认下一个块头部中的位是否标识下一个块已经进行了分配；
    size_t next_alloc=GET_ALLOC(HDRP(NEXT_BLKP(bp)));
    //获取当前块大小
    size_t size=GET_SIZE(HDRP(bp));
    
    if(prev_alloc && next_alloc)      //第一种情况，前后两个块均为已分配块，此时不需要进行合并直接返回即可；
        return bp;
    if(prev_alloc && !next_alloc)     //第二种情况，前边一个块已经分配，但是后边一个块未分配，则bp可与后边一个块进行合并
    {
        //获取下一个块的大小;
        size_t next_size=GET_SIZE(HDRP(NEXT_BLKP(bp)));
        PUT(HDRP(bp), PACK(next_size+size, 0));
        PUT(FTRP(NEXT_BLKP(bp)), PACK(next_size+size, 0));
        return bp;
    }
    if(!prev_alloc && next_alloc)    //第三种情况，前边一个块未分配，但是后边的一个块已分配；bp指针需要前移
    {
        //获取前一个块的大小；
        size_t prev_size=GET_SIZE(FTRP(PREV_BLKP(bp)));
        PUT(HDRP(PREV_BLKP(bp)), PACK(size+prev_size, 0));
        PUT(FTRP(bp), PACK(size+prev_size, 0));
        return PREV_BLKP(bp);
    }
    if(!prev_alloc && !next_alloc)  //第四种情况，前后均未分配；
    {
        size_t prev_size=GET_SIZE(FTRP(PREV_BLKP(bp)));
        size_t next_size=GET_SIZE(HDRP(NEXT_BLKP(bp)));
        PUT(HDRP(PREV_BLKP(bp)), PACK(size+prev_size+next_size, 0));
        PUT(FTRP(NEXT_BLKP(bp)), PACK(next_size+size+prev_size, 0));
        return PREV_BLKP(bp);
    }
    return (void *)-1;
}

static void *findfit(size_t size_needed)
{
    char * bp=heap_listp+3*WSIZE;//块的头部
    //判断当前块是否已经被分配：
    while (GET_SIZE(bp)>0)//边界条件时最后的结束块长度为0；
    {
        size_t isalloced=GET_ALLOC(bp);
        if(isalloced)//如果当前块已经分配，则将bp进行迭代；重新开始新的一轮循环
        {
            bp=HDRP(NEXT_BLKP(bp+WSIZE));
            continue;
        }
        else
        {
            //当前块未分配时,获取当前块的大小
            size_t current_size=GET_SIZE(bp);
            if(current_size>=size_needed)
                return bp+WSIZE;
            else
            {
                bp=HDRP(NEXT_BLKP(bp+WSIZE));
                continue;
            }
        }
    }
    //当前已初始化的内容无法满足size needed的需求，需要重新进行扩展；
    size_needed=MAX(size_needed, CHUNKSIZE);
    size_needed/=WSIZE;
    bp=extend_heap(size_needed);
    return bp;
}

static void place(void *bp,size_t size)
{
    //bp为块的有效载荷地址
    //需要计算bp块的大小与size的差值，是否大于2*双字作为判断是否需要在后边设置一个空闲块；
    size_t totoalsize=GET_SIZE(HDRP(bp));
    size_t rsize=totoalsize-size;
    if(rsize<=2*DSIZE)//即后续的字节空间已经不足以再放下一个空闲块了
    {
        PUT(HDRP(bp), PACK(totoalsize, 1));
        PUT(FTRP(bp), PACK(totoalsize, 1));
    }
    else
    {
        PUT(HDRP(bp), PACK(size, 1));
        PUT(FTRP(bp), PACK(size, 1));
        bp=NEXT_BLKP(bp);
        PUT(HDRP(bp), PACK(totoalsize-size, 0));
        PUT(FTRP(bp), PACK(totoalsize-size, 0));
    }
}
