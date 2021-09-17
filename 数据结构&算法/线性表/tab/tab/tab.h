//
//  tab.h
//  tab
//
//  Created by 莫玄 on 2021/8/3.
//

#ifndef tab_h
#define tab_h

#include <stdio.h>


#define LIST_INIT_SIZE 100
#define LISTINCREMENT 10   //线性表预分配的空间不足时再分配的额度；
#define TRUE 1
#define FALSE 0
#define OK 1
#define ERROR 0
typedef int Status;

typedef struct{
    int *head;      //此顺序线性表的首地址,是一个数组;
    int length;     //此顺序线性表的当前长度；
    int listsize;   //此顺序表的最大容量
} Sqlist;




#endif /* tab_h */
