//
//  main.c
//  3前n个数的二进制表示中1的频次
//
//  Created by 莫玄 on 2021/8/8.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#pragma mark---solution1
//将每个数的二进制表示 分为前后两个部分，使用位运算的方式可得，然后使用dp；
int* countBits1(int n, int* returnSize){
    int *res=(int *)calloc(n+1,sizeof(int));
    if(n==0)
    {
        res[0]=0;
        *returnSize=n+1;
        return res;
    }
    if(n==1)
    {
        res[0]=0;
        res[1]=1;
        *returnSize=n+1;
        return res;
    }
    res[0]=0;
    res[1]=1;
    res[2]=1;
    for(int i=3;i<=n;i++)
    {
        int pre=i & (i-1);
        int last=i ^ pre;
        if(pre==0)
            res[i]=1;
        else
            res[i]=res[pre]+res[last];
    }
    *returnSize=n+1;
    return res;
}
#pragma mark---solution2
//另一种动态规划的方法，对于一个数i，i=2^n+...2^0;所以 res[i]一定为res[i/2]+i%2,因为i/2小于i，所以res[i/2]为已知；
//因为i/2的时候 末尾的2^0 会被阶段，所以要加上i%2；
//即 res[i]=i%2 + res[i/2];
int *countBits2(int n,int *returnSize)
{
    int *res=(int *)calloc(n+1,sizeof(int));
    res[0]=0;
    *returnSize=0;
    for(int i=0;i<=n;i++)
    {
        res[i]=i%2+res[i/2];
        //等同于：res[i]=res[i>>1];
        //      if(i&1) res[i]++;
        (*returnSize)++;
    }
    return res;
}
int main(int argc, const char * argv[]) {
    // insert code here...
    countBits1(3, <#int *returnSize#>);
    return 0;
}
