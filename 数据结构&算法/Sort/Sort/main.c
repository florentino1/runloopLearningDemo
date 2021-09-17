//
//  main.c
//  Sort
//
//  Created by 莫玄 on 2021/7/14.
//

#include <stdio.h>
#include "sort.h"
int main()
{
    int a[9]={1,2,9,7,4,9,3,2,-1};
    int len=sizeof(a)/sizeof(int);
    mybubble_sort(a, len);
    for(int i=0;i<len;i++)
    {
        printf("%d\n",a[i]);
    }
    return 0;
}
