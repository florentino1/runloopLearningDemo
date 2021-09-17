//
//  tab.c
//  tab
//
//  Created by 莫玄 on 2021/8/3.
//

#include "tab.h"
#include <stdlib.h>
#include <unistd.h>


//构造一个新的空的线性表
void InitList_sq(Sqlist *L)
{
    L->head=(int *)malloc(LIST_INIT_SIZE * sizeof(int));
    if(L->head==NULL)
    {
        printf("malloc error...\n");
        exit(1);
    }
    L->length=0;
    L->listsize=LIST_INIT_SIZE;
}


//插入一个新元素,i为插入的位序，e为待插入的元素
void ListInsert_sq(Sqlist *L,int i,int e)
{
    if(i<0 || i>L->length+1)//数组越界
    {
        printf("beyond bond...\n");
        exit(2);
    }
    if(L->length>=L->listsize)//所分配的空间已经满了的时候
    {
        int  *newArray=(int  *)realloc(L->head, (L->listsize+LISTINCREMENT)*sizeof(int));
        if(!newArray)
        {
            printf("realloc fail...\n");
            exit(3);
        }
        L->head=newArray;
        L->listsize+=LISTINCREMENT;
    }
    int *p=&(L->head[L->length-1]);//数组的最后一个元素;
    int *q=&(L->head[i-1]);//待插入的元素位序
    for(;p>=q;p--)
    {
        *(p+1)=*p;
    }
    *p=e;
    L->length+=1;
}

//删除数组中的一个元素
void ListDelete_sq(Sqlist *L,int i)
{
    if(i<0 || i>L->length)
    {
        printf("beyond bondary...\n");
        exit(2);
    }
    int *p=&(L->head[i-1]);//待删除的元素
    int *q=&(L->head[L->length-1]);// int *q=L->head + L->length-1;
    for(p++;p<=q;p++)
    {
        *(p-1)=*p;
    }
    L->length--;
}
//定位线性表中的元素位置
int LocateList_sq(Sqlist *L,int e)
{
    int index=1;
    while(index<=L->length && L->head[index-1]!=e)
        index++;
    if(index<=L->length)
        return index;
    else
        return -1;
}

//合并两个线性表
void MergeList_sq(Sqlist *La,Sqlist *Lb,Sqlist *Lc)
{
    int *pa=La->head;
    int *pb=Lb->head;
    Lc->length=Lc->listsize=La->length+Lb->length;
    Lc->head=(int *)malloc(Lc->length * sizeof(int));
    int *pc=Lc->head;
    if(!pc)
    {
        printf("malloc error...\n");
        exit(1);
    }
    int *pa_last=pa+La->length-1;
    int *pb_last=pb+Lb->length-1;
    while (pa<=pa_last && pb<=pb_last)
    {
        if(*pa<(*pb))
        {
            *pc=*pa;
            pa++;
            pc++;
        }
        else
        {
            *pc=*pb;
            pc++;
            pb++;
        }
    }
    while(pa<=pa_last)
    {
        *pc++=*pa++;
    }
    while (pb<=pb_last) {
        *pc++=*pb++;
    }
}
