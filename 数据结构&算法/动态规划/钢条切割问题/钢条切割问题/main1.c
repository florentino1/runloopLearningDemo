//
//  main1.c
//  钢条切割问题
//
//  Created by 莫玄 on 2021/8/7.
//

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#pragma mark-每切割一刀带有固定的成本c；
#define c 1
int cut1(int *p,int n)
{
    if(n==0)
        return 0;
    int totalPrice=INT_MIN;
    for(int i=1;i<=n;i++)
    {
        int tmp;
        if(i!=n)
            tmp=p[i]+cut1(p,n-i)-c;
        else
            tmp=p[i]+cut1(p, n-1);//i==n的时候不需要进行切割，
        totalPrice=(totalPrice>tmp)?totalPrice:tmp;
    }
    return totalPrice;

}
